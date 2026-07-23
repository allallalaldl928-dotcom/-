-- SBERBANK HUB [FULL UI MOBILE FIXED]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
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

local ToggleButton = Instance.new("ImageButton", ScreenGui)
ToggleButton.Size = UDim2.new(0, 45, 0, 45)
ToggleButton.Position = UDim2.new(0, 20, 0, 200)
ToggleButton.BackgroundColor3 = Color3.fromRGB(0, 130, 65)
ToggleButton.Image = "rbxassetid://18828254115"
ToggleButton.ScaleType = Enum.ScaleType.Crop
ToggleButton.Draggable = true
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", ToggleButton, {Color = Color3.fromRGB(255, 255, 255), Thickness = 2})

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 260, 0, 460)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -230)
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

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, -16, 0, 40)
Title.Position = UDim2.new(0, 8, 0, 8)
Title.BackgroundColor3 = Color3.fromRGB(0, 100, 50)
Title.BackgroundTransparency = 0.2
Title.Text = "SBERBANK HUB [FIXED]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 12
Title.Font = Enum.Font.GothamBold
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", Title, {Color = Color3.fromRGB(0, 255, 120), Thickness = 1.5})

local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, -12, 1, -60)
Scroll.Position = UDim2.new(0, 6, 0, 54)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 1150)
Scroll.ScrollBarThickness = 3
local UIList = Instance.new("UIListLayout", Scroll)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 5)

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
    btn.MouseButton1Click:Connect(function()
        active = not active
        dot.BackgroundColor3 = active and Color3.fromRGB(255, 50, 50) or Color3.fromRGB(0, 255, 120)
        callback(active)
    end)
end

-- 1. ФЛИНГ
local flingActive = false
AddButton("Fling (Безопасная крутилка)", function(v) flingActive = v end)
RunService.Heartbeat:Connect(function()
    if flingActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        hrp.AssemblyAngularVelocity = Vector3.new(0, 25000, 0)
        hrp.AssemblyLinearVelocity = Vector3.new(hrp.AssemblyLinearVelocity.X, 2, hrp.AssemblyLinearVelocity.Z)
    end
end)

-- 2. ФЛАЙ
local flyActive = false
local flySpeed = 50
local bv, bg
AddButton("Fly (Полет 3D)", function(v)
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
            if hum.Jump then velocity = velocity + Vector3.new(0, flySpeed, 0) end
            bv.Velocity = velocity
        end
    end
end)

-- 3. СПИД ХАК
local speedActive = false
AddButton("Speed Hack (Скорость)", function(v) speedActive = v end)
RunService.Heartbeat:Connect(function()
    if speedActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").WalkSpeed = 35
    end
end)

-- 4. НОКЛИП
local noclipActive = false
AddButton("Noclip (Проход сквозь стены)", function(v) noclipActive = v end)
RunService.Stepped:Connect(function()
    if noclipActive and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- 5-8. ЕСП
local espBoxActive = false
local boxObjects = {}
AddButton("ESP Box (Игроки)", function(v) espBoxActive = v end)

local espLinesActive = false
local lineObjects = {}
AddButton("ESP Lines (Трасеры)", function(v) espLinesActive = v end)

local espPlayerNames = false
local nameObjects = {}
AddButton("ESP Player (Никнеймы)", function(v) espPlayerNames = v end)

local espNpcActive = false
local npcObjects = {}
AddButton("ESP NPC", function(v) espNpcActive = v end)

RunService.RenderStepped:Connect(function()
    for _, o in pairs(boxObjects) do if o then o:Remove() end end boxObjects = {}
    for _, o in pairs(lineObjects) do if o then o:Remove() end end lineObjects = {}
    for _, o in pairs(nameObjects) do if o then o:Remove() end end nameObjects = {}
    for _, o in pairs(npcObjects) do if o then o:Remove() end end npcObjects = {}

    if espBoxActive or espLinesActive or espPlayerNames then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Head") then
                local hrp = plr.Character.HumanoidRootPart
                local head = plr.Character.Head
                local vec, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                if onScreen then
                    if espLinesActive then
                        local l = Drawing.new("Line")
                        l.Visible = true
                        l.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                        l.To = Vector2.new(vec.X, vec.Y)
                        l.Color = Color3.fromRGB(0, 255, 128)
                        l.Thickness = 1
                        table.insert(lineObjects, l)
                    end
                    if espBoxActive then
                        local top = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                        local bot = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 2, 0))
                        local h = math.abs(top.Y - bot.Y)
                        local w = h / 2
                        local b = Drawing.new("Square")
                        b.Visible = true
                        b.Size = Vector2.new(w, h)
                        b.Position = Vector2.new(top.X - w/2, top.Y)
                        b.Color = Color3.fromRGB(0, 255, 128)
                        b.Thickness = 1
                        b.Filled = false
                        table.insert(boxObjects, b)
                    end
                    if espPlayerNames then
                        local t = Drawing.new("Text")
                        t.Visible = true
                        t.Text = plr.Name
                        t.Size = 14
                        t.Center = true
                        t.Outline = true
                        t.Color = Color3.fromRGB(255, 255, 255)
                        local top = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1.2, 0))
                        t.Position = Vector2.new(top.X, top.Y)
                        table.insert(nameObjects, t)
                    end
                end
            end
        end
    end
end)

