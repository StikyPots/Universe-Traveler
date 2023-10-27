local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local components = require(ReplicatedStorage.Shared.Components)
local matter = require(ReplicatedStorage.Libraries.matter)
local GetTower = require(ReplicatedStorage.Shared.GetElement).GetTower
local playerInterface = require(ServerStorage.PlayerManager.PlayerInterface)
local Start = require(ReplicatedStorage.Shared.Start)

local Assets = ReplicatedStorage.Assets
local _Towers = {}
local super = {}

local World: matter.World = require(ServerStorage.World)
local SystemsFolder = ServerStorage.Systems.TowerSystems
local SystemPrefix = "%sSystem"

local BASE_LEVELDAMAGE = 1.5

Start(World, SystemsFolder)

export type ITower = typeof(new())
type IPlayer = playerInterface.IPlayer
type DatastoreTower = {Name: string, Experience: number, Level: number}


function new(Player: Player, Name: string, CFrame: CFrame)

    local GlobalTowerInfo = GetTower(Name)

    local self = setmetatable(
        {
            Name = Name;
            Owner = Player;
            CFrame = CFrame;
            Prefix = GlobalTowerInfo.Prefix;
            IPlayer = playerInterface.GetIPlayerFromPlayerInstance(Player);
            Model = nil :: Model;
            PlayerTowerInfo = nil;
            Level = 0;
            Id = 0;
            Radius = GlobalTowerInfo.radius;
            Damage = GlobalTowerInfo.damage;
            Delay = GlobalTowerInfo.delay;
            Updated = 1;
            _DAMAGECALCULATION = 0;
            _Component = nil;
        },
        {
            __index = super
        }
    )

    _Towers[tostring(#_Towers+1)] = self
    self.PlayerTowerInfo = self.IPlayer:GetTower(self.Name) :: DatastoreTower
    self.Id = tonumber(#_Towers)
    self.Level = self.PlayerTowerInfo.Level
    self._DAMAGECALCULATION = self.Damage[self.Updated] + self.Level * BASE_LEVELDAMAGE
    self._Component = components(string.format(SystemPrefix, self.Prefix))


    self:Spawn()

    return self
end


function super.Spawn(self: ITower)
    
    local ModelToClone: Model = Assets.Towers:FindFirstChild(self.Name)

    if not ModelToClone then
        print("no model")
        return
    end

    self.Model = ModelToClone:Clone()
    self.Model:PivotTo(self.CFrame)
    self.Model.Parent = workspace.LoadedMap.Towers






    World:spawnAt(self.Id, self._Component({

        Owner = self.Owner;
        Model = self.Model;
        Radius = self.Radius[self.Updated];
        Damage = self._DAMAGECALCULATION;
        Delay = self.Delay[self.Updated];

    }))
end


function super.Update(self: ITower)
    World:replace(self.Id, self._Component({
        Owner = self.Owner;
        Model = self.Model;
        Radius = self.Radius[self.Updated];
        Damage = self._DAMAGECALCULATION;
        Delay = self.Delay[self.Updated];
    }))
end

function super.Remove(self: ITower)
    World:despawn(self.Id)
    _Towers[tostring(self.Id)] = nil
    self.Model:Destroy()
    self.IPlayer.SessionData:Update("Coins", self.price * self.updated / 2)
end

-- return only Radius, Damage, Delay


function super.Get(self: ITower, Instance: string, updated: number)
    local accept = {"Radius", "Damage", "Delay", "Name"}

    assert(table.find(accept, Instance), "Not instance found")
    assert(updated >= 1 and updated <= 3, "uptaded must be between 1 and 3")


    return self[Instance][updated]
end


function GetTowerFromId(Id: number): ITower
    return _Towers[tostring(Id)]
end

return {
    new = new;
    GetTowerFromId = GetTowerFromId;
}