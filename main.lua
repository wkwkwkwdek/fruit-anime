-- ✅ Anime Fruit OP Auto Dungeon | July 2025
-- 💥 Floating Brutal Attack + Skill + Stage Loop

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local VIM = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
player.CharacterAdded:Connect(function(c) char = c end)

local Settings = {
    AutoFarm = false,
    LoopDungeon = false,
    SafeMode = true,
    SelectedDungeon = "Hell Dungeon",
    DelayBetweenStages = 2
}

-- 🧱 Dungeon List
local DungeonList = {
    "Hell Dungeon",
    "Sky Dungeon",
    "Lava Dungeon",
    "Ice Dungeon"
}

-- 🛡️ NoClip (Safe Mode)
local function applyNoClip()
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end
end

-- 🔁 Auto Start Dungeon
spawn(function()
    while task.wait(5) do
        if Settings.LoopDungeon then
            local remote = RS:FindFirstChild("Remotes")
            if remote and remote:FindFirstChild("StartDungeon") then
                remote.StartDungeon:FireServer()
            end
        end
    end
end)

-- 🔍 Ambil Mobs (di Dungeon)
local function getMobs()
    local mobs = {}
    local mobFolder = WS:FindFirstChild("Monsters")
    if mobFolder then
        for _, mob in ipairs(mobFolder:GetChildren()) do
            if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 and mob:FindFirstChild("HumanoidRootPart") then
                table.insert(mobs, mob)
            end
        end
    end
    return mobs
end

-- 🚪 Pindah ke Stage Selanjutnya
local function goToNextStage()
    local portals = WS:FindFirstChild("Portals") or WS:FindFirstChild("Stages")
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

-- 🎯 Auto Attack Loop
spawn(function()
    while task.wait(0.1) do
        if Settings.AutoFarm and char and char:FindFirstChild("HumanoidRootPart") then
            if Settings.SafeMode then applyNoClip() end
            local mobs = getMobs()
            if #mobs > 0 then
                local mob = mobs[1]
                local mobHRP = mob:FindFirstChild("HumanoidRootPart")
                if mobHRP then
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    hrp.Velocity = Vector3.zero
                    hrp.CFrame = mobHRP.CFrame + Vector3.new(0, 15, 0)

                    -- Auto Skill
                    for _, key in ipairs({Enum.KeyCode.One, Enum.KeyCode.Two, Enum.KeyCode.Three, Enum.KeyCode.Four}) do
                        VIM:SendKeyEvent(true, key, false, game)
                        task.wait(0.05)
                        VIM:SendKeyEvent(false, key, false, game)
                    end

                    -- Serangan Brutal (Spam Click Mouse)
                    for i = 1, 3 do
                        VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                        task.wait(0.01)
                        VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                    end
                end
            else
                task.wait(Settings.DelayBetweenStages)
                goToNextStage()
            end
        end
    end
end)

-- 🖥️ GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 260)
frame.Position = UDim2.new(0, 20, 0.5, -130)
frame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
frame.BorderSizePixel = 0

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

-- 🔄 GUI Toggle (RightShift)
UIS.InputBegan:Connect(function(key, g)
    if not g and key.KeyCode == Enum.KeyCode.RightShift then
        gui.Enabled = not gui.Enabled
    end
end)

print("✅ Anime Fruit Dungeon Script Loaded!")
