local replicatedStorage = game:GetService("ReplicatedStorage")
local serverStorage = game:GetService("ServerStorage")

local matter = require(replicatedStorage.Libraries.matter)
local components = require(replicatedStorage.Shared.Components)

local WalkingEntitySystem = components("WalkingEntitySystem")

return function(world: matter.World)
    for id, entity in world:query(WalkingEntitySystem) do
        
        print(id, entity)

        local Model:Model = entity.Model;
        local Speed: number = entity.Speed;
        local health: number = entity.Health;
        local StartPos: Part = entity.StartPos;
        local Waypoints: number = entity.Waypoints;

        local Humanoid: Humanoid = Model:FindFirstChild("Humanoid")
        
        --// Set Entity Bahavior

        Humanoid.WalkSpeed = Speed
        Humanoid.MaxHealth = health
        Humanoid.Health = health
        Model.Parent = workspace.LoadedMap.Entities
        Model:PivotTo(StartPos:GetPivot())
        Model.HumanoidRootPart:SetNetworkOwner(nil)
        Model:AddTag("Entities")
        world:despawn(id)

        --// Moving Entity

        task.defer(function()
            for i=1, #Waypoints do
                Humanoid:MoveTo(Waypoints[i].Position)
                Humanoid.MoveToFinished:Wait()
            end
            Model:Destroy()
        end)
    end
end


