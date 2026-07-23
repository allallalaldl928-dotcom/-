-- SBERBANK HUB (Full Ultimate Version)
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

-- Кнопка открытия/закрытия
local ToggleButton = Instance.new("ImageButton", ScreenGui)
ToggleButton.Size = UDim2.new(0, 50, 0, 50)
ToggleButton.Position = UDim2.new(0, 20, 0, 150)
ToggleButton.BackgroundColor3 = Color3.fromRGB(15, 40, 25)
ToggleButton.Image = "rbxassetid://18828254115"
ToggleButton.ScaleType = Enum.ScaleType.Crop
ToggleButton.Draggable = true
Instance.new("UICorner", ToggleButton).CornerRadius = UDim.new(1, 0)
Instance.new("UIStroke", ToggleButton, {Color = Color3.fromRGB(0, 200, 100), Thickness = 2})

-- Главное окно
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 230, 0, 440)
MainFrame.Position = UDim2.new(0.5, -115, 0.5, -220)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 25, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", MainFrame, {Color = Color3.fromRGB(0, 168, 89), Thickness = 1.5})

ToggleButton.MouseButton1Click:Connect(function()
    MainFrame.Visible = not MainFrame.Visible
end)

-- Заголовок
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, -10, 0, 45)
Title.Position = UDim2.new(0, 5, 0, 5)
Title.BackgroundColor3 = Color3.fromRGB(20, 40, 30)
Title.Text = "SBERBANK HUB [ULTIMATE]"
Title.TextColor3 = Color3.fromRGB(0, 255, 128)
Title.TextSize = 12
Title.Font = Enum.Font.GothamBold
Instance.new("UICorner", Title).CornerRadius = UDim.new(0, 6)

-- Скролл меню
local Scroll = Instance.new("ScrollingFrame", MainFrame)
Scroll.Size = UDim2.new(1, -10, 1, -60)
Scroll.Position = UDim2.new(0, 5, 0, 55)
Scroll.BackgroundTransparency = 1
Scroll.CanvasSize = UDim2.new(0, 0, 0, 2200)
Scroll.ScrollBarThickness = 3
local UIList = Instance.new("UIListLayout", Scroll)
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 6)

local function AddButton(name, callback)
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(20, 50, 35)
    btn.AutoButtonColor = false
    btn.Text = ""
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", btn, {Color = Color3.fromRGB(0, 180, 90), Thickness = 1})
    
    local txt = Instance.new("TextLabel", btn)
    txt.Size = UDim2.new(1, -10, 1, 0)
    txt.Position = UDim2.new(0, 8, 0, 0)
    txt.BackgroundTransparency = 1
    txt.Text = name
    txt.TextColor3 = Color3.fromRGB(220, 255, 235)
    txt.TextSize = 11
    txt.Font = Enum.Font.GothamBold
    txt.TextXAlignment = Enum.TextXAlignment.Left
    
    local active = false
    btn.MouseButton1Click:Connect(function()
        active = not active
        btn.BackgroundColor3 = active and Color3.fromRGB(0, 130, 65) or Color3.fromRGB(20, 50, 35)
        callback(active)
    end)
end

local function AddAction(name, callback)
    local btn = Instance.new("TextButton", Scroll)
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.BackgroundColor3 = Color3.fromRGB(35, 30, 50)
    btn.AutoButtonColor = false
    btn.Text = ""
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", btn, {Color = Color3.fromRGB(150, 50, 150), Thickness = 1})
    
    local txt = Instance.new("TextLabel", btn)
    txt.Size = UDim2.new(1, -10, 1, 0)
    txt.Position = UDim2.new(0, 8, 0, 0)
    txt.BackgroundTransparency = 1
    txt.Text = name
    txt.TextColor3 = Color3.fromRGB(255, 200, 220)
    txt.TextSize = 11
    txt.Font = Enum.Font.GothamBold
    txt.TextXAlignment = Enum.TextXAlignment.Left
    
    btn.MouseButton1Click:Connect(callback)
end

-- 1. ФЛАЙ (FLY)
local flyActive = false
local flySpeed = 50
AddButton("Fly Mode", function(v)
    flyActive = v
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.PlatformStand = flyActive end
end)

RunService.RenderStepped:Connect(function()
    if flyActive and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = LocalPlayer.Character.HumanoidRootPart
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        local moveDir = hum and hum.MoveDirection or Vector3.zero
        hrp.Velocity = (Camera.CFrame:VectorToWorldSpace(Camera.CFrame:VectorToObjectSpace(moveDir)) * flySpeed) + Vector3.new(0, 0.1, 0)
    end
end)

