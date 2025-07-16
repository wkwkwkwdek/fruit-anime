-- ✅ Anime Fruit AutoFarm COMPLETE v7
local Players=game:GetService("Players")
local RS=game:GetService("ReplicatedStorage")
local WS=game:GetService("Workspace")
local VIM=game:GetService("VirtualInputManager")
local UIS=game:GetService("UserInputService")
local player=Players.LocalPlayer
local char=player.Character or player.CharacterAdded:Wait()
player.CharacterAdded:Connect(function(c)char=c end)

-- SETTINGS
local Settings={AutoFarm=false,Mode="Dungeon",SelectedDungeon="Arabasta",SelectedIsland="Center Town",SelectedMob="",LoopDungeon=true,SafeMode=true,DelayBetweenStages=2}
local DungeonList={"Arabasta","PH Islands","Beast Pirate Ships","Undersea Prison","Demon Castle"}
local IslandList={"Center Town","Arena Island","Pirate Port","Demon Island","Ninja Village","Namek Planet","Sky Island"}

local IslandMobs={
 ["Center Town"]={"Guardian","Marine","Officer","Agent"},
 ["Arena Island"]={"Thief","Fighter","Warrior","Killer","Soldier","Chef"},
 ["Pirate Port"]={"Clown Pirate","Sailor","Fishman","Captain"},
 ["Demon Island"]={"Demon","Demon Fighter","Ball Demon","Spider Demon"},
 ["Ninja Village"]={"Ninja","Sound Ninja","Black Ninja","Ninja Killer"},
 ["Namek Planet"]={"Martial Artist","Devil","Alien","Saiyan"},
 ["Sky Island"]={"Birdman","Birdman Fighter","Birdman Warrior","Birdman Duelist","Birdman Solider","Birdman Office"}
}

-- UTILITY
local function noclip()for _,p in ipairs(char:GetDescendants())do if p:IsA("BasePart")then p.CanCollide=false end end end
local function hoverAbove(p)
 local hrp=char:FindFirstChild("HumanoidRootPart") if not hrp then return end
 if not hrp:FindFirstChild("HoverForce")then
  local bv=Instance.new("BodyVelocity",hrp)
  bv.Name="HoverForce";bv.Velocity=Vector3.new(0,0,0);bv.MaxForce=Vector3.new(0,1e5,0);bv.P=1000
 end
 hrp.CFrame=CFrame.new(p+Vector3.new(0,15,0))
end

local function fireStartDungeon()
 local rem=RS:FindFirstChild("Remotes")
 if rem and rem:FindFirstChild("StartDungeon")then rem.StartDungeon:FireServer()end
end

local function getTargets()
 local out={},folder
 if Settings.Mode=="Dungeon"then folder=WS:FindFirstChild("Monsters")
 else
  for _, mobName in ipairs(IslandMobs[Settings.SelectedIsland] or {})do
   for _, mob in ipairs(WS:GetDescendants())do
    if mob:IsA("Model") and mob.Name:match(mobName) then table.insert(out,mob)end
   end
  end
 end
 if Settings.Mode=="Dungeon"and folder then
  for _,mob in ipairs(folder:GetChildren())do
   local h=mob:FindFirstChildOfClass("Humanoid")
   local r=mob:FindFirstChild("HumanoidRootPart")
   if h and r and h.Health>0 then table.insert(out,mob)end
  end
 end
 table.sort(out,function(a,b)
  local sa=a:FindFirstChild("HumanoidRootPart")and a.HumanoidRootPart.Size.Magnitude or 0
  local sb=b:FindFirstChild("HumanoidRootPart")and b.HumanoidRootPart.Size.Magnitude or 0
  return sa>sb
 end)
 return out
end

local function autoAttack(mob)
 local root=mob:FindFirstChild("HumanoidRootPart")
 local hrp=char:FindFirstChild("HumanoidRootPart")
 if not root or not hrp then return end
 hoverAbove(root.Position)
 for _,k in ipairs({Enum.KeyCode.One,Enum.KeyCode.Two,Enum.KeyCode.Three,Enum.KeyCode.Four})do
  VIM:SendKeyEvent(true,k,false,game);task.wait(0.05);VIM:SendKeyEvent(false,k,false,game)
 end
 for i=1,5 do VIM:SendMouseButtonEvent(0,0,0,true,game,0);VIM:SendMouseButtonEvent(0,0,0,false,game,0);task.wait(0.01)end
