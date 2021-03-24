function GameLoaded() repeat wait() until game:IsLoaded() end
function CheckGame()if game.PlaceId==6494523288 then return true,false end;if game.gameId==2429242760 then return false,true else return false,false end end
function ConvertFunctions()local a={["writefile"]="None",["readfile"]="None",["isfile"]="None"}if is_synapse_function then a["writefile"]=writefile;a["readfile"]=readfile;a["isfile"]=isfile;return a elseif pebc_execute then a["writefile"]=writefile;a["readfile"]=readfile;a["isfile"]=function(b)local c,d=pcall(function()a["readfile"](b)end)if c==false or d~=nil and string.find(d,"file does not exist")or d~=nil and string.find(d,"attempt to index nil with 'readfile'")then return false elseif c==true and d==nil then return true end end;return a elseif issentinelclosure then a["writefile"]=writefile;a["readfile"]=readfile;a["isfile"]=function(b)local c,d=pcall(function()a["readfile"](b)end)if c==false or d~=nil and string.find(d,"file does not exist")or d~=nil and string.find(d,"attempt to index nil with 'readfile'")then return false elseif c==true and d==nil then return true end end;return a else return false end end 

for i, v in pairs(game:GetService("CoreGui"):GetChildren()) do if v.Name == "FluxLib" then v:Destroy() end end
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ConvertedFunctions = ConvertFunctions()

shared.BladeQuest = {["Player"] = {["AutoAttack"] = false,["AutoDodge"] = false,["AutoSupport"] = false,["AutoDamage"] = false, ["attackWalkSpeed"] = 20, ["defaultWalkSpeed"] = 20},["Dungeon"] = {["CreateDungeon"] = false,["Map"] = "Forest",["Difficulty"] = "Easy",["Hardcore"] = false,["FriendsOnly"] = true},["Pathfinding"] = {["Pathfinding"] = true,["ShowPath"] = false,["AroundObstacles"] = false},["AutoBuy"] = {["AutoBuy"] = true,["MaxBuyCost"] = 5000,["BuyBestSword"] = true,["BuyTime"] = 1},["AutoSell"] = {["AutoSell"] = false,["SellTime"] = 1,["MinSellValue"] = 10,["MaxSellValue"] = 10,["MinLevel"] = 1,["MaxLevel"] = 1}}

local Lobby, Dungeon = CheckGame()

if not Lobby and not Dungeon then return end 
if not ConvertedFunctions then Players.LocalPlayer:Kick("Incompatible exploit, as of now Synapse X, Sentinel, and Protosmasher are supported!") end 

CheckGame()

-- // Settings

function LoadSettings()local a=ConvertedFunctions;if a.readfile and a.isfile and a.writefile then local b=a.readfile;local c=a.writefile;local d=a.isfile;if d("BladeQuest.txt")==false then c("BladeQuest.txt",game:GetService("HttpService"):JSONEncode(shared.BladeQuest))else local e=game:GetService("HttpService"):JSONDecode(b("BladeQuest.txt"))for f,g in pairs(e)do for h,i in pairs(g)do shared.BladeQuest[f][h]=i end end end else warn("Failed to load settings!")return false end end 
function SaveSettings()local a=ConvertedFunctions;if a.readfile and a.isfile and a.writefile then local b=a.readfile;local c=a.writefile;local d=a.isfile;if d("BladeQuest.txt")==false then LoadSettings()else local e=game:GetService("HttpService"):JSONDecode(b("BladeQuest.txt"))local f={}for g,h in pairs(shared.BladeQuest)do f[g]={}for i,j in pairs(h)do f[g][i]=j end end;c("BladeQuest.txt",game:GetService("HttpService"):JSONEncode(f))end else warn("Failed to save settings!")return false end end  

-- // UI 

local TempPlayer = Players.LocalPlayer
local Flux = loadstring(game:HttpGet"https://raw.githubusercontent.com/dawid-scripts/UI-Libs/main/fluxlib.txt")()
local UI = Flux:Window("perhaps Hub", "\nBlade Quest", Color3.fromRGB(255, 110, 48), Enum.KeyCode.LeftControl)
local Player = UI:Tab("Player", "http://www.roblox.com/asset/?id=6023426915")
local Dungeon = UI:Tab("Dungeon", "http://www.roblox.com/asset/?id=6022668888")
local Pathfinding = UI:Tab("Pathfinding", "http://www.roblox.com/asset/?id=6022668888")
local AutoBuy = UI:Tab("Auto-Buy", "http://www.roblox.com/asset/?id=6022668888")
local AutoSell = UI:Tab("Auto-Sell", "http://www.roblox.com/asset/?id=6022668888")
local InfoTab = UI:Tab("Credits", "http://www.roblox.com/asset/?id=6023426915")