local SpeedBox = Instance.new("TextBox", Scroll)
SpeedBox.Size = UDim2.new(1, 0, 0, 32)
SpeedBox.BackgroundColor3 = Color3.fromRGB(15, 35, 25)
SpeedBox.Text = "Fly Speed: 50"
SpeedBox.TextColor3 = Color3.fromRGB(220, 255, 235)
SpeedBox.TextSize = 11
SpeedBox.Font = Enum.Font.GothamBold
Instance.new("UICorner", SpeedBox).CornerRadius = UDim.new(0, 6)
SpeedBox.FocusLost:Connect(function()
    local num = tonumber(SpeedBox.Text:match("%d+"))
    if num then flySpeed = num end
    SpeedBox.Text = "Fly Speed: " .. flySpeed
end)

-- 2. СПИДХАК (WALKSPEED)
local WalkSpeedBox = Instance.new("TextBox", Scroll)
WalkSpeedBox.Size = UDim2.new(1, 0, 0, 32)
WalkSpeedBox.BackgroundColor3 = Color3.fromRGB(15, 35, 25)
WalkSpeedBox.Text = "WalkSpeed: 16"
WalkSpeedBox.TextColor3 = Color3.fromRGB(220, 255, 235)
WalkSpeedBox.TextSize = 11
WalkSpeedBox.Font = Enum.Font.GothamBold
Instance.new("UICorner", WalkSpeedBox).CornerRadius = UDim.new(0, 6)
WalkSpeedBox.FocusLost:Connect(function()
    local num = tonumber(WalkSpeedBox.Text:match("%d+"))
    if num and LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        LocalPlayer.Character.Humanoid.WalkSpeed = num
    end
    WalkSpeedBox.Text = "WalkSpeed: " .. (num or 16)
end)

-- 3. NOCLIP
local noclipActive = false
RunService.Stepped:Connect(function()
    if noclipActive and LocalPlayer.Character then
        for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end
end)
AddButton("Noclip", function(v) noclipActive = v end)

-- 4. МОБИЛЬНЫЙ ДЖОЙСТИК (POJAV / JOYSTICK)
local pojJoystickActive = false
local PojJoyFrame = Instance.new("Frame", ScreenGui)
PojJoyFrame.Size = UDim2.new(0, 120, 0, 120)
PojJoyFrame.Position = UDim2.new(0, 20, 1, -150)
PojJoyFrame.BackgroundTransparency = 0.4
PojJoyFrame.BackgroundColor3 = Color3.fromRGB(10, 25, 15)
PojJoyFrame.Visible = false
Instance.new("UICorner", PojJoyFrame).CornerRadius = UDim.new(1, 0)

local PojKnob = Instance.new("Frame", PojJoyFrame)
PojKnob.Size = UDim2.new(0, 50, 0, 50)
PojKnob.Position = UDim2.new(0.5, -25, 0.5, -25)
PojKnob.BackgroundColor3 = Color3.fromRGB(0, 180, 90)
Instance.new("UICorner", PojKnob).CornerRadius = UDim.new(1, 0)

local activeTouch, joyCenter = nil, Vector2.zero
PojJoyFrame.InputBegan:Connect(function(input)
    if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) and not activeTouch then
        activeTouch = input
        joyCenter = PojJoyFrame.AbsolutePosition + Vector2.new(60, 60)
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == activeTouch and pojJoystickActive then
        local delta = Vector2.new(input.Position.X, input.Position.Y) - joyCenter
        local dist = math.min(delta.Magnitude, 40)
        local dir = delta.Magnitude > 0 and delta.Unit or Vector2.zero
        PojKnob.Position = UDim2.new(0.5, (dir.X * dist) - 25, 0.5, (dir.Y * dist) - 25)
        local char = LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then
            local camLook = Vector3.new(Camera.CFrame.LookVector.X, 0, Camera.CFrame.LookVector.Z).Unit
            local camRight = Vector3.new(Camera.CFrame.RightVector.X, 0, Camera.CFrame.RightVector.Z).Unit
            local moveDir = (camLook * (-dir.Y) + camRight * dir.X)
            if moveDir.Magnitude > 0 then char.Humanoid:Move(moveDir.Unit, true) end
        end
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input == activeTouch then
        activeTouch = nil
        PojKnob.Position = UDim2.new(0.5, -25, 0.5, -25)
        local char = LocalPlayer.Character
        if char and char:FindFirstChildOfClass("Humanoid") then char.Humanoid:Move(Vector3.zero, true) end
    end
