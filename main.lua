-- Anime Fruit AutoFarm GUI with Dungeon Support, Boss Detection, and Brutal Skill Spam

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
    LoopDungeon = false,
    SafeMode = true,
    SelectedDungeon = "Hell Dungeon",
    DelayBetweenStages = 2,
}

-- Manual Dungeon List (You can expand this)
local DungeonList = {
    "Hell Dungeon", "Sky Dungeon", "Lava Dungeon", "Ice Dungeon"
}

-- NoClip to prevent falling or stuck
local function applyNoClip()
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end

-- Brutal skill spam
local function spamSkills()
    for _, key in ipairs({Enum.KeyCode.One, Enum.KeyCode.Two, Enum.KeyCode.Three, Enum.KeyCode.Four}) do
        VirtualInput:SendKeyEvent(true, key, false, game)
        task.wait(0.05)
        VirtualInput:SendKeyEvent(false, key, false, game)
    end
end

-- Ambil semua mobs aktif (termasuk boss)
local function getAliveMobs()
    local mobs = {}
    local folder = Workspace:FindFirstChild("Monsters")
    if folder then
        for _, mob in ipairs(folder:GetChildren()) do
            local hum = mob:FindFirstChildOfClass("Humanoid")
            local root = mob:FindFirstChild("HumanoidRootPart")
            if hum and root and hum.Health > 0 then
                table.insert(mobs, mob)
            end
        end
    end
    return mobs
end

-- Teleport ke portal untuk stage berikutnya
local function goToNextStage()
    local portals = Workspace:FindFirstChild("Portals") or Workspace:FindFirstChild("Stages")
    if not portals then return end
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

-- Loop Dungeon Auto Start
task.spawn(function()
    while task.wait(5) do
        if Settings.LoopDungeon then
            local remotes = ReplicatedStorage:FindFirstChild("Remotes")
            if remotes and remotes:FindFirstChild("StartDungeon") then
                remotes.StartDungeon:FireServer()
            end
        end
    end
end)

-- AutoFarm Brutal Loop
task.spawn(function()
    while task.wait(0.25) do
        if Settings.AutoFarm and char and char:FindFirstChild("HumanoidRootPart") then
            if Settings.SafeMode then applyNoClip() end
            local mobs = getAliveMobs()
            if #mobs > 0 then
                for _, mob in ipairs(mobs) do
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    local target = mob:FindFirstChild("HumanoidRootPart")
                    if hrp and target then
                        -- Deteksi boss berdasarkan ukuran
                        local isBoss = target.Size.Magnitude > 6
                        local heightOffset = isBoss and 30 or 18
                        -- Terbang stabil
                        hrp.Velocity = Vector3.new(0,0,0)
                        hrp.CFrame = target.CFrame + Vector3.new(0, heightOffset, 0)
                        task.wait(0.1)
                        spamSkills()
                    end
                end
            else
                task.wait(Settings.DelayBetweenStages)
                goToNextStage()
            end
        end
    end
end)

-- GUI Setup
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 250, 0, 250)
frame.Position = UDim2.new(0, 20, 0.5, -125)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)
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

-- Toggle GUI with RightShift
UIS.InputBegan:Connect(function(key, g)
    if not g and key.KeyCode == Enum.KeyCode.RightShift then
        gui.Enabled = not gui.Enabled
    end
end)

print("✅ Anime Fruit AutoFarm GUI loaded with full support.")
