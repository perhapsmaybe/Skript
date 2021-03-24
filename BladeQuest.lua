function GameLoaded() repeat wait() until game:IsLoaded() end
function CheckGame()if game.PlaceId==6494523288 then return true,false end;if game.gameId==2429242760 then return false,true else return false,false end end
function ConvertFunctions()local a={["writefile"]="None",["readfile"]="None",["isfile"]="None"}if is_synapse_function then a["writefile"]=writefile;a["readfile"]=readfile;a["isfile"]=isfile;return a elseif pebc_execute then a["writefile"]=writefile;a["readfile"]=readfile;a["isfile"]=function(b)local c,d=pcall(function()a["readfile"](b)end)if c==false or d~=nil and string.find(d,"file does not exist")or d~=nil and string.find(d,"attempt to index nil with 'readfile'")then return false elseif c==true and d==nil then return true end end;return a elseif issentinelclosure then a["writefile"]=writefile;a["readfile"]=readfile;a["isfile"]=function(b)local c,d=pcall(function()a["readfile"](b)end)if c==false or d~=nil and string.find(d,"file does not exist")or d~=nil and string.find(d,"attempt to index nil with 'readfile'")then return false elseif c==true and d==nil then return true end end;return a else return false end end 

for i, v in pairs(game:GetService("CoreGui"):GetChildren()) do if v.Name == "FluxLib" then v:Destroy() end end
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ConvertedFunctions = ConvertFunctions()

shared.BladeQuest = {
    ["Player"] = {
        ["AutoAttack"] = false,
        ["AutoRun"] = false
    },
    ["Dungeon"] = {
        ["CreateDungeon"] = false,
        ["Map"] = "Forest",
        ["Difficulty"] = "Easy",
        ["Hardcore"] = false,
        ["FriendsOnly"] = true
    },
    ["Pathfinding"] = {
        ["Pathfinding"] = true,
        ["ShowPath"] = false,
        ["AroundObstacles"] = false
    },
    ["AutoBuy"] = {
        ["AutoBuy"] = true,
        ["MaxBuyCost"] = 5000,
        ["BuyBestSword"] = true,
        ["BuyTime"] = 1
    },
    ["AutoSell"] = {
        ["AutoSell"] = false,
        ["SellTime"] = 1,
        ["MinSellValue"] = 10,
        ["MaxSellValue"] = 10,
        ["MinLevel"] = 1,
        ["MaxLevel"] = 1
    }
}

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
local UI = Flux:Window("perhaps", "Blade Quest", Color3.fromRGB(255, 110, 48), Enum.KeyCode.LeftControl)
local Player = UI:Tab("Player", "http://www.roblox.com/asset/?id=6023426915")
local Dungeon = UI:Tab("Dungeon", "http://www.roblox.com/asset/?id=6022668888")
local Pathfinding = UI:Tab("Pathfinding", "http://www.roblox.com/asset/?id=6022668888")
local AutoBuy = UI:Tab("Auto-Buy", "http://www.roblox.com/asset/?id=6022668888")
local AutoSell = UI:Tab("Auto-Sell", "http://www.roblox.com/asset/?id=6022668888")

LoadSettings()
SaveSettings()

local AttackFunc = function()
    setsimulationradius(1e3, 1e3)
    spawn(function()
        repeat
            wait()
            if shared.BladeQuest["Player"]["AutoAttack"] then
                for i, v in pairs(workspace.Enemies:GetChildren()) do
                    if TempPlayer.Character and TempPlayer.Character:FindFirstChild("Sword") and TempPlayer.Character.Sword:FindFirstChild("Sword") and TempPlayer.Character.Sword.Sword:IsA("LocalScript") then
                        local Script = getsenv(TempPlayer.Character.Sword.Sword)
                        local fireRange = Script.attackRange
                        if v:FindFirstChildWhichIsA("BasePart") and (v:FindFirstChildWhichIsA("BasePart").Position - TempPlayer.Character.Head.Position).magnitude < fireRange + 2 and v:FindFirstChildOfClass("Humanoid").Health ~= 0 then
                            Script.fireRate = 0.1

                            Script.Shoot()
                            Script.ResetSpeed()
                        end
                    end
                end
            end 
        until shared.BladeQuest["Player"]["AutoAttack"] == false
    end)