end)
AddButton("Mobile Joystick", function(v) pojJoystickActive = v; PojJoyFrame.Visible = v end)

-- 5. ESP ИГРОКОВ (HIGHLIGHT)
AddButton("Player ESP", function(v)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character then
            if v and not plr.Character:FindFirstChild("SberHighlight") then
                local hl = Instance.new("Highlight", plr.Character)
                hl.Name = "SberHighlight"
                hl.FillColor = Color3.fromRGB(0, 255, 128)
            elseif not v and plr.Character:FindFirstChild("SberHighlight") then
                plr.Character.SberHighlight:Destroy()
            end
        end
    end
end)

-- 6. ESP БОКСЫ (BOX ESP)
AddButton("ESP Box", function(v)
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = plr.Character.HumanoidRootPart
            if v and not hrp:FindFirstChild("BoxESP") then
                Instance.new("BoxHandleAdornment", hrp, {Name = "BoxESP", Size = Vector3.new(3, 5, 3), Adornee = hrp, AlwaysOnTop = true, Color3 = Color3.fromRGB(0, 255, 128), Transparency = 0.5})
            elseif not v and hrp:FindFirstChild("BoxESP") then
                hrp.BoxESP:Destroy()
            end
        end
    end
end)

-- 7. ESP NPC
local npcHighlights = {}
AddButton("NPC ESP", function(v)
    if v then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") then
                if not Players:GetPlayerFromCharacter(obj) and obj ~= LocalPlayer.Character then
                    if not obj:FindFirstChild("NPCEspHL") then
                        local hl = Instance.new("Highlight", obj, {Name = "NPCEspHL", FillColor = Color3.fromRGB(0, 200, 255)})
                        table.insert(npcHighlights, hl)
                    end
                end
            end
        end
    else
        for _, hl in ipairs(npcHighlights) do if hl then hl:Destroy() end end
        npcHighlights = {}
    end
end)

-- 8. MM2 ESP РОЛЕЙ
local mm2EspActive = false
local function getMM2Role(player)
    pcall(function()
        local backpack, char = player:FindFirstChildOfClass("Backpack"), player.Character
        local function checkItem(item)
            if not item then return end
            local name = item.Name:lower()
            if name:find("knife") or name:find("murder") then return "MURDERER"
            elseif name:find("gun") or name:find("revolver") or name:find("sheriff") then return "SHERIFF" end
        end
        if char then for _, i in ipairs(char:GetChildren()) do local r = checkItem(i) if r then return r end end end
        if backpack then for _, i in ipairs(backpack:GetChildren()) do local r = checkItem(i) if r then return r end end end
    end)
    return "Innocent"
end

AddButton("MM2 Role ESP", function(active)
    mm2EspActive = active
    if active then
        RunService.RenderStepped:Connect(function()
            if not mm2EspActive then return end
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                    local head = player.Character.Head
                    local role = getMM2Role(player)
                    local tag = head:FindFirstChild("MM2RoleTag")
                    if not tag then
                        tag = Instance.new("BillboardGui", head, {Name = "MM2RoleTag", Size = UDim2.new(0, 100, 0, 40), StudsOffset = Vector3.new(0, 2.5, 0), AlwaysOnTop = true})
                        Instance.new("TextLabel", tag, {Name = "RoleText", Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 1, TextSize = 12, Font = Enum.Font.GothamBold})
                    end
                    local tLbl = tag:FindFirstChild("RoleText")
                    if tLbl then
                        tLbl.Text = player.Name .. "\n[" .. role .. "]"
                        tLbl.TextColor3 = role == "MURDERER" and Color3.fromRGB(255, 50, 50) or (role == "SHERIFF" and Color3.fromRGB(50, 150, 255) or Color3.fromRGB(50, 255, 50))
                    end
                end
            end
        end)
    else
        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("Head") then
                local tag = player.Character.Head:FindFirstChild("MM2RoleTag")
                if tag then tag:Destroy() end
            end
        end
    end
end)

-- 9. ВЫБОР ЦЕЛИ (СПИСОК ИГРОКОВ)
_G.SelectedTarget = nil
local TargetLabel = Instance.new("TextLabel", Scroll)
TargetLabel.Size = UDim2.new(1, 0, 0, 26)
TargetLabel.BackgroundColor3 = Color3.fromRGB(10, 20, 15)
TargetLabel.Text = " Target: None"
TargetLabel.TextColor3 = Color3.fromRGB(255, 120, 120)
TargetLabel.TextSize = 11
TargetLabel.Font = Enum.Font.GothamBold
TargetLabel.TextXAlignment = Enum.TextXAlignment.Left
Instance.new("UICorner", TargetLabel).CornerRadius = UDim.new(0, 4)

