-- THE ULTIMATE MOBILE FAKE VR (Real Spoof, First Person Visible, Fixed Joysticks)
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

-- 1. ПОДМЕНА VR (VREnabled Spoofing)
pcall(function()
    local mt = getrawmetatable(game)
    local oldIndex = mt.__index
    setreadonly(mt, false)
    mt.__index = newcclosure(function(self, key)
        if key == "VREnabled" and (self == UserInputService or self == game:GetService("VRService")) then
            return true -- Заставляем игру думать, что мы в VR шлеме
        end
        return oldIndex(self, key)
    end)
    setreadonly(mt, true)
    print("✅ VR Spoofing успешно активирован!")
end)

-- 2. ОТКЛЮЧЕНИЕ ДЕФОЛТНЫХ АНИМАЦИЙ
local animateScript = Character:FindFirstChild("Animate")
if animateScript then animateScript.Enabled = false end

-- 3. СОЗДАНИЕ ИНТЕРФЕЙСА
if CoreGui:FindFirstChild("UltimateVRGui") then
    CoreGui.UltimateVRGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "UltimateVRGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

local function createJoystick(name, position)
    local bg = Instance.new("Frame", ScreenGui)
    bg.Name = name
    bg.Size = UDim2.new(0, 110, 0, 110)
    bg.Position = position
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0.6
    bg.Active = true -- Обязательно для мобильного тача
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

    local stick = Instance.new("Frame", bg)
    stick.Size = UDim2.new(0, 45, 0, 45)
    stick.Position = UDim2.new(0.5, -22.5, 0.5, -22.5)
    stick.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
    stick.BackgroundTransparency = 0.2
    Instance.new("UICorner", stick).CornerRadius = UDim.new(1, 0)
    
    local title = Instance.new("TextLabel", bg)
    title.Size = UDim2.new(1, 0, 0, 20)
    title.Position = UDim2.new(0, 0, -0.2, 0)
    title.BackgroundTransparency = 1
    title.Text = name
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14

    return bg, stick
end

local function createSlider(name, text, position)
    local bg = Instance.new("Frame", ScreenGui)
    bg.Name = name
    bg.Size = UDim2.new(0, 35, 0, 130)
    bg.Position = position
    bg.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    bg.BackgroundTransparency = 0.5
    bg.Active = true
    Instance.new("UICorner", bg).CornerRadius = UDim.new(0, 8)

    local knob = Instance.new("Frame", bg)
    knob.Size = UDim2.new(1, 0, 0, 25)
    knob.Position = UDim2.new(0, 0, 0.5, -12.5)
    knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", knob).CornerRadius = UDim.new(0, 8)

    local title = Instance.new("TextLabel", bg)
    title.Size = UDim2.new(0, 80, 0, 20)
    title.Position = UDim2.new(0.5, -40, -0.15, 0)
    title.BackgroundTransparency = 1
    title.Text = text
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 11

    return bg, knob
end

-- Размещение UI элементов
local leftJoyBg, leftJoyStick = createJoystick("L Hand (X/Y)", UDim2.new(0, 30, 0.4, 0))
local leftExtBg, leftExtKnob = createSlider("LeftExt", "Push", UDim2.new(0, 160, 0.4, -10))
local leftRotBg, leftRotKnob = createSlider("LeftRot", "Rotate", UDim2.new(0, 215, 0.4, -10))

local rightJoyBg, rightJoyStick = createJoystick("R Hand (X/Y)", UDim2.new(1, -140, 0.4, 0))
local rightExtBg, rightExtKnob = createSlider("RightExt", "Push", UDim2.new(1, -195, 0.4, -10))
local rightRotBg, rightRotKnob = createSlider("RightRot", "Rotate", UDim2.new(1, -250, 0.4, -10))

local vrData = { lX = 0, lY = 0, lZ = -1.5, lRot = 0, rX = 0, rY = 0, rZ = -1.5, rRot = 0 }

