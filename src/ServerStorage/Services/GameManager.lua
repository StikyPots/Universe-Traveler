local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")
local MemoryStoreService = game:GetService("MemoryStoreService")




local PartySortedMap = MemoryStoreService:GetSortedMap("PartyData")
local SequenceController = require(ServerStorage.Services.WavesController.SequenceController)
local mapLoader = require(ServerStorage.MapLoader)
local Constante = require(ReplicatedStorage.Enums.Constante)


local GameManager = {}
local _gameManager = nil

export type Sequence = SequenceController.SequenceController
export type Map = mapLoader.mapLoader
export type GameManager = typeof(GameManager.new())
type PartyData = {Map: string, Difficulty: string, PlayerNumbers: number}


function GameManager.new()
    local self = setmetatable({}, {__index = GameManager})


    if RunService:IsStudio() then
        PartySortedMap:SetAsync(game.PlaceId, Constante.DefaultTeleportData, 60, game.PlaceId)
    end

    self.ServerData = {} :: PartyData
    self.Key = if not RunService:IsStudio() then game.PrivateServerId else game.PlaceId

    self:GetDatFaromMemoryStore()
    self:SetupAttributes()
    _gameManager = self

    return self
end



function GameManager.GetDatFaromMemoryStore(self: GameManager)

    print(self.Key)

    local succes, result = pcall(function()
        return PartySortedMap:GetAsync(self.Key)
    end)

	if succes then
        print(succes, result)
		self.ServerData = result
        print(self.ServerData.Difficulty, self.ServerData.PlayerNumbers)
    end
end

function GameManager.SetupAttributes(self: GameManager)


    workspace.Map:SetAttribute("AmountPlacedTower", 0)

    for key, data in self.ServerData do
        workspace.Map:SetAttribute(key, data)
    end
end

--// return Sequence and Map instances
function GameManager.CreateSequenceAndMap(self: GameManager)

    local CurrentMap = mapLoader.new(self.ServerData.Map)
    local Sequence = SequenceController.new(CurrentMap.Settings.Waves, CurrentMap.Settings.Entities, self.ServerData.Difficulty)

    return Sequence, CurrentMap
end


function GameManager.GetCurrentGameManager()
    return _gameManager
end




return GameManager