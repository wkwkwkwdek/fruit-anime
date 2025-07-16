-- ✅ Anime Fruit Simulator OP Script (Improved GUI + Auto Everything)
-- 📅 Final Version: Juli 2025
-- ⚠️ Edukasi Only | Jangan merugikan pemain lain

-- Services
local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local WS = game:GetService("Workspace")
local Vim = game:GetService("VirtualInputManager")
local UserInput = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()

player.CharacterAdded:Connect(function(c)
    char = c
end)

-- ⛔ Anti-AFK
player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), WS.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), WS.CurrentCamera.CFrame)
end)

-- 🔧 Settings
local Settings = {
    AutoQuest = false,
    AutoFarm = false,
    AutoSkill = false,
    AutoBoss = false,
    AutoFruit = false,
    AutoDash = false,
    NoClip = false,
}

-- 🌀 Auto Skill (1–4)
task.spawn(function()
    while task.wait(0.5) do
        if Settings.AutoSkill then
            for _, key in ipairs({Enum.KeyCode.One, Enum.KeyCode.Two, Enum.KeyCode.Three, Enum.KeyCode.Four}) do
                Vim:SendKeyEvent(true, key, false, game)
                task.wait(0.05)
                Vim:SendKeyEvent(false, key, false, game)
            end
        end
    end
end)

-- 🗡️ Auto Farm Mobs + Melayang
task.spawn(function()
    while task.wait(0.5) do
        if Settings.AutoFarm and char and char:FindFirstChild("HumanoidRootPart") then
            local mobs = WS:FindFirstChild("Mobs")
            if mobs then
                for _, mob in ipairs(mobs:GetChildren()) do
                    if mob:FindFirstChild("Humanoid") and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
                        char.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0)
                        break
                    end
                end
            end
        end
    end
end)

-- 👑 Auto Boss
task.spawn(function()
    while task.wait(1) do
        if Settings.AutoBoss then
            local boss = WS:FindFirstChild("Boss")
            if boss and boss:FindFirstChild("HumanoidRootPart") and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                char.HumanoidRootPart.CFrame = boss.HumanoidRootPart.CFrame * CFrame.new(0, 20, 0)
            end
        end
    end
end)

-- 🎯 Auto Quest
task.spawn(function()
    while task.wait(5) do
        if Settings.AutoQuest and RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("Quest") then
            RS.Remotes.Quest:FireServer("AcceptQuest", "Kill 10 Bandits")
        end
    end
end)

-- 🍍 Auto Fruit Collector
task.spawn(function()
    while task.wait(1.5) do
        if Settings.AutoFruit and WS:FindFirstChild("Drops") then
            for _, drop in ipairs(WS.Drops:GetChildren()) do
                if drop:IsA("Tool") and drop:FindFirstChild("Handle") then
                    firetouchinterest(char.HumanoidRootPart, drop.Handle, 0)
                    task.wait(0.1)
                    firetouchinterest(char.HumanoidRootPart, drop.Handle, 1)
                end
            end
        end
    end
end)

-- 💨 Auto Dash (Spam Shift Key)
task.spawn(function()
    while task.wait(0.3) do
        if Settings.AutoDash then
            Vim:SendKeyEvent(true, Enum.KeyCode.LeftShift, false, game)
            task.wait(0.05)
            Vim:SendKeyEvent(false, Enum.KeyCode.LeftShift, false, game)
        end
    end
end)

-- 🎮 GUI Creation
local function createButton(text, order, callback)
    local button = Instance.new("TextButton")
    button.Size = UDim2.new(1, -20, 0, 30)
    button.Position = UDim2.new(0, 10, 0, 10 + (order * 35))
    button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.Font = Enum.Font.GothamBold
    button.TextSize = 14
    button.Text = text .. ": OFF"
    button.MouseButton1Click:Connect(function()
        Settings[text] = not Settings[text]
        button.Text = text .. (Settings[text] and ": ON" or ": OFF")
        button.BackgroundColor3 = Settings[text] and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(30, 30, 30)
        callback(Settings[text])
    end)
    return button
end

local gui = Instance.new("ScreenGui")
gui.Name = "AnimeFruitGUI"
gui.ResetOnSpawn = false
gui.Parent = game:GetService("CoreGui")

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0, 220, 0, 330)
frame.Position = UDim2.new(0, 20, 0.5, -165)
frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
frame.BorderSizePixel = 0
frame.Parent = gui

local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1, 0, 0, 30)
title.Text = "🍍 Anime Fruit OP GUI"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextSize = 16

local i = 0
for feature, _ in pairs(Settings) do
    local btn = createButton(feature, i, function(_) end)
    btn.Parent = frame
    i += 1
end

-- 🔄 Toggle GUI with RightShift
UserInput.InputBegan:Connect(function(input, gpe)
    if not gpe and input.KeyCode == Enum.KeyCode.RightShift then
        gui.Enabled = not gui.Enabled
    end
end)

print("✅ Improved Anime Fruit GUI Loaded")
