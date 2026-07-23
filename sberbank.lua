local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local Workspace = game:GetService("Workspace")
local VirtualInputManager = game:GetService("VirtualInputManager")
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
Title.Text = "SBERBANK HUB [FINAL FIX]"
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
Scroll.CanvasSize = UDim2.new(0, 0, 0, 1000)
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

-- Флай (IY стиль без падения)
local iyFlying = false
local flySpeed = 50
AddButton("Fly (Fixed No-Fall)", function(v)
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
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
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
                    activeBv.Velocity = (camCFrame.RightVector * moveDir.X + camCFrame.LookVector * moveDir.Z).Unit * flySpeed
                else
                    activeBv.Velocity = Vector3.new(0, 0, 0)
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

-- Флинг стоя и с возможностью ходить
local standFlingActive = false
AddButton("Fling (Стоя и с ходьбой)", function(v) 
    standFlingActive = v 
    if not v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end
end)

RunService.Heartbeat:Connect(function()
    if standFlingActive and ScreenGui.Parent then
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hrp and hum then
            -- Вращаем только по оси Y, заставляя персонажа оставаться вертикально (стоя)
            local currentAngle = hrp.CFrams and hrp.CFrame.Rotation or hrp.CFrame
            hrp.AssemblyAngularVelocity = Vector3.new(0, 1000, 0)
        end
    end
end)

-- Noclip
local noclipActive = false
AddButton("Noclip (Сквозь стены)", function(v) 
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
AddButton("Speed Hack (Скорость)", function(v) 
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
AddButton("High Jump (Прыжок)", function(v) 
    highJumpActive = v 
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum and not v then hum.JumpPower = 50 end
end)
RunService.Heartbeat:Connect(function()
    if highJumpActive and ScreenGui.Parent and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character:FindFirstChildOfClass("Humanoid").JumpPower = 120
    end
end)

-- ESP Переменные
local espBoxActive = false
local boxObjects = {}
AddButton("ESP Box", function(v) espBoxActive = v if not v then for _, o in pairs(boxObjects) do if o then o:Remove() end end boxObjects = {} end)

local espLinesActive = false
local lineObjects = {}
AddButton("ESP Lines (Трасеры)", function(v) espLinesActive = v if not v then for _, o in pairs(lineObjects) do if o then o:Remove() end end lineObjects = {} end)

local espPlayerNames = false
local nameObjects = {}
AddButton("ESP Player (Ники)", function(v) espPlayerNames = v if not v then for _, o in pairs(nameObjects) do if o then o:Remove() end end nameObjects = {} end)

local espRolesActive = false
local roleObjects = {}
AddButton("ESP Roles (Роли)", function(v) espRolesActive = v if not v then for _, o in pairs(roleObjects) do if o then o:Remove() end end roleObjects = {} end)

local espNpcActive = false
local npcObjects = {}
AddButton("ESP NPC", function(v) espNpcActive = v if not v then for _, o in pairs(npcObjects) do if o then o:Remove() end end npcObjects = {} end)

RunService.RenderStepped:Connect(function()
    for _, o in pairs(boxObjects) do if o then o:Remove() end end boxObjects = {}
    for _, o in pairs(lineObjects) do if o then o:Remove() end end lineObjects = {}
    for _, o in pairs(nameObjects) do if o then o:Remove() end end nameObjects = {}
    for _, o in pairs(roleObjects) do if o then o:Remove() end end roleObjects = {}
    for _, o in pairs(npcObjects) do if o then o:Remove() end end npcObjects = {}

    if not ScreenGui.Parent then return end

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

    if espNpcActive then
        for _, model in ipairs(Workspace:GetDescendants()) do
            if model:IsA("Model") and model:FindFirstChild("Humanoid") and model:FindFirstChild("HumanoidRootPart") then
                if not Players:GetPlayerFromCharacter(model) then
                    local hrp = model.HumanoidRootPart
                    local vec, onScreen = Camera:WorldToViewportPoint(hrp.Position)
                    if onScreen then
                        local t = Drawing.new("Text")
                        t.Visible = true
                        t.Text = "[NPC: " .. model.Name .. "]"
                        t.Size = 13
                        t.Center = true
                        t.Outline = true
                        t.Color = Color3.fromRGB(255, 165, 0)
                        t.Position = Vector2.new(vec.X, vec.Y)
                        table.insert(npcObjects, t)
                    end
                end
            end
        end
    end
end)

-- Заморозка (Freeze)
local freezeActive = false
AddButton("Freeze (Заморозка)", function(v) 
    freezeActive = v
    if not freezeActive then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Anchored = false
            end
        end
    end
end)

RunService.Heartbeat:Connect(function()
    if freezeActive and ScreenGui.Parent then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
                p.Character.HumanoidRootPart.Anchored = true
            end
        end
    end
end)

AddButton("Bring All Items (Лут)", function()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Tool") and obj:FindFirstChild("Handle") then
            obj.Handle.CFrame = hrp.CFrame
        end
    end
end)

-- 4. КНОПКИ УПРАВЛЕНИЯ E, Q, Shift ДЛЯ МОБИЛЬНЫХ
local function CreateScreenButton(name, size, pos, callbackDown, callbackUp)
    local btn = Instance.new("TextButton", ScreenGui)
    btn.Size = size
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(0, 100, 50)
    btn.BackgroundTransparency = 0.3
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 13
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = true
    btn.Active = false
    btn.Modal = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", btn, {Color = Color3.fromRGB(0, 255, 120), Thickness = 1.5})
    
    if callbackDown then
        btn.MouseButton1Down:Connect(callbackDown)
        btn.TouchStarted:Connect(callbackDown)
    end
    if callbackUp then
        btn.MouseButton1Up:Connect(callbackUp)
        btn.TouchEnded:Connect(callbackUp)
    end
    return btn
end

-- Кнопка E
CreateScreenButton("E", UDim2.new(0, 42, 0, 42), UDim2.new(1, -55, 0.45, 0), function()
    pcall(function() VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.E, false, game) end)
end, function()
    pcall(function() VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.E, false, game) end)
end)

-- Кнопка Q
CreateScreenButton("Q", UDim2.new(0, 42, 0, 42), UDim2.new(1, -55, 0.45, -50), function()
    pcall(function() VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Q, false, game) end)
end, function()
    pcall(function() VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Q, false, game) end)
end)

-- Кнопка Shift
CreateScreenButton("Shift", UDim2.new(0, 50, 0, 42), UDim2.new(1, -112, 0.45, 0), function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = (hum