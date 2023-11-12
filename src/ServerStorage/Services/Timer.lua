local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local red = require(ReplicatedStorage.Libraries.red)
local signal = require(ReplicatedStorage.Libraries.signal)
local TimerNetwork = red.Server("Timer")


local Timer = {}

export type Timer = typeof(new())

function new(DELAY: number, AmountPlayerToStart: number?)
    local self = setmetatable(
        {
            Delay = DELAY,
            Ended = signal.new() :: signal.Signal,
            AmountPlayerToStart = AmountPlayerToStart,
            Tick = signal.new() :: signal.Signal,
            Skipped = false,
            BooleanPause = false,
            Thread = nil,
            Connections = {},
        },
        {
            __index = Timer
        }
    )

    return self
end


local function update(self: Timer)
    return function(Player)
        local playerList = Players:GetPlayers()
        local PlayersNumber = #playerList

        if PlayersNumber >= self.AmountPlayerToStart then

            TimerNetwork:FireAll("OnTimerStarted")

           task.defer(function()
                for sec = self.Delay, 0, -1 do
                print(`start in {sec} seconds`)
                    self.Tick:Fire(sec)
                    task.wait(1)
                end
                self.Ended:Fire(true)
           end)

            for _, Connection: RBXScriptConnection in self.Connections do
                Connection:Disconnect()
            end
            self.Connections = {}
        else
            warn(`{self.AmountPlayerToStart - PlayersNumber} players missing`)
        end
    end
end


function Timer.startOnPlayerAdded(self: Timer)
    self.Connections.OnPlayerAdded = Players.PlayerAdded:Connect(update(self))
    self.Connections.OnPlayerRemoving = Players.PlayerRemoving:Connect(update(self))
end

function Timer.Start(self: Timer)

    if self.Thread then
        return
    end

    self.Thread = coroutine.create(function()
        TimerNetwork:FireAll("OnTimerStarted", self.Delay)

        for sec = self.Delay, 0, -1 do
            TimerNetwork:FireAll("OnTimerUpdate", sec)
            self.Tick:Fire(sec)

            if self.Skipped then
                break
            end

            if self.BooleanPause then
                coroutine.yield()
            end

            task.wait(1)
        end
        
        TimerNetwork:FireAll("OnTimerEnded")
        self.Ended:Fire(true)
    end)

    print(self.Thread)
    coroutine.resume(self.Thread)

end

function Timer.Stop(self: Timer)
    self.Skipped = true
    coroutine.close(self.Thread)
end

function Timer.Pause(self: Timer)
    self.BooleanPause = true
    print('timer has been paused')
end

function Timer.Resume(self: Timer)
    self.BooleanPause = false
    coroutine.resume(self.Thread)
end

return {
    new = new
}
