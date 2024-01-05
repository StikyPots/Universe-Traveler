local LocalizationService = game:GetService("LocalizationService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")


local matter = require(ReplicatedStorage.Libraries.matter)
local red = require(ReplicatedStorage.Libraries.red)
local components = require(ReplicatedStorage.Shared.Components)
local FindTarget = require(ServerStorage.Services.TowersController.TowerUtils.FindTarget)
local DealDamage = require(ServerStorage.Services.TowersController.TowerUtils.DealDamage)
local RotateTower = require(ServerStorage.Services.TowersController.TowerUtils.RotateTower)

local ShootingTowerSystem = components("ShootingTowerSystem")
local useThrottle = matter.useThrottle


return function (World: matter.World)
    for id, entity in World:query(ShootingTowerSystem) do


        local Model: Model = entity.Model;
        local Radius = entity.Radius;
        local Delay = entity.Delay;
        local Damage = entity.Damage;
        local Owner = entity.Owner;

        local Target: Model = FindTarget(Model, Radius)


        if Target then

            RotateTower(Model, Target)

            if useThrottle(Delay, id) then
                DealDamage(Owner, Target, Damage)
            end

        end
    end
end