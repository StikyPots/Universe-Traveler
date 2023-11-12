local CollectionService = game:GetService("CollectionService")
local ServerStorage = game:GetService("ServerStorage")
local Logs = require(ServerStorage.Services.LogsSystem)

return function(context)
    for _, entity in CollectionService:GetTagged("Entities") do
        task.wait(.05)
        entity:RemoveTag("Entities")
        entity:Destroy()
    end
    Logs.AddLog(context.Executor.Name, "Clear_All_Entity", tostring("none"))
end