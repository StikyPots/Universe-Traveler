local ReplicatedStorage = game:GetService("ReplicatedStorage")
local entitiesFolder = ReplicatedStorage.entities
local TowersFolder = ReplicatedStorage.Towers


export type Entity = {
    System: string;
    Health: number;
    Speed: number;

    Animations: {
        OnSummon: string,
        Walking: string,
    }
}

export type Tower = {
    Prefix: string;
    placeAreas: {string},
    radius: {number},
    rarity: string,
    damage: {number},
    delay: {number},
    price: number,
    MaxTowerOnMap: number,
}



local function GetEntity(name)
    local success, result = pcall(require, entitiesFolder:FindFirstChild(name))

    if success then
        return result
    end
end

local function GetTower(name): Tower
    local success, result = pcall(require, TowersFolder:FindFirstChild(name))

    if success then
        return result
    end
end


return {
    GetEntity = GetEntity,
    GetTower = GetTower,
}