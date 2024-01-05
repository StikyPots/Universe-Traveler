local ServerStorage = game:GetService("ServerStorage")
local SequenceController = require(ServerStorage.Services.WavesController.SequenceController)

return function(context)
    if SequenceController.GetSequence() == nil then
        return "there is no sequence currently"
    end

   SequenceController.GetSequence():skip()
end