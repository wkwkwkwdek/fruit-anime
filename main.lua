-- ⚔️ Anime Fruit Dungeon AutoFarm v4
-- ✅ Hover Anti-Hit + Brutal Damage Spam (Tanpa Mouse Click)
-- 🌀 Fitur: AutoFarm, Hover, Auto Stage, Brutal Click, GUI Toggle

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local VirtualInput = game:GetService("VirtualInputManager")
local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
player.CharacterAdded:Connect(function(c) char = c end)

local Settings = {
    AutoFarm = false,
    LoopStage = true,
    BrutalMultiplier = 100,
}

-- 🛸 Hover di atas mobs agar tidak tersentuh
local function startHover(targetPos)
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local bp = hrp:FindFirstChild("HoverBP") or Instance.new("BodyPosition")
    bp.Name = "HoverBP"
    bp.MaxForce = Vector3.new(0, 1e6, 0)
    bp.P = 5000
    bp.D = 1000
    bp.Position = targetPos + Vector3.new(0, 20, 0)
    bp.Parent = hrp
end

local function stopHover()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        local bp = hrp:FindFirstChild("HoverBP")
        if bp then bp:Destroy() end
    end
end

-- 🎯 Deteksi mobs hidup
local function getEnemies()
    local enemies = {}
    local folder = Workspace:FindFirstChild("Monsters")
    if folder then
        for _, mob in ipairs(folder:GetChildren()) do
            local hum = mob:FindFirstChildOfClass("Humanoid")
            local root = mob:FindFirstChild("HumanoidRootPart")
            if hum and root and hum.Health > 0 then
                table.insert(enemies, mob)
            end
        end
    end
    return enemies
end

-- 💥 Brutal click spam (seolah mouse diklik 100x)
local function brutalAutoAttack()
    for _ = 1, Settings.BrutalMultiplier do
        VirtualInput:SendMouseButtonEvent(0, 0, 0, true, game)
        VirtualInput:SendMouseButtonEvent(0, 0, 0, false, game)
        task.wait()
    end
end

-- 🚪 Auto lanjut stage
local function goToNextStage()
    local stage = Workspace:FindFirstChild("Portals") or Workspace:FindFirstChild("Stages")
    if stage then
        for _, p in pairs(stage:GetChildren()) do
            if p:IsA("BasePart") and p.Name:lower():find("portal") then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                if hrp then hrp.CFrame = p.CFrame + Vector3.new(0, 5, 0) end
                break
            end
        end
    end
end

-- 🔁 Main Loop
spawn(function()
    while task.wait(0.15) do
        if Settings.AutoFarm and char then
            local enemies = getEnemies()
            if #enemies > 0 then
                local mob = enemies[1]
                local root = mob:FindFirstChild("HumanoidRootPart")
                if root then
                    startHover(root.Position)
                    brutalAutoAttack()
                end
            else
                stopHover()
                if Settings.LoopStage then
                    goToNextStage()
                end
            end
        else
            stopHover()
        end
    end
end)

-- 🖥️ GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0, 200, 0, 140)
frame.Position = UDim2.new(0, 10, 0, 300)
frame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)

local function addToggle(name, key, y)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0, 180, 0, 30)
    btn.Position = UDim2.new(0, 10, 0, y)
    btn.Text = name .. ": OFF"
    btn.TextColor3 = Color3.new(1,1,1)
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        btn.Text = name .. (Settings[key] and ": ON" or ": OFF")
        btn.BackgroundColor3 = Settings[key] and Color3.fromRGB(0,170,0) or Color3.fromRGB(60,60,60)
    end)
end

addToggle("Auto Farm", "AutoFarm", 10)
addToggle("Loop Stage", "LoopStage", 50)

print("✅ Brutal Hover AutoFarm loaded")
