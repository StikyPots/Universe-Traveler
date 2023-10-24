local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local signal = require(ReplicatedStorage.Libraries.signal)

local DELAY = 0 --// in seconds
local super = {}

export type Timer = typeof(new())

function new(AmountPlayerToStart: number)
    local self = setmetatable(
        {
            Delay = DELAY;
            Ended = signal.new();
            AmountPlayerToStart = AmountPlayerToStart,
            Connections = {};
        },
        {
            __index = super
        }
    )
    self:start()
    return self
end


function super.start(self: Timer)
    playerList = Players:GetPlayers()

    local function update()
        playerList = Players:GetPlayers()
        local PlayersNumber = #playerList

        if PlayersNumber >= self.AmountPlayerToStart then
            for i = self.Delay, 0, -1 do
                task.wait(1)
                print(`start in {i} seconds`)
            end
            
            self.Ended:Fire()

            for _, Connection: RBXScriptConnection in self.Connections do
                Connection:Disconnect()
            end
            self.Connections = {}
        else
            print(`{self.AmountPlayerToStart - PlayersNumber} players missing`)
        end

    end

    self.Connections.OnPlayerAdded = Players.PlayerAdded:Connect(update)
    self.Connections.OnPlayerRemoving = Players.PlayerRemoving:Connect(update)
end

return {
    new = new
}