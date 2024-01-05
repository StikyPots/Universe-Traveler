local HttpService = game:GetService("HttpService")
local ServerStorage = game:GetService("ServerStorage")
local SequenceController = require(ServerStorage.Services.WavesController.SequenceController)

local MapLoader = require(ServerStorage.MapLoader)

return function(context)
    return HttpService:JSONEncode(SequenceController.GetSequence())
end