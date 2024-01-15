local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local red = require(ReplicatedStorage.Libraries.red)
local mapLoader = require(ServerStorage.MapLoader)
local TimerModule = require(ServerStorage.Services.Timer)
local SequenceController = require(ServerStorage.Services.WavesController.SequenceController)
local Constante = require(ReplicatedStorage.Enums.Constante)
local ServerManager = require(ServerStorage.Services.ServerManager)




local Server = ServerManager:StartServerOnOnePlayerJoining()