end

local function getQuestRemote()
 local rem=RS:FindFirstChild("Remotes")
 return rem and rem:FindFirstChild("Quest")
end

local function takeQuest()
 local q=getQuestRemote()
 if q then q:FireServer("AcceptQuest","Kill "..Settings.SelectedMob)end
end

local function goNextStage()
 local st=WS:FindFirstChild("Portals")orWS:FindFirstChild("Stages")
 if st then for _,p in ipairs(st:GetChildren())do if p:IsA("BasePart")and p.Name:lower():find("portal")then
   local hrp=char:FindFirstChild("HumanoidRootPart")if hrp then hrp.CFrame=p.CFrame+Vector3.new(0,6,0)end;break
 end end end
end

-- MAIN LOOPS
spawn(function()
 while task.wait(5) do if Settings.LoopDungeon and Settings.Mode=="Dungeon" then fireStartDungeon() end end
end)

spawn(function()
 while task.wait(0.1) do
  if Settings.AutoFarm then
   if Settings.SafeMode then noclip() end
   local t=getTargets()
   if #t>0 then
    autoAttack(t[1])
    if Settings.Mode=="Island" then takeQuest() end
   elseif Settings.Mode=="Dungeon" then task.wait(Settings.DelayBetweenStages);goNextStage() end
  end
 end
end)

-- GUI
local gui=Instance.new("ScreenGui",player:WaitForChild("PlayerGui"))
local f=Instance.new("Frame",gui);f.Size=UDim2.new(0,260,0,340);f.Position=UDim2.new(0,20,0.5,-170);f.BackgroundColor3=Color3.fromRGB(30,30,30)
local function mkToggle(n,k,y)
 local b=Instance.new("TextButton",f);b.Size=UDim2.new(0,220,0,30);b.Position=UDim2.new(0,20,0,y);b.Text=n..": OFF";b.TextColor3=Color3.new(1,1,1);b.BackgroundColor3=Color3.fromRGB(60,60,60)
 b.MouseButton1Click:Connect(function()Settings[k]=not Settings[k];b.Text=n..(Settings[k]and": ON":": OFF");b.BackgroundColor3=Settings[k]and Color3.fromRGB(0,170,0)or Color3.fromRGB(60,60,60)end)
end
local function mkDropdown(n,k,list,y)
 local lbl=Instance.new("TextLabel",f);lbl.Position=UDim2.new(0,20,0,y);lbl.Size=UDim2.new(0,220,0,20);lbl.Text=n..": "..Settings[k];lbl.TextColor3=Color3.new(1,1,1);lbl.BackgroundTransparency=1
 local btn=Instance.new("TextButton",f);btn.Size=UDim2.new(0,220,0,30);btn.Position=UDim2.new(0,20,0,y+22);btn.Text="Pilih "..n;btn.TextColor3=Color3.new(1,1,1);btn.BackgroundColor3=Color3.fromRGB(50,50,50)
 btn.MouseButton1Click:Connect(function()
  for _,c in pairs(f:GetChildren())do if c.Name=="opt"then c:Destroy()end end
  for i,v in ipairs(list)do
   local o=Instance.new("TextButton",f);o.Name="opt";o.Size=UDim2.new(0,200,0,25);o.Position=UDim2.new(0,30,0,y+60+(i*26));o.Text=v;o.TextColor3=Color3.new(1,1,1);o.BackgroundColor3=Color3.fromRGB(80,80,80)
   o.MouseButton1Click:Connect(function()Settings[k]=v;lbl.Text=n..": "..v;for _,c in pairs(f:GetChildren())do if c.Name=="opt"then c:Destroy()end end end)
  end
 end)
end

mkToggle("Auto Farm","AutoFarm",10)
mkToggle("Safe Mode","SafeMode",50)
mkDropdown("Mode", "Mode", {"Dungeon","Island"}, 90)
mkDropdown("Dungeon", "SelectedDungeon", DungeonList, 150)
mkDropdown("Island", "SelectedIsland", IslandList, 210)
mkToggle("Loop Dungeon","LoopDungeon",270)

UIS.InputBegan:Connect(function(k,g)if not g and k.KeyCode==Enum.KeyCode.RightShift then gui.Enabled=not gui.Enabled end end)

print("✅ Script COMPLETE Loaded")
