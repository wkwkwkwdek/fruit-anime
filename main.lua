-- ✅ Clean GUI + Loop Dungeon for Anime Fruit Simulator

-- 🧱 Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local Settings = {
    AutoFarm = false,
    LoopDungeon = false,
    NoClip = true,
}

-- 🪟 GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "AFS_GUI"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 240, 0, 300)
frame.Position = UDim2.new(0, 20, 0.5, -150)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Parent = gui

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "🍍 Anime Fruit OP"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

-- 🔘 Button Generator
local function createToggle(name, key, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 200, 0, 30)
    btn.Position = UDim2.new(0, 20, 0, 40 + order * 40)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Text = name .. ": OFF"
    btn.Parent = frame

    btn.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        btn.Text = name .. (Settings[key] and ": ON" or ": OFF")
        btn.BackgroundColor3 = Settings[key] and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(40, 40, 40)
    end)
end

createToggle("Auto Farm", "AutoFarm", 0)
createToggle("Loop Dungeon", "LoopDungeon", 1)
createToggle("No Clip", "NoClip", 2)

-- ⌨️ Toggle GUI
UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.RightShift then
        gui.Enabled = not gui.Enabled
    end
end)

-- 🔁 Dungeon Loop
spawn(function()
    while task.wait(1) do
        if Settings.LoopDungeon then
            local remoteFolder = ReplicatedStorage:FindFirstChild("Remotes")
            if remoteFolder and remoteFolder:FindFirstChild("StartDungeon") then
                remoteFolder.StartDungeon:FireServer()
            end
        end
    end
end)

-- 📌 Export Settings (optional global access)
_G.AFS_Settings = Settings
print("✅ Anime Fruit GUI & Dungeon Loop Loaded")
