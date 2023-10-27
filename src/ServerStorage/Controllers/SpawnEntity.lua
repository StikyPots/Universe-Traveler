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
local SystemPrefix = "%sSystem"



return function(name: string, Pos, World)

    local EntityInfo  = GetEntity(name)
    local EntityToSpawn = components("WalkingEntitySystem")
    local LoadedMap: MapLoader.MapInstance = workspace.LoadedMap

    print(string.format(SystemPrefix, EntityInfo.System))

    local Waypoints = LoadedMap.waypoints:GetChildren()
    local StartPos = LoadedMap.waypoints[Pos]
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

    World:spawn(EntityToSpawn({
        Health = EntityInfo.Health;
        Speed = EntityInfo.Speed;
        Model = Model:Clone();
        StartPos = StartPos;
        Waypoints = Waypoints;
    }))

end