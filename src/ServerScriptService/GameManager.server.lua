local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local red = require(ReplicatedStorage.Libraries.red)
local mapLoader = require(ServerStorage.MapLoader)
local TimerModule = require(ServerStorage.Services.Timer)
local SequenceController = require(ServerStorage.Services.WavesController.SequenceController)
local Constante = require(ReplicatedStorage.Enums.Constante)

local BaseModule = require(ServerStorage.Services.BaseController)




local currentMap: mapLoader.mapLoader = mapLoader.new("Zombieland")
local Sequence = SequenceController.new(currentMap.Settings.Waves, currentMap.Settings.Entities)
local CurrentBase = BaseModule.new(Constante.BaseHealth.Hard)


local IsBaseDestoyed = false

local PreloadTimer = TimerModule.new(Constante.PreloadTime, 1)
local StartTimer = TimerModule.new(Constante.StartTime)
local EndGameNetwork = red.Server("EndGameNetwork")

PreloadTimer:startOnPlayerAdded()


PreloadTimer.Ended:Connect(function()
    currentMap:load()
    StartTimer:Start()
    currentMap:TeleportPlayers(Players:GetPlayers())
end)




StartTimer.Ended:Connect(function()
    Sequence:Start()
end)


Sequence.SequenceEnded:Connect(function()

end)

CurrentBase.OnDestroyed:Connect(function()
    IsBaseDestoyed = true
    Sequence:Finish()
    print("destroyed")
end)

CurrentBase.OnDamaged:Connect(function(CurrentHealth: number)
    print(CurrentHealth)
end)