local Dropdown = Instance.new("ScrollingFrame", Scroll)
Dropdown.Size = UDim2.new(1, 0, 0, 80)
Dropdown.BackgroundColor3 = Color3.fromRGB(12, 25, 18)
Dropdown.BorderSizePixel = 0
Dropdown.AutomaticCanvasSize = Enum.AutomaticSize.Y
Dropdown.ScrollBarThickness = 3
Instance.new("UICorner", Dropdown).CornerRadius = UDim.new(0, 6)
Instance.new("UIListLayout", Dropdown, {SortOrder = Enum.SortOrder.LayoutOrder, Padding = UDim.new(0, 2)})

local function updateList()
    for _, c in ipairs(Dropdown:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    for _, plr in ipairs(Players:GetPlayers()) do
        local b = Instance.new("TextButton", Dropdown)
        b.Size = UDim2.new(1, 0, 0, 24)
        b.BackgroundColor3 = (plr == _G.SelectedTarget) and Color3.fromRGB(0, 135, 70) or Color3.fromRGB(20, 45, 30)
        b.Text = " - " .. plr.Name
        b.TextColor3 = Color3.fromRGB(220, 255, 235)
        b.TextSize = 10
        b.Font = Enum.Font.GothamSemibold
        b.TextXAlignment = Enum.TextXAlignment.Left
        b.MouseButton1Click:Connect(function()
            _G.SelectedTarget = plr
            TargetLabel.Text = " Target: " .. plr.Name
            TargetLabel.TextColor3 = Color3.fromRGB(0, 255, 128)
            updateList()
        end)
    end
end
updateList()
Players.PlayerAdded:Connect(updateList)
Players.PlayerRemoving:Connect(updateList)

-- 10. ФЛИНГ ЦЕЛИ
AddAction("Fling Selected Target", function()
    local t = _G.SelectedTarget
    if t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = t.Character.HumanoidRootPart
        local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        if myHrp then
            local old = myHrp.CFrame
            task.spawn(function()
                for i = 1, 25 do
                    if not hrp or not myHrp then break end
                    myHrp.CFrame = hrp.CFrame
                    hrp.AssemblyAngularVelocity = Vector3.new(99999, 99999, 99999)
                    hrp.AssemblyLinearVelocity = Vector3.new(99999, 99999, 99999)
                    task.wait()
                end
                myHrp.CFrame = old
            end)
        end
    end
end)

-- 11. ТП ЦЕЛИ ПОД КАРТУ
AddAction("TP Target Under Map", function()
    if _G.SelectedTarget and _G.SelectedTarget.Character and _G.SelectedTarget.Character:FindFirstChild("HumanoidRootPart") then
        pcall(function()
            _G.SelectedTarget.Character.HumanoidRootPart.CFrame -= Vector3.new(0, 500, 0)
        end)
    end
end)

-- 12. ТП ЦЕЛИ К СЕБЕ
AddAction("TP Target To Me", function()
    if _G.SelectedTarget and _G.SelectedTarget.Character and _G.SelectedTarget.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        pcall(function()
            _G.SelectedTarget.Character.HumanoidRootPart.CFrame = LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(3, 0, 3)
        end)
    end
end)

-- 13. ЗАМОРОЗКА ЦЕЛИ
AddAction("Freeze Target", function()
    if _G.SelectedTarget and _G.SelectedTarget.Character then
        pcall(function()
            local hum = _G.SelectedTarget.Character:FindFirstChildOfClass("Humanoid")
            local root = _G.SelectedTarget.Character:FindFirstChild("HumanoidRootPart")
            if hum and root then
                hum.PlatformStand = true
                root.Anchored = true
            end
        end)
    end
end)

-- 14. РАЗМОРОЗКА ЦЕЛИ
AddAction("Unfreeze Target", function()
    if _G.SelectedTarget and _G.SelectedTarget.Character then
        pcall(function()
            local hum = _G.SelectedTarget.Character:FindFirstChildOfClass("Humanoid")
            local root = _G.SelectedTarget.Character:FindFirstChild("HumanoidRootPart")
            if hum and root then
                hum.PlatformStand = false
                root.Anchored = false
            end
        end)
    end
end)

print("Sberbank Hub [Ultimate] успешно запущен!")

