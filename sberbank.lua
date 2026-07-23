local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("SberbankHubGui") then
    CoreGui.SberbankHubGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "SberbankHubGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

-- 1. ИКОНКА ОТКРЫТИЯ/ЗАКРЫТИЯ ХАБА
local ToggleButton = Instance.new("ImageButton", ScreenGui)
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0, 20, 0, 150)
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 130, 65)
ToggleButton.Image = "rbxassetid://18828254115"
ToggleButton.ScaleType = Enum.ScaleType.Crop
ToggleButton.Draggable = true
ToggleButton.Active = true
ToggleButton.Selectable = true
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", ToggleButton, {Color = Color3.fromRGB(255, 255, 255), Thickness = 2})

-- 2. ГЛАВНОЕ ОКНО ХАБА
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 280, 0, 340)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -170)
MainFrame.BackgroundColor3 = Color3.fromRGB(5, 25, 12)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", MainFrame, {Color = Color3.fromRGB(0, 210, 100), Thickness = 2.5})

local BgGradient = Instance.new("UIGradient", MainFrame)
BgGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(5, 35, 18)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(2, 15, 8)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 8, 4))
})
BgGradient.Rotation = 45

ToggleButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local startPos = input.Position
        local moved = false
        local connection
        connection = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                connection:Disconnect()
                if not moved then
                    MainFrame.Visible = not MainFrame.Visible
                end
            end
        end)
        task.spawn(function()
            while input.UserInputState == Enum.UserInputState.Begin do
                if (input.Position - startPos).Magnitude > 10 then
                    moved = true
                    break
                end
                task.wait()
            end
        end)
    end
end)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, -50, 0, 32)
Title.Position = UDim2.new(0, 8, 0, 8)
Title.BackgroundColor3 = Color3.fromRGB(0, 100, 50)
Title.BackgroundTransparency = 0.2
Title.Text = "SBERBANK HUB [POWER FLY]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 10
Title.Font = Enum.Font.GothamBold
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", Title, {Color = Color3.fromRGB(0, 255, 120), Thickness = 1.5})

local CloseButton = Instance.new("TextButton", MainFrame)
CloseButton.Size = UDim2.new(0, 32, 0, 32)
CloseButton.Position = UDim2.new(1, -40, 0, 8)
CloseButton.BackgroundColor3 = Color3.fromRGB(180, 30, 30)
CloseButton.BackgroundTransparency = 0.2
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseButton.TextSize = 14
CloseButton.Font = Enum.Font.GothamBold
Instance.new("UICorner", CloseButton).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", CloseButton, {Color = Color3.fromRGB(255, 80, 80), Thickness = 1.5})

CloseButton.Activated:Connect(function()
    ScreenGui:Destroy()
end)

local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, -12, 1, -55)
Scroll.Position = UDim2.new(0, 6, 0, 48)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 800)
Scroll.ScrollBarThickness = 3
local UIList = Instance.new("UIListLayout", Scroll)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 6)

local function AddButton(name, callback)
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(10, 45, 25)
    btn.BackgroundTransparency = 0.2
    btn.AutoButtonColor = false
    btn.Text = ""
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", btn, {Color = Color3.fromRGB(0, 180, 90), Thickness = 1.2})
    
    local txt = Instance.new("TextLabel", btn)
    txt.Size = UDim2.new(1, -35, 1, 0)
    txt.Position = UDim2.new(0, 8, 0, 0)
    txt.BackgroundTransparency = 1
    txt.Text = name
    txt.TextColor3 = Color3.fromRGB(230, 255, 240)
    txt.TextSize = 11
    txt.Font = Enum.Font.GothamBold
    txt.TextXAlignment = Enum.TextXAlignment.Left
    
    local dot = Instance.new("Frame", btn)
    dot.Size = UDim2.new(0, 14, 0, 14)
    dot.Position = UDim2.new(1, -22, 0.5, -7)
    dot.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    
    local active = false
    btn.Activated:Connect(function()
        active = not active
        dot.BackgroundColor3 = active and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(0, 255, 120)
        callback(active)
    end)
end

-- 3. ФУНКЦИИ

-- Усиленный Флай (Мгновенный подъем и абсолютная сила тяги)
local iyFlying = false
local flySpeed = 60
AddButton("Fly (Усиленный мощный)", function(v)
    iyFlying = v
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    if iyFlying then
        hum.PlatformStand = true
        local bv = Instance.new("BodyVelocity")
        bv.Name = "IY_FlyVelocity"
        -- Максимальная мощность во все стороны, чтобы персонажа вообще не тянуло вниз
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = hrp

        task.spawn(function()
            while iyFlying and ScreenGui.Parent do
                RunService.RenderStepped:Wait()
                local currentChar = LocalPlayer.Character
                if not currentChar then break end
                local currentHrp = currentChar:FindFirstChild("HumanoidRootPart")
                local currentHum = currentChar:FindFirstChildOfClass("Humanoid")
                local activeBv = currentHrp and currentHrp:FindFirstChild("IY_FlyVelocity")
                if not currentHrp or not currentHum or not activeBv then break end

                local camCFrame = Camera.CFrame
                local moveDir = currentHum.MoveDirection
                
                if moveDir.Magnitude > 0 then
                    -- Направление строго по камере и джойстику с учетом наклона вверх/вниз
                    activeBv.Velocity = (camCFrame.RightVector * moveDir.X + camCFrame.LookVector * moveDir.Z).Unit * flySpeed
                else
                    activeBv.Velocity = Vector3.new(0, 0.1, 0)
                end
                
                currentHrp.CFrame = CFrame.new(currentHrp.Position, currentHrp.Position + camCFrame.LookVector)
            end
            if hrp and hrp:FindFirstChild("IY_FlyVelocity") then
                hrp.IY_FlyVelocity:Destroy()
            end
        end)
    else
        hum.PlatformStand = false
        if hrp and hrp:FindFirstChild("IY_FlyVelocity") then
            hrp.IY_FlyVelocity:Destroy()
        end
        if hrp then hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0) end
    end
end)

-- Флинг стоя
local newFlingActive = false
AddButton("Fling (Стоя)", function(v) 
    newFlingActive = v 
    if not v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end
end)

RunService.Heartbeat:Connect(function()
    if newFlingActive and ScreenGui.Parent then
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hrp and hum then
            hrp.AssemblyAngularVelocity = Vector3.new(0, 700, 0)
        end
    end
end)

-- Noclip
local noclipActive = false
AddButton("Noclip", function(v) 
    noclipActive = v 
    if not v and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = true end
        end
    end
end)
RunService.Stepped:Connect(function()
    if noclipActive and ScreenGui.Parent and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)

-- Speed Hack
local speedActive = false
AddButton("Speed Hack", function(v) 
    speedActive = v 
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum and not v then hum.WalkSpeed = 16 end
end)
RunService.Heartbeat:Connect(function()
    if speedActive and ScreenGui.Parent and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 35
    end
end)

-- High Jump
local highJumpActive = false
AddButton("High Jump", function(v) 
    highJumpActive = v 
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum and not v then hum.JumpPower = 50 end
end)
RunService.Heartbeat:Connect(function()
    if highJumpActive and ScreenGui.Parent and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = 120
    end
end)
