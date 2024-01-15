local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Red = require(ReplicatedStorage.Libraries.red)

local TimerNetwork = Red.Client("Timer")
local PlayerGui = Players.LocalPlayer.PlayerGui
local TimerScreen: ScreenGui = PlayerGui:WaitForChild("Timer")
local TimerLabel: TextLabel = TimerScreen.Seconds



TimerNetwork:On("OnTimerStarted", function(delay)
    TimerLabel.Text = `{delay}s`
    TimerScreen.Enabled = true
end)

TimerNetwork:On("OnTimerUpdate", function(sec)
    TimerLabel.Text = `{sec}s`
    
    if not TimerScreen.Enabled then
        TimerScreen.Enabled = true
    end
end)


TimerNetwork:On("OnTimerEnded", function()
    TimerScreen.Enabled = false
end)