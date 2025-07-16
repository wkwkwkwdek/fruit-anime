-- ✅ Anime Fruit Simulator OP Script (Full GUI + Auto Segalanya)
-- 📅 Final Version: Juli 2025
-- ⚠️ Edukasi Only | Jangan merugikan pemain lain

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local Vim = game:GetService("VirtualInputManager")
local UserInput = game:GetService("UserInputService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

player.CharacterAdded:Connect(function(c) char = c end)

-- ⛔ Anti AFK
game:GetService("VirtualUser").Button2Down(Vector2.new(0,0), WS.CurrentCamera.CFrame)
player.Idled:Connect(function()
    game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0), WS.CurrentCamera.CFrame)
    wait(1)
    game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0), WS.CurrentCamera.CFrame)
end)

-- 🔧 Settings
local Settings = {
    AutoQuest = false,
    AutoFarm = false,
    AutoSkill = false,
    AutoBoss = false,
    AutoFruit = false,
}

-- 🌀 Auto Skill (1–4)
spawn(function()
    while task.wait(0.5) do
        if Settings.AutoSkill then
            pcall(function()
                for _, key in ipairs({Enum.KeyCode.One, Enum.KeyCode.Two, Enum.KeyCode.Three, Enum.KeyCode.Four}) do
                    Vim:SendKeyEvent(true, key, false, game)
                    task.wait(0.1)
                    Vim:SendKeyEvent(false, key, false, game)
                end
            end)
        end
    end
end)

-- 🗡️ Auto Farm Mobs + Melayang
spawn(function()
    while task.wait(0.7) do
        if Settings.AutoFarm then
            pcall(function()
                local mobs = WS:FindFirstChild("Mobs")
                if mobs then
                    local found = false
                    for _, mob in pairs(mobs:GetChildren()) do
                        if mob:FindFirstChild("HumanoidRootPart") and mob:FindFirstChild("Humanoid") and mob.Humanoid.Health > 0 then
                            found = true
                            char:WaitForChild("HumanoidRootPart").CFrame = mob.HumanoidRootPart.CFrame + Vector3.new(0, 20, 0)
                            break
                        end
                    end
                    if not found then
                        local next = WS:FindFirstChild("NextArea") or WS:FindFirstChild("Area2")
                        if next and next:FindFirstChild("Spawn") then
                            char:WaitForChild("HumanoidRootPart").CFrame = next.Spawn.CFrame + Vector3.new(0, 10, 0)
                        end
                    end
                end
            end)
        end
    end
end)

-- 👑 Auto Boss
spawn(function()
    while task.wait(1) do
        if Settings.AutoBoss then
            pcall(function()
                local boss = WS:FindFirstChild("Boss")
                if boss and boss:FindFirstChild("HumanoidRootPart") and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                    char:WaitForChild("HumanoidRootPart").CFrame = boss.HumanoidRootPart.CFrame + Vector3.new(0, 20, 0)
                end
            end)
        end
    end
end)

-- 🎯 Auto Quest
spawn(function()
    while task.wait(4) do
        if Settings.AutoQuest and RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("Quest") then
            RS.Remotes.Quest:FireServer("AcceptQuest", "Kill 10 Bandits")
        end
    end
end)

-- 🍍 Auto Drop/Fruit Collect
spawn(function()
    while task.wait(2) do
        if Settings.AutoFruit then
            pcall(function()
                if WS:FindFirstChild("Drops") then
                    for _, drop in pairs(WS.Drops:GetChildren()) do
                        if drop:IsA("Tool") and drop:FindFirstChild("Handle") then
                            firetouchinterest(char.HumanoidRootPart, drop.Handle, 0)
                            task.wait()
                            firetouchinterest(char.HumanoidRootPart, drop.Handle, 1)
                        end
                    end
                end
            end)
        end
    end
end)

-- 📺 GUI
local gui = Instance.new("ScreenGui", game.CoreGui)
gui.Name = "FruitOP_GUI"

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 220, 0, 260)
frame.Position = UDim2.new(0, 10, 0.5, -130)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0

local closeBtn = Instance.new("TextButton", frame)
closeBtn.Text = "❌"
closeBtn.Size = UDim2.new(0, 30, 0, 30)
closeBtn.Position = UDim2.new(1, -35, 0, 5)
closeBtn.BackgroundColor3 = Color3.fromRGB(150, 0, 0)
closeBtn.MouseButton1Click:Connect(function() gui.Enabled = false end)

local function addToggle(name, index)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 200, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, 40 + (index * 40))
    btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSansBold
    btn.TextSize = 16
    btn.Text = name .. ": OFF"

    btn.MouseButton1Click:Connect(function()
        Settings[name] = not Settings[name]
        btn.Text = name .. (Settings[name] and ": ON" or ": OFF")
        btn.BackgroundColor3 = Settings[name] and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(40, 40, 40)
    end)
end

addToggle("AutoQuest", 0)
addToggle("AutoFarm", 1)
addToggle("AutoSkill", 2)
addToggle("AutoBoss", 3)
addToggle("AutoFruit", 4)

-- Toggle GUI: Tekan RightShift
UserInput.InputBegan:Connect(function(key)
    if key.KeyCode == Enum.KeyCode.RightShift then
        gui.Enabled = not gui.Enabled
    end
end)

print("✅ Anime Fruit GUI OP Loaded")
