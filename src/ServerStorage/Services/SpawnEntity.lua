local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Shared = ReplicatedStorage.Shared

local components = require(Shared.Components)
local Start = require(Shared.Start)
local matter = require(ReplicatedStorage.Libraries.matter)
local GetEntity = require(Shared.GetElement).GetEntity
local MapLoader = require(ServerStorage.MapLoader)

local Assets: Folder = ReplicatedStorage.Assets
local World: matter.World = require(ServerStorage.World)
local SystemsFolder = ServerStorage.Systems.EntitiesSystems
local MakeComponentList = require(ServerStorage.Utils.MakeComponentList)



return function(name: string, Pos)
    local EntityInfo  = GetEntity(name)
    local Map: MapLoader.MapInstance = workspace.Map
    local Waypoints = Map.waypoints:GetChildren()
    local StartPos = Map.waypoints[Pos]
    local Model = Assets.Entities:FindFirstChild(name)




    table.sort(Waypoints, function(a, b)
        return tonumber(a.Name) < tonumber(b.Name)
    end)


    local temporaryTable = table.pack(select(Pos, table.unpack(Waypoints)))
    Waypoints = temporaryTable

    print(Waypoints)

    table.sort(Waypoints, function(a, b)
        return tonumber(a.Name) < tonumber(b.Name)
    end)

    if not Model then
        error(`{name} not found`)
        return
    end


    EntityInfo.ComponentsList["SpawningData"] = {Waypoints = Waypoints, StartPos = StartPos}
    EntityInfo.ComponentsList.EntityData["Model"] = Model:Clone()

    World:spawn(MakeComponentList(EntityInfo.ComponentsList))
end