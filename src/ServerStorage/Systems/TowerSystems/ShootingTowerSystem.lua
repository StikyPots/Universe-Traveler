local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")


local matter = require(ReplicatedStorage.Libraries.matter)
local red = require(ReplicatedStorage.Libraries.red)
local components = require(ReplicatedStorage.Shared.Components)
local FindTarget = require(ServerStorage.Controllers.TowersController.TowerUtils.FindTarget)
local DealDamage = require(ServerStorage.Controllers.TowersController.TowerUtils.DealDamage)

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

            
            print(id, Damage)

            if useThrottle(.005, id) then
                Model.PrimaryPart.CFrame = CFrame.lookAt(Model.PrimaryPart.Position, Target.PrimaryPart.Position)
            end

            if useThrottle(Delay, id) then
                DealDamage(Owner, Target, Damage)
            end

        end

        

    end
end