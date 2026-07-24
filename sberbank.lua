-- =====================================================================
-- ULTIMATE R6 MOBILE VR WITH JOYSTICKS & AUTO-RECONNECT SPOOF
-- =====================================================================

local TeleportService = game:GetService("TeleportService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer

-- Авто-реконнект для первичного запуска, чтобы движок подхватил состояние
if not getgenv().VR_Reconnected then
    getgenv().VR_Reconnected = true
    
    local sg = Instance.new("ScreenGui", CoreGui)
    local lbl = Instance.new("TextLabel", sg)
    lbl.Size = UDim2.new(0, 400, 0, 50)
    lbl.Position = UDim2.new(0.5, -200, 0, 10)
    lbl.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    lbl.TextColor3 = Color3.fromRGB(0, 255, 120)
    lbl.TextSize = 16
    lbl.Font = Enum.Font.GothamBold
    lbl.Text = "🔄 Переподключение для активации VR..."

    task.wait(1.5)
    pcall(function()
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    end)
    return
end

-- =====================================================================
-- ОСНОВНОЙ СКРИПТ НА НОВОМ СЕРВЕРЕ
-- =====================================================================

local Camera = Workspace.CurrentCamera

local function initVR()
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local Humanoid = Character:WaitForChild("Humanoid")
    local Torso = Character:WaitForChild("Torso")

    if Humanoid.RigType ~= Enum.HumanoidRigType.R6 then
        warn("⚠️ Внимание: Требуется R6 аватар!")
    end

    -- Удаляем старый интерфейс, если он был
    if CoreGui:FindFirstChild("UltimateVRMobileGui") then
        CoreGui.UltimateVRMobileGui:Destroy()
    end

    -- Создаем визуальные блоки-контроллеры на концах рук
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

    -- Создаем графический интерфейс с джойстиками
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UltimateVRMobileGui"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.Parent = CoreGui

    local function createJoystick(name, position)
        local bg = Instance.new("Frame", ScreenGui)
        bg.Size = UDim2.new(0, 110, 0, 110)
        bg.Position = position
        bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        bg.BackgroundTransparency = 0.5
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
        title.Position = UDim2.new(0, 0, -0.25, 0)
        title.BackgroundTransparency = 1
        title.Text = name
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.Font = Enum.Font.GothamBold
        title.TextSize = 14

        return bg, stick
    end

    local leftJoyBg, leftJoyStick = createJoystick("Left Hand", UDim2.new(0, 30, 0.15, 0))
    local rightJoyBg, rightJoyStick = createJoystick("Right Hand", UDim2.new(1, -140, 0.15, 0))

    local vrData = { lX = 0, lY = 0, rX = 0, rY = 0 }

    -- Обработка касаний джойстиков
    local function bindJoystick(bg, stick, prefix)
        local trackingInput = nil
        local startPos = nil

        bg.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                if not trackingInput then
                    trackingInput = input
                    startPos = input.Position
                end
            end
        end)
        
        UserInputService.InputEnded:Connect(function(input)
            if input == trackingInput then
                trackingInput = nil
                startPos = nil
                stick.Position = UDim2.new(0.5, -22.5, 0.5, -22.5)
                vrData[prefix.."X"], vrData[prefix.."Y"] = 0, 0
            end
        end)
        
        UserInputService.InputChanged:Connect(function(input)
            if input == trackingInput and startPos then
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

    local leftShoulder = Torso:FindFirstChild("Left Shoulder")
    local rightShoulder = Torso:FindFirstChild("Right Shoulder")

    -- Основной цикл обновления позиций каждый кадр
    local renderConnection
    renderConnection = RunService.RenderStepped:Connect(function()
        if not Character or Humanoid.Health <= 0 then
            if renderConnection then renderConnection:Disconnect() end
            return
        end

        local camCF = Camera.CFrame
        local leftTarget = camCF * CFrame.new(-1.2 + vrData.lX, -0.5 + vrData.lY, -1.5) * CFrame.Angles(math.rad(90), 0, 0)
        local rightTarget = camCF * CFrame.new(1.2 + vrData.rX, -0.5 + vrData.rY, -1.5) * CFrame.Angles(math.rad(90), 0, 0)

        leftBrick.CFrame = leftTarget
        rightBrick.CFrame = rightTarget

        if leftShoulder then
            leftShoulder.Transform = Torso.CFrame:Inverse() * leftTarget
        end
        if rightShoulder then
            rightShoulder.Transform = Torso.CFrame:Inverse() * rightTarget
        end
    end)

    LocalPlayer.CharacterRemoving:Connect(function()
        if renderConnection then renderConnection:Disconnect() end
        if ScreenGui then ScreenGui:Destroy() end
    end)
end

initVR()
LocalPlayer.CharacterAdded:Connect(initVR)
