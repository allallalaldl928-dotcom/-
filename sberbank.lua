-- SBERBANK HUB [FINAL ULTIMATE EDITION]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local Camera = Workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("SberbankHubGui") then
    CoreGui.SberbankHubGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "SberbankHubGui"
ScreenGui.ResetOnSpawn = false

-- Кнопка открытия/закрытия хаба
local ToggleButton = Instance.new("ImageButton", ScreenGui)
ToggleButton.Size = UDim2.new(0, 45, 0, 45)
ToggleButton.Position = UDim2.new(0, 20, 0, 200)
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 130, 65)
ToggleButton.Image = "rbxassetid://18828254115"
ToggleButton.ScaleType = Enum.ScaleType.Crop
ToggleButton.Draggable = true
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", ToggleButton, {Color = Color3.fromRGB(255, 255, 255), Thickness = 2})

-- Главное окно (Стиль Сбербанка с градиентом)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 260, 0, 450)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -225)
MainFrame.BackgroundColor3 = Color3.fromRGB(5, 25, 12)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.ClipsDescendants = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 12)
Instance.new("UIStroke", MainFrame, {Color = Color3.fromRGB(0, 210, 100), Thickness = 2.5})

-- Премиальный градиент Сбера на фоне
local BgGradient = Instance.new("UIGradient", MainFrame)
BgGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(5, 35, 18)),
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(2, 15, 8)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 8, 4))
})
BgGradient.Rotation = 45

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Заголовок
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, -16, 0, 42)
Title.Position = UDim2.new(0, 8, 0, 8)
Title.BackgroundColor3 = Color3.fromRGB(0, 100, 50)
Title.BackgroundTransparency = 0.2
Title.Text = "SBERBANK HUB [PRO]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 13
Title.Font = Enum.Font.GothamBold
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", Title, {Color = Color3.fromRGB(0, 255, 120), Thickness = 1.5})

local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, -12, 1, -62)
Scroll.Position = UDim2.new(0, 6, 0, 56)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 1800)
Scroll.ScrollBarThickness = 3
local UIList = Instance.new("UIListLayout", Scroll)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 6)

-- Функция создания кнопки с анимацией
local function AddButton(name, callback)
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(10, 45, 25)
    btn.BackgroundTransparency = 0.2
    btn.AutoButtonColor = false
    btn.Text = ""
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", btn, {Color = Color3.fromRGB(0, 180, 90), Thickness = 1.2})
    
    local txt = Instance.new("TextLabel", btn)
    txt.Size = UDim2.new(1, -45, 1, 0)
    txt.Position = UDim2.new(0, 10, 0, 0)
    txt.BackgroundTransparency = 1
    txt.Text = name
    txt.TextColor3 = Color3.fromRGB(230, 255, 240)
    txt.TextSize = 11
    txt.Font = Enum.Font.GothamBold
    txt.TextXAlignment = Enum.TextXAlignment.Left
    
    local spinIcon = Instance.new("Frame", btn)
    spinIcon.Size = UDim2.new(0, 22, 0, 22)
    spinIcon.Position = UDim2.new(1, -28, 0.5, -11)
    spinIcon.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
    Instance.new("UICorner", spinIcon).CornerRadius = UDim.new(1, 0)
    
    task.spawn(function()
        while spinIcon and spinIcon.Parent do
            TweenService:Create(spinIcon, TweenInfo.new(1.5, Enum.EasingStyle.Linear), {Rotation = spinIcon.Rotation + 360}):Play()
            task.wait(1.5)
        end
    end)
    
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.BackgroundColor3 = active and Color3.fromRGB(0, 130, 65) or Color3.fromRGB(10, 45, 25)
        callback(active)
    end)
end

-- 1. ПОЛНОЦЕННЫЙ 3D ФЛАЙ
local flyActive = false
local flySpeed = 50
local bv, bg

AddButton("Fly Mode (Full 3D)", function(v)
    flyActive = v
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    
    if flyActive then
        if hum then hum.PlatformStand = true end
        if hrp then
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
            
            bv = Instance.new("BodyVelocity", hrp)
            bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
            bv.Velocity = Vector3.new(0, 0, 0)
            
            bg = Instance.new("BodyGyro", hrp)
            bg.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
            bg.CFrame = hrp.CFrame
        end
    else
        if hum then hum.PlatformStand = false end
        if bv then bv:Destroy() bv = nil end
        if bg then bg:Destroy() bg = nil end
    end
end)

RunService.RenderStepped:Connect(function()
    if flyActive and LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hrp and hum and bv and bg then
            bg.CFrame = Camera.CFrame
            local moveDir = hum.MoveDirection
            local velocity = Vector3.new(0, 0, 0)
            
            if moveDir.Magnitude > 0 then
                velocity = Camera.CFrame:VectorToWorldSpace(Vector3.new(moveDir.X, 0, moveDir.Z)) * flySpeed
            end
            
            if hum.Jump then
                velocity = velocity + Vector3.new(0, flySpeed, 0)
            end
            
            bv.Velocity = velocity
        end
    end
end)

-- 2. ESP BOX + ЛИНИИ
local espActive = false
local espObjects = {}