InfoTab:Label("V3rm Credits")
InfoTab:Line()
InfoTab:Label("AFriendlyNewUser - Creator")
InfoTab:Label("e621 - Helping")
InfoTab:Line()
InfoTab:Label("Other Credits")
InfoTab:Line()
InfoTab:Label("Bluwu#3621 - Helping")

Pathfinding:Label("Pathfinding is coming soon!")

LoadSettings()
SaveSettings()

local function GetEnemiesNearby()
    local EnemiesNearby = {}
    if not TempPlayer.Character:FindFirstChild("Sword") and not TempPlayer.Character.Sword:FindFirstChild("Sword") then return false, {} end

    local Script = getsenv(TempPlayer.Character.Sword.Sword) 
    Script.attackRange = 7

    local fireRange = Script.attackRange
    
    local FoundEnemies = false
    for i, v in pairs(workspace.Enemies:GetChildren()) do
        if v:FindFirstChildWhichIsA("BasePart") and v:FindFirstChildWhichIsA("Humanoid") and v:FindFirstChildWhichIsA("Humanoid").Health ~= 0 and TempPlayer.Character:FindFirstChild("HumanoidRootPart") and (v:FindFirstChildWhichIsA("BasePart").Position - TempPlayer.Character.Head.Position).magnitude < fireRange then
            table.insert(EnemiesNearby, v)
            FoundEnemies = true
        end
    end

    if FoundEnemies then
        return true, EnemiesNearby
    end 

    return false, EnemiesNearby
end

local function RunSwordFunction(SwordFunction)
    if not TempPlayer.Character:FindFirstChild("Sword") and not TempPlayer.Character.Sword:FindFirstChild("Sword") then return false end

    local Script = getsenv(TempPlayer.Character.Sword.Sword)
    if Script[SwordFunction] then
        Script[SwordFunction]()

        return true
    end 

    return false
end

local function ChangeSwordVariable(SwordVariable, NewValue)
    if not TempPlayer.Character:FindFirstChild("Sword") and not TempPlayer.Character.Sword:FindFirstChild("Sword") then return false end

    local Script = getsenv(TempPlayer.Character.Sword.Sword)
    if Script[SwordVariable] then
        Script[SwordVariable] = NewValue

        return true
    end 

    return false
end

local function CreateLoop(VariableParent, VariableName, LoopFunction) spawn(function() repeat wait() if shared.BladeQuest[VariableParent][VariableName] then LoopFunction() end until shared.BladeQuest[VariableParent][VariableName] == false end) end 
Player:Toggle("Auto-Attack", "Automatically attacks enemies that are in range!", shared.BladeQuest["Player"]["AutoAttack"], function(Value)
    shared.BladeQuest["Player"]["AutoAttack"] = Value 
    SaveSettings()       

    if Value and not Lobby then
        CreateLoop("Player", "AutoAttack", function()
            setsimulationradius(1e3, 1e3)
            ChangeSwordVariable("fireRate", 0.01)
        
            if GetEnemiesNearby() ~= false and {} then
                RunSwordFunction("Shoot")
                RunSwordFunction("ResetSpeed")
            end 
        end)
    end
end)

Player:Toggle("Auto-Damage", "Automatically uses support magic", shared.BladeQuest["Player"]["AutoDamage"], function(Value)
    shared.BladeQuest["Player"]["AutoDamage"] = Value
    SaveSettings()

    if Value and not Lobby then
        CreateLoop("Player", "AutoAttack", function()
            setsimulationradius(1e3, 1e3)
            ChangeSwordVariable("fireRate", 0.01)
        
            if GetEnemiesNearby() ~= false and {} then
                RunSwordFunction("Damage")
                RunSwordFunction("ResetSpeed")
            end 
        end)
    end
end)

