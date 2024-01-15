local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local red = require(ReplicatedStorage.Libraries.red)

local local_player = Players.LocalPlayer
local GameStatsNetwork = red.Client("GameStatsNetwork")


local StatsScreen = local_player.PlayerGui:WaitForChild("Stats")

local WaveTextLabel = StatsScreen.Wave

GameStatsNetwork:On("WaveStarted", function(w: number)
    WaveTextLabel.Text = string.upper("wave "..w)
end) 