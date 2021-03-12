local Material = loadstring(game:HttpGet("https://raw.githubusercontent.com/Kinlei/MaterialLua/master/Module.lua"))()
local UI = Material.Load({Title="Blade Quest", Style=3, SizeX=400, SizeY=300, Theme="Light"})

local Player = UI.New({
    Title = "Player"
})

local Dungeon = UI.New({
    Title = "Dungeon"
})

repeat wait() until game:IsLoaded()

Dungeon.Toggle({
    Text = "Create Dungeon",
    Callback = function(Value)
        shared.CreateDungeon = Value
        
        spawn(
            function()
                repeat
                    wait(5)
                    if shared.CreateDungeon and game.PlaceId == 6494523288 then
                        local Map = tostring(shared.DungeonMap) or "Forest"
                        local Difficulty = tostring(shared.DungeonDifficulty) or "Easy"
                        local Friends = shared.DungeonFriends or true 
                        local Hardcore = shared.DungeonHardcore or false
                            
                        game:GetService("ReplicatedStorage").RF:InvokeServer("Create", Map, Difficulty, Friends, Hardcore)
                        game:GetService("ReplicatedStorage").RF:InvokeServer("Start")
                    end 
                until shared.CreateDungeon == false 
            end 
        )
    end,
    Enabled = false
})

Dungeon.Toggle({
    Text = "Friends Only",
    Callback = function(Value)
        shared.DungeonFriends = Value
    end,
    Enabled = false
})

Dungeon.Toggle({
    Text = "Hardcore",
    Callback = function(Value)
        shared.DungeonHardcore = Value
    end,
    Enabled = false
})

function GetMaps() 
    local ReturnTable = {} 
    if game.Players.LocalPlayer.PlayerGui:FindFirstChild("UI") and game.Players.LocalPlayer.PlayerGui.UI:FindFirstChild("Play") and game.Players.LocalPlayer.PlayerGui.UI.Play:FindFirstChild("Create") and game.Players.LocalPlayer.PlayerGui.UI.Play:FindFirstChild("Create") and game.Players.LocalPlayer.PlayerGui.UI.Play.Create:FindFirstChild("Maps") then 
        for i, v in pairs(game.Players.LocalPlayer.PlayerGui.UI.Play.Create.Maps:GetChildren()) do 
            local PlayerLevel = game.Players.LocalPlayer.leaderstats.Level.Value
            if v.Name ~= "Soon" and v.Name ~= "UIGridLayout"  then
                local MapLevel = string.split(v.Lvl.Text, "Level ")[2]
                MapLevel = MapLevel:gsub("+", "")
                if v:FindFirstChild("Lvl") and tonumber(MapLevel) <= PlayerLevel then 
                    table.insert(ReturnTable, v.Name) 
                end 
            end 
        end 
    end 
    return ReturnTable 
end 

function GetDifficulties() 
    local Difficulties = {["Easy"] = 1, ["Medium"] = 4, ["Hard"] = 7, ["Expert"] = 10}
    
    local PlayerLevel = game.Players.LocalPlayer.leaderstats.Level.Value
    local ReturnTable = {} 
    
    for i, v in pairs(Difficulties) do
        if v <= PlayerLevel then
            table.insert(ReturnTable, i)
        end 
    end 
    
    return ReturnTable 
end

table.foreach(GetMaps(), warn)
Dungeon.Dropdown({
    Text = "Dungeon Map",
    Callback = function(Value)
        shared.DungeonMap = Value
    end,
    Options = GetMaps()
})

Dungeon.Dropdown({
    Text = "Difficulty",
    Callback = function(Value)
        shared.DungeonDifficulty = Value
    end,
    Options = GetDifficulties()
})

function CheckObject(Object) if Object ~= nil then return true end return false end

function Loaded() return game:IsLoaded() end
function LocalPlayer() return Loaded() and game:GetService("Players").LocalPlayer end 
function PlayerAlive() if not Loaded() or not LocalPlayer() then return false end if CheckObject(game:GetService("Players").LocalPlayer.Character) and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid") and game:GetService("Players").LocalPlayer.Character:FindFirstChild("Humanoid").Health > 0 then return true end return false end

shared.InstaKillTP = false
shared.KillingEnemies = false
Player.Toggle({
    Text = "Insta-Kill",
    Callback = function(Value)
        shared.InstaKill = Value
        spawn(
            function()
                repeat
                    wait(1)
                    if shared.InstaKill and not shared.KillingEnemies then
                        if game:GetService("Workspace"):FindFirstChild("Enemies") then
                            local OrginalTable = game:GetService("Workspace"):FindFirstChild("Enemies"):GetChildren()
                            for i1, v1 in pairs(game:GetService("Workspace"):FindFirstChild("Enemies"):GetChildren()) do
                                if i1 == #OrginalTable then
                                    shared.KillingEnemies = false
                                    
                                    if PlayerAlive() then
                                        for i, v in pairs(game:GetService("Players").LocalPlayer.Character:GetChildren()) do
                                            if v.Name == "HumanoidRootPart" then
                                                v.Anchored = false 
                                            end 
                                        end          
                                    end
                                else
                                    shared.KillingEnemies = true    
                                end 
                                
                                if v1 and v1:FindFirstChild("HumanoidRootPart") then
                                    if PlayerAlive() and v1:FindFirstChild("Enemy") and v1:FindFirstChild("Enemy").Health > 0 then
                                        for i, v in pairs(game:GetService("Players").LocalPlayer.Character:GetChildren()) do
                                            if v.Name == "HumanoidRootPart" then
                                                v.Anchored = false 
                                            end 
                                        end   
                                        
                                        if shared.InstaKillTP then
                                            game:GetService("Players").LocalPlayer.Character.HumanoidRootPart.CFrame = v1.HumanoidRootPart.CFrame + Vector3.new(0, 5, 0) 
                                        end 
                                        
                                        game:GetService("ReplicatedStorage").RE:FireServer("Hit", v1, v1.HumanoidRootPart.Position)
                                        v1:FindFirstChild("Enemy").Health = 0
                                        
                                        wait(0.75)
                                    end 
                                end 
                            end 
                        end 
                    end 
                until shared.InstaKill == false
            end 
        )
    end, 
    Enabled = false
})

Player.Toggle({
    Text="Insta-Kill TP",
    Callback = function(Value)
        shared.InstaKillTP = Value
    end,
    Enabled = false
})

Player.Toggle({
    Text="Auto-Equip Best",
    Callback = function(Value)
        shared.AutoEquipBest = Value 
        
        spawn(
            function()
               repeat 
                    wait(5)
                    
                    if PlayerAlive() and game.Players.LocalPlayer:FindFirstChild("Data") and game.Players.LocalPlayer.Data:FindFirstChild("Swords") then
                        local HighSword = {0, "None"}
                        for i, v in pairs(game.Players.LocalPlayer.Data.Swords:GetChildren()) do
                            if v.Amnt.Value > HighSword[1] then
                                HighSword[2] = v 
                                HighSword[1] = v.Amnt.Value
                            end 
                        end 
                        
                        game:GetService("ReplicatedStorage").RE:FireServer("Equip", HighSword[2])
                    end
                until shared.AutoEquipBest == false
            end 
        )
    end,
    Enabled = false
})