end

Player:Toggle("Auto-Attack", "Automatically attacks enemies that are in range!", shared.BladeQuest["Player"]["AutoAttack"], function(Value)
    shared.BladeQuest["Player"]["AutoAttack"] = Value 
    SaveSettings()       

    if shared.BladeQuest["Player"]["AutoAttack"] and not Lobby then
        AttackFunc()
    end
end)

local function AutoRunFunc()
    setsimulationradius(1e3, 1e3)
    local Running = false
    spawn(function()
        repeat
            wait()
            if shared.BladeQuest["Player"]["AutoRun"] then
                for i, v in pairs(workspace.Enemies:GetChildren()) do
                    if TempPlayer.Character and TempPlayer.Character:FindFirstChild("Sword") and TempPlayer.Character.Sword:FindFirstChild("Sword") and TempPlayer.Character.Sword.Sword:IsA("LocalScript") then
                        local Script = getsenv(TempPlayer.Character.Sword.Sword)
                        local fireRange = Script.attackRange
                        if v:FindFirstChildWhichIsA("BasePart") and (v:FindFirstChildWhichIsA("BasePart").Position - TempPlayer.Character.Head.Position).magnitude < fireRange + 2 and v:FindFirstChildOfClass("Humanoid").Health ~= 0 then
                            if game:GetService("ReplicatedStorage").Enemies[v.Name] then
                                local AttackDamage = game:GetService("ReplicatedStorage").Enemies[v.Name].Damage.Value
                                
                                if TempPlayer.Character:FindFirstChild("Humanoid") then
                                    local PlayerHealth = TempPlayer.Character.Humanoid.Health
                                    
                                    if AttackDamage >= PlayerHealth then 
                                        -- uh oh 
                                        
                                        if TempPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                            if Running == false then
                                                Running = true
                                                
                                                if workspace:FindFirstChild("RunningAwayPart") then
                                                    v:Destroy()
                                                end
                                                
                                                TempPlayer.Character.HumanoidRootPart.CFrame = TempPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0,10,0)
                                                local NewPart = Instance.new("Part", workspace)
                                                NewPart.Size = Vector3.new(15, 1, 15)
                                                NewPart.Position = TempPlayer.Character.HumanoidRootPart.Position
                                                NewPart.Name = "RunningAwayPart"
                                                NewPart.Anchored = true
                                                TempPlayer.Character.HumanoidRootPart.CFrame = TempPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0,13,0)
                                            end
                                        end 
                                    else 
                                        Running = false 
                                        if workspace:FindFirstChild("RunningAwayPart") then
                                            v:Destroy()
                                        end
                                    end
                                end
                            end 
                        end
                    end
                end
            end 
        until shared.BladeQuest["Player"]["AutoRun"] == false
    end)
end 

Player:Toggle("Auto-Run", "Automatically runs if the next attack from an enemy will kill you!", shared.BladeQuest["Player"]["AutoRun"], function(Value)
    shared.BladeQuest["Player"]["AutoRun"] = Value
    SaveSettings()
    
    if shared.BladeQuest["Player"]["AutoRun"] and not Lobby then
        AutoRunFunc()
    end 
end)

-- // Dungeon 

local CreateDungeonFunc = function()
    spawn(function()
        repeat
            wait(5)
            local TempDungeon = shared.BladeQuest["Dungeon"]
            local Map = TempDungeon["Map"] or "Forest"
            local Difficulty = TempDungeon["Difficulty"] or "Easy"
            local Friends = TempDungeon["FriendsOnly"] or true
            local Hardcore = TempDungeon["Hardcore"] or false
            
            game:GetService("ReplicatedStorage").RF:InvokeServer("Start")
            game:GetService("ReplicatedStorage").RF:InvokeServer("Create", Map, Difficulty, Friends, Hardcore)
            game:GetService("ReplicatedStorage").RF:InvokeServer("Start")
        until shared.BladeQuest["Dungeon"]["CreateDungeon"] == false
    end)
