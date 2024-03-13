local LocalizationService = game:GetService("LocalizationService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")


local matter = require(ReplicatedStorage.Libraries.matter)
local red = require(ReplicatedStorage.Libraries.red)
local components = require(ReplicatedStorage.Shared.Components)
local Constantes = require(ReplicatedStorage.Enums.Constante)



local CanSommonComponent = components("CanSommon")
local EntityDataComponent = components("EntityData")
local SpawningDataComponent = components("SpawningData")
local CanWalkComponent = components("CanWalk")
local CanFlyComponent = components("CanFly")


local SpawnEntityController = require(ServerStorage.Services.SpawnEntity)






local useThrottle = matter.useThrottle
local Base = require(ServerStorage.Services.BaseController).GetCurrentBase()



return function (World: matter.World)
    for id, EntityDataValue, SpawningDataValue in World:query(EntityDataComponent, SpawningDataComponent, CanSommonComponent):without(CanWalkComponent, CanFlyComponent) do

        local EntityData = EntityDataValue.EntityData
        local SpawningData = SpawningDataValue.SpawningData

        local Model:Model = EntityData.Model;
        local Speed: number = EntityData.Speed;
        local health: number = EntityData.Health;
        local StartPos: Part = SpawningData.StartPos;
        local Waypoints: number = SpawningData.Waypoints;


        local Humanoid: Humanoid = Model:FindFirstChild("Humanoid")

        Humanoid.WalkSpeed = Speed
        Humanoid.MaxHealth = health
        Humanoid.Health = health
        Model.Parent = workspace.Map.Entities
        Model:PivotTo(StartPos:GetPivot())
        Model.HumanoidRootPart:SetNetworkOwner(nil)
        Model:AddTag(Constantes.EntityTag)
        World:despawn(id)


        task.defer(function()
            for i=1, #Waypoints do
                local Waypoint: Part = Waypoints[i]
                Humanoid:MoveTo(Waypoint.Position, Waypoint)
                Humanoid.MoveToFinished:Wait()
                Model:SetAttribute("OnSummon", i)
                SpawnEntityController(EntityData.EntityToSpawn, i)
            end
            Base:TakeDamage(Humanoid.Health)
            Model:Destroy()
            Model:RemoveTag(Constantes.EntityTag)
        end)

    end
end