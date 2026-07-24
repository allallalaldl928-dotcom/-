-- PERFECT SERVER-SIDED FAKE VR (No Visual Glitches, Network Replicated)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

if Humanoid.RigType ~= Enum.HumanoidRigType.R15 then
    warn("⚠️ Этот скрипт работает только на R15 аватарах!")
    return
end

-- 1. НАСТРОЙКА ФИЗИКИ И ОТКЛЮЧЕНИЕ КОЛЛИЗИЙ (Анти-флинг)
local function disableCollisions()
    for _, part in ipairs(Character:GetDescendants()) do
        if part:IsA("BasePart") and (part.Name:match("Arm") or part.Name:match("Hand")) then
            part.Massless = true -- Делаем руки невесомыми для идеальной работы AlignPosition
            
            -- Отключаем коллизию рук с торсом и головой
            for _, bodyPart in ipairs(Character:GetChildren()) do
                if bodyPart:IsA("BasePart") and not (bodyPart.Name:match("Arm") or bodyPart.Name:match("Hand")) then
                    local noCol = Instance.new("NoCollisionConstraint")
                    noCol.Part0 = part
                    noCol.Part1 = bodyPart
                    noCol.Parent = part
                end
            end
        end
    end
end
disableCollisions()

-- 2. СОЗДАНИЕ СЕТЕВЫХ РУК
local function setupNetworkArm(prefix)
    -- Отключаем только плечевой сустав, чтобы рука стала отдельным физическим объектом
    local shoulder = Character:FindFirstChild(prefix .. "Shoulder", true)
    if shoulder and shoulder:IsA("Motor6D") then
        shoulder.Enabled = false
    end

    local hand = Character:FindFirstChild(prefix .. "Hand")
    if not hand then return end

    local att0 = Instance.new("Attachment", hand)
    
    local ap = Instance.new("AlignPosition")
    ap.Attachment0 = att0
    ap.RigidityEnabled = false
    ap.Responsiveness = 150 -- Плавность и скорость
    ap.MaxForce = math.huge -- Бесконечная сила для удержания
    
    local ao = Instance.new("AlignOrientation")
    ao.Attachment0 = att0
    ao.RigidityEnabled = false
    ao.Responsiveness = 150
    ao.MaxTorque = math.huge
    
    -- Целевые точки привязываем к Террейну (мировому пространству), чтобы физика не баговалась
    local targetAtt = Instance.new("Attachment", Workspace.Terrain)
    ap.Attachment1 = targetAtt
    ao.Attachment1 = targetAtt
    
    ap.Parent = hand
    ao.Parent = hand
    
    return targetAtt
end

local leftTarget = setupNetworkArm("Left")
local rightTarget = setupNetworkArm("Right")

-- 3. СОЗДАНИЕ ИНТЕРФЕЙСА (Точь-в-точь как на скриншоте)
if CoreGui:FindFirstChild("VRControlGui") then
    CoreGui.VRControlGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "VRControlGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

local function createPad(name, text, position)
    local bg = Instance.new("Frame", ScreenGui)
    bg.Name = name
    bg.Size = UDim2.new(0, 120, 0, 120)
    bg.Position = position
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0.5
    Instance.new("UICorner", bg).CornerRadius = UDim.new(1, 0)

    local title = Instance.new("TextLabel", bg)
    title.Size = UDim2.new(1, 0, 0, 20)
    title.Position = UDim2.new(0, 0, 0, -25)
    title.BackgroundTransparency = 1
    title.Text = text
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 16

    local stick = Instance.new("Frame", bg)
    stick.Size = UDim2.new(0, 50, 0, 50)
    stick.Position = UDim2.new(0.5, -25, 0.5, -25)
    stick.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    stick.BackgroundTransparency = 0.1
    Instance.new("UICorner", stick).CornerRadius = UDim.new(1, 0)

    return bg, stick
end

local function createBtn(text, position)
    local btn = Instance.new("TextButton", ScreenGui)
    btn.Size = UDim2.new(0, 90, 0, 40)
    btn.Position = position
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.BackgroundTransparency = 0.2
    btn.Text = text
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 12
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", btn, {Color = Color3.fromRGB(255, 255, 255), Thickness = 2})
    return btn
end

-- Расположение элементов
local moveLBg, moveLStick = createPad("MoveL", "Move L", UDim2.new(0, 40, 0.3, 0))
local pushLBtn = createBtn("PUSH L", UDim2.new(0, 55, 0.3, 130))
local pushRBtn = createBtn("PUSH R", UDim2.new(0, 55, 0.3, 190))

