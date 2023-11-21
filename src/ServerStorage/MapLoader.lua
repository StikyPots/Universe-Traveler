local ServerStorage = game:GetService("ServerStorage")

local MapModels: Folder = ServerStorage.MapsModels
local sequenceService = require(ServerStorage.Services.WavesController.SequenceController)
local super = {}

export type mapLoader = typeof(new())
type Sequence = typeof(sequenceService.new())

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
            Sequence = nil;
        }, 
        {
            __index = super
        }
        )

        self.Sequence = sequenceService.new(self.settings.Waves, self.settings.Entities)


    return self
end

function super.load(self:mapLoader)

    local LoadedMap: MapInstance = workspace.LoadedMap
    local MapToLoad: Folder = MapModels:FindFirstChild(self.name)

    for _, Element: Instance in MapToLoad do
        local E = Element:Clone()
        E.Parent = LoadedMap
        task.wait(.005)
    end
end

function super.telepotPlayerToMap(playerList: {Player})

    for _, player: Player in playerList do
        local character = player.Character
        character:PivotTo(workspace.LoadedMap.TeleportPos:GetPivot())
    end
    print(playerList .. "have been teleported")
end



return {
    new = new
}