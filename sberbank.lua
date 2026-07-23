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

-- ИКОНКА ОТКРЫТИЯ/ЗАКРЫТИЯ
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

-- ГЛАВНОЕ ОКНО ХАБА
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 280, 0, 380)
MainFrame.Position = UDim2.new(0.5, -140, 0.5, -190)
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
Title.Text = "SBERBANK HUB [ULTIMATE]"
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
Scroll.CanvasSize = UDim2.new(0, 0, 0, 1100)
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

-- КОНТЕЙНЕР ДЛЯ ESP ВИЗУАЛОВ
local espFolder = Instance.new("Folder", ScreenGui)
espFolder.Name = "ESP_Visuals"

-- 1. УЛУЧШЕННЫЙ ФЛАЙ (Поворот тела вслед за камерой + джойстик)
local flyActive = false
local flySpeed = 55
AddButton("Fly (Поворот за камерой)", function(v)
    flyActive = v
    local char = LocalPlayer.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end

    if flyActive then
        hum.PlatformStand = true
        local bv = Instance.new("BodyVelocity")
        bv.Name = "SberFlyVel"
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Velocity = Vector3.new(0, 0, 0)
        bv.Parent = hrp

        task.spawn(function()
            while flyActive and ScreenGui.Parent do
                RunService.RenderStepped:Wait()
                local cChar = LocalPlayer.Character
                local cHrp = cChar and cChar:FindFirstChild("HumanoidRootPart")
                local cHum = cChar and cChar:FindFirstChildOfClass("Humanoid")
                local cBv = cHrp and cHrp:FindFirstChild("SberFlyVel")
                if not cHrp or not cHum or not cBv then break end

                local camCFrame = Camera.CFrame
                local moveDir = cHum.MoveDirection
                
                if moveDir.Magnitude > 0 then
                    cBv.Velocity = (camCFrame.RightVector * moveDir.X + camCFrame.LookVector * moveDir.Z) * flySpeed
                else
                    cBv.Velocity = Vector3.new(0, 0, 0)
                end
                -- Персонаж полностью поворачивается туда, куда смотрит камера (вниз/вверх/в стороны)
                cHrp.CFrame = CFrame.new(cHrp.Position, cHrp.Position + camCFrame.LookVector)
            end
            if hrp and hrp:FindFirstChild("SberFlyVel") then
                hrp.SberFlyVel:Destroy()
            end
        end)
    else
        hum.PlatformStand = false
        if hrp and hrp:FindFirstChild("SberFlyVel") then
            hrp.SberFlyVel:Destroy()
        end
        if hrp then hrp.AssemblyLinearVelocity = Vector3.new(0, 0, 0) end
    end
end)

-- 2. ФЛИНГ СТОЯ (Безопасный)
local flingActive = false
AddButton("Fling (Стоя)", function(v) 
    flingActive = v 
    if not v and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.AssemblyAngularVelocity = Vector3.new(0, 0, 0)
    end
end)

RunService.Heartbeat:Connect(function()
    if flingActive and ScreenGui.Parent then
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.AssemblyAngularVelocity = Vector3.new(0, 4000, 0)
            hrp.AssemblyLinearVelocity = Vector3.new(0, 2, 0)
        end
    end
end)

-- ПЕРЕМЕННЫЕ ESP
local espPlayers = false
local espNpcs = false
local espBoxes = false
local espLines = false
local espMm2Roles = false

AddButton("ESP Players", function(v) espPlayers = v end)
AddButton("ESP NPCs", function(v) espNpcs = v end)
AddButton("ESP Boxes (Квадраты)", function(v) espBoxes = v end)
AddButton("ESP Lines (Линии)", function(v) espLines = v end)
AddButton("ESP MM2 Roles (Шериф/Убийца)", function(v) espMm2Roles = v end)

-- 3. БАНИХОП (BunnyHop)
local bhopActive = false
AddButton("BunnyHop (Авто-прыжок)", function(v) bhopActive = v end)
RunService.Heartbeat:Connect(function()
    if bhopActive and ScreenGui.Parent then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and hum.FloorMaterial ~= Enum.Material.Air then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end
end)

-- 4. NOCLIP
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

-- 5. SPEED HACK
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

-- 6. HIGH JUMP
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

