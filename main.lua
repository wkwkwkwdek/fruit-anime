-- ✅ Anime Fruit Simulator | AutoFarm (Island & Dungeon Support)
-- ⚠️ Gunakan dengan bijak, edukasi penggunaan script

-- 🧱 Services
local Players = game:GetService("Players")
local WS = game:GetService("Workspace")
local Vim = game:GetService("VirtualInputManager")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
player.CharacterAdded:Connect(function(c) char = c end)

-- 🔧 Settings
local Settings = {
    AutoFarm = false,
    SelectedIsland = "Hell Dungeon", -- Bisa: "Center Town", "Arena Island", dll.
    SelectedMob = "Skeleton",        -- Sesuaikan dengan mob yang ada di pulau
    NoClip = true,
}

-- 🌍 Data Pulau & Mobs
local IslandMobMap = {
    ["Center Town"] = {"Guardian","Marine","Officer","Agent"},
    ["Arena Island"] = {"Thief","Fighter","Warrior","Killer","Soldier","Chef"},
    ["Pirate Port"] = {"Clown Pirate","Sailor","Fishman","Captain"},
    ["Demon Island"] = {"Demon","Demon Fighter","Ball Demon","Spider Demon"},
    ["Ninja Village"] = {"Ninja","Sound Ninja","Black Ninja","Ninja Killer"},
    ["Namek Planet"] = {"Martial Artist","Devil","Alien","Saiyan"},
    ["Hell Dungeon"] = {"Skeleton","Orc","Orc Warrior","Orc Chief","Demon Knight","Vampire"},
    ["Sky Island"] = {"Birdman","Birdman Fighter","Birdman Warrior","Birdman Duelist","Birdman Soldier","Birdman Officer"},
}

-- 🎯 Fungsi: Ambil target mobs
local function getTargets()
    local mobsFolder = WS:FindFirstChild("Mobs")
    if not mobsFolder then return {} end

    local results = {}
    for _, mob in ipairs(mobsFolder:GetChildren()) do
        if mob.Humanoid and mob:FindFirstChild("HumanoidRootPart") and mob.Humanoid.Health > 0 then
            if mob.Name == Settings.SelectedMob then
                table.insert(results, mob)
            end
        end
    end
    return results
end

-- 🚀 AutoFarm
spawn(function()
    while task.wait(0.3) do
        if Settings.AutoFarm and char and char:FindFirstChild("HumanoidRootPart") then
            local targets = getTargets()
            if #targets > 0 then
                local mob = targets[1]
                char.HumanoidRootPart.CFrame = mob.HumanoidRootPart.CFrame + Vector3.new(0, 25, 0)
                task.wait(0.2)
                for _, key in ipairs({Enum.KeyCode.One, Enum.KeyCode.Two, Enum.KeyCode.Three, Enum.KeyCode.Four}) do
                    Vim:SendKeyEvent(true, key, false, game)
                    task.wait(0.1)
                    Vim:SendKeyEvent(false, key, false, game)
                end
            elseif Settings.SelectedIsland == "Hell Dungeon" then
                local area = WS:FindFirstChild("Hell Dungeon")
                if area and area:FindFirstChild("Spawn") then
                    char.HumanoidRootPart.CFrame = area.Spawn.CFrame + Vector3.new(0, 10, 0)
                end
            end
        end
    end
end)

-- 🧱 NoClip
spawn(function()
    while task.wait() do
        if Settings.NoClip and char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide == true then
                    part.CanCollide = false
                end
            end
        end
    end
end)

print("✅ AutoFarm Ready for", Settings.SelectedIsland, "| Mob:", Settings.SelectedMob)
