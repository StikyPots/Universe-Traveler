local ReplicatedStorage = game:GetService("ReplicatedStorage")
local readonlyTable = require(ReplicatedStorage.Shared.MakeReadOnly)
local EnumsFolder = ReplicatedStorage.Enums



return function(EnumName: string, EnumType: string)
    local success, module = pcall(require, EnumsFolder:FindFirstChild(EnumName))

    type temporary = typeof(module[EnumType])

    if not success then
        return nil
    end

    return module[EnumType]
end