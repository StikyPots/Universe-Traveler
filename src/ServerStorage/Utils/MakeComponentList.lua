local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local Shared = ReplicatedStorage.Shared

local components = require(Shared.Components)


return function(ComponentTable: table)

    local ComponentList = {}

    for key, ComponentValue in ComponentTable do
       local Component = components(tostring(key))
       table.insert(ComponentList, Component({ [tostring(key)] = ComponentValue }))
    end


    return table.unpack(ComponentList)
end