-- ЕДИНЫЙ ЦИКЛ РЕНДЕРА ЕСП (Автообновление для новых/переродившихся игроков)
RunService.RenderStepped:Connect(function()
    for _, child in ipairs(espFolder:GetChildren()) do
        child:Destroy()
    end

    if not ScreenGui.Parent then return end

    -- Функция определения роли MM2
    fnGetMm2Role = function(plr)
        if not espMm2Roles then return "" end
        local backpack = plr:FindFirstChildOfClass("Backpack")
        local char = plr.Character
        local items = {}
        if backpack then for _, i in ipairs(backpack:GetChildren()) do table.insert(items, i.Name) end end
        if char then for _, i in ipairs(char:GetChildren()) do table.insert(items, i.Name) end end
        
        for _, name in ipairs(items) do
            if name:lower():find("gun") or name:lower():find("revolver") or name:lower():find("шериф") then
                return " [ШЕРИФ]"
            elseif name:lower():find("knife") or name:lower():find("dagger") or name:lower():find("нож") then
                return " [УБИЙЦА]"
            end
        end
        return " [МИРНЫЙ]"
    end

    -- Обработка игроков
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") and p.Character:FindFirstChildOfClass("Humanoid") then
            local char = p.Character
            local hrp = char.HumanoidRootPart
            local head = char:FindFirstChild("Head")
            
            -- Подсветка персонажа (ESP Players)
            if espPlayers then
                local hl = char:FindFirstChild("SberHighlight")
                if not hl then
                    hl = Instance.new("Highlight", char)
                    hl.Name = "SberHighlight"
                    hl.FillTransparency = 0.5
                    hl.OutlineTransparency = 0
                end
                local roleText = fnGetMm2Role(p)
                hl.FillColor = (roleText == " [УБИЙЦА]") and Color3.fromRGB(255, 0, 0) or ((roleText == " [ШЕРИФ]") and Color3.fromRGB(0, 100, 255) or Color3.fromRGB(0, 255, 100))
                hl.OutlineColor = hl.FillColor
            else
                if char:FindFirstChild("SberHighlight") then
                    char.SberHighlight:Destroy()
                end
            end

            local vector, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen then
                -- ESP BOXES (Квадраты вокруг игрока)
                if espBoxes and head then
                    local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
                    local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
                    local height = math.abs(headPos.Y - legPos.Y)
                    local width = height / 2

                    local box = Instance.new("Frame", espFolder)
                    box.Size = UDim2.new(0, width, 0, height)
                    box.Position = UDim2.new(0, vector.X - width/2, 0, headPos.Y)
                    box.BackgroundTransparency = 1
                    Instance.new("UIStroke", box, {Color = Color3.fromRGB(0, 255, 100), Thickness = 1.5})
                end

                -- ESP LINES (Линии от низа экрана до игроков)
                if espLines then
                    local line = Instance.new("Frame", espFolder)
                    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                    local targetPos = Vector2.new(vector.X, vector.Y)
                    local dist = (targetPos - screenCenter).Magnitude
                    
                    line.Size = UDim2.new(0, 1.5, 0, dist)
                    line.Position = UDim2.new(0, screenCenter.X, 0, screenCenter.Y)
                    line.AnchorPoint = Vector2.new(0.5, 1)
                    line.BackgroundColor3 = Color3.fromRGB(0, 255, 100)
                    line.BorderSizePixel = 0
                    line.Rotation = math.deg(math.atan2(targetPos.Y - screenCenter.Y, targetPos.X - screenCenter.X)) + 90
                end
            end
        end
    end

    -- Обработка NPC
    if espNpcs then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChildOfClass("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
                local isPlayer = false
                for _, p in ipairs(Players:GetPlayers()) do
                    if p.Character == obj then isPlayer = true break end
                end
                if not isPlayer then
                    local hl = obj:FindFirstChild("SberHighlight")
                    if not hl then
                        hl = Instance.new("Highlight", obj)
                        hl.Name = "SberHighlight"
                        hl.FillColor = Color3.fromRGB(255, 165, 0)
                        hl.OutlineColor = Color3.fromRGB(255, 165, 0)
                        hl.FillTransparency = 0.5
                    end
                end
            end
        end
    end
end)
