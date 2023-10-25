local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Red = require(ReplicatedStorage.Libraries.red)
local PlayerInterface = require(ServerStorage.PlayerManager.PlayerInterface)

local GettingTower = Red.Server("GettingTower")


Players.PlayerAdded:Connect(function(player)
    local Iplayer: PlayerInterface.IPlayer = PlayerInterface.new(player)
    print(Iplayer.SessionData:Get("Coins"))

    Iplayer:EquipTower("Peashooter", {Name = "Peashooter", Experience = 0, Level = 0})

    GettingTower:On("GettingTower", function(player)
        local Iplayer = PlayerInterface.GetPlayerFromPlayerInstance(player)

        local StringfyTowers = {}
        

        for key, _ in Iplayer.EquipTowers.Value do
            table.insert(StringfyTowers, key)
        end

        print(StringfyTowers)


        return StringfyTowers
    end)
end)


Players.PlayerRemoving:Connect(function(player)
    local Iplayer = PlayerInterface.RemovePlayer(player)
end)

