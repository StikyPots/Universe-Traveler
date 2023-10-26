local replicatedStorage = game:GetService("ReplicatedStorage")
local serverStorage = game:GetService("ServerStorage")

local matter = require(replicatedStorage.Libraries.matter)
local red = require(replicatedStorage.Libraries.red)
local components = require(replicatedStorage.Shared.Components)
local SummonEntitySystem = components("SummonEntitySystem")
local SpawnEntityController = require(serverStorage.Controllers.SpawnEntity)

local AnimationNetwork = red.Server("AnimationNetwork")

return function(world: matter.World)
    for id, entity in world:query(SummonEntitySystem) do
        

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
                AnimationNetwork:FireAll("OnSummon", Model.Name, Humanoid)
                SpawnEntityController("Zombie", i, world)
            end
            Model:Destroy()
            Model:RemoveTag("Entities")
        end)
    end
end


