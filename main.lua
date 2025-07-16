local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")

-- Hapus GUI lama kalau ada
pcall(function()
    if CoreGui:FindFirstChild("FruitOP_GUI") then
        CoreGui.FruitOP_GUI:Destroy()
    end
end)

-- Buat GUI
local gui = Instance.new("ScreenGui")
gui.Name = "FruitOP_GUI"
gui.ResetOnSpawn = false
gui.Parent = CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 250)
frame.Position = UDim2.new(0, 20, 0.5, -125)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Parent = gui

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "🍍 Anime Fruit GUI"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16
title.Parent = frame

local toggles = {
    { name = "AutoFarm", state = false },
    { name = "LoopDungeon", state = false },
    { name = "NoClip", state = true },
}

local Settings = {}

for i, toggle in ipairs(toggles) do
    Settings[toggle.name] = toggle.state

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 220, 0, 30)
    btn.Position = UDim2.new(0, 20, 0, 30 + (i * 35))
    btn.BackgroundColor3 = toggle.state and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Text = toggle.name .. ": " .. (toggle.state and "ON" or "OFF")
    btn.Parent = frame

    btn.MouseButton1Click:Connect(function()
        Settings[toggle.name] = not Settings[toggle.name]
        btn.Text = toggle.name .. ": " .. (Settings[toggle.name] and "ON" or "OFF")
        btn.BackgroundColor3 = Settings[toggle.name] and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(40, 40, 40)
    end)
end

-- Toggle GUI via RightShift
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.RightShift then
        gui.Enabled = not gui.Enabled
    end
end)

print("✅ GUI berhasil dimuat!")
