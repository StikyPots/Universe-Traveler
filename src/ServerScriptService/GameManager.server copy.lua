local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local red = require(ReplicatedStorage.Libraries.red)
local mapLoader = require(ServerStorage.MapLoader)
local TimerModule = require(ServerStorage.Services.Timer)
local SequenceController = require(ServerStorage.Services.WavesController.SequenceController)
local Constante = require(ReplicatedStorage.Enums.Constante)



local currentMap: mapLoader.mapLoader = mapLoader.new("Zombieland")
local Sequence = SequenceController.new(currentMap.Settings.Waves, currentMap.Settings.Entities, {Map = "Zombieland", Difficulty = "Normal"})


local IsBaseDestoyed = false

local PreloadTimer = TimerModule.new(Constante.PreloadTime, 1)
local StartTimer = TimerModule.new(Constante.StartTime)

local EndGameNetwork = red.Server("EndGameNetwork")
local GameStatsNetwork = red.Server("GameStatsNetwork")




PreloadTimer:startOnPlayerAdded()


PreloadTimer.Ended:Connect(function()
    currentMap:load()
    StartTimer:Start()
    currentMap:TeleportPlayers(Players:GetPlayers())
end)




StartTimer.Ended:Connect(function()
    Sequence:Start()
end)



Sequence.NewWaveStarted:Connect(function(w)
    GameStatsNetwork:FireAll("WaveStarted", w)
end)



Sequence.Base.OnDestroyed:Connect(function()
    Sequence:Finish()
    print("destroyed")
end)

Sequence.Base.OnDamaged:Connect(function(CurrentHealth: number)
    print(CurrentHealth)
end)




