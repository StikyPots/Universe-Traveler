local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local red = require(ReplicatedStorage.Libraries.red)
local mapLoader = require(ServerStorage.MapLoader)
local TimerModule = require(ServerStorage.Controllers.Timer)
local SequenceController = require(ServerStorage.Controllers.WavesController.SequenceController)

local PreloadTimer = TimerModule.new(35, 1)
local StartTimer = TimerModule.new(10)
local currentMap: mapLoader.mapLoader = mapLoader.new("Zombieland")
local Sequence = SequenceController.new(currentMap.settings.Waves, currentMap.settings.Entities)
local TimerNetwork = red.Server("Timer")


PreloadTimer:startOnPlayerAdded()

PreloadTimer.Tick:Connect(function(seconds)
    TimerNetwork:FireAll("OnTimerUpdate", seconds)
end)

PreloadTimer.Ended:Connect(function()


    currentMap:load(function(MapFolder)
        local TeleportPosPivot = MapFolder.TeleportPos:GetPivot()

        for _, player in Players:GetPlayers() do
            player.Character:PivotTo(TeleportPosPivot)
        end
    end)

    TimerNetwork:FireAll("OnTimerEnded")
    StartTimer:Start()
end)

StartTimer.Tick:Connect(function(seconds)
    TimerNetwork:FireAll("OnTimerUpdate", seconds)
end)

StartTimer.Ended:Connect(function(seconds)
    TimerNetwork:FireAll("OnTimerEnded")
    Sequence:Start()
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







