-- SBERBANK HUB [INFINITE YIELD INTEGRATION]
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
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

-- Уменьшенная высота меню (видно 3-4 функции)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 260, 0, 210)
MainFrame.Position = UDim2.new(0.5, -130, 0.5, -105)
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
Title.Size = UDim2.new(1, -16, 0, 32)
Title.Position = UDim2.new(0, 8, 0, 8)
Title.BackgroundColor3 = Color3.fromRGB(0, 100, 50)
Title.BackgroundTransparency = 0.2
Title.Text = "SBERBANK HUB [IY]"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 11
Title.Font = Enum.Font.GothamBold
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", Title, {Color = Color3.fromRGB(0, 255, 120), Thickness = 1.5})

local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, -12, 1, -50)
Scroll.Position = UDim2.new(0, 6, 0, 46)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 1250)
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

-- 1. ФЛИНГ ИЗ INFINITE YIELD
local flingActive = false
AddButton("Fling (Infinite Yield)", function(v) flingActive = v end)

RunService.Heartbeat:Connect(function()
    if flingActive then
        local character = LocalPlayer.Character
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if rootPart and humanoid then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
            local vel = rootPart.AssemblyLinearVelocity
            rootPart.AssemblyLinearVelocity = Vector3.new(0, 4000, 0) + Vector3.new(vel.X * 50, 0, vel.Z * 50)
            RunService.RenderStepped:Wait()
            if rootPart then
                rootPart.AssemblyLinearVelocity = Vector3.new(0, -4000, 0) + Vector3.new(vel.X * 50, 0, vel.Z * 50)
                rootPart.CFrame = rootPart.CFrame * CFrame.Angles(math.rad(math.random(-360, 360)), math.rad(math.random(-360, 360)), math.rad(math.random(-360, 360)))
            end
        end
    end
end)

-- 2. ФЛАЙ ИЗ INFINITE YIELD
local flyKeyDown, flyKeyUp
local flying = false
local iySpeed = 50

AddButton("Fly (Infinite Yield)", function(v)
    local character = LocalPlayer.Character
    if not character then return end
    local rootPart = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not rootPart or not humanoid then return end

    if not v and flying then
        flying = false
        humanoid.PlatformStand = false
        if flyKeyDown then flyKeyDown:Disconnect() end
        if flyKeyUp then flyKeyUp:Disconnect() end
        return
    elseif v and not flying then
        flying = true
        humanoid.PlatformStand = true

        local bv = Instance.new("BodyVelocity", rootPart)
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Velocity = Vector3.new(0, 0, 0)

        local bg = Instance.new("BodyGyro", rootPart)
        bg.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
        bg.CFrame = rootPart.CFrame

        local ctrl = {f = 0, b = 0, l = 0, r = 0}
        local lastctrl = {f = 0, b = 0, l = 0, r = 0}

        flyKeyDown = UserInputService.InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.W then ctrl.f = 1
            elseif input.KeyCode == Enum.KeyCode.S then ctrl.b = -1
            elseif input.KeyCode == Enum.KeyCode.A then ctrl.l = -1
            elseif input.KeyCode == Enum.KeyCode.D then ctrl.r = 1
            end
        end)

        flyKeyUp = UserInputService.InputEnded:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.W then ctrl.f = 0
            elseif input.KeyCode == Enum.KeyCode.S then ctrl.b = 0
            elseif input.KeyCode == Enum.KeyCode.A then ctrl.l = 0
            elseif input.KeyCode == Enum.KeyCode.D then ctrl.r = 0
            end
        end)

        task.spawn(function()
            while flying do
                RunService.RenderStepped:Wait()
                if not rootPart.Parent or not humanoid.Parent then break end
                if ctrl.f + ctrl.b ~= 0 or ctrl.l + ctrl.r ~= 0 then
                    bv.Velocity = ((Camera.CFrame.LookVector * (ctrl.f + ctrl.b)) + ((Camera.CFrame * CFrame.new(ctrl.l + ctrl.r, (ctrl.f + ctrl.b) * 0.2, 0).Position) - Camera.CFrame.Position)) * iySpeed
                    lastctrl = {f = ctrl.f, b = ctrl.b, l = ctrl.l, r = ctrl.r}
                elseif lastctrl.f + lastctrl.b ~= 0 or lastctrl.l + lastctrl.r ~= 0 then
                    bv.Velocity = ((Camera.CFrame.LookVector * (lastctrl.f + lastctrl.b)) + ((Camera.CFrame * CFrame.new(lastctrl.l + lastctrl.r, (lastctrl.f + lastctrl.b) * 0.2, 0).Position) - Camera.CFrame.Position)) * iySpeed
                else
                    bv.Velocity = Vector3.new(0, 0, 0)
                end
                bg.CFrame = Camera.CFrame
            end
            ctrl = {f = 0, b = 0, l = 0, r = 0}
            lastctrl = {f = 0, b = 0, l = 0, r = 0}
            if bv then bv:Destroy() end
            if bg then bg:Destroy() end
            if humanoid then humanoid.PlatformStand = false end
        end)
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

