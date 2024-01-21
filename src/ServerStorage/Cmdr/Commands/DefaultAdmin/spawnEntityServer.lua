local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Shared = ReplicatedStorage.Shared

local components = require(Shared.Components)
local Start = require(Shared.Start)
local matter = require(ReplicatedStorage.Libraries.matter)
local GetEntity = require(Shared.GetElement).GetEntity
local MapLoader = require(ServerStorage.MapLoader)
local Logs = require(ServerStorage.Services.LogsSystem)

local Assets: Folder = ReplicatedStorage.Assets
local World: matter.World = require(ServerStorage.World)
local SystemsFolder = ServerStorage.Systems.EntitiesSystems
local SystemPrefix = "%sSystem"

return function(context, Entity: string, amount: number)
    local EntityInfo  = GetEntity(Entity)
    local EntityToSpawn = components(string.format(SystemPrefix, EntityInfo.System))
    local Map: MapLoader.MapInstance = workspace.Map

    print(string.format(SystemPrefix, EntityInfo.System))

    local StartPos = Map.StartPos
    local Waypoints = Map.waypoints:GetChildren()
    local Model = Assets.Entities:FindFirstChild(Entity)

    if not Model then
        error(`{Entity} not found`)
        return
    end

    table.sort(Waypoints, function(a, b)
        return tonumber(a.Name) < tonumber(b.Name)
    end)

    for i=1, amount do
        task.wait(0.5)
        World:spawn(EntityToSpawn({
            Health = EntityInfo.Health;
            Speed = EntityInfo.Speed;
            Model = Model:Clone();
            StartPos = StartPos;
            Waypoints = Waypoints;
        }))
    end

    Logs.AddLog(context.Executor.Name, "Spawn_Entity", Entity .. ": " .. tostring(amount))
end