Player:Toggle("Auto-Support", "Automatically uses support magic", shared.BladeQuest["Player"]["AutoSupport"], function(Value)
    shared.BladeQuest["Player"]["AutoSupport"] = Value
    SaveSettings()

    if Value and not Lobby then
        CreateLoop("Player", "AutoSupport", function()
            if TempPlayer.Character:FindFirstChild("Humanoid") and TempPlayer.Character.Humanoid.Health ~= TempPlayer.Character.Humanoid.MaxHealth then
                RunSwordFunction("Support")
            end
        end)
    end 
end)

Player:Line()
Player:Toggle("Auto-Dodge", "Automatically dodges if the next attack from an enemy will kill you!", shared.BladeQuest["Player"]["AutoDodge"], function(Value)
    shared.BladeQuest["Player"]["AutoDodge"] = Value
    SaveSettings()
    
    if Value and not Lobby then
        shared["Dodging"] = false
        CreateLoop("Player", "AutoDodge", function()
            setsimulationradius(1e3, 1e3)
    
            local IsEnemies, EnemiesNearby = GetEnemiesNearby()
            if IsEnemies ~= false and EnemiesNearby ~= {} then
                for i, v in pairs(EnemiesNearby) do 
                    if game:GetService("ReplicatedStorage").Enemies:FindFirstChild(v.Name) and TempPlayer.Character:FindFirstChild("Humanoid") then
                        local AttackDamage = game:GetService("ReplicatedStorage").Enemies:FindFirstChild(v.Name).Damage.Value 
                        local PlayerHealth = TempPlayer.Character.Humanoid.Health
                        
                        if PlayerHealth <= AttackDamage and shared["Dodging"] == false then
                            shared["Dodging"] = true
                            
                            TempPlayer.Character.HumanoidRootPart.CFrame = TempPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0,10,0)
                            local NewPart = Instance.new("Part", workspace) NewPart.Size = Vector3.new(15, 1, 15) NewPart.Position = TempPlayer.Character.HumanoidRootPart.Position NewPart.Name = "DodgeAwayPart" NewPart.Anchored = true TempPlayer.Character.HumanoidRootPart.CFrame = TempPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0,13,0)
                            
                            repeat wait() until TempPlayer.Character.Humanoid.Health > AttackDamage 
                            if workspace:FindFirstChild("DodgeAwayPart") then 
                                workspace.DodgeAwayPart:Destroy()
                            end
                        elseif TempPlayer.Character.Humanoid.Health > AttackDamage and shared["Dodging"] == true then
                            shared["Dodging"] = false
                            
                            if workspace:FindFirstChild("DodgeAwayPart") then 
                                workspace.DodgeAwayPart:Destroy()
                            end 
                        end 
                    end
                end 
            end 
        end)
    end 
end)

Player:Line()

local function ConvertNumberToBaseValue(Max, Min, BaseValue)
    local ReturnValue = 0
    for i = 0, Max do
        local TempValue = i and math.floor((i / Max) * (Max - Min) + Min) or 0
        
        if TempValue == BaseValue then
            ReturnValue = i
        end 
    end 
    
    return ReturnValue
end


ChangeSwordVariable("attackWalkSpeed", shared.BladeQuest["Player"]["attackWalkSpeed"])
Player:Slider("Attack Walkspeed", "Walkspeed when attacking", 10, 50, ConvertNumberToBaseValue(50, 10, shared.BladeQuest["Player"]["attackWalkSpeed"]), function(Value)
    shared.BladeQuest["Player"]["attackWalkSpeed"] = Value
    ChangeSwordVariable("attackWalkSpeed", Value)

    SaveSettings()
end)

ChangeSwordVariable("defaultWalkSpeed", shared.BladeQuest["Player"]["defaultWalkSpeed"])
Player:Slider("Default Walkspeed", "Walkspeed when not attacking, updates after you stop attacking", 20, 100, ConvertNumberToBaseValue(100, 20, shared.BladeQuest["Player"]["defaultWalkSpeed"]), function(Value)
    shared.BladeQuest["Player"]["defaultWalkSpeed"] = Value
    ChangeSwordVariable("defaultWalkSpeed", Value)

    SaveSettings()
end)

-- // Dungeon 