local rotLBg, rotLStick = createPad("RotL", "Rotate L", UDim2.new(1, -160, 0.2, 0))
local rotRBg, rotRStick = createPad("RotR", "Rotate R", UDim2.new(1, -160, 0.5, 0))

-- 4. ЛОГИКА УПРАВЛЕНИЯ
local offsets = {
    leftPos = Vector3.new(-1.2, -0.5, -1.5),
    rightPos = Vector3.new(1.2, -0.5, -1.5),
    leftRot = Vector2.zero,
    rightRot = Vector2.zero
}

-- Настройка тач-управления для джойстиков
local function setupJoystick(bg, stick, axisTable, key, factor)
    local active, startPos = false, Vector2.zero
    bg.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
            active = true
            startPos = Vector2.new(input.Position.X, input.Position.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) and active then
            active = false
            stick.Position = UDim2.new(0.5, -25, 0.5, -25)
            if key:match("Rot") then offsets[key] = Vector2.zero end -- Сброс ротации при отпускании
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if active and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
            local currPos = Vector2.new(input.Position.X, input.Position.Y)
            local delta = currPos - startPos
            local clamped = Vector2.new(math.clamp(delta.X, -35, 35), math.clamp(delta.Y, -35, 35))
            stick.Position = UDim2.new(0.5, clamped.X - 25, 0.5, clamped.Y - 25)
            
            -- Обновляем данные смещения
            if key:match("Pos") then
                local baseOffset = (key == "leftPos") and Vector3.new(-1.2, -0.5, offsets[key].Z) or Vector3.new(1.2, -0.5, offsets[key].Z)
                offsets[key] = baseOffset + Vector3.new(clamped.X / factor, -clamped.Y / factor, 0)
            else
                offsets[key] = Vector2.new(-clamped.Y / factor, -clamped.X / factor)
            end
        end
    end)
end

setupJoystick(moveLBg, moveLStick, offsets, "leftPos", 30)
setupJoystick(rotLBg, rotLStick, offsets, "leftRot", 15)
setupJoystick(rotRBg, rotRStick, offsets, "rightRot", 15)

-- Кнопки PUSH (Вытягивание рук вперед)
local pushLActive, pushRActive = false, false
pushLBtn.InputBegan:Connect(function(inp) if inp.UserInputType.Name:match("Touch") or inp.UserInputType.Name:match("Mouse") then pushLActive = true end end)
pushLBtn.InputEnded:Connect(function(inp) if inp.UserInputType.Name:match("Touch") or inp.UserInputType.Name:match("Mouse") then pushLActive = false end end)

pushRBtn.InputBegan:Connect(function(inp) if inp.UserInputType.Name:match("Touch") or inp.UserInputType.Name:match("Mouse") then pushRActive = true end end)
pushRBtn.InputEnded:Connect(function(inp) if inp.UserInputType.Name:match("Touch") or inp.UserInputType.Name:match("Mouse") then pushRActive = false end end)

-- 5. ОБНОВЛЕНИЕ КООРДИНАТ ПО СЕТИ
RunService.Heartbeat:Connect(function()
    if not Character or not Character.Parent or Humanoid.Health <= 0 then return end
    local camCF = Camera.CFrame

    -- Вытягивание рук при зажатии PUSH
    offsets.leftPos = Vector3.new(offsets.leftPos.X, offsets.leftPos.Y, math.clamp(offsets.leftPos.Z + (pushLActive and -0.1 or 0.1), -3.5, -1.5))
    offsets.rightPos = Vector3.new(offsets.rightPos.X, offsets.rightPos.Y, math.clamp(offsets.rightPos.Z + (pushRActive and -0.1 or 0.1), -3.5, -1.5))

    -- Применяем координаты (CFrame + Вращение)
    if leftTarget then
        leftTarget.WorldCFrame = camCF 
            * CFrame.new(offsets.leftPos) 
            * CFrame.Angles(math.rad(90) + offsets.leftRot.X, offsets.leftRot.Y, 0)
    end
    
    if rightTarget then
        -- Правая рука берет координаты X/Y от базы (можно добавить Move R джойстик по аналогии)
        rightTarget.WorldCFrame = camCF 
            * CFrame.new(offsets.rightPos) 
            * CFrame.Angles(math.rad(90) + offsets.rightRot.X, offsets.rightRot.Y, 0)
    end
end)
