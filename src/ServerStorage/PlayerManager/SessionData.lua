local Session = {}
local START_VALUE = 350;

export type SessionData = typeof(new())


function new(player: Player)
    local self = setmetatable(
        {
            Leaderstats = Instance.new("Folder", player);
            Coins = Instance.new("IntValue");
            DamageDeal = Instance.new("IntValue");
        },
        {
            __index = Session
        }
    )

    self.Leaderstats.Name = "leaderstats"
    self.Coins.Value = START_VALUE
    self.Coins.Name = "Coins"
    self.Coins.Parent = self.Leaderstats
    self.DamageDeal.Parent = self.Leaderstats
    self.DamageDeal.Name = "DamageDeal"

    return self
end

function Session.Get(self: SessionData, instance: string): number
    return self[instance].Value
end

function Session.Set(self: SessionData, instance: string, Value: number): number
    self[instance].Value = Value
end

function Session.Update(self: SessionData, instance: string, Value: number, callback:(OldValue: number) -> ()?): number
    local OldValue = self[instance].Value
    self[instance].Value += Value
    if callback then
        callback(OldValue)
    end
end


return {
    new = new
}