-- 9. ФРИЗ
local freezeActive = false
AddButton("Freeze (Заморозить игроков)", function(v) freezeActive = v end)
RunService.Heartbeat:Connect(function()
    if freezeActive then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Anchored = true
            end
        end
    else
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Anchored = false
            end
        end
    end
end)

-- 10. БРИНГ ЛУТА
AddButton("Bring All Items (Собрать лут)", function()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Tool") and obj:FindFirstChild("Handle") then
            obj.Handle.CFrame = hrp.CFrame
        end
    end
end)

-- КАСТОМНЫЙ ДЖОЙСТИК
local thumbstickArea = Instance.new("Frame", ScreenGui)
thumbstickArea.Name = "CustomThumbstickArea"
thumbstickArea.Size = UDim2.new(0, 180, 0, 180)
thumbstickArea.Position = UDim2.new(0, 45, 1, -210)
thumbstickArea.BackgroundTransparency = 1

local stickBase = Instance.new("Frame", thumbstickArea)
stickBase.Size = UDim2.new(0, 100, 0, 100)
stickBase.Position = UDim2.new(0.5, -50, 0.5, -50)
stickBase.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
stickBase.BackgroundTransparency = 0.6
Instance.new("UICorner", stickBase).CornerRadius = UDim.new(1, 0)

local stickKnob = Instance.new("Frame", stickBase)
stickKnob.Size = UDim2.new(0, 45, 0, 45)
stickKnob.Position = UDim2.new(0.5, -22, 0.5, -22)
stickKnob.BackgroundColor3 = Color3.fromRGB(0, 255, 120)
stickKnob.BackgroundTransparency = 0.3
Instance.new("UICorner", stickKnob).CornerRadius = UDim.new(1, 0)

local draggingStick = false
local stickCenter = Vector2.new(0, 0)
local currentMoveVector = Vector3.new(0, 0, 0)

thumbstickArea.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingStick = true
        stickCenter = stickBase.AbsolutePosition + (stickBase.AbsoluteSize / 2)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
        draggingStick = false
        stickKnob.Position = UDim2.new(0.5, -22, 0.5, -22)
        currentMoveVector = Vector3.new(0, 0, 0)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if draggingStick and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) then
        local mousePos = Vector2.new(input.Position.X, input.Position.Y)
        local delta = mousePos - stickCenter
        local maxDist = 40
        if delta.Magnitude > maxDist then
            delta = delta.Unit * maxDist
        end
        stickKnob.Position = UDim2.new(0.5, delta.X - 22, 0.5, delta.Y - 22)
        local moveX = delta.X / maxDist
        local moveY = delta.Y / maxDist
        currentMoveVector = Vector3.new(moveX, 0, moveY)
    end
end)

RunService.RenderStepped:Connect(function()
    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if currentMoveVector.Magnitude > 0 then
            local camFwd = Camera.CFrame.LookVector
            local camRight = Camera.CFrame.RightVector
            camFwd = Vector3.new(camFwd.X, 0, camFwd.Z).Unit
            camRight = Vector3.new(camRight.X, 0, camRight.Z).Unit
            local moveDir = (camFwd * -currentMoveVector.Z) + (camRight * currentMoveVector.X)
            hum:Move(moveDir, true)
        end
    end
end)

-- ЭКРАННЫЕ КНОПКИ УПРАВЛЕНИЯ
local vim = game:GetService("VirtualInputManager")

local function CreateKey(name, size, pos, keyCode, isMouse)
    local btn = Instance.new("TextButton", ScreenGui)
    btn.Size = size
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.BackgroundTransparency = 0.5
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
    Instance.new("UIStroke", btn, {Color = Color3.fromRGB(200, 200, 200), Thickness = 2})

    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            btn.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
            if isMouse == "Left" then
                vim:SendMouseButtonEvent(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2, 0, true, game, 1)
            elseif isMouse == "Right" then
                vim:SendMouseButtonEvent(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2, 1, true, game, 1)
            elseif keyCode then
                vim:SendKeyEvent(true, keyCode, false, game)
            end
        end
    end)

    btn.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
            if isMouse == "Left" then
                vim:SendMouseButtonEvent(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2, 0, false, game, 1)
            elseif isMouse == "Right" then
                vim:SendMouseButtonEvent(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2, 1, false, game, 1)
            elseif keyCode then
                vim:SendKeyEvent(false, keyCode, false, game)
            end
        end
    end)
end

CreateKey("Esc", UDim2.new(0, 60, 0, 45), UDim2.new(0, 10, 0, 50), Enum.KeyCode.Escape, nil)
CreateKey("E", UDim2.new(0, 60, 0, 45), UDim2.new(0, 10, 0, 105), Enum.KeyCode.E, nil)
CreateKey("ЛКМ", UDim2.new(0, 100, 0, 60), UDim2.new(0.25, -50, 0, 45), nil, "Left")
CreateKey("ПКМ", UDim2.new(0, 100, 0, 60), UDim2.new(0.65, -50, 0, 45), nil, "Right")
CreateKey("Q", UDim2.new(0, 55, 0, 55), UDim2.new(1, -70, 0, 55), Enum.KeyCode.Q, nil)
CreateKey("Shift", UDim2.new(0, 80, 0, 60), UDim2.new(0.65, -40, 0.55, 0), Enum.KeyCode.LeftShift, nil)

print("Sberbank Hub успешно запущен!")
