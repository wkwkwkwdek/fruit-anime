-- ✅ Anime Fruit GUI with Dropdown & Autofarm Framework (PlayerGui version)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local gui = Instance.new("ScreenGui")
gui.Name = "FruitOP_GUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

-- 💾 Config
local Settings = {
    AutoFarm = false,
    LoopDungeon = false,
    SelectedIsland = "Hell Dungeon",
    SelectedMob = "Skeleton"
}

local IslandMobMap = {
    ["Center Town"] = {"Guardian", "Marine", "Officer", "Agent"},
    ["Arena Island"] = {"Thief", "Fighter", "Warrior"},
    ["Pirate Port"] = {"Clown Pirate", "Captain"},
    ["Hell Dungeon"] = {"Skeleton", "Orc", "Orc Chief"}
}

-- 🪟 GUI Layout
local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 260, 0, 340)
frame.Position = UDim2.new(0, 20, 0.5, -170)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
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

-- 🔘 Toggle
local function createToggle(name, key, y)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 220, 0, 30)
    btn.Position = UDim2.new(0, 20, 0, y)
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
local function createDropdown(labelText, items, selectedKey, yOffset)
    local label = Instance.new("TextLabel")
    label.Position = UDim2.new(0, 20, 0, yOffset)
    label.Size = UDim2.new(0, 220, 0, 20)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.new(1, 1, 1)
    label.Font = Enum.Font.Gotham
    label.TextSize = 14
    label.Text = labelText .. ": " .. Settings[selectedKey]
    label.Parent = frame

    local dropdown = Instance.new("TextButton")
    dropdown.Position = UDim2.new(0, 20, 0, yOffset + 22)
    dropdown.Size = UDim2.new(0, 220, 0, 25)
    dropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    dropdown.TextColor3 = Color3.new(1, 1, 1)
    dropdown.Font = Enum.Font.Gotham
    dropdown.TextSize = 13
    dropdown.Text = "Pilih " .. labelText
    dropdown.Parent = frame

    dropdown.MouseButton1Click:Connect(function()
        for _, v in ipairs(frame:GetChildren()) do
            if v.Name == "OptionButton" then v:Destroy() end
        end
        for i, option in ipairs(items) do
            local opt = Instance.new("TextButton")
            opt.Name = "OptionButton"
            opt.Size = UDim2.new(0, 220, 0, 25)
            opt.Position = UDim2.new(0, 20, 0, yOffset + 50 + ((i - 1) * 25))
            opt.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            opt.TextColor3 = Color3.new(1, 1, 1)
            opt.Font = Enum.Font.Gotham
            opt.TextSize = 13
            opt.Text = option
            opt.Parent = frame
            opt.MouseButton1Click:Connect(function()
                Settings[selectedKey] = option
                label.Text = labelText .. ": " .. option
                for _, b in ipairs(frame:GetChildren()) do
                    if b.Name == "OptionButton" then b:Destroy() end
                end
                if selectedKey == "SelectedIsland" then
                    Settings.SelectedMob = IslandMobMap[option][1] or ""
                end
            end)
        end
    end)
end

-- 👷 Build GUI
createToggle("Auto Farm", "AutoFarm", 40)
createToggle("Loop Dungeon", "LoopDungeon", 80)

local islandList = {}
for name, _ in pairs(IslandMobMap) do table.insert(islandList, name) end

createDropdown("Island", islandList, "SelectedIsland", 130)
createDropdown("Mob", IslandMobMap[Settings.SelectedIsland], "SelectedMob", 200)

-- 🎹 Toggle GUI
UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.RightShift then
        gui.Enabled = not gui.Enabled
    end
end)

-- 🔁 Loop Dungeon
spawn(function()
    while task.wait(1) do
        if Settings.LoopDungeon then
            local remote = ReplicatedStorage:FindFirstChild("Remotes")
            if remote and remote:FindFirstChild("StartDungeon") then
                remote.StartDungeon:FireServer()
            end
        end
    end
end)

-- 🔨 Placeholder AutoFarm (to be upgraded)
spawn(function()
    while task.wait(0.5) do
        if Settings.AutoFarm then
            local mobs = Workspace:FindFirstChild("Mobs")
            if mobs then
                for _, mob in ipairs(mobs:GetChildren()) do
                    if mob.Name == Settings.SelectedMob and mob:FindFirstChild("HumanoidRootPart") then
                        player.Character:WaitForChild("HumanoidRootPart").CFrame = mob.HumanoidRootPart.CFrame + Vector3.new(0, 20, 0)
                        break
                    end
                end
            end
        end
    end
end)

print("✅ GUI, Dropdown, and basic functions loaded!")
