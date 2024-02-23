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
local SendNotification = require(ReplicatedStorage.Shared.SendNotification)
local NotificationTemplate = require(ReplicatedStorage.Enums.NotificationTemplate)



--// constante
local TowerNetwork = red.Server("TowerNetwork")



TowerNetwork:On("Placement", function(Player: Player, Name: string, CFrameV: CFrame)
    local IPlayer = PlayerInterface.GetIPlayerFromPlayerInstance(Player)
    
    local AmountPlacedTower = workspace.Map:GetAttribute("AmountPlacedTower")
    local Difficulty = Constantes.MaxTowerOnMapPerDifficulty[workspace.Map:GetAttribute("Difficulty")]


    local PlayerCoins = IPlayer.SessionData:Get("Coins")
    local TowerPrice = GetTowers(Name).price

    local AbleToPlace = (PlayerCoins >= TowerPrice) and IPlayer:HasTower(Name)
    local HasReachMaxTowerLimit = IPlayer:HasReachMaxTowerLimit(Name)
    local AmountPlacedTowerCheck = AmountPlacedTower < Difficulty

	
    local function CheckNotification(b1: boolean, b2: boolean, b3:boolean)
        if b1 then
            SendNotification.Notify(Player, NotificationTemplate.NotEnoughMoney)
        elseif b2 then

            local StrToFormat = NotificationTemplate.HasReachMaxTowerLimit.Description
            local Body = table.clone(NotificationTemplate.HasReachMaxTowerLimit)
            Body.Description = string.format(StrToFormat, Name)
            
            SendNotification.Notify(Player, Body)
        elseif b3 then
            SendNotification.Notify(Player, NotificationTemplate.MaxTowerLimit)
        end
    end

    if not AbleToPlace or HasReachMaxTowerLimit or not AmountPlacedTowerCheck then
        CheckNotification(not AbleToPlace, HasReachMaxTowerLimit, not AmountPlacedTowerCheck)
        return
    end

    workspace.Map:SetAttribute("AmountPlacedTower", AmountPlacedTower + 1)
    IPlayer.SessionData:Update("Coins", - TowerPrice)
    TowerInterface.new(Player, Name, CFrameV)
end)