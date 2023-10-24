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
    StartPos: Part
}

type settings = {
    Waves: number;
    Entities: {string};
}

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
            settings = GetSettings(name) :: settings;
        }, 
        {
            __index = super
        }
        )
    return self
end

function super.load(self:mapLoader ,callback: (mapFolder: MapInstance) -> ())

    local LoadedMap: MapInstance = workspace.LoadedMap
    local MapToLoad: Folder = MapModels:FindFirstChild(self.name)

    if not MapToLoad then
        error(`the map {self.name} doesn't exsit at location {MapModels.Name}`)
        return
    end

    for _, element: Folder in MapToLoad:GetChildren() do
        element:Clone()
        element.Parent = LoadedMap
    end

    if callback then
        callback(LoadedMap)
    end
end



return {
    new = new
}