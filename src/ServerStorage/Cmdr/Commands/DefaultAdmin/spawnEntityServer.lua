local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")



local Shared = ReplicatedStorage.Shared
local matter = require(ReplicatedStorage.Libraries.matter)
local GetEntity = require(Shared.GetElement).GetEntity
local MapLoader = require(ServerStorage.MapLoader)
local MakeComponentList = require(ServerStorage.Utils.MakeComponentList)


local Assets: Folder = ReplicatedStorage.Assets
local World: matter.World = require(ServerStorage.World)


return function(Context, name: string, amount: number)


    local EntityInfo  = GetEntity(name)
    local Map: MapLoader.MapInstance = workspace.Map
    local StartPos = Map.StartPos
    local Waypoints = Map.waypoints:GetChildren()
    local Model = Assets.Entities:FindFirstChild(name)


    if not Model then
        error(`{name} not found`)
        return
    end

    table.sort(Waypoints, function(a, b)
        return tonumber(a.Name) < tonumber(b.Name)
    end)

    EntityInfo.ComponentsList["SpawningData"] = {Waypoints = Waypoints, StartPos = StartPos}

    for i=1, amount do
        task.wait(0.5)
        EntityInfo.ComponentsList.EntityData["Model"] = Model:Clone()
        World:spawn(MakeComponentList(EntityInfo.ComponentsList))
    end
end
