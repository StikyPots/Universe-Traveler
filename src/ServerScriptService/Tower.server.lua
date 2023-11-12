--// services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")


--/ require
local red = require(ReplicatedStorage.Libraries.red)
local PlayerInterface = require(ServerStorage.PlayerManager.PlayerInterface)
local GetTowers = require(ReplicatedStorage.Shared.GetElement).GetTower
local TowerInterface = require(ServerStorage.Services.TowersController.TowerInterface)

--// constante
local PlacementNetwork = red.Server("PlacementNetwork")
local NotificationNetwork = red.Server("NotificationNetwork")


PlacementNetwork:On("Placement", function(Player: Player, Name: string, CFrameV: CFrame)
    local IPlayer = PlayerInterface.GetIPlayerFromPlayerInstance(Player)


    local PlayerCoins = IPlayer.SessionData:Get("Coins")
    local TowerPrice = GetTowers(Name).price

    print(PlayerCoins, TowerPrice)

    if not (PlayerCoins >= TowerPrice) then
        return
    end

    IPlayer.SessionData:Update("Coins", - TowerPrice)
    TowerInterface.new(Player, Name, CFrameV)
end)