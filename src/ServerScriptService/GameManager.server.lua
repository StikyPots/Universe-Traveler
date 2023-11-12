local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local red = require(ReplicatedStorage.Libraries.red)
local mapLoader = require(ServerStorage.MapLoader)
local TimerModule = require(ServerStorage.Services.Timer)
local SequenceController = require(ServerStorage.Services.WavesController.SequenceController)

local PreloadTimer = TimerModule.new(2, 0)
local StartTimer = TimerModule.new(5)
local currentMap: mapLoader.mapLoader = mapLoader.new("Zombieland")
local Sequence = SequenceController.new(currentMap.settings.Waves, currentMap.settings.Entities)
local TimerNetwork = red.Server("Timer")


PreloadTimer:startOnPlayerAdded()


PreloadTimer.Ended:Connect(function()

    currentMap:load(function(MapFolder)
        local TeleportPosPivot = MapFolder.TeleportPos:GetPivot()

        for _, player in Players:GetPlayers() do
            player.Character:PivotTo(TeleportPosPivot)
        end
    end)
    
end)


StartTimer.Ended:Connect(function()
    Sequence:Start()
end)

StartTimer.Tick:Connect(function()
    
end)

Sequence.NewWaveStarted:Connect(function(WaveStarted)
    print(` wave {WaveStarted}`)
end)


Sequence.WaveEnded:Connect(function(WaveEnded)
    print(`wave {WaveEnded} ended`)
end)


Sequence.SequenceEnded:Connect(function()
    print("sequence ended")
end)







