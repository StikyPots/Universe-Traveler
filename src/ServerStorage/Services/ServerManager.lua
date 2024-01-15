local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local ServerStorage = game:GetService("ServerStorage")


local SequenceController = require(ServerStorage.Services.WavesController.SequenceController)
local mapLoader = require(ServerStorage.MapLoader)
local Constante = require(ReplicatedStorage.Enums.Constante)


local Server = {}
local _server = nil

export type ServerManager = typeof(Server.new())


function Server.new(FirstPlayerToJoin: Player)
    local self = setmetatable({}, {__index = Server})


    self.FirstPlayerToJoin = FirstPlayerToJoin
    self.TeleportData = 
    if not RunService:IsStudio() then self.FirstPlayerToJoin:GetJoinData().TeleportData else Constante.DefaultTeleportData


    if _server == nil then
        _server = self
    else
        error("Cannot create sevreal server", 1)
    end

    return self
end

--Static Methods

--Yield the current thread until a player Join and create a server instance. return a Server Instance
function Server.StartServerOnOnePlayerJoining(): ServerManager
    local playerJoined = Players.PlayerAdded:Wait() 
    return Server.new(playerJoined)
end


function Server.GetServer()
    return _server
end

--// Methods



function Server.CreateSequenceAndMapWithTeleportData(self: ServerManager)

    local currentMap = mapLoader.new(self:GetTeleportData().Map)


    local Sequence = SequenceController.new(
        currentMap.Settings.Waves, 
        currentMap.Settings.Entities,
        self:GetTeleportData().Difficulty
    )

    return Sequence, currentMap
end

function Server.GetTeleportData(self: ServerManager)
    return self.TeleportData
end











return Server