local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Signal = require(ReplicatedStorage.Libraries.signal)

local BaseController = {}
local CurrentBase = nil

export type BaseController = typeof(new())

function new(MaxHealth: number)
    local self = setmetatable(
        {
            MaxHealth = MaxHealth;
            Health = MaxHealth;

            OnDamaged = Signal.new() :: Signal.Signal;
            OnDestroyed = Signal.new() :: Signal.Signal;
        },
        {
            __index = BaseController
        }
    )

    CurrentBase = self
    return self
end

function BaseController.TakeDamage(self: BaseController, Damage: number)
    if self.Health > 0 then
        self.Health -= Damage
        self.OnDamaged:Fire(Damage)
    else
        self.OnDestroyed:Fire()
    end
end

function GetCurrentBase()
    return CurrentBase
end

return {
    new = new,
    GetCurrentBase = GetCurrentBase,
}