-- ✅ Anime Fruit OP Script (Fully Automated for Dungeon)
-- Game: [✨Mugen] Buah Anime oleh Immortal Sect
-- Fitur: AutoFarm, AutoSkill, AutoStage Loop, SafeMode, Dropdown Dungeon/Island

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local VirtualInput = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
player.CharacterAdded:Connect(function(c) char = c end)

-- Settings
local Settings = {
    AutoFarm = false,
    AutoSkill = false,
    SafeMode = true,
    LoopDungeon = false,
    DelayNextStage = 2.5,
    FlyingHeight = 20,
    Mode = "Dungeon"   -- Dungeon atau Island
}

-- List Dungeon berdasarkan riset nyata
local DungeonList = {
    "Hell Dungeon",
    "Sky Dungeon",
    "Lava Dungeon"
}

-- NoClip untuk SafeMode
local function noClip()
    if not char then return end
    for _, v in pairs(char:GetDescendants()) do
        if v:IsA("BasePart") then v.CanCollide = false end
    end
end

-- Dapatkan mobs hidup di world/dungeon
local function getActiveMobs()
    local mobs = {}
    local folder = Workspace:FindFirstChild("Mobs") or Workspace:FindFirstChild("Enemies")
    if folder then
        for _, mob in ipairs(folder:GetChildren()) do
            if mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                table.insert(mobs, mob)
            end
        end
    end
    return mobs
end

-- Melompat ke portal stage berikutnya
local function goToNextStage()
    local portals = Workspace:FindFirstChild("Portals") or Workspace:FindFirstChild("Stages")
    if portals then
        for _, p in ipairs(portals:GetChildren()) do
            if p:IsA("BasePart") and p.Name:lower():find("portal") then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.CFrame = p.CFrame + Vector3.new(0, 4, 0) end
                break
            end
        end
    end
end

-- Loop AutoFarm utama
spawn(function()
    while task.wait(0.3) do
        if Settings.AutoFarm then
            pcall(function()
                if Settings.SafeMode then noClip() end
                local mobs = getActiveMobs()
                if #mobs > 0 then
                    local mob = mobs[1]
                    local hrp = char:FindFirstChild("HumanoidRootPart")
                    local target = mob:FindFirstChild("HumanoidRootPart")
                    if hrp and target then
                        hrp.CFrame = target.CFrame + Vector3.new(0, Settings.FlyingHeight, 0)
                        if Settings.AutoSkill then
                            for _, key in ipairs({Enum.KeyCode.One, Enum.KeyCode.Two, Enum.KeyCode.Three, Enum.KeyCode.Four}) do
                                VirtualInput:SendKeyEvent(true, key, false, game)
                                task.wait(0.05)
                                VirtualInput:SendKeyEvent(false, key, false, game)
                            end
                        end
                    end
                else
                    task.wait(Settings.DelayNextStage)
                    if Settings.LoopDungeon and Settings.Mode == "Dungeon" then
                        goToNextStage()
                    end
                end
            end)
        end
    end
end)

-- GUI sederhana
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "AnimeFruit_OP"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 240, 0, 260)
frame.Position = UDim2.new(0, 20, 0, 100)
frame.BackgroundColor3 = Color3.fromRGB(30,30,30)

local function makeToggle(text, key, ypos)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 200, 0, 30)
    btn.Position = UDim2.new(0, 20, 0, ypos)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Text = text..": OFF"
    btn.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        btn.Text = text .. (Settings[key] and ": ON" or ": OFF")
        btn.BackgroundColor3 = Settings[key] and Color3.fromRGB(0,170,0) or Color3.fromRGB(50,50,50)
    end)
end

makeToggle("Auto Farm", "AutoFarm", 20)
makeToggle("Auto Skill", "AutoSkill", 60)
makeToggle("Safe Mode", "SafeMode", 100)
makeToggle("Loop Dungeon", "LoopDungeon", 140)

-- Dropdown Mode
local label = Instance.new("TextLabel", frame)
label.Size = UDim2.new(0,200,0,20)
label.Position = UDim2.new(0,20,0,180)
label.BackgroundTransparency = 1
label.TextColor3 = Color3.new(1,1,1)
label.Font = Enum.Font.Gotham
label.TextSize = 14
label.Text = "Mode: "..Settings.Mode

local dd = Instance.new("TextButton", frame)
dd.Size = UDim2.new(0,200,0,30)
dd.Position = UDim2.new(0,20,0,200)
dd.BackgroundColor3 = Color3.fromRGB(50,50,50)
dd.TextColor3 = Color3.new(1,1,1)
dd.Font = Enum.Font.Gotham
dd.TextSize = 14
dd.Text = "Change Mode"
dd.MouseButton1Click:Connect(function()
    local menu = Instance.new("Folder", frame)
    for _, v in ipairs({"Dungeon", "Island"}) do
        local opt = Instance.new("TextButton", menu)
        opt.Name = "Opt"
        opt.Size = UDim2.new(0,200,0,25)
        opt.Position = UDim2.new(0,20,0,230 + (v=="Dungeon" and 0 or 30))
        opt.BackgroundColor3 = Color3.fromRGB(60,60,60)
        opt.TextColor3 = Color3.new(1,1,1)
        opt.Text = v
        opt.Font = Enum.Font.Gotham
        opt.TextSize = 13
        opt.MouseButton1Click:Connect(function()
            Settings.Mode = v
            label.Text = "Mode: "..v
            menu:Destroy()
        end)
    end
end)

UIS.InputBegan:Connect(function(i,gp)
    if not gp and i.KeyCode == Enum.KeyCode.RightShift then
        gui.Enabled = not gui.Enabled
    end
end)
