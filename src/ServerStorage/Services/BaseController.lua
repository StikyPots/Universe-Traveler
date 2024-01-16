local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Signal = require(ReplicatedStorage.Libraries.signal)
local red = require(ReplicatedStorage.Libraries.red)
local BaseNetwork = red.Server("BaseNetwork")

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

function BaseController.Initialize(self: BaseController)
    BaseNetwork:FireAll("OnUpdateHealth", self.MaxHealth, self.MaxHealth)
end

function BaseController.TakeDamage(self: BaseController, Damage: number)
    if self.Health > 0 then
        self.Health -= Damage
        self.OnDamaged:Fire(self.Health)
        BaseNetwork:FireAll("OnUpdateHealth", self.MaxHealth, self.Health)
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