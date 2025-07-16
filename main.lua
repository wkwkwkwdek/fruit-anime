-- ✅ Anime Fruit GUI: Dungeon AutoFarm Full + GUI Dropdown + Extra Features

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local VirtualInput = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
player.CharacterAdded:Connect(function(c) char = c end)

local Settings = {
    AutoFarm = false,
    SafeMode = true,
    LoopDungeon = false,
    DelayBetweenStages = 2.5,
    SelectedDungeon = "Hell Dungeon"
}

local DungeonList = {
    "Hell Dungeon",
    "Ice Dungeon",
    "Sky Dungeon",
    "Lava Dungeon",
    "Shadow Dungeon"
}

-- 🧠 SafeMode: NoClip
local function applyNoClip()
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

-- 🔁 Dungeon Auto Start
spawn(function()
    while task.wait(5) do
        if Settings.LoopDungeon then
            local remote = ReplicatedStorage:FindFirstChild("Remotes")
            if remote and remote:FindFirstChild("StartDungeon") then
                remote.StartDungeon:FireServer()
            end
        end
    end
end)

-- 📡 Detect Available Dungeon Mobs
local function getAvailableDungeonMobs()
    local mobs = {}
    local mobFolder = Workspace:FindFirstChild("Mobs")
    if mobFolder then
        for _, mob in ipairs(mobFolder:GetChildren()) do
            if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                table.insert(mobs, mob)
            end
        end
    end
    return mobs
end

-- 🚪 Auto Go to Next Stage
local function goToNextStage()
    local portals = Workspace:FindFirstChild("Portals") or Workspace:FindFirstChild("Stages")
    if portals then
        for _, obj in ipairs(portals:GetChildren()) do
            if obj:IsA("BasePart") and obj.Name:lower():find("portal") then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    hrp.CFrame = obj.CFrame + Vector3.new(0, 6, 0)
                end
                break
            end
        end
    end
end

-- 🌀 AutoFarm
spawn(function()
    while task.wait(0.3) do
        if Settings.AutoFarm then
            if Settings.SafeMode then applyNoClip() end
            local mobs = getAvailableDungeonMobs()
            if #mobs > 0 then
                local mob = mobs[1]
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local target = mob:FindFirstChild("HumanoidRootPart")
                if hrp and target then
                    hrp.CFrame = target.CFrame + Vector3.new(0, 22, 0)
                    for _, key in ipairs({Enum.KeyCode.One, Enum.KeyCode.Two, Enum.KeyCode.Three, Enum.KeyCode.Four}) do
                        VirtualInput:SendKeyEvent(true, key, false, game)
                        task.wait(0.1)
                        VirtualInput:SendKeyEvent(false, key, false, game)
                    end
                end
            else
                task.wait(Settings.DelayBetweenStages)
                goToNextStage()
            end
        end
    end
end)

-- 🖥 GUI Setup
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 250)
frame.Position = UDim2.new(0, 20, 0.5, -125)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)

local function addToggle(name, key, y)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 200, 0, 30)
    btn.Position = UDim2.new(0, 25, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Text = name .. ": OFF"

    btn.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        btn.Text = name .. (Settings[key] and ": ON" or ": OFF")
        btn.BackgroundColor3 = Settings[key] and Color3.fromRGB(0,170,0) or Color3.fromRGB(60,60,60)
    end)
end

local function addDropdown(name, key, options, y)
    local label = Instance.new("TextLabel", frame)
    label.Position = UDim2.new(0, 25, 0, y)
    label.Size = UDim2.new(0, 200, 0, 20)
    label.Text = name .. ": " .. Settings[key]
    label.TextColor3 = Color3.new(1,1,1)
    label.BackgroundTransparency = 1
    label.Font = Enum.Font.Gotham
    label.TextSize = 14

    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 200, 0, 30)
    btn.Position = UDim2.new(0, 25, 0, y+22)
    btn.Text = "Pilih " .. name
    btn.Font = Enum.Font.Gotham
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)

    btn.MouseButton1Click:Connect(function()
        for _, c in pairs(frame:GetChildren()) do if c.Name == "Option" then c:Destroy() end end
        for i, v in ipairs(options) do
            local opt = Instance.new("TextButton", frame)
            opt.Name = "Option"
            opt.Size = UDim2.new(0, 200, 0, 25)
            opt.Position = UDim2.new(0, 25, 0, y+60+(i*26))
            opt.Text = v
            opt.TextColor3 = Color3.new(1,1,1)
            opt.BackgroundColor3 = Color3.fromRGB(80,80,80)
            opt.Font = Enum.Font.Gotham
            opt.TextSize = 13
            opt.MouseButton1Click:Connect(function()
                Settings[key] = v
                label.Text = name .. ": " .. v
                for _, o in pairs(frame:GetChildren()) do if o.Name == "Option" then o:Destroy() end end
            end)
        end
    end)
end

addToggle("Auto Farm", "AutoFarm", 10)
addToggle("Loop Dungeon", "LoopDungeon", 50)
addToggle("Safe Mode", "SafeMode", 90)
addDropdown("Dungeon", "SelectedDungeon", DungeonList, 130)

UIS.InputBegan:Connect(function(key, g)
    if not g and key.KeyCode == Enum.KeyCode.RightShift then
        gui.Enabled = not gui.Enabled
    end
end)

print("✅ Full Anime Fruit GUI loaded with Dungeon dropdown, stage auto-loop, and safemode!")