-- 4. ВЫСОКИЙ ПРЫЖОК
local highJumpActive = false
AddButton("High Jump (Высокий прыжок)", function(v) highJumpActive = v end)
RunService.Heartbeat:Connect(function()
    if highJumpActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = 120
    else
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
            LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = 50
        end
    end
end)

-- 5. БАНИХОП
local bhopActive = false
AddButton("Bhop (Авто-прыжок при беге)", function(v) bhopActive = v end)
RunService.Heartbeat:Connect(function()
    if bhopActive and LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.MoveDirection.Magnitude > 0 then
            if hum.FloorMaterial ~= Enum.Material.Air then
                hum:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end
    end
end)

-- 6. НОКЛИП
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

-- 7-10. ЕСП
local espBoxActive = false
local boxObjects = {}
AddButton("ESP Box (Игроки)", function(v) espBoxActive = v end)

local espLinesActive = false
local lineObjects = {}
AddButton("ESP Lines (Трасеры)", function(v) espLinesActive = v end)

local espPlayerNames = false
local nameObjects = {}
AddButton("ESP Player (Никнеймы)", function(v) espPlayerNames = v end)

local espRolesActive = false
local roleObjects = {}
AddButton("ESP Roles (Роли игроков)", function(v) espRolesActive = v end)

RunService.RenderStepped:Connect(function()
    for _, o in pairs(boxObjects) do if o then o:Remove() end end boxObjects = {}
    for _, o in pairs(lineObjects) do if o then o:Remove() end end lineObjects = {}
    for _, o in pairs(nameObjects) do if o then o:Remove() end end nameObjects = {}
    for _, o in pairs(roleObjects) do if o then o:Remove() end end roleObjects = {}

    if espBoxActive or espLinesActive or espPlayerNames or espRolesActive then
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") and plr.Character:FindFirstChild("Head") then
                local hrp = plr.Character.HumanoidRootPart
                local head = plr.Character.Head
                local vec, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                
                local roleColor = Color3.fromRGB(0, 255, 128)
                local roleText = "Игрок"
                
                local char = plr.Character
                local backpack = plr:FindFirstChildOfClass("Backpack")
                
                local function checkTool(t)
                    if not t then return end
                    local name = t.Name:lower()
                    if name:find("gun") or name:find("pistol") or name:find("revolver") or name:find("шериф") then
                        roleColor = Color3.fromRGB(0, 150, 255)
                        roleText = "Шериф"
                    elseif name:find("knife") or name:find("sword") or name:find("dagger") or name:find("убийца") or name:find("murder") then
                        roleColor = Color3.fromRGB(255, 50, 50)
                        roleText = "Убийца"
                    end
                end
                
                if char:FindFirstChildOfClass("Tool") then checkTool(char:FindFirstChildOfClass("Tool")) end
                if backpack then
                    for _, t in ipairs(backpack:GetChildren()) do checkTool(t) end
                end

                if onScreen then
                    if espLinesActive then
                        local l = Drawing.new("Line")
                        l.Visible = true
                        l.From = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y)
                        l.To = Vector2.new(vec.X, vec.Y)
                        l.Color = roleColor
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
                        b.Color = roleColor
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
                    if espRolesActive then
                        local r = Drawing.new("Text")
                        r.Visible = true
                        r.Text = "[" .. roleText .. "]"
                        r.Size = 13
                        r.Center = true
                        r.Outline = true
                        r.Color = roleColor
                        local top = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 2.3, 0))
                        r.Position = Vector2.new(top.X, top.Y)
                        table.insert(roleObjects, r)
                    end
                end
            end
        end
    end
end)

-- 11. ФРИЗ
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

-- 12. БРИНГ ЛУТА
AddButton("Bring All Items (Собрать лут)", function()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Tool") and obj:FindFirstChild("Handle") then
            obj.Handle.CFrame = hrp.CFrame
        end
    end
end)

-- КНОПКИ УПРАВЛЕНИЯ
local function CreateIsolatedButton(name, size, pos)
    local btn = Instance.new("TextButton", ScreenGui)
    btn.Size = size
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    btn.BackgroundTransparency = 0.4
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = true
    btn.Active = false
    btn.Selectable = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
    Instance.new("UIStroke", btn, {Color = Color3.fromRGB(200, 200, 200), Thickness = 2})
    return btn
end

CreateIsolatedButton("Esc", UDim2.new(0, 60, 0, 45), UDim2.new(0, 10, 0, 50))
CreateIsolatedButton("E", UDim2.new(0, 60, 0, 45), UDim2.new(0, 10, 0, 105))
CreateIsolatedButton("Q", UDim2.new(0, 55, 0, 55), UDim2.new(1, -70, 0, 55))
CreateIsolatedButton("Shift", UDim2.new(0, 80, 0, 60), UDim2.new(0.65, -40, 0.55, 0))

print("SBERBANK HUB [IY] успешно запущен!")
