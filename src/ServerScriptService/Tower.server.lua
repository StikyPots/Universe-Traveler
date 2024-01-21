--// services
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")


--/ require
local red = require(ReplicatedStorage.Libraries.red)
local PlayerInterface = require(ServerStorage.PlayerManager.PlayerInterface)
local GetTowers = require(ReplicatedStorage.Shared.GetElement).GetTower
local TowerInterface = require(ServerStorage.Services.TowersController.TowerInterface)
local Constantes = require(ReplicatedStorage.Enums.Constante)
local GameManagerModule = require(ServerStorage.Services.GameManager)



--// constante
local TowerNetwork = red.Server("TowerNetwork")


TowerNetwork:On("Placement", function(Player: Player, Name: string, CFrameV: CFrame)
    local IPlayer = PlayerInterface.GetIPlayerFromPlayerInstance(Player)
    
    local AmountPlacedTower = workspace.Map:GetAttribute("AmountPlacedTower")
    local Difficulty = Constantes.MaxTowerOnMapPerDifficulty[workspace.Map:GetAttribute("Difficulty")]


    local PlayerCoins = IPlayer.SessionData:Get("Coins")
    local TowerPrice = GetTowers(Name).price

    local AbleToPlace = (PlayerCoins >= TowerPrice) and IPlayer:HasTower(Name) and AmountPlacedTower < Difficulty

	-- print(AbleToPlace, IPlayer:HasTower(Name), PlayerCoins >= TowerPrice, AmountPlacedTower < Difficulty)

    

    if not AbleToPlace or IPlayer:HasReachMaxTowerLimit(Name) then
        return
    end

    workspace.Map:SetAttribute("AmountPlacedTower", AmountPlacedTower + 1)
    IPlayer.SessionData:Update("Coins", - TowerPrice)
    TowerInterface.new(Player, Name, CFrameV)
end)