end 

local CreateDungeon = Dungeon:Toggle("Create Dungeon", "Automatically creates a dungeon when in lobby!", shared.BladeQuest["Dungeon"]["CreateDungeon"], function(Value)
    shared.BladeQuest["Dungeon"]["CreateDungeon"] = Value 
    SaveSettings()
    
    if shared.BladeQuest["Dungeon"]["CreateDungeon"] and Lobby then
        CreateDungeonFunc()
    end
end)

local FriendsOnly = Dungeon:Toggle("Friends Only", "Dungeons are friends only when automatically created!", shared.BladeQuest["Dungeon"]["FriendsOnly"], function(Value)
    shared.BladeQuest["Dungeon"]["FriendsOnly"] = Value
    SaveSettings()
end)

local HardcoreDungeon = Dungeon:Toggle("Hardcore Mode", "Dungeons are hardcore when automatically created! (One Life, More Loot)", shared.BladeQuest["Dungeon"]["Hardcore"], function(Value)
    shared.BladeQuest["Dungeon"]["Hardcore"] = Value
    SaveSettings()
end)

function GetMaps() local ReturnTable = {} if TempPlayer.PlayerGui:FindFirstChild("UI") and TempPlayer.PlayerGui.UI:FindFirstChild("Play") and TempPlayer.PlayerGui.UI.Play:FindFirstChild("Create") and TempPlayer.PlayerGui.UI.Play:FindFirstChild("Create") and TempPlayer.PlayerGui.UI.Play.Create:FindFirstChild("Maps") then for i, v in pairs(TempPlayer.PlayerGui.UI.Play.Create.Maps:GetChildren()) do local PlayerLevel = TempPlayer.leaderstats.Level.Value if v.Name ~= "Soon" and v.Name ~= "UIGridLayout" then local MapLevel = string.split(v.Lvl.Text, "Level ")[2] MapLevel = MapLevel:gsub("+", "") if v:FindFirstChild("Lvl") and tonumber(MapLevel) <= PlayerLevel then table.insert(ReturnTable, v.Name..[[(Level ]]..MapLevel..[[+)]])  end end end end return ReturnTable end 
local MapsDropdown = Dungeon:Dropdown("Dungeon Map", GetMaps(), function(Value)
    shared.BladeQuest["Dungeon"]["Map"] = string.split(Value, [[(]])[1]
end)

local TempDifficulties = {"Easy", "Medium", "Hard", "Expert"}
local DifficultiesDropdown = Dungeon:Dropdown("Dungeon Difficulty", TempDifficulties, function(Value)
    shared.BladeQuest["Dungeon"]["Difficulty"] = Value

    if TempPlayer.PlayerGui:FindFirstChild("UI") and TempPlayer.PlayerGui.UI:FindFirstChild("Play") and TempPlayer.PlayerGui.UI.Play:FindFirstChild("Create") and TempPlayer.PlayerGui.UI.Play:FindFirstChild("Create") and TempPlayer.PlayerGui.UI.Play.Create:FindFirstChild("Maps") then 
        if TempPlayer.PlayerGui.UI.Play.Create.Maps:FindFirstChild(shared.BladeQuest["Dungeon"]["Map"]) then
            local MapsPath = TempPlayer.PlayerGui.UI.Play.Create.Maps
            local CurrentMap = MapsPath[shared.BladeQuest["Dungeon"]["Map"]]

            local MapLevel = string.split(CurrentMap.Lvl.Text, "Level ")[2]
            MapLevel = MapLevel:gsub("+", "")
            MapLevel = tonumber(MapLevel)

            for i, v in pairs(TempDifficulties) do
                if v ~= Value then
                    MapLevel = MapLevel + 3
                end
            end

            if MapLevel >= TempPlayer.leaderstats.Level.Value then
                Flux:Notification("Warning! This difficulty level requires a level higher than your current level", "Alright, continue anyways")
            end
        end 
    end
end)
