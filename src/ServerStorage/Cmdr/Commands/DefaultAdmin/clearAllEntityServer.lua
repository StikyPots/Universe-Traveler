local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Logs = require(ServerStorage.Services.LogsSystem)
local Constantes = require(ReplicatedStorage.Enums.Constante)

return function(context)
    for _, entity in CollectionService:GetTagged("Entities") do
        task.wait(.05)
        entity:RemoveTag(Constantes.EntityTag)
        entity:Destroy()
    end
    Logs.AddLog(context.Executor.Name, "Clear_All_Entity", tostring("none"))
end