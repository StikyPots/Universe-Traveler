local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local SuphisDatastore = require(ServerStorage.Libraries.datastore)
local Signal = require(ReplicatedStorage.Libraries.signal)
local Red = require(ReplicatedStorage.Libraries.red)
local DatastoreTemplates = require(script.Parent.Template)
local SessionData = require(script.Parent.SessionData)

local MAX_TOWERS = 5
local userdata_key = "%i_userdata"
local equipTower_key = "%i_equipTowers"

local super = {}
local _Players = {}

export type IPlayer = typeof(new())

function new(player: Player)
    local KeyUserdata =  string.format(userdata_key, player.UserId)
    local KeyEquipTowers = string.format(equipTower_key, player.UserId)

    local self = setmetatable(
        {
            
            Player = player :: Player;
            Userdata = SuphisDatastore.new("Userdata",  KeyUserdata) :: SuphisDatastore.DataStore;
            EquipTowers = SuphisDatastore.new("EquipTowers", KeyEquipTowers) :: SuphisDatastore.DataStore;
            SessionData = SessionData.new(player) :: SessionData.SessionData;

            --// Event Interactions

            OnLevelUp = Signal.new() :: Signal.Signal
        },
        {
            __index = super
        }
    )
    --// opening datastore

    self.Userdata:Open(DatastoreTemplates.UserdataTemplate)
    self.EquipTowers:Open(DatastoreTemplates.EquipTowers)

    

    _Players[player.UserId] = self

    return self
end

function super.Get(self: IPlayer, Instance: string): number
    return self.Userdata.Value[Instance]
end

function super.Set(self: IPlayer, Instance: string, Value: number | {})
    local ignore = {"Chests", "Towers", "Experience"}
     
    if Instance == "Level" then
        self.Userdata.Value.Experience = 0
    end

    if table.find(ignore, Instance) then
        error(`not allowed to set this instance {Instance}`)
        return
    end

    self.Userdata.Value[Instance] = Value
end

function super.Update(self: IPlayer, Instance: string, Value: number, callback: (OldValue: number) -> ()?)
    local ignore = {"Chests", "Towers", "Experience"}
    
    if table.find(ignore, Instance) then
        error(`not allowed to update this instance {Instance}`)
        return
    end

    if Instance == "Level" then
        self.Userdata.Value.Experience = 0
    end

    local OldValue = self.Userdata.Value[Instance]


    if callback then
        callback(OldValue)
    end

    self.Userdata.Value[Instance] += Value
end

function super.UpdateExperience(self: IPlayer, Value: number)
    local Experience = self:Get("Experience")
    local Level = self:Get("Experience")
    local Base = 100 * (Level * 1.5)

    self.Userdata.Value.Experience += Value

    if Experience >= Base then
        self:Update("Level", 1)
        self.OnLevelUp:Fire(self:Get("Experience"))
    end
end

function super.CloseDatastore(self: IPlayer)
    self.EquipTowers:Close()
    self.Userdata:Close()
end

function super.EquipTower(self: IPlayer, Tower: string, TowerStats: {Name: string, Experience: number, Level: number})
    local TowersDatastore = self.EquipTowers.Value
    
    if #TowersDatastore > MAX_TOWERS then
        table.remove(self.EquipTowers.Value, MAX_TOWERS)
    end

    self.EquipTowers.Value[Tower] = TowerStats
end


function super.HasTower(self: IPlayer, TowerName: string): boolean
    return self.EquipTowers.Value[TowerName] ~= nil
end

function super.GetTower(self: IPlayer, Name: string): {Name: string, Experience: number, Level: number}
    if not self.EquipTowers.Value[Name] then
        return nil
    end
    
    return self.EquipTowers.Value[Name]
end

function super.UnequipTower(self: IPlayer, Tower: string)
    local TowersDatastore = self.EquipTowers.Value
    local Index = table.find(TowersDatastore)
    
    if Index then
        table.remove(self.EquipTowers.Value, Index)
    end
end


function super.ClearTower(self: IPlayer)
    self.EquipTowers.Value = {}
end

function GetIPlayerFromPlayerInstance(player: Player): IPlayer
    return _Players[player.UserId]
end

function RemovePlayer(player: Player)
    local IPlayer = _Players[player.UserId]
    _Players[player.UserId] = nil

    return IPlayer
end

return {
    new = new;
    GetIPlayerFromPlayerInstance = GetIPlayerFromPlayerInstance,
    RemovePlayer = RemovePlayer,
}