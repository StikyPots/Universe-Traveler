local ServerStorage = game:GetService("ServerStorage")

local MapModels: Folder = ServerStorage.MapsModels
local super = {}

export type mapLoader = typeof(new())

export type MapInstance  = {
    Entities: Folder,
    Towers: Folder,
    Models: Folder,
    Roads: Folder,
    waypoints: Folder,
    Placable: Folder,
    TeleportPos: Part;
    StartPos: Part;
}

type settings = {
    Waves: number;
    Entities: {string};
}

local CurrentMap = nil

local function GetSettings(name)
    local success, result = pcall(require, ServerStorage.Maps:FindFirstChild(name))

    if success then
        return result
    end
end

function new(name: string)
    local self = setmetatable(
        {
            name = name;
            Settings = GetSettings(name) :: settings;
        }, 
        {
            __index = super
        }
        )


    CurrentMap = self
    return self
end

function super.load(self:mapLoader)

    local LoadedMap: MapInstance = workspace.LoadedMap
    local MapToLoad: Folder = MapModels:FindFirstChild(self.name)

    if not MapToLoad then
        error(`the map {self.name} doesn't exsit at location {MapModels.Name}`)
        return
    end

    for _, element: Folder in MapToLoad:GetChildren() do
        task.wait(0.05)
        element:Clone()
        element.Parent = LoadedMap
    end
end


function super.TeleportPlayers(self: mapLoader, Players: {Player})
    local LoadedMap: MapInstance = workspace.LoadedMap

    for _, Player: Player in Players do
        Player.Character:PivotTo(LoadedMap.TeleportPos:GetPivot())
    end

    print("all players have been teleported")
end

function GetCurrentMap(): mapLoader
    return CurrentMap
end


return {
    new = new,
    GetCurrentMap = GetCurrentMap,
}