local TempDifficulties = {"Easy", "Medium", "Hard", "Expert"}
function GetMaps() local ReturnTable = {} if TempPlayer.PlayerGui:FindFirstChild("UI") and TempPlayer.PlayerGui.UI:FindFirstChild("Play") and TempPlayer.PlayerGui.UI.Play:FindFirstChild("Create") and TempPlayer.PlayerGui.UI.Play:FindFirstChild("Create") and TempPlayer.PlayerGui.UI.Play.Create:FindFirstChild("Maps") then for i, v in pairs(TempPlayer.PlayerGui.UI.Play.Create.Maps:GetChildren()) do local PlayerLevel = TempPlayer.leaderstats.Level.Value if v.Name ~= "Soon" and v.Name ~= "UIGridLayout" then local MapLevel = string.split(v.Lvl.Text, "Level ")[2] MapLevel = MapLevel:gsub("+", "") if v:FindFirstChild("Lvl") and tonumber(MapLevel) <= PlayerLevel then table.insert(ReturnTable, v.Name..[[(Level ]]..MapLevel..[[+)]])  end end end end return ReturnTable end 

local CreateDungeon = Dungeon:Toggle("Create Dungeon", "Automatically creates a dungeon when in lobby!", shared.BladeQuest["Dungeon"]["CreateDungeon"], function(Value) shared.BladeQuest["Dungeon"]["CreateDungeon"] = Value SaveSettings() if shared.BladeQuest["Dungeon"]["CreateDungeon"] and Lobby then CreateLoop("Dungeon", "CreateDungeon", function() wait(7.5) local TempDungeon = shared.BladeQuest["Dungeon"] local Map = TempDungeon["Map"] or "Forest" local Difficulty = TempDungeon["Difficulty"] or "Easy" local Friends = TempDungeon["FriendsOnly"] or true local Hardcore = TempDungeon["Hardcore"] or false game:GetService("ReplicatedStorage").RF:InvokeServer("Start") game:GetService("ReplicatedStorage").RF:InvokeServer("Create", Map, Difficulty, Friends, Hardcore) game:GetService("ReplicatedStorage").RF:InvokeServer("Start") end) end end)
local FriendsOnly = Dungeon:Toggle("Friends Only", "Dungeons are friends only when automatically created!", shared.BladeQuest["Dungeon"]["FriendsOnly"], function(Value) shared.BladeQuest["Dungeon"]["FriendsOnly"] = Value SaveSettings() end)
local HardcoreDungeon = Dungeon:Toggle("Hardcore Mode", "Dungeons are hardcore when automatically created! (One Life, More Loot)", shared.BladeQuest["Dungeon"]["Hardcore"], function(Value) shared.BladeQuest["Dungeon"]["Hardcore"] = Value SaveSettings() end)
local MapsDropdown = Dungeon:Dropdown("Dungeon Map", GetMaps(), function(Value) shared.BladeQuest["Dungeon"]["Map"] = string.split(Value, [[(]])[1] end)
local DifficultiesDropdown = Dungeon:Dropdown("Dungeon Difficulty", TempDifficulties, function(Value) shared.BladeQuest["Dungeon"]["Difficulty"] = Value if TempPlayer.PlayerGui:FindFirstChild("UI") and TempPlayer.PlayerGui.UI:FindFirstChild("Play") and TempPlayer.PlayerGui.UI.Play:FindFirstChild("Create") and TempPlayer.PlayerGui.UI.Play:FindFirstChild("Create") and TempPlayer.PlayerGui.UI.Play.Create:FindFirstChild("Maps") then if TempPlayer.PlayerGui.UI.Play.Create.Maps:FindFirstChild(shared.BladeQuest["Dungeon"]["Map"]) then local MapsPath = TempPlayer.PlayerGui.UI.Play.Create.Maps local CurrentMap = MapsPath[shared.BladeQuest["Dungeon"]["Map"]] local MapLevel = string.split(CurrentMap.Lvl.Text, "Level ")[2] MapLevel = MapLevel:gsub("+", "") MapLevel = tonumber(MapLevel) for i, v in pairs(TempDifficulties) do if v ~= Value then MapLevel = MapLevel + 3 end end if MapLevel >= TempPlayer.leaderstats.Level.Value then Flux:Notification("Warning! This difficulty level requires a level higher than your current level", "Alright, continue anyways") end end end end)

-- Pathfinding

local PathfindingToggle = Pathfinding:Toggle("Pathfinding", "Automatically moves to enemies and kills them", shared.BladeQuest["Pathfinding"]["Pathfinding"], function(Value) 
    shared.BladeQuest["Pathfinding"]["Pathfinding"] = Value 
    
    if Value and not Lobby then 
        CreateLoop("Pathfinding", "Pathfinding", function()
            
        end)
    end 
end)
