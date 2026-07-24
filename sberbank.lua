-- =====================================================================
-- FULL ULTIMATE MOBILE VR SCRIPT (GITHUB VERSION)
-- =====================================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Функция инициализации персонажа и суставов
local function initVR()
    local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
    local Humanoid = Character:WaitForChild("Humanoid")
    local Torso = Character:WaitForChild("Torso")

    -- Очистка старого интерфейса, если он уже был создан
    if CoreGui:FindFirstChild("UltimateVRGuiGitHub") then
        CoreGui.UltimateVRGuiGitHub:Destroy()
    end

    -- Создание графического интерфейса с джойстиками управления
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "UltimateVRGuiGitHub"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.Parent = CoreGui

    local function createJoystick(name, position)
        local bg = Instance.new("Frame")
        bg.Name = name
        bg.Size = UDim2.new(0, 120, 0, 120)
        bg.Position = position
        bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        bg.BackgroundTransparency = 0.5
        bg.Active = true
        bg.Parent = ScreenGui
        
        local cornerBg = Instance.new("UICorner")
        cornerBg.CornerRadius = UDim.new(1, 0)
        cornerBg.Parent = bg

        local stick = Instance.new("Frame")
        stick.Name = "Stick"
        stick.Size = UDim2.new(0, 50, 0, 50)
        stick.Position = UDim2.new(0.5, -25, 0.5, -25)
        stick.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
        stick.BackgroundTransparency = 0.2
        stick.Parent = bg
        
        local cornerStick = Instance.new("UICorner")
        cornerStick.CornerRadius = UDim.new(1, 0)
        cornerStick.Parent = stick
        
        local title = Instance.new("TextLabel")
        title.Size = UDim2.new(1, 0, 0, 20)
        title.Position = UDim2.new(0, 0, -0.25, 0)
        title.BackgroundTransparency = 1
        title.Text = name
        title.TextColor3 = Color3.fromRGB(255, 255, 255)
        title.Font = Enum.Font.GothamBold
        title.TextSize = 14
        title.Parent = bg

        return bg, stick
    end

    -- Джойстики подняты выше для комфортного управления на экране мобильного устройства
    local leftJoyBg, leftJoyStick = createJoystick("Left Hand", UDim2.new(0, 30, 0.15, 0))
    local rightJoyBg, rightJoyStick = createJoystick("Right Hand", UDim2.new(1, -150, 0.15, 0))

    local vrData = {
        lX = 0, lY = 0,
        rX = 0, rY = 0
    }

    -- Система обработки касаний и перемещения стиков джойстика
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
                stick.Position = UDim2.new(0.5, -25, 0.5, -25)
                vrData[prefix .. "X"] = 0
                vrData[prefix .. "Y"] = 0
            end
        end)

        UserInputService.InputChanged:Connect(function(input)
            if input == trackingInput and startPos then
                local delta = input.Position - startPos
                local clamped = Vector2.new(
                    math.clamp(delta.X, -35, 35),
                    math.clamp(delta.Y, -35, 35)
                )
                stick.Position = UDim2.new(0.5, clamped.X - 25, 0.5, clamped.Y - 25)
                vrData[prefix .. "X"] = clamped.X / 15
                vrData[prefix .. "Y"] = -clamped.Y / 15
            end
        end)
    end

    bindJoystick(leftJoyBg, leftJoyStick, "l")
    bindJoystick(rightJoyBg, rightJoyStick, "r")

    -- Основной цикл обновления позиций рук каждый кадр
    local renderConnection
    renderConnection = RunService.RenderStepped:Connect(function()
        if not Character or not Humanoid or Humanoid.Health <= 0 then
            if renderConnection then renderConnection:Disconnect() end
            return
        end

        local camCF = Camera.CFrame
        
        -- Расчет целевых координат для левой и правой руки относительно камеры
        local lTarget = camCF * CFrame.new(-1.2 + vrData.lX, -0.5 + vrData.lY, -1.5) * CFrame.Angles(math.rad(90), 0, 0)
        local rTarget = camCF * CFrame.new(1.2 + vrData.rX, -0.5 + vrData.rY, -1.5) * CFrame.Angles(math.rad(90), 0, 0)

        local leftShoulder = Torso:FindFirstChild("Left Shoulder")
        local rightShoulder = Torso:FindFirstChild("Right Shoulder")

        if leftShoulder and leftShoulder:IsA("Motor6D") then
            leftShoulder.Transform = Torso.CFrame:Inverse() * lTarget
        end

        if rightShoulder and rightShoulder:IsA("Motor6D") then
            rightShoulder.Transform = Torso.CFrame:Inverse() * rTarget
        end
    end)

    -- Очистка при смене персонажа или смерти
    LocalPlayer.CharacterRemoving:Connect(function()
        if renderConnection then renderConnection:Disconnect() end
        if ScreenGui then ScreenGui:Destroy() end
    end)
end

-- Запуск инициализации при старте
initVR()
LocalPlayer.CharacterAdded:Connect(initVR)
