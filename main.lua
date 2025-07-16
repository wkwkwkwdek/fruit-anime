-- ✅ GUI + Dropdown + Loop Dungeon for Anime Fruit Simulator

-- 🧱 Services
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local Settings = {
    AutoFarm = false,
    LoopDungeon = false,
    NoClip = true,
    SelectedIsland = "Hell Dungeon",
    SelectedMob = "Skeleton",
}

local IslandMobMap = {
    ["Center Town"] = {"Guardian","Marine","Officer","Agent"},
    ["Arena Island"] = {"Thief","Fighter","Warrior","Killer","Soldier","Chef"},
    ["Pirate Port"] = {"Clown Pirate","Sailor","Fishman","Captain"},
    ["Demon Island"] = {"Demon","Demon Fighter","Ball Demon","Spider Demon"},
    ["Ninja Village"] = {"Ninja","Sound Ninja","Black Ninja","Ninja Killer"},
    ["Namek Planet"] = {"Martial Artist","Devil","Alien","Saiyan"},
    ["Hell Dungeon"] = {"Skeleton","Orc","Orc Warrior","Orc Chief","Demon Knight","Vampire"},
    ["Sky Island"] = {"Birdman","Birdman Fighter","Birdman Warrior","Birdman Duelist","Birdman Soldier","Birdman Officer"},
}

-- 🪟 GUI Setup
local gui = Instance.new("ScreenGui")
gui.Name = "AFS_GUI"
gui.ResetOnSpawn = false
gui.Parent = game.CoreGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 400)
frame.Position = UDim2.new(0, 20, 0.5, -200)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0
frame.Parent = gui

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.BackgroundTransparency = 1
title.Text = "🍍 Anime Fruit OP GUI"
title.TextColor3 = Color3.new(1, 1, 1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

-- 🔘 Toggle Buttons
local function createToggle(name, key, order)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 220, 0, 30)
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

-- 📦 Dropdown
local function createDropdown(labelText, options, default, yOffset, callback)
    local label = Instance.new("TextLabel", frame)
    label.Position = UDim2.new(0, 20, 0, yOffset)
    label.Size = UDim2.new(0, 220, 0, 20)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.GothamSemibold
    label.TextSize = 14
    label.Text = labelText .. ": " .. default

    local dropdown = Instance.new("TextButton", frame)
    dropdown.Position = UDim2.new(0, 20, 0, yOffset + 25)
    dropdown.Size = UDim2.new(0, 220, 0, 30)
    dropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    dropdown.TextColor3 = Color3.new(1, 1, 1)
    dropdown.Font = Enum.Font.Gotham
    dropdown.TextSize = 14
    dropdown.Text = "Pilih..."

    dropdown.MouseButton1Click:Connect(function()
        for _, v in ipairs(frame:GetChildren()) do
            if v.Name == "OptionButton" then v:Destroy() end
        end
        for i, option in ipairs(options) do
            local optBtn = Instance.new("TextButton", frame)
            optBtn.Name = "OptionButton"
            optBtn.Size = UDim2.new(0, 220, 0, 25)
            optBtn.Position = UDim2.new(0, 20, 0, yOffset + 60 + ((i - 1) * 25))
            optBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            optBtn.TextColor3 = Color3.new(1, 1, 1)
            optBtn.Font = Enum.Font.Gotham
            optBtn.TextSize = 13
            optBtn.Text = option
            optBtn.MouseButton1Click:Connect(function()
                label.Text = labelText .. ": " .. option
                callback(option)
                for _, child in ipairs(frame:GetChildren()) do
                    if child.Name == "OptionButton" then
                        child:Destroy()
                    end
                end
            end)
        end
    end)
end

-- 🧱 Build GUI
createToggle("Auto Farm", "AutoFarm", 0)
createToggle("Loop Dungeon", "LoopDungeon", 1)
createToggle("No Clip", "NoClip", 2)

createDropdown("Island", table.keys(IslandMobMap), Settings.SelectedIsland, 160, function(selected)
    Settings.SelectedIsland = selected
    Settings.SelectedMob = IslandMobMap[selected][1] or ""
end)

createDropdown("Mob", IslandMobMap[Settings.SelectedIsland] or {}, Settings.SelectedMob, 230, function(selected)
    Settings.SelectedMob = selected
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

-- ⌨️ Toggle GUI
UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.RightShift then
        gui.Enabled = not gui.Enabled
    end
end)

-- 📌 Export Settings
_G.AFS_Settings = Settings
print("✅ GUI + Dropdown + Dungeon Loop Loaded")
