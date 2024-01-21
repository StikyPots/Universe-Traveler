local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Red = require(ReplicatedStorage.Libraries.red)

local TimerNetwork = Red.Client("Timer")
local PlayerGui = Players.LocalPlayer.PlayerGui
local Topbar: ScreenGui = PlayerGui:WaitForChild("Topbar")
local TimerLabel: TextLabel = Topbar.Seconds



TimerNetwork:On("OnTimerStarted", function(delay)
    TimerLabel.Text = `{delay}s`
    TimerLabel.Visible = true
end)

TimerNetwork:On("OnTimerUpdate", function(sec)
    TimerLabel.Text = `{sec}s`
    
    if not TimerLabel.Visible then
        Topbar.Visible = true
    end
end)


TimerNetwork:On("OnTimerEnded", function()
    TimerLabel.Visible = false
end)