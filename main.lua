-- 🚀 Anime Fruit AutoFarm v3 – Brutal Basic Attack + Hover + Stage Loop

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local VirtualInput = game:GetService("VirtualInputManager")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer
local char = player.Character or player.CharacterAdded:Wait()
player.CharacterAdded:Connect(function(c) char = c end)

-- Settings
local Settings = {
    AutoFarm = false,
    LoopStage = false,
    SafeMode = true,
}

-- Hover: guna BodyVelocity stabil
local function hoverOn()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp and not hrp:FindFirstChild("AF_Hover") then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "AF_Hover"
        bv.MaxForce = Vector3.new(0,1e5,0)
        bv.Velocity = Vector3.new(0,50,0)
        bv.Parent = hrp
    end
end
local function hoverOff()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if hrp then
        local bv = hrp:FindFirstChild("AF_Hover")
        if bv then bv:Destroy() end
    end
end

-- Deteksi musuh/hidup
local function getEnemies()
    local out = {}
    local folder = Workspace:FindFirstChild("Monsters")
    if folder then
        for _, mob in ipairs(folder:GetChildren()) do
            local hum = mob:FindFirstChildOfClass("Humanoid")
            local root = mob:FindFirstChild("HumanoidRootPart")
            if hum and root and hum.Health > 0 then
                table.insert(out, mob)
            end
        end
    end
    return out
end

-- Brutal basic click attack
local function clickAttack()
    VirtualInput:SendMouseButtonEvent(0,0,0,true,game)
    VirtualInput:SendMouseButtonEvent(0,0,0,false,game)
end

-- Auto attack & hover loop
task.spawn(function()
    while task.wait(0.1) do
        if Settings.AutoFarm and char then
            if Settings.SafeMode then hoverOn() end

            local enemies = getEnemies()
            if #enemies > 0 then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local mob = enemies[1]
                local root = mob:FindFirstChild("HumanoidRootPart")
                if hrp and root then
                    -- hover atas musuh (offset 25)
                    hrp.CFrame = root.CFrame + Vector3.new(0,25,0)
                    -- spam click
                    for i=1, 6 do
                        clickAttack()
                        task.wait(0.05)
                    end
                end
            else
                hoverOff()
                if Settings.LoopStage then
                    -- lanjut ke portal jika ada
                    local pFolder = Workspace:FindFirstChild("Portals") or Workspace:FindFirstChild("Stages")
                    if pFolder then
                        for _, p in ipairs(pFolder:GetChildren()) do
                            if p:IsA("BasePart") and p.Name:lower():find("portal") then
                                char:FindFirstChild("HumanoidRootPart").CFrame = p.CFrame + Vector3.new(0,5,0)
                                break
                            end
                        end
                    end
                end
            end
        else
            hoverOff()
        end
    end
end)

-- GUI
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,200,0,140)
frame.Position = UDim2.new(0,20,0,150)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)

local function makeToggle(lbl, key, y)
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(0,180,0,30)
    btn.Position = UDim2.new(0,10,0,y)
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 14
    btn.Text = lbl..": OFF"

    btn.MouseButton1Click:Connect(function()
        Settings[key] = not Settings[key]
        btn.Text = lbl..(Settings[key] and ": ON" or ": OFF")
        btn.BackgroundColor3 = Settings[key] and Color3.fromRGB(0,170,0) or Color3.fromRGB(60,60,60)
    end)
end

makeToggle("AutoFarm", "AutoFarm", 10)
makeToggle("LoopStage", "LoopStage", 50)
makeToggle("SafeMode", "SafeMode", 90)

UIS.InputBegan:Connect(function(i,g)
    if not g and i.KeyCode == Enum.KeyCode.RightShift then
        gui.Enabled = not gui.Enabled
    end
end)

print("✅ Brutal AutoFarm loaded. Use basic click, hover & stage loop!")
