local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local red = require(ReplicatedStorage.Libraries.red)
local mapLoader = require(ServerStorage.MapLoader)
local TimerModule = require(ServerStorage.Controllers.Timer)
local SequenceController = require(ServerStorage.Controllers.WavesController.SequenceController)

local Timer = TimerModule.new(1)
local currentMap: mapLoader.mapLoader = mapLoader.new("Zombieland")
local Allowing = red.Server("allowing")
local Sequence = SequenceController.new(currentMap.settings.Waves, currentMap.settings.Entities)



Timer.Ended:Connect(function()
    currentMap:load()
    Sequence:Start()
end)


Sequence.NewWaveStarted:Connect(function()
    print("new wave")
end)


Sequence.WaveEnded:Connect(function(currentWave)
    print(`wave ended`)
end)


Sequence.SequenceEnded:Connect(function()
    print("sequence ended")
end)





