local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local red = require(ReplicatedStorage.Libraries.red)
local signal = require(ReplicatedStorage.Libraries.signal)
local TimerNetwork = red.Server("Timer")


local super = {}

export type Timer = typeof(new())

function new(DELAY: number, AmountPlayerToStart: number?)
    local self = setmetatable(
        {
            Delay = DELAY;
            Ended = signal.new() :: signal.Signal;
            AmountPlayerToStart = AmountPlayerToStart,
            Tick = signal.new() :: signal.Signal;
            Skipped = false;
            Connections = {};
        },
        {
            __index = super
        }
    )

    return self
end


function super.startOnPlayerAdded(self: Timer)
    playerList = Players:GetPlayers()

    local function update()
        playerList = Players:GetPlayers()
        local PlayersNumber = #playerList

        if PlayersNumber >= self.AmountPlayerToStart then

            TimerNetwork:FireAll("OnTimerStarted")


            task.defer(function()
                for sec = self.Delay, 0, -1 do
                    task.wait(1)
                   print(`start in {sec} seconds`)
                    self.Tick:Fire(sec)
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

    self.Connections.OnPlayerAdded = Players.PlayerAdded:Connect(update)
    self.Connections.OnPlayerRemoving = Players.PlayerRemoving:Connect(update)
end

function super.Start(self: Timer)

    task.defer(function()
        TimerNetwork:FireAll("OnTimerStarted")

        for sec = self.Delay, 0, -1 do

            task.wait(1)
            self.Tick:Fire(sec)

            if self.Skipped then
                break
            end
        end
        
        self.Ended:Fire(true)
    end)
end

function super.Stop(self: Timer)
    self.Skipped = true
end

return {
    new = new
}