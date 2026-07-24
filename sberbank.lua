-- Mobile Fake VR Dual-Joystick Hand Controller for POCO F3
local Players = game:GetService("Players")
local RunService = service and nil or game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

if Humanoid.RigType ~= Enum.HumanoidRigType.R15 then
    warn("⚠️ Нужен R15 риг!")
    return
end

-- Отключаем стандартные плечевые суставы
for _, jointName in ipairs({"RightShoulder", "LeftShoulder"}) do
    local joint = Character:FindFirstChild(jointName, true)
    if joint and joint:IsA("Motor6D") then
        joint.Enabled = false
    end
end

local function setupHand(handName)
    local hand = Character:FindFirstChild(handName)
    if not hand then return end

    local att = Instance.new("Attachment", hand)
    local alignPos = Instance.new("AlignPosition")
    alignPos.Attachment0 = att
    alignPos.RigidityEnabled = false
    alignPos.Responsiveness = 400
    alignPos.MaxForce = 35000

    local alignOri = Instance.new("AlignOrientation")
    alignOri.Attachment0 = att
    alignOri.RigidityEnabled = false
    alignOri.Responsiveness = 400
    alignOri.MaxTorque = 35000

    local targetAtt = Instance.new("Attachment", RootPart)
    alignPos.Attachment1 = targetAtt
    alignOri.Attachment1 = targetAtt

    alignPos.Parent = hand
    alignOri.Parent = hand

    return targetAtt
end

local rightTarget = setupHand("RightHand")
local leftTarget = setupHand("LeftHand")

-- Создаем GUI с двумя джойстиками на экране
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "VRJoysticksGui"
ScreenGui.ResetOnSpawn = false

local function createJoystick(name, position)
    local base = Instance.new("Frame", ScreenGui)
    base.Name = name .. "Base"
    base.Size = UDim2.new(0, 120, 0, 120)
    base.Position = position
    base.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    base.BackgroundTransparency = 0.6
    Instance.new("UICorner", base).CornerRadius = UDim.new(1, 0)

    local stick = Instance.new("Frame", base)
    stick.Name = "Stick"
    stick.Size = UDim2.new(0, 50, 0, 50)
    stick.Position = UDim2.new(0.5, -25, 0.5, -25)
    stick.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
    stick.BackgroundTransparency = 0.3
    Instance.new("UICorner", stick).CornerRadius = UDim.new(1, 0)

    return base, stick
end

local leftBase, leftStick = createJoystick("LeftHand", UDim2.new(0, 30, 1, -170))
local rightBase, rightStick = createJoystick("RightHand", UDim2.new(1, -150, 1, -170))

-- Переменные смещения для рук (X, Y, Z вылет и повороты)
local leftOffset = Vector3.new(-1, -0.5, -1.5)
local rightOffset = Vector3.new(1, -0.5, -1.5)

local leftInputActive, rightInputActive = false, false
local leftStartPos, rightStartPos = Vector2.zero, Vector2.zero

UserInputService.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        local pos = input.Position
        if pos.X < Camera.ViewportSize.X / 2 then
            leftInputActive = true
            leftStartPos = Vector2.new(pos.X, pos.Y)
        else
            rightInputActive = true
            rightStartPos = Vector2.new(pos.X, pos.Y)
        end
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        leftInputActive = false
        rightInputActive = false
        leftStick.Position = UDim2.new(0.5, -25, 0.5, -25)
        rightStick.Position = UDim2.new(0.5, -25, 0.5, -25)
        leftOffset = Vector3.new(-1, -0.5, -1.5)
        rightOffset = Vector3.new(1, -0.5, -1.5)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch then
        local pos = input.Position
        if leftInputActive and pos.X < Camera.ViewportSize.X / 2 then
            local delta = Vector2.new(pos.X, pos.Y) - leftStartPos
            local clampDelta = Vector2.new(math.clamp(delta.X, -40, 40), math.clamp(delta.Y, -40, 40))
            leftStick.Position = UDim2.new(0.5, clampDelta.X - 25, 0.5, clampDelta.Y - 25)
            leftOffset = Vector3.new(-1 + (clampDelta.X / 30), -0.5 - (clampDelta.Y / 30), -1.5)
        elseif rightInputActive and pos.X >= Camera.ViewportSize.X / 2 then
            local delta = Vector2.new(pos.X, pos.Y) - rightStartPos
            local clampDelta = Vector2.new(math.clamp(delta.X, -40, 40), math.clamp(delta.Y, -40, 40))
            rightStick.Position = UDim2.new(0.5, clampDelta.X - 25, 0.5, clampDelta.Y - 25)
            rightOffset = Vector3.new(1 + (clampDelta.X / 30), -0.5 - (clampDelta.Y / 30), -1.5)
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if not Character or not Character.Parent or Humanoid.Health <= 0 then return end
    local camCF = Camera.CFrame

    if rightTarget and leftTarget then
        rightTarget.WorldCFrame = camCF * CFrame.new(rightOffset) * CFrame.Angles(math.rad(90), 0, 0)
        leftTarget.WorldCFrame = camCF * CFrame.new(leftOffset) * CFrame.Angles(math.rad(90), 0, 0)
    end
end)
