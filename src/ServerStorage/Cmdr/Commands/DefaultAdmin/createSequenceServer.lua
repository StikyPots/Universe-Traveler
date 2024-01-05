local ServerStorage = game:GetService("ServerStorage")
local SequenceController = require(ServerStorage.Services.WavesController.SequenceController)

local MapLoader = require(ServerStorage.MapLoader)

return function(context)


    local succes, result = pcall(SequenceController.new, MapLoader.GetCurrentMap().Settings.Waves, MapLoader.GetCurrentMap().Settings.Entities)
    
    if not succes then
        return result
    end

    result:Start()

    return "the sequence has been successfully created"
end