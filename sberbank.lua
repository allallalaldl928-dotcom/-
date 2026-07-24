-- ULTIMATE MOBILE VR FOR R6 (Attached Bricks, Moved Joysticks Up)
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Torso = Character:WaitForChild("Torso")

if Humanoid.RigType ~= Enum.HumanoidRigType.R6 then
    warn("⚠️ Внимание: Этот скрипт сделан специально для R6! Переключи аватар на R6.")
end

-- Удаляем старый интерфейс, если остался
if CoreGui:FindFirstChild("UltimateVRGuiR6") then
    CoreGui.UltimateVRGuiR6:Destroy()
end

-- Создаем блоки-контроллеры, которые спавнятся прямо в руках и привязаны к ним
local function createHandBrick(name, color)
    local part = Instance.new("Part")
    part.Name = name
    part.Size = Vector3.new(0.4, 0.4, 0.8)
    part.BrickColor = BrickColor.new(color)
    part.Material = Enum.Material.Neon
    part.Transparency = 0.2
    part.CanCollide = false
    part.Parent = Character
    
    local w = Instance.new("WeldConstraint")
    w.Part0 = part
    w.Parent = part
    return part
end

local leftBrick = createHandBrick("VRLeftHandBrick", "Bright green")
local rightBrick = createHandBrick("VRRightHandBrick", "Bright blue")

-- Создаем интерфейс (джойстики подняты выше)
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "UltimateVRGuiR6"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

local function createJoystick(name, position)
    local bg = Instance.new("Frame", ScreenGui)
    bg.Size = UDim2.new(0, 110, 0, 110)
    bg.Position = position
    bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    bg.BackgroundTransparency = 0.6
    bg.Active = true
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

-- Позиции джойстиков подняты выше (было 0.4, поставили 0.2, ближе к середине/верху экрана)
local leftJoyBg, leftJoyStick = createJoystick("L Hand", UDim2.new(0, 30, 0.2, 0))
local rightJoyBg, rightJoyStick = createJoystick("R Hand", UDim2.new(1, -140, 0.2, 0))

local vrData = { lX = 0, lY = 0, rX = 0, rY = 0 }

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

bindJoystick(leftJoyBg, leftJoyStick, "l")
bindJoystick(rightJoyBg, rightJoyStick, "r")

-- Логика управления суставами для R6 через CFrame
RunService.RenderStepped:Connect(function()
    if not Character or Humanoid.Health <= 0 then return end
    
    local camCF = Camera.CFrame
    
    -- Целевые позиции кирпичей перед камерой с учетом джойстиков
    local leftTarget = camCF * CFrame.new(-1.2 + vrData.lX, -0.5 + vrData.lY, -1.5) * CFrame.Angles(math.rad(90), 0, 0)
    local rightTarget = camCF * CFrame.new(1.2 + vrData.rX, -0.5 + vrData.rY, -1.5) * CFrame.Angles(math.rad(90), 0, 0)

    leftBrick.CFrame = leftTarget
    rightBrick.CFrame = rightTarget

    -- Перенос позиций на плечи R6 (Left/Right Shoulder)
    local leftShoulder = Torso:FindFirstChild("Left Shoulder")
    local rightShoulder = Torso:FindFirstChild("Right Shoulder")

    if leftShoulder and leftShoulder:IsA("Motor6D") then
        local cf = Torso.CFrame:Inverse() * leftTarget
        leftShoulder.Transform = cf
    end

    if rightShoulder and rightShoulder:IsA("Motor6D") then
        local cf = Torso.CFrame:Inverse() * rightTarget
        rightShoulder.Transform = cf
    end
end)

LocalPlayer.CharacterRemoving:Connect(function()
    if ScreenGui then ScreenGui:Destroy() end
end)
