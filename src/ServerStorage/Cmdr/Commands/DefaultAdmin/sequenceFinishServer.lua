local ServerStorage = game:GetService("ServerStorage")
local SequenceController = require(ServerStorage.Services.WavesController.SequenceController)

return function(context)
   SequenceController.GetSequence():Finish()
end