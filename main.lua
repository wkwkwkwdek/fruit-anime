-- ✅ Anime Fruit GUI Full (Dropdown Island, Mob, Fly AutoFarm, AutoSkill)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local VirtualInput = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
player.CharacterAdded:Connect(function(c) char = c end)

local Settings = {
    AutoFarm = false,
    LoopDungeon = false,
    SelectedIsland = "Hell Dungeon",
    SelectedMob = "Skeleton"
}

local IslandMobMap = {
    ["Center Town"] = {"Marine", "Guardian", "Agent"},
    ["Arena Island"] = {"Thief", "Fighter", "Warrior"},
    ["Pirate Port"] = {"Clown Pirate", "Captain"},
    ["Hell Dungeon"] = {"Skeleton", "Orc", "Orc Chief"},
    ["Ice Island"] = {"Snow Bandit", "Ice Guard"},
    ["Sky Island"] = {"Sky Warrior", "Priest"},
    ["Desert"] = {"Bandit", "Raider"},
    ["Boss Island"] = {"Boss A", "Boss B"}
}

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "FruitOP_GUI"
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 260, 0, 360)
frame.Position = UDim2.new(0, 20, 0.5, -180)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
frame.BorderSizePixel = 0

local function createLabel(text, pos)
    local l = Instance.new("TextLabel", frame)
    l.Size = UDim2.new(0, 220, 0, 20)
    l.Position = UDim2.new(0, 20, 0, pos)
    l.BackgroundTransparency = 1
    l.TextColor3 = Color3.new(1,1,1)
    l.Text = text
    l.Font = Enum.Font.Gotham
    l.TextSize = 14
    return l
end

local function createToggle(name, key, pos)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 220, 0, 30)
    btn.Position = UDim2.new(0, 20, 0, pos)
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 14
    btn.Text = name .. ": OFF"
    btn.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        btn.Text = name .. (Settings[key] and ": ON" or ": OFF")
        btn.BackgroundColor3 = Settings[key] and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(40, 40, 40)
    end)
end

local function createDropdown(labelText, key, data, pos)
    local label = createLabel(labelText .. ": " .. Settings[key], pos)
    local dropdown = Instance.new("TextButton", frame)
    dropdown.Size = UDim2.new(0, 220, 0, 25)
    dropdown.Position = UDim2.new(0, 20, 0, pos+22)
    dropdown.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    dropdown.TextColor3 = Color3.new(1, 1, 1)
    dropdown.Font = Enum.Font.Gotham
    dropdown.TextSize = 13
    dropdown.Text = "Pilih " .. labelText

    dropdown.MouseButton1Click:Connect(function()
        for _, b in ipairs(frame:GetChildren()) do
            if b.Name == "OptionButton" then b:Destroy() end
        end
        for i, v in ipairs(data) do
            local opt = Instance.new("TextButton", frame)
            opt.Name = "OptionButton"
            opt.Size = UDim2.new(0, 220, 0, 25)
            opt.Position = UDim2.new(0, 20, 0, pos+50+(i*26))
            opt.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            opt.TextColor3 = Color3.new(1,1,1)
            opt.Font = Enum.Font.Gotham
            opt.TextSize = 13
            opt.Text = v
            opt.MouseButton1Click:Connect(function()
                Settings[key] = v
                label.Text = labelText .. ": " .. v
                for _, o in ipairs(frame:GetChildren()) do
                    if o.Name == "OptionButton" then o:Destroy() end
                end
                if key == "SelectedIsland" then
                    Settings.SelectedMob = IslandMobMap[v][1] or ""
                end
            end)
        end
    end)
end

createToggle("Auto Farm", "AutoFarm", 40)
createToggle("Loop Dungeon", "LoopDungeon", 80)
createDropdown("Island", "SelectedIsland", table.getn and table.getn(IslandMobMap) or (function()
    local t = {}
    for k,_ in pairs(IslandMobMap) do table.insert(t, k) end
    return t
end)(), 130)
createDropdown("Mob", "SelectedMob", IslandMobMap[Settings.SelectedIsland], 210)

UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.RightShift then
        gui.Enabled = not gui.Enabled
    end
end)

-- 🔁 Dungeon Auto Start
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

-- 🌀 Auto Farm Fly + Skill
spawn(function()
    while task.wait(0.5) do
        if Settings.AutoFarm then
            local mobs = Workspace:FindFirstChild("Mobs")
            if mobs then
                for _, mob in ipairs(mobs:GetChildren()) do
                    if mob.Name == Settings.SelectedMob and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        local target = mob:FindFirstChild("HumanoidRootPart")
                        if hrp and target then
                            hrp.CFrame = target.CFrame + Vector3.new(0, 20, 0)
                            for _, key in ipairs({Enum.KeyCode.One, Enum.KeyCode.Two, Enum.KeyCode.Three, Enum.KeyCode.Four}) do
                                VirtualInput:SendKeyEvent(true, key, false, game)
                                task.wait(0.1)
                                VirtualInput:SendKeyEvent(false, key, false, game)
                            end
                        end
                        break
                    end
                end
            end
        end
    end
end)

print("✅ Anime Fruit GUI fully loaded with flying AutoFarm and full island support!")
