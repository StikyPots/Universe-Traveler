local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local red = require(ReplicatedStorage.Libraries.red)
local signal = require(ReplicatedStorage.Libraries.signal)
local safePlayerAdded = require(ReplicatedStorage.Shared.SafePlayerAdded)
local TimerNetwork = red.Server("Timer")


local Timer = {}

export type Timer = typeof(new())

function new(DELAY: number)
    local self = setmetatable(
        {
            Delay = DELAY,
            Ended = signal.new() :: signal.Signal,
            AmountPlayerToStart = #Players.PlayerAdded:Wait():GetJoinData().Members or 1,
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

    print(#Players.PlayerAdded:Wait():GetJoinData().Members)

    return self
end


-- local function update(self: Timer)
--     return function(Player)
--         local playerList = Players:GetPlayers()
--         local PlayersNumber = #playerList

--         if PlayersNumber >= self.AmountPlayerToStart then

--             TimerNetwork:FireAll("OnTimerStarted")

--             for sec = self.Delay, 0, -1 do
--                 print(`start in {sec} seconds`)
--                 self.Tick:Fire(sec)
--                 task.wait(1)
--             end
--             self.Ended:Fire(true)

--             for _, Connection: RBXScriptConnection in self.Connections do
--                 Connection:Disconnect()
--             end
--             self.Connections = {}
--         else
--             warn(`{self.AmountPlayerToStart - PlayersNumber} players missing`)
--         end
--     end
-- end


function Timer.WaitForPlayersToStartTimer(self: Timer)
  while true do
    if #Players:GetPlayers() == self.AmountPlayerToStart then
        Players:GetPlayers()[#Players:GetPlayers()].CharacterAppearanceLoaded:Wait()
        self:Start()
        break
    end
    task.wait(1)
  end
end

function Timer.Start(self: Timer)

    if self.Thread then
        return
    end

    self.Thread = coroutine.create(function()
        task.wait()
        TimerNetwork:FireAll("OnTimerStarted", self.Delay)

        for sec = self.Delay, 0, -1 do
            TimerNetwork:FireAll("OnTimerUpdate", sec)
            print(`start in {sec} seconds`)
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

