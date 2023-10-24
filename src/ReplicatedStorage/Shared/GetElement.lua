local ReplicatedStorage = game:GetService("ReplicatedStorage")
local entitiesFolder = ReplicatedStorage.entities
local TowersFolder = ReplicatedStorage.Towers


export type Entity = {
    System: string;
    Health: number;
    Speed: number;
}

function GetEntity(name): Entity
    local success, result = pcall(require, entitiesFolder:FindFirstChild(name))

    if success then
        return result
    end
end

function GetTower(name)
    local success, result = pcall(require, TowersFolder:FindFirstChild(name))

    if success then
        return result
    end
end


return {
    GetEntity = GetEntity,
    GetTower = GetTower,
}