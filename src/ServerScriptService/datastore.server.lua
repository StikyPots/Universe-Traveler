local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Red = require(ReplicatedStorage.Libraries.red)
local PlayerInterface = require(ServerStorage.PlayerManager.PlayerInterface)

local GettingTower = Red.Server("GettingTower")


Players.PlayerAdded:Connect(function(player)
    local Iplayer: PlayerInterface.IPlayer = PlayerInterface.new(player)

    GettingTower:On("GettingTower", function(player)
        local Iplayer = PlayerInterface.GetIPlayerFromPlayerInstance(player)

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
    Iplayer:CloseDatastore()
end)

