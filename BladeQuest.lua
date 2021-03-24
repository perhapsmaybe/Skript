function GameLoaded() repeat wait() until game:IsLoaded() end
function CheckGame()if game.PlaceId==6494523288 then return true,false end;if game.gameId==2429242760 then return false,true else return false,false end end
function ConvertFunctions()local a={["writefile"]="None",["readfile"]="None",["isfile"]="None"}if is_synapse_function then a["writefile"]=writefile;a["readfile"]=readfile;a["isfile"]=isfile;return a elseif pebc_execute then a["writefile"]=writefile;a["readfile"]=readfile;a["isfile"]=function(b)local c,d=pcall(function()a["readfile"](b)end)if c==false or d~=nil and string.find(d,"file does not exist")or d~=nil and string.find(d,"attempt to index nil with 'readfile'")then return false elseif c==true and d==nil then return true end end;return a elseif issentinelclosure then a["writefile"]=writefile;a["readfile"]=readfile;a["isfile"]=function(b)local c,d=pcall(function()a["readfile"](b)end)if c==false or d~=nil and string.find(d,"file does not exist")or d~=nil and string.find(d,"attempt to index nil with 'readfile'")then return false elseif c==true and d==nil then return true end end;return a else return false end end 

local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ConvertedFunctions = ConvertFunctions()

shared.BladeQuest = {
    ["Player"] = {
        ["AutoAttack"] = false,
    },
    ["Dungeon"] = {
        ["CreateDungeon"] = true,
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

local Material = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))()
local UI = Material.Load({Title="Blade Quest", Style=_G.UIStyle or 3, SizeX=400, SizeY=300, Theme="Light"})
local Player = UI.New({Title="Player"})
local Dungeon = UI.New({Title="Dungeon"})
local Pathfinding = UI.New({Title = "Pathfinding"})
local AutoBuy = UI.New({Title="Auto-Buy"})
local AutoSell = UI.New({Title="Auto-Sell"})

LoadSettings()
SaveSettings()

local AutoAttack = Player.Toggle({Text="Auto-Attack",
    Callback = function(Value)
        shared.BladeQuest["Player"]["AutoAttack"] = Value
        
        local a = getsenv(game.Players.LocalPlayer.Character.Sword.Sword)
        a.fireRate = 0.1
        setsimulationradius(1e3, 1e3)
        spawn(
            function()
                repeat
                    wait()
                    if shared.BladeQuest["Player"]["AutoAttack"] then
                        for i, v in pairs(workspace.Enemies:GetChildren()) do
                            if v:FindFirstChildWhichIsA("BasePart") and (v:FindFirstChildWhichIsA("BasePart").Position - game.Players.LocalPlayer.Character.Head.Position).magnitude < 15 and v:FindFirstChildOfClass("Humanoid").Health ~= 0 then
                                --game:GetService("ReplicatedStorage").RE:FireServer("Hit", v, v:FindFirstChildWhichIsA("BasePart").Position)
                                a.Shoot()
                                a.ResetSpeed()
                            end
                        end
                    end 
                until shared.BladeQuest["Player"]["AutoAttack"] == false
            end 
        )
    end, 
    Enabled = shared.BladeQuest["Player"]["AutoAttack"]
})

-- // Dungeon 

local CreateDungeon = Dungeon.Toggle({Text="Create Dungeon", 
    Callback = function(Value)
        shared.BladeQuest["Dungeon"]["CreateDungeon"] = Value 
        SaveSettings()
    end,
    Enabled = shared.BladeQuest["Dungeon"]["CreateDungeon"]
})

