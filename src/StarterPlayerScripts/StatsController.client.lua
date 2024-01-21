local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local red = require(ReplicatedStorage.Libraries.red)

local local_player = Players.LocalPlayer
local GameStatsNetwork = red.Client("GameStatsNetwork")


local Topbar = local_player.PlayerGui:WaitForChild("Topbar")

local WaveTextLabel = Topbar.Wave

GameStatsNetwork:On("WaveStarted", function(w: number)
    WaveTextLabel.Text = string.upper("wave "..w)
end)