-- 4. НАДЕЖНАЯ ЛОГИКА ДЖОЙСТИКОВ (Исправлено для мобилок)
local function bindJoystick(bg, stick, prefix)
    local trackingInput = nil
    local startPos = nil

    bg.InputBegan:Connect(function(input)
        if input.UserInputType.Name:match("Touch|MouseButton1") then
            trackingInput = input
            startPos = input.Position
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input == trackingInput then
            trackingInput = nil
            stick.Position = UDim2.new(0.5, -22.5, 0.5, -22.5)
            vrData[prefix.."X"], vrData[prefix.."Y"] = 0, 0
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == trackingInput then
            local delta = input.Position - startPos
            local clamped = Vector2.new(math.clamp(delta.X, -35, 35), math.clamp(delta.Y, -35, 35))
            stick.Position = UDim2.new(0.5, clamped.X - 22.5, 0.5, clamped.Y - 22.5)
            vrData[prefix.."X"] = clamped.X / 15
            vrData[prefix.."Y"] = -clamped.Y / 15
        end
    end)
end

-- НАДЕЖНАЯ ЛОГИКА СЛАЙДЕРОВ
local function bindSlider(bg, knob, dataKey, minVal, maxVal)
    local trackingInput = nil

    bg.InputBegan:Connect(function(input)
        if input.UserInputType.Name:match("Touch|MouseButton1") then
            trackingInput = input
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input == trackingInput then
            trackingInput = nil
            knob.Position = UDim2.new(0, 0, 0.5, -12.5)
            vrData[dataKey] = (minVal + maxVal) / 2
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == trackingInput then
            local relY = math.clamp(input.Position.Y - bg.AbsolutePosition.Y, 0, bg.AbsoluteSize.Y - 25)
            knob.Position = UDim2.new(0, 0, 0, relY)
            local percent = 1 - (relY / (bg.AbsoluteSize.Y - 25))
            vrData[dataKey] = minVal + ((maxVal - minVal) * percent)
        end
    end)
end

bindJoystick(leftJoyBg, leftJoyStick, "l")
bindJoystick(rightJoyBg, rightJoyStick, "r")
bindSlider(leftExtBg, leftExtKnob, "lZ", -4, -0.5)
bindSlider(leftRotBg, leftRotKnob, "lRot", math.rad(-90), math.rad(90))
bindSlider(rightExtBg, rightExtKnob, "rZ", -4, -0.5)
bindSlider(rightRotBg, rightRotKnob, "rRot", math.rad(-90), math.rad(90))

-- 5. ТРАНСФОРМАЦИЯ (Движения рук) И ВИДИМОСТЬ ОТ 1 ЛИЦА
local function applyTransform(motorName, targetWorldCFrame)
    local motor = Character:FindFirstChild(motorName, true)
    if motor and motor:IsA("Motor6D") and motor.Part0 and motor.Part1 then
        local localCFrame = motor.C0:Inverse() * motor.Part0.CFrame:Inverse() * targetWorldCFrame * motor.C1
        motor.Transform = localCFrame
    end
end

RunService.RenderStepped:Connect(function()
    if not Character or Humanoid.Health <= 0 then return end
    
    -- Видимость от первого лица (убираем прозрачность у всего, кроме головы)
    for _, part in ipairs(Character:GetChildren()) do
        if part:IsA("BasePart") and part.Name ~= "Head" then
            part.LocalTransparencyModifier = 0
        end
    end
    -- Руки (кисти)
    for _, acc in ipairs(Character:GetDescendants()) do
        if acc:IsA("BasePart") and acc.Name:match("Hand") then
            acc.LocalTransparencyModifier = 0
        end
    end

    local camCF = Camera.CFrame
    local leftBase = camCF * CFrame.new(-1.2 + vrData.lX, -0.5 + vrData.lY, vrData.lZ)
    local rightBase = camCF * CFrame.new(1.2 + vrData.rX, -0.5 + vrData.rY, vrData.rZ)

    local targetLeft = leftBase * CFrame.Angles(math.rad(90), vrData.lRot, 0)
    local targetRight = rightBase * CFrame.Angles(math.rad(90), vrData.rRot, 0)

    applyTransform("LeftShoulder", targetLeft)
    applyTransform("RightShoulder", targetRight)
    
    -- Блокировка локтей (жесткие руки)
    for _, joint in ipairs({"LeftElbow", "RightElbow", "LeftWrist", "RightWrist"}) do
        local m = Character:FindFirstChild(joint, true)
        if m and m:IsA("Motor6D") then m.Transform = CFrame.new() end
    end
end)