AddButton("Box + Lines ESP", function(v)
    espActive = v
    if not v then
        for _, obj in pairs(espObjects) do
            if obj then obj:Remove() end
        end
        espObjects = {}
    end
end)

RunService.RenderStepped:Connect(function()
    if not espActive then return end
    
    for _, obj in pairs(espObjects) do
        if obj then obj:Remove() end
    end
    espObjects = {}

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Head") then
            local hrp = plr.Character.HumanoidRootPart
            local head = plr.Character.Head
            
            local vector, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                local line = Drawing.new("Line")
                line.Visible = true
                line.From = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                line.To = Vector2.new(vector.X, vector.Y)
                line.Color = Color3.fromRGB(0, 255, 128)
                line.Thickness = 1.5
                table.insert(espObjects, line)

                local topVector = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.8, 0))
                local bottomVector = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 2.2, 0))
                local boxHeight = math.abs(topVector.Y - bottomVector.Y)
                local boxWidth = boxHeight / 2

                local box = Drawing.new("Square")
                box.Visible = true
                box.Size = Vector2.new(boxWidth, boxHeight)
                box.Position = Vector2.new(topVector.X - boxWidth / 2, topVector.Y)
                box.Color = Color3.fromRGB(0, 255, 128)
                box.Thickness = 1.5
                box.Filled = false
                table.insert(espObjects, box)
            end
        end
    end
end)

-- 3. МОЩНЫЙ ФЛИНГ
local flingActive = false
AddButton("Fling Spin (Мощный Флинг)", function(v)
    flingActive = v
end)

RunService.Heartbeat:Connect(function()
    if flingActive and LocalPlayer.Character then
        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local target = nil
            local minDist = math.huge
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
                    local dist = (hrp.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                    if dist < minDist then
                        minDist = dist
                        target = plr.Character.HumanoidRootPart
                    end
                end
            end
            
            if target then
                hrp.CFrame = target.CFrame
            end
            
            hrp.AssemblyAngularVelocity = Vector3.new(99999, 99999, 99999)
            hrp.AssemblyLinearVelocity = Vector3.new(99999, 99999, 99999)
        end
    end
end)

-- 4. ШИФТЛОК
local shiftLockActive = false
local ShiftLockButton = Instance.new("TextButton", ScreenGui)
ShiftLockButton.Size = UDim2.new(0, 45, 0, 45)
ShiftLockButton.Position = UDim2.new(1, -65, 0.4, 0)
ShiftLockButton.BackgroundColor3 = Color3.fromRGB(15, 40, 25)
ShiftLockButton.Text = "🔒"
ShiftLockButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ShiftLockButton.TextSize = 20
Instance.new("UICorner", ShiftLockButton).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", ShiftLockButton, {Color = Color3.fromRGB(0, 200, 100), Thickness = 2})

ShiftLockButton.MouseButton1Click:Connect(function()
    shiftLockActive = not shiftLockActive
    ShiftLockButton.BackgroundColor3 = shiftLockActive and Color3.fromRGB(0, 130, 65) or Color3.fromRGB(15, 40, 25)
end)

RunService.RenderStepped:Connect(function()
    if shiftLockActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(LocalPlayer.Character.HumanoidRootPart.Position, Vector3.new(Camera.CFrame.LookVector.X * 9999, LocalPlayer.Character.HumanoidRootPart.Position.Y, Camera.CFrame.LookVector.Z * 9999))
    end
end)

-- 5. ПАНЕЛЬ POJAV LAUNCHER
local PojavPanel = Instance.new("Frame", ScreenGui)
PojavPanel.Size = UDim2.new(1, 0, 1, 0)
PojavPanel.BackgroundTransparency = 1
PojavPanel.Visible = true

local function CreatePojavKey(name, size, pos)
    local btn = Instance.new("TextButton", PojavPanel)
    btn.Size = size
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(15, 40, 25)
    btn.BackgroundTransparency = 0.35
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 14
    btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", btn, {Color = Color3.fromRGB(0, 180, 90), Thickness = 1.5})
    return btn
end

local btnEsc = CreatePojavKey("Esc", UDim2.new(0, 50, 0, 35), UDim2.new(0, 10, 0, 10))
local btnLKM = CreatePojavKey("ЛКМ", UDim2.new(0, 90, 0, 45), UDim2.new(0, 70, 0, 10))
local btnPKM = CreatePojavKey("ПКМ", UDim2.new(0, 90, 0, 45), UDim2.new(0, 170, 0, 10))
local btnQ   = CreatePojavKey("Q", UDim2.new(0, 45, 0, 45), UDim2.new(1, -60, 0, 10))
local btnE   = CreatePojavKey("E", UDim2.new(0, 45, 0, 45), UDim2.new(0, 270, 0, 10))
local btnShift = CreatePojavKey("Shift", UDim2.new(0, 60, 0, 35), UDim2.new(0, 330, 0, 10))

btnE.MouseButton1Click:Connect(function()
    local vim = game:GetService("VirtualInputManager")
    vim:SendKeyEvent(true, Enum.KeyCode.E, false, game)
    task.wait(0.05)
    vim:SendKeyEvent(false, Enum.KeyCode.E, false, game)
end)

print("Sberbank Hub [Final Edition] успешно запущен!")
