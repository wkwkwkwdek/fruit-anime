-- 🚀 Anime Fruit Ultimate AutoFarm OP

local Players       = game:GetService("Players")
local RS            = game:GetService("ReplicatedStorage")
local WS            = game:GetService("Workspace")
local VIM           = game:GetService("VirtualInputManager")
local UIS           = game:GetService("UserInputService")

local player        = Players.LocalPlayer
local char          = player.Character or player.CharacterAdded:Wait()
player.CharacterAdded:Connect(function(c) char = c end)

-- ─── SETTINGS ─────────────────────────────────────────────────────
local Settings = {
  AutoFarm        = false,
  Mode            = "Dungeon",            -- "Dungeon" / "Island"
  SelectedDungeon = "Arabasta",
  SelectedIsland  = "Center Town",
  LoopStage       = true,
  SafeMode        = true,
  DelayStage      = 1,
}

local DungeonList = {
  "Arabasta", "PH Islands", "Beast Pirate Ships",
  "Undersea Prison", "Demon Castle"
}
local IslandList = {
  "Center Town", "Arena Island", "Pirate Port",
  "Demon Island", "Ninja Village", "Namek Planet", "Sky Island"
}
local IslandMobs = {
  ["Center Town"]    = {"Guardian","Marine","Officer","Agent"},
  ["Arena Island"]   = {"Thief","Fighter","Warrior","Killer","Soldier","Chef"},
  ["Pirate Port"]    = {"Clown Pirate","Sailor","Fishman","Captain"},
  ["Demon Island"]   = {"Demon","Demon Fighter","Ball Demon","Spider Demon"},
  ["Ninja Village"]  = {"Ninja","Sound Ninja","Black Ninja","Ninja Killer"},
  ["Namek Planet"]   = {"Martial Artist","Devil","Alien","Saiyan"},
  ["Sky Island"]     = {"Birdman","Birdman Fighter","Birdman Warrior",
                        "Birdman Duelist","Birdman Soldier","Birdman Office"}
}

-- ─── UTILITY FUNCTIONS ────────────────────────────────────────────
-- NoClip
local function applyNoClip()
  if not char then return end
  for _, p in ipairs(char:GetDescendants()) do
    if p:IsA("BasePart") then p.CanCollide = false end
  end
end

-- Hover stabil anti-gravity
local function hoverAbove(pos)
  local hrp = char:FindFirstChild("HumanoidRootPart")
  if not hrp then return end
  if not hrp:FindFirstChild("AF_Hover") then
    local bv = Instance.new("BodyVelocity", hrp)
    bv.Name       = "AF_Hover"
    bv.MaxForce   = Vector3.new(0,1e5,0)
    bv.Velocity   = Vector3.new(0,0,0)
  end
  hrp.CFrame = CFrame.new(pos + Vector3.new(0,20,0))
end
local function stopHover()
  local hrp = char:FindFirstChild("HumanoidRootPart")
  if hrp then
    local bv = hrp:FindFirstChild("AF_Hover")
    if bv then bv:Destroy() end
  end
end

-- Ambil target mobs/boss hidup
local function getTargets()
  local out = {}
  if Settings.Mode == "Dungeon" then
    local folder = WS:FindFirstChild("Monsters")
    if folder then
      for _, mob in ipairs(folder:GetChildren()) do
        local h = mob:FindFirstChildOfClass("Humanoid")
        local r = mob:FindFirstChild("HumanoidRootPart")
        if h and r and h.Health > 0 then
          table.insert(out, mob)
        end
      end
    end
  else
    for _, name in ipairs(IslandMobs[Settings.SelectedIsland] or {}) do
      for _, mob in ipairs(WS:GetDescendants()) do
        if mob:IsA("Model") and mob.Name:match(name) then
          local h = mob:FindFirstChildOfClass("Humanoid")
          local r = mob:FindFirstChild("HumanoidRootPart")
          if h and r and h.Health > 0 then
            table.insert(out, mob)
          end
        end
      end
    end
  end
  -- Prioritaskan boss (lebih besar)
  table.sort(out, function(a,b)
    local sa = a:FindFirstChild("HumanoidRootPart") and a.HumanoidRootPart.Size.Magnitude or 0
    local sb = b:FindFirstChild("HumanoidRootPart") and b.HumanoidRootPart.Size.Magnitude or 0
    return sa > sb
  end)
  return out
end

-- Auto skill brutal
local function spamSkills()
  for _, k in ipairs({Enum.KeyCode.One,Enum.KeyCode.Two,Enum.KeyCode.Three,Enum.KeyCode.Four}) do
    VIM:SendKeyEvent(true, k, false, game)
    task.wait(0.03)
    VIM:SendKeyEvent(false, k, false, game)
  end
end

