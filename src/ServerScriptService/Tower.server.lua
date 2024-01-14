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


PlacementNetwork:On("Placement", function(Player: Player, Name: string, CFrameV: CFrame)
    local IPlayer = PlayerInterface.GetIPlayerFromPlayerInstance(Player)


    local PlayerCoins = IPlayer.SessionData:Get("Coins")
    local TowerPrice = GetTowers(Name).price

    -- print(PlayerCoins, TowerPrice)
    -- print(IPlayer:HasTower(Name))

    if not (PlayerCoins >= TowerPrice) and IPlayer:HasTower(Name) then
        return
    end

    IPlayer.SessionData:Update("Coins", - TowerPrice)
    TowerInterface.new(Player, Name, CFrameV)
end)