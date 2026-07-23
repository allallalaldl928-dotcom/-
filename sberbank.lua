-- SBERBANK HUB [FINAL MOBILE FIXED PACK + PERFECT FLING]
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

-- Главное окно
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

-- 1. ФЛИНГ (ИДЕАЛЬНЫЙ: без наклонов и провалов под карту)
local flingActive = false
local bgFling, bavFling
AddButton("Fling (Безопасная крутилка)", function(v)
    flingActive = v
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    if flingActive then
        -- Запрещаем наклоняться по осям X и Z (Фикс "под углом")
        bgFling = Instance.new("BodyGyro", hrp)
        bgFling.P = 9e4
        bgFling.MaxTorque = Vector3.new(math.huge, 0, math.huge)
        bgFling.CFrame = hrp.CFrame

        -- Включаем стабильное вращение только по оси Y (Фикс "тепает под карту")
        bavFling = Instance.new("BodyAngularVelocity", hrp)
        bavFling.AngularVelocity = Vector3.new(0, 40000, 0) -- Скорость подобрана для мощного откидывания без багов
        bavFling.MaxTorque = Vector3.new(0, math.huge, 0)
    else
        if bgFling then bgFling:Destroy() end
        if bavFling then bavFling:Destroy() end
        hrp.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
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

-- 5. ЕСП БОКС
local espBoxActive = false
local boxObjects = {}
AddButton("ESP Box (Игроки)", function(v)
    espBoxActive = v
    if not v then for _, o in pairs(boxObjects) do if o then o:Remove() end end boxObjects = {} end
end)

-- 6. ЕСП ЛИНИИ
local espLinesActive = false
local lineObjects = {}
AddButton("ESP Lines (Трасеры)", function(v)
    espLinesActive = v
    if not v then for _, o in pairs(lineObjects) do if o then o:Remove() end end lineObjects = {} end
end)

-- 7. ЕСП ПЛЕЙЕР
local espPlayerNames = false
local nameObjects = {}
AddButton("ESP Player (Никнеймы)", function(v)
    espPlayerNames = v
    if not v then for _, o in pairs(nameObjects) do if o then o:Remove() end end nameObjects = {} end
end)

-- 8. ЕСП НПС
local espNpcActive = false
local npcObjects = {}
AddButton("ESP NPC", function(v)
    espNpcActive = v
    if not v then for _, o in pairs(npcObjects) do if o then o:Remove() end end npcObjects = {} end
end)

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

    if espNpcActive then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("Head") then
                if not Players:GetPlayerFromCharacter(obj) then
                    local head = obj.Head
                    local vec, onScreen = Camera:WorldToViewportPoint(head.Position)
                    if onScreen then
                        local t = Drawing.new("Text")
                        t.Visible = true
                        t.Text = "[NPC] " .. obj.Name
                        t.Size = 13
                        t.Center = true
                        t.Outline = true
                        t.Color = Color3.fromRGB(255, 200, 0)
                        t.Position = Vector2.new(vec.X, vec.Y)
                        table.insert(npcObjects, t)
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

-- 10. БРИНГ АЛ АЙТЕМС
AddButton("Bring All Items (Собрать лут)", function()
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("Tool") and obj:FindFirstChild("Handle") then
            obj.Handle.CFrame = hrp.CFrame
        end
    end
end)

-- 11. АВТО-ПОДБОР ОРУЖИЯ ШЕРИФА
local autoGunActive = false
AddButton("Auto-Grab Sheriff Gun (MM2)", function(v) autoGunActive = v end)
RunService.Heartbeat:Connect(function()
    if autoGunActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        for _, obj in ipairs(Workspace:GetChildren()) do
            if obj:IsA("Tool") and (obj.Name == "Gun" or obj.Name == "Revolver") then
                if obj:FindFirstChild("Handle") then
                    obj.Handle.CFrame = hrp.CFrame
                end
            end
        end
    end
end)

-- 12. ЕСП РОЛЕС В MM2
local mm2EspActive = false
local mm2Objects = {}
AddButton("ESP Roles MM2 (Шериф/Убийца)", function(v)
    mm2EspActive = v
    if not v then for _, o in pairs(mm2Objects) do if o then o:Remove() end end mm2Objects = {} end
end)

RunService.RenderStepped:Connect(function()
    for _, o in pairs(mm2Objects) do if o then o:Remove() end end
    mm2Objects = {}
    if not mm2EspActive then return end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
            local role = "Невинный"
            local color = Color3.fromRGB(0, 255, 0)
            
            local backpack = plr:FindFirstChildOfClass("Backpack")
            local char = plr.Character
            local function hasItem(container)
                if not container then return false end
                for _, item in ipairs(container:GetChildren()) do
                    if item.Name == "Knife" then role = "УБИЙЦА!"; color = Color3.fromRGB(255, 0, 0); return true end
                    if item.Name == "Gun" or item.Name == "Revolver" then role = "ШЕРИФ"; color = Color3.fromRGB(0, 120, 255); return true end
                end
                return false
            end
            
            if not hasItem(char) then hasItem(backpack) end

            local head = char.Head
            local vec, onScreen = Camera:WorldToViewportPoint(head.Position)
            if onScreen then
                local t = Drawing.new("Text")
                t.Visible = true
                t.Text = plr.Name .. " [" .. role .. "]"
                t.Size = 14
                t.Center = true
                t.Outline = true
                t.Color = color
                t.Position = Vector2.new(vec.X, vec.Y - 15)
                table.insert(mm2Objects, t)
            end
        end
    end
end)

-- 13. ИГРОВЫЕ КНОПКИ УПРАВЛЕНИЯ
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

-- Кнопки строго по позициям с твоего скриншота:
CreateKey("Esc", UDim2.new(0, 60, 0, 45), UDim2.new(0, 10, 0, 50), Enum.KeyCode.Escape, nil)
CreateKey("ЛКМ", UDim2.new(0, 100, 0, 60), UDim2.new(0.25, -50, 0, 45), nil, "Left")
CreateKey("ПКМ", UDim2.new(0, 100, 0, 60), UDim2.new(0.65, -50, 0, 45), nil, "Right")
CreateKey("Q", UDim2.new(0, 55, 0, 55), UDim2.new(1, -70, 0, 55), Enum.KeyCode.Q, nil)
CreateKey("E", UDim2.new(0, 60, 0, 60), UDim2.new(0.25, -30, 0.55, 0), Enum.KeyCode.E, nil)
CreateKey("Shift", UDim2.new(0, 80, 0, 60), UDim2.new(0.65, -40, 0.55, 0), Enum.KeyCode.LeftShift, nil)

print("Sberbank Hub [Perfect Fling Edition] успешно запущен!")