-- Brutal click spam
local function spamClick(times)
  for i=1, times do
    VIM:SendMouseButtonEvent(0,0,0,true,game,0)
    VIM:SendMouseButtonEvent(0,0,0,false,game,0)
  end
end

-- Teleport portal stage
local function nextStage()
  local st = WS:FindFirstChild("Portals") or WS:FindFirstChild("Stages")
  if st then
    for _, p in ipairs(st:GetChildren()) do
      if p:IsA("BasePart") and p.Name:lower():find("portal") then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then hrp.CFrame = p.CFrame + Vector3.new(0,6,0) end
        break
      end
    end
  end
end

-- Auto accept quest (Island)
local function takeQuest()
  local rem = RS:FindFirstChild("Remotes") and RS.Remotes:FindFirstChild("Quest")
  if rem then rem:FireServer("AcceptQuest", "Kill 10 "..Settings.SelectedIsland) end
end

-- Auto start dungeon
spawn(function()
  while task.wait(5) do
    if Settings.Mode=="Dungeon" and Settings.LoopStage then
      local rem = RS:FindFirstChild("Remotes")
      if rem and rem:FindFirstChild("StartDungeon") then
        rem.StartDungeon:FireServer()
      end
    end
  end
end)

-- Main loop
spawn(function()
  while task.wait(0.15) do
    if Settings.AutoFarm and char and char:FindFirstChild("HumanoidRootPart") then
      if Settings.SafeMode then applyNoClip() end

      local list = getTargets()
      if #list>0 then
        local mob = list[1]
        local pos = mob:FindFirstChild("HumanoidRootPart").Position
        hoverAbove(pos)
        spamSkills()
        spamClick(10)
        if Settings.Mode=="Island" then takeQuest() end
      else
        stopHover()
        if Settings.Mode=="Dungeon" then
          task.wait(Settings.DelayStage)
          nextStage()
        end
      end
    end
  end
end)

-- ─── GUI ──────────────────────────────────────────────────────────
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "AF_GUI"; gui.ResetOnSpawn=false

local f = Instance.new("Frame", gui)
f.Size = UDim2.new(0,260,0,360)
f.Position = UDim2.new(0,20,0.5,-180)
f.BackgroundColor3 = Color3.fromRGB(30,30,30)

local function mkToggle(txt,key,y)
  local b=Instance.new("TextButton",f)
  b.Size=UDim2.new(0,240,0,30);b.Position=UDim2.new(0,0,0,y)
  b.BackgroundColor3=Color3.fromRGB(60,60,60);b.TextColor3=Color3.new(1,1,1)
  b.Font=Enum.Font.Gotham;b.TextSize=14;b.Text=txt..": OFF"
  b.MouseButton1Click:Connect(function()
    Settings[key]=not Settings[key]
    b.Text=txt..(Settings[key] and": ON" or": OFF")
    b.BackgroundColor3=Settings[key] and Color3.fromRGB(0,170,0) or Color3.fromRGB(60,60,60)
  end)
end

local function mkDropdown(txt,key,list,y)
  local l=Instance.new("TextLabel",f)
  l.Position=UDim2.new(0,10,0,y);l.Size=UDim2.new(0,240,0,20)
  l.Text=txt..": "..Settings[key];l.TextColor3=Color3.new(1,1,1);l.BackgroundTransparency=1
  local b=Instance.new("TextButton",f)
  b.Size=UDim2.new(0,240,0,30);b.Position=UDim2.new(0,0,0,y+22)
  b.Text="Pilih "..txt;b.TextColor3=Color3.new(1,1,1);b.BackgroundColor3=Color3.fromRGB(50,50,50)
  b.MouseButton1Click:Connect(function()
    for _,c in pairs(f:GetChildren()) do if c.Name=="opt" then c:Destroy() end end
    for i,v in ipairs(list) do
      local o=Instance.new("TextButton",f);o.Name="opt"
      o.Size=UDim2.new(0,220,0,25);o.Position=UDim2.new(0,10,0,y+60+(i*26))
      o.Text=v;o.TextColor3=Color3.new(1,1,1);o.BackgroundColor3=Color3.fromRGB(80,80,80)
      o.MouseButton1Click:Connect(function()
        Settings[key]=v;l.Text=txt..": "..v
        for _,c in pairs(f:GetChildren()) do if c.Name=="opt" then c:Destroy() end end
      end)
    end
  end)
end

mkToggle("Auto Farm","AutoFarm",10)
mkToggle("Safe Mode","SafeMode",50)
mkToggle("Loop Stage","LoopStage",90)
mkDropdown("Mode","Mode",{"Dungeon","Island"},130)
mkDropdown("Dungeon","SelectedDungeon",DungeonList,200)
mkDropdown("Island","SelectedIsland",IslandList,270)

print("✅ Anime Fruit OP AutoFarm GUI loaded!")
