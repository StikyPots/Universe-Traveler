local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local red = require(ReplicatedStorage.Libraries.red)
local mapLoader = require(ServerStorage.MapLoader)
local TimerModule = require(ServerStorage.Services.Timer)
local SequenceController = require(ServerStorage.Services.WavesController.SequenceController)
local Constante = require(ReplicatedStorage.Enums.Constante)


local currentMap: mapLoader.mapLoader = mapLoader.new("Zombieland")
local Sequence = SequenceController.new(currentMap.Settings.Waves, currentMap.Settings.Entities)


local PreloadTimer = TimerModule.new(Constante.PreloadTime, 0)
local StartTimer = TimerModule.new(Constante.StartTime)

PreloadTimer:startOnPlayerAdded()


PreloadTimer.Ended:Connect(function()
    currentMap:load()
    StartTimer:Start()
    currentMap:TeleportPlayers(Players:GetPlayers())
end)


StartTimer.Ended:Connect(function()
    Sequence:Start()
end)


print(SequenceController.GetSequence())





