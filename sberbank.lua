-- ULTIMATE MOBILE FAKE VR (Server Replicated via Transform)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")

if Humanoid.RigType ~= Enum.HumanoidRigType.R15 then
    warn("⚠️ Требуется R15!")
    return
end

-- Отключаем дефолтные анимации рук
local animateScript = Character:FindFirstChild("Animate")
if animateScript then animateScript.Enabled = false end

-- СОЗДАНИЕ GUI
if CoreGui:FindFirstChild("UltimateVRGui") then
    CoreGui.UltimateVRGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "UltimateVRGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

-- Функция создания джойстика
local function createJoystick(name, position)
    local bg = Instance.new("Frame", ScreenGui)
    bg.Name = name
    bg.Size = UDim2.new(0, 100, 0, 100)
    bg.Position = position
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0.6
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

    local stick = Instance.new("Frame", bg)
    stick.Size = UDim2.new(0, 40, 0, 40)
    stick.Position = UDim2.new(0.5, -20, 0.5, -20)
    stick.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
    stick.BackgroundTransparency = 0.2
    Instance.new("UICorner", stick).CornerRadius = UDim.new(1, 0)

    local title = Instance.new("TextLabel", bg)
    title.Size = UDim2.new(1, 0, 0, 20)
    title.Position = UDim2.new(0, 0, -0.2, 0)
    title.BackgroundTransparency = 1
    title.Text = name:gsub("Pad", " Hand (X/Y)")
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 12

    return bg, stick
end

-- Функция создания вертикального ползунка (Слайдера)
local function createSlider(name, text, position)
    local bg = Instance.new("Frame", ScreenGui)
    bg.Name = name
    bg.Size = UDim2.new(0, 30, 0, 120)
    bg.Position = position
    bg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    bg.BackgroundTransparency = 0.5
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 8)

    local knob = Instance.new("Frame", bg)
    knob.Size = UDim2.new(1, 0, 0, 20)
    knob.Position = UDim2.new(0, 0, 0.5, -10) -- По умолчанию по центру (0.5)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", knob).CornerRadius = UDim.new(0, 8)

    local title = Instance.new("TextLabel", bg)
    title.Size = UDim2.new(0, 80, 0, 20)
    title.Position = UDim2.new(0.5, -40, -0.15, 0)
    title.BackgroundTransparency = 1
    title.Text = text
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 10

    return bg, knob
end

-- РАЗМЕЩЕНИЕ ЭЛЕМЕНТОВ НА ЭКРАНЕ (Чуть выше дефолтных стиков)
local leftJoyBg, leftJoyStick = createJoystick("LeftPad", UDim2.new(0, 40, 0.4, 0))
local leftExtBg, leftExtKnob = createSlider("LeftExt", "Push", UDim2.new(0, 160, 0.4, -10))
local leftRotBg, leftRotKnob = createSlider("LeftRot", "Rotate", UDim2.new(0, 210, 0.4, -10))

local rightJoyBg, rightJoyStick = createJoystick("RightPad", UDim2.new(1, -140, 0.4, 0))
local rightExtBg, rightExtKnob = createSlider("RightExt", "Push", UDim2.new(1, -190, 0.4, -10))
local rightRotBg, rightRotKnob = createSlider("RightRot", "Rotate", UDim2.new(1, -240, 0.4, -10))

-- ДАННЫЕ УПРАВЛЕНИЯ
local vrData = {
    lX = 0, lY = 0, lZ = -1.5, lRot = 0,
    rX = 0, rY = 0, rZ = -1.5, rRot = 0
}

-- ЛОГИКА ДЖОЙСТИКОВ
local function bindJoystick(bg, stick, prefix)
    local active, startPos = false, Vector2.zero
    bg.InputBegan:Connect(function(input)
        if input.UserInputType.Name:match("Touch|Mouse") then
            active = true
            startPos = Vector2.new(input.Position.X, input.Position.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType.Name:match("Touch|Mouse") and active then
            active = false
            stick.Position = UDim2.new(0.5, -20, 0.5, -20)
            vrData[prefix.."X"] = 0
            vrData[prefix.."Y"] = 0
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if active and input.UserInputType.Name:match("Touch|Mouse") then
            local delta = Vector2.new(input.Position.X, input.Position.Y) - startPos
            local clamped = Vector2.new(math.clamp(delta.X, -30, 30), math.clamp(delta.Y, -30, 30))
            stick.Position = UDim2.new(0.5, clamped.X - 20, 0.5, clamped.Y - 20)
            vrData[prefix.."X"] = clamped.X / 15
            vrData[prefix.."Y"] = -clamped.Y / 15
        end
    end)
end

-- ЛОГИКА СЛАЙДЕРОВ (ПОЛЗУНКОВ)
local function bindSlider(bg, knob, dataKey, minVal, maxVal)
    local active = false
    bg.InputBegan:Connect(function(input)
        if input.UserInputType.Name:match("Touch|Mouse") then active = true end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType.Name:match("Touch|Mouse") then
            active = false
            -- Возвращаем ползунок в центр при отпускании (как пружина)
            knob.Position = UDim2.new(0, 0, 0.5, -10)
            vrData[dataKey] = (minVal + maxVal) / 2
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if active and input.UserInputType.Name:match("Touch|Mouse") then
            local relY = math.clamp(input.Position.Y - bg.AbsolutePosition.Y, 0, bg.AbsoluteSize.Y - 20)
            knob.Position = UDim2.new(0, 0, 0, relY)
            
            -- Вычисляем процент от 0 до 1 (инвертируем, чтобы верх был максимумом)
            local percent = 1 - (relY / (bg.AbsoluteSize.Y - 20))
            vrData[dataKey] = minVal + ((maxVal - minVal) * percent)
        end
    end)
end

bindJoystick(leftJoyBg, leftJoyStick, "l")
bindJoystick(rightJoyBg, rightJoyStick, "r")

-- Настройка пределов: Вытягивание (от -1.5 до -4), Вращение (от -90 до 90 градусов)
bindSlider(leftExtBg, leftExtKnob, "lZ", -4, -0.5)
bindSlider(leftRotBg, leftRotKnob, "lRot", math.rad(-90), math.rad(90))

bindSlider(rightExtBg, rightExtKnob, "rZ", -4, -0.5)
bindSlider(rightRotBg, rightRotKnob, "rRot", math.rad(-90), math.rad(90))

-- ФУНКЦИЯ ПРИМЕНЕНИЯ ТРАНСФОРМАЦИИ
local function applyTransform(motorName, targetWorldCFrame)
    local motor = Character:FindFirstChild(motorName, true)
    if motor and motor:IsA("Motor6D") and motor.Part0 and motor.Part1 then
        local localCFrame = motor.C0:Inverse() * motor.Part0.CFrame:Inverse() * targetWorldCFrame * motor.C1
        motor.Transform = localCFrame
    end
end

-- ПЕРЕДАЧА НА СЕРВЕР КАЖДЫЙ КАДР
RunService.Stepped:Connect(function()
    if not Character or Humanoid.Health <= 0 then return end
    local camCF = Camera.CFrame

    -- Формируем финальные CFrame для рук
    -- Базовое смещение от камеры (чтобы плечи были по бокам)
    local leftBase = camCF * CFrame.new(-1.2 + vrData.lX, -0.5 + vrData.lY, vrData.lZ)
    local rightBase = camCF * CFrame.new(1.2 + vrData.rX, -0.5 + vrData.rY, vrData.rZ)

    -- Добавляем вращение (по умолчанию рука смотрит вперед + наклон с ползунка)
    local targetLeft = leftBase * CFrame.Angles(math.rad(90), vrData.lRot, 0)
    local targetRight = rightBase * CFrame.Angles(math.rad(90), vrData.rRot, 0)

    applyTransform("LeftShoulder", targetLeft)
    applyTransform("RightShoulder", targetRight)
    
    -- Выпрямляем локти и кисти, чтобы рука была как жесткий манипулятор
    for _, joint in ipairs({"LeftElbow", "RightElbow", "LeftWrist", "RightWrist"}) do
        local m = Character:FindFirstChild(joint, true)
        if m and m:IsA("Motor6D") then 
            m.Transform = CFrame.new() 
        end
    end
end)
