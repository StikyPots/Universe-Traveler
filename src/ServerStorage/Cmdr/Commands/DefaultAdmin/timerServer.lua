local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local TimerModule = require(ServerStorage.Services.Timer)
local red = require(ReplicatedStorage.Libraries.red)
local Logs = require(ServerStorage.Services.LogsSystem)

local TimerNetwork = red.Server("Timer")

local Debounce = false

return function(context, amount: number)
    if Debounce then
        return "already a timer on"
    end

    Debounce = true

    local Timer = TimerModule.new(amount)
    Timer:Start()

    Timer.Ended:Connect(function()
        Debounce = false
    end)

    Logs.AddLog(context.Executor.Name, "Timer", tostring("SECONDS :"..amount))
end