
-- ✅ Anime Fruit AutoFarm – All Features, GUI Always Visible

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local VIM = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
player.CharacterAdded:Connect(function(c) char = c end)

local Settings = {
    AutoFarm = false,
    SafeMode = true,
    LoopDungeon = true,
    SelectedMode = "Dungeon", -- or "Island"
    SelectedDungeon = "Arabasta",
    SelectedIsland = "Center Town",
    DelayBetweenStages = 2
}

local DungeonList = {"Arabasta", "PH Islands", "Beast Pirate Ships", "Undersea Prison", "Demon Castle"}
local IslandList = {"Center Town", "Arena Island", "Pirate Port", "Demon Island", "Ninja Village", "Namek Planet", "Sky Island"}

local IslandMobs = {
    ["Center Town"]={"Guardian","Marine","Officer","Agent"},
    ["Arena Island"]={"Thief","Fighter","Warrior","Killer","Soldier","Chef"},
    ["Pirate Port"]={"Clown Pirate","Sailor","Fishman","Captain"},
    ["Demon Island"]={"Demon","Demon Fighter","Ball Demon","Spider Demon"},
    ["Ninja Village"]={"Ninja","Sound Ninja","Black Ninja","Ninja Killer"},
    ["Namek Planet"]={"Martial Artist","Devil","Alien","Saiyan"},
    ["Sky Island"]={"Birdman","Birdman Fighter","Birdman Warrior","Birdman Duelist","Birdman Solider","Birdman Office"}
}

local function noclip()
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

local function hoverAbove(pos)
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    if not hrp:FindFirstChild("HoverForce") then
        local bv = Instance.new("BodyVelocity", hrp)
        bv.Name = "HoverForce"
        bv.Velocity = Vector3.new(0,0,0)
        bv.MaxForce = Vector3.new(0, 1e5, 0)
    end
    hrp.CFrame = CFrame.new(pos + Vector3.new(0, 15, 0))
end

local function getTargets()
    local results = {}
    local folder = Settings.SelectedMode == "Dungeon" and WS:FindFirstChild("Monsters") or nil
    if folder then
        for _, mob in ipairs(folder:GetChildren()) do
            local h = mob:FindFirstChildOfClass("Humanoid")
            local r = mob:FindFirstChild("HumanoidRootPart")
            if h and r and h.Health > 0 then
                table.insert(results, mob)
            end
        end
    else
        for _, mobName in ipairs(IslandMobs[Settings.SelectedIsland] or {}) do
            for _, mob in ipairs(WS:GetDescendants()) do
                if mob:IsA("Model") and mob.Name:match(mobName) then
                    table.insert(results, mob)
                end
            end
        end
    end
    table.sort(results, function(a,b)
        local sa = a:FindFirstChild("HumanoidRootPart") and a.HumanoidRootPart.Size.Magnitude or 0
        local sb = b:FindFirstChild("HumanoidRootPart") and b.HumanoidRootPart.Size.Magnitude or 0
        return sa > sb
    end)
    return results
end

local function brutalClick()
    for _ = 1, 100 do
        VIM:SendMouseButtonEvent(0,0,0,true,game,0)
        VIM:SendMouseButtonEvent(0,0,0,false,game,0)
        task.wait(0.01)
    end
end

local function autoAttack(mob)
    local root = mob:FindFirstChild("HumanoidRootPart")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not root or not hrp then return end
    hoverAbove(root.Position)
    for _, key in ipairs({Enum.KeyCode.One, Enum.KeyCode.Two, Enum.KeyCode.Three, Enum.KeyCode.Four}) do
        VIM:SendKeyEvent(true, key, false, game)
        task.wait(0.05)
        VIM:SendKeyEvent(false, key, false, game)
    end
    brutalClick()
end

local function goNextStage()
    local st = WS:FindFirstChild("Portals") or WS:FindFirstChild("Stages")
    if st then
        for _, p in ipairs(st:GetChildren()) do
            if p:IsA("BasePart") and p.Name:lower():find("portal") then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.CFrame = p.CFrame + Vector3.new(0, 6, 0) end
                break
            end
        end
    end
end

spawn(function()
    while task.wait(5) do
        if Settings.LoopDungeon and Settings.SelectedMode == "Dungeon" then
            local rem = RS:FindFirstChild("Remotes")
            if rem and rem:FindFirstChild("StartDungeon") then
                rem.StartDungeon:FireServer()
            end
        end
    end
end)

spawn(function()
    while task.wait(0.2) do
        if Settings.AutoFarm then
            if Settings.SafeMode then noclip() end
            local t = getTargets()
            if #t > 0 then
                autoAttack(t[1])
            elseif Settings.SelectedMode == "Dungeon" then
                task.wait(Settings.DelayBetweenStages)
                goNextStage()
            end
        end
    end
end)

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "AnimeFruitOP_GUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 240, 0, 160)
frame.Position = UDim2.new(0, 20, 0.5, -80)
frame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local function createToggle(text, yPos, settingKey)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 200, 0, 30)
    btn.Position = UDim2.new(0, 20, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    btn.TextColor3 = Color3.new(1, 1, 1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Text = text .. ": OFF"
    btn.MouseButton1Click:Connect(function()
        Settings[settingKey] = not Settings[settingKey]
        btn.Text = text .. (Settings[settingKey] and ": ON" or ": OFF")
        btn.BackgroundColor3 = Settings[settingKey] and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(70, 70, 70)
    end)
end

createToggle("Auto Farm", 10, "AutoFarm")
createToggle("Safe Mode", 50, "SafeMode")
createToggle("Loop Dungeon", 90, "LoopDungeon")

print("✅ GUI Loaded – All Features Enabled")
