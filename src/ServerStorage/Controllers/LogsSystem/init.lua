local Requests = require(script.Request)
local Logs = {}

local Colors = {"yellow", "purple", "blue", "red"}

function Logs.AddLog(Username: string, commandName: string, desc: string)
    local CurrentTime = DateTime.now():ToIsoDate()
    local Cards = Requests.CreateCard(commandName, desc, CurrentTime)
    Requests.AddLabelToCard(Cards.id, Username, "blue")
end


return Logs