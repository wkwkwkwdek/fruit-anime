-- ✅ Anime Fruit Simulator OP Script with Full GUI (Updated July 2025)
-- ⚠️ DISCLAIMER: Gunakan untuk pembelajaran. Resiko tanggung sendiri.
-- 🛑 Jangan gunakan script ini untuk merugikan pemain lain.

-- 📌 FITUR:
-- [✔] Auto Quest
-- [✔] Auto Farm (Mobs)
-- [✔] Auto Skill Spam
-- [✔] Auto Boss
-- [✔] Auto Fruit/Drop Collect
-- [✔] GUI Toggle Friendly

-- ✅ Struktur game berdasarkan inspeksi langsung dari game:
--   workspace.Mobs         : kumpulan musuh
--   workspace.Boss         : 1 boss model
--   workspace.Drops        : buah atau item
--   ReplicatedStorage.Remotes.Skill : serangan
--   ReplicatedStorage.Remotes.Quest : ambil quest

---------------------------------------------------------------------

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

-- ⛔ Anti AFK
local vu = game:GetService("VirtualUser")
player.Idled:Connect(function()
    vu:Button2Down(Vector2.new(0,0), WS.CurrentCamera.CFrame)
    wait(1)
    vu:Button2Up(Vector2.new(0,0), WS.CurrentCamera.CFrame)
end)

-- 🔧 Settings
local Settings = {
    AutoQuest = false,
    AutoFarm = false,
    AutoSkill = false,
    AutoBoss = false,
    AutoFruit = false
}

-- 🌀 Auto Skill
spawn(function()
    while wait(0.3) do
        if Settings.AutoSkill and RS:FindFirstChild("Remotes") then
            for i = 1, 4 do
                local skill = RS.Remotes:FindFirstChild("Skill")
                if skill then
                    skill:FireServer("Skill"..i)
                end
            end
        end
    end
end)

-- 🗡️ Auto Farm (Mob)
spawn(function()
    while wait(0.5) do
        if Settings.AutoFarm and WS:FindFirstChild("Mobs") then
            for _, mob in ipairs(WS.Mobs:GetChildren()) do
                local h = mob:FindFirstChild("Humanoid")
                local hrp = mob:FindFirstChild("HumanoidRootPart")
                if h and hrp and h.Health > 0 then
                    char:WaitForChild("HumanoidRootPart").CFrame = hrp.CFrame + Vector3.new(0, 10, 0)
                end
            end
        end
    end
end)

-- 👑 Auto Boss
spawn(function()
    while wait(1) do
        if Settings.AutoBoss and WS:FindFirstChild("Boss") then
            local boss = WS.Boss
            local hrp = boss:FindFirstChild("HumanoidRootPart")
            local h = boss:FindFirstChild("Humanoid")
            if h and hrp and h.Health > 0 then
                char:WaitForChild("HumanoidRootPart").CFrame = hrp.CFrame + Vector3.new(0, 10, 0)
            end
        end
    end
end)

-- 🎯 Auto Quest
spawn(function()
    while wait(5) do
        if Settings.AutoQuest and RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("Quest") then
            RS.Remotes.Quest:FireServer("AcceptQuest", "Kill 10 Bandits")
        end
    end
end)

-- 🍍 Auto Fruit/Drop
spawn(function()
    while wait(2) do
        if Settings.AutoFruit and WS:FindFirstChild("Drops") then
            for _, item in pairs(WS.Drops:GetChildren()) do
                if item:IsA("Tool") and item:FindFirstChild("Handle") then
                    firetouchinterest(char.HumanoidRootPart, item.Handle, 0)
                    wait()
                    firetouchinterest(char.HumanoidRootPart, item.Handle, 1)
                end
            end
        end
    end
end)

-- 🎛️ GUI Interface
local gui = Instance.new("ScreenGui")
gui.Name = "AFS_OP_GUI"
gui.ResetOnSpawn = false
gui.Parent = player:WaitForChild("PlayerGui")

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 240)
frame.Position = UDim2.new(0, 10, 0.5, -120)
frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
frame.BorderSizePixel = 0

local function createToggle(name, index)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, -20, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, 10 + index * 40)
    btn.Text = name .. ": OFF"
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    btn.MouseButton1Click:Connect(function()
        Settings[name] = not Settings[name]
        btn.Text = name .. (Settings[name] and ": ON" or ": OFF")
        btn.BackgroundColor3 = Settings[name] and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(40, 40, 40)
    end)
end

createToggle("AutoQuest", 0)
createToggle("AutoFarm", 1)
createToggle("AutoSkill", 2)
createToggle("AutoBoss", 3)
createToggle("AutoFruit", 4)

print("✅ Anime Fruit GUI loaded. Aktifkan fitur lewat tombol GUI.")
