local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local red = require(ReplicatedStorage.Libraries.red)
local TimerModule = require(ServerStorage.Services.Timer)
local Constante = require(ReplicatedStorage.Enums.Constante)
local GameManagerModule = require(ServerStorage.Services.GameManager)





local GameManager = GameManagerModule.new()
local Sequence: GameManagerModule.Sequence, Map: GameManagerModule.Map = GameManager:CreateSequenceAndMap()


local PreloadTimer = TimerModule.new(Constante.PreloadTime, GameManager.ServerData.PlayerNumbers)
local StartTimer = TimerModule.new(Constante.StartTime)

local EndGameNetwork = red.Server("EndGameNetwork")
local GameStatsNetwork = red.Server("GameStatsNetwork")

--wait the current thread to wait players
Map:load()
PreloadTimer:WaitForPlayersToStartTimer()



PreloadTimer.Ended:Connect(function()
    Map:TeleportPlayers(Players:GetPlayers())
    StartTimer:Start()
end)



StartTimer.Ended:Connect(function()
    Sequence:Start()
end)


Sequence.NewWaveStarted:Connect(function(w)
    GameStatsNetwork:FireAll("WaveStarted", w)
end)



Sequence.Base.OnDestroyed:Connect(function()
    Sequence:Finish()
    for _, p in Players:GetPlayers() do
        p:Kick("lose")
    end
end)