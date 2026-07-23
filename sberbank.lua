-- SBERBANK HUB [ФИНАЛЬНЫЙ ТЕСТОВОЕ ОКНО ДЛЯ ЭКРАННЫХ КНОПОК]
local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

if CoreGui:FindFirstChild("SberbankHubGui") then
    CoreGui.SberbankHubGui:Destroy()
end

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = "SberbankHubGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

local function CreateScreenButton(name, size, pos, callback)
    local btn = Instance.new("TextButton", ScreenGui)
    btn.Size = size
    btn.Position = pos
    btn.BackgroundColor3 = Color3.fromRGB(0, 100, 50)
    btn.BackgroundTransparency = 0.2
    btn.Text = name
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.TextSize = 16
    btn.Font = Enum.Font.GothamBold
    btn.AutoButtonColor = true
    btn.Active = true
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    Instance.new("UIStroke", btn, {Color = Color3.fromRGB(0, 255, 120), Thickness = 2})
    
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ВСЕ ЭКРАННЫЕ КНОПКИ НА ВИДУ:
CreateScreenButton("ESC", UDim2.new(0, 60, 0, 45), UDim2.new(0, 20, 0, 50), function()
    game:GetService("GuiService"):ToggleGameMenu()
end)

CreateScreenButton("E", UDim2.new(0, 60, 0, 45), UDim2.new(0, 20, 0, 105), function()
    local vim = game:GetService("VirtualInputManager")
    if vim then
        vim:SendKeyEvent(true, Enum.KeyCode.E, false, game)
        task.wait(0.05)
        vim:SendKeyEvent(false, Enum.KeyCode.E, false, game)
    end
end)

CreateScreenButton("Q", UDim2.new(0, 60, 0, 45), UDim2.new(0, 20, 0, 160), function()
    local vim = game:GetService("VirtualInputManager")
    if vim then
        vim:SendKeyEvent(true, Enum.KeyCode.Q, false, game)
        task.wait(0.05)
        vim:SendKeyEvent(false, Enum.KeyCode.Q, false, game)
    end
end)

CreateScreenButton("SHIFT", UDim2.new(0, 75, 0, 45), UDim2.new(0, 20, 0, 215), function()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.WalkSpeed = (hum.WalkSpeed == 16) and 24 or 16
    end
end)

CreateScreenButton("GIFT", UDim2.new(0, 75, 0, 45), UDim2.new(0, 20, 0, 270), function()
    -- Автоматический поиск и открытие/клик по GUI подарков на экране
    for _, ui in ipairs(LocalPlayer.PlayerGui:GetDescendants()) do
        if ui:IsA("TextButton") or ui:IsA("ImageButton") then
            local n = ui.Name:lower()
            if n:find("gift") or n:find("reward") or n:find("подар") or n:find("free") then
                local success = pcall(function()
                    for _, conn in ipairs(getconnections(ui.MouseButton1Click)) do
                        conn:Fire()
                    end
                end)
                if not success then
                    ui.AbsolutePosition = Vector2.new(0, 0) -- триггер
                end
            end
        end
    end
end)
