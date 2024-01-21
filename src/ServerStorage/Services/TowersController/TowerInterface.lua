local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local components = require(ReplicatedStorage.Shared.Components)
local matter = require(ReplicatedStorage.Libraries.matter)
local GetTower = require(ReplicatedStorage.Shared.GetElement).GetTower
local playerInterface = require(ServerStorage.PlayerManager.PlayerInterface)
local Start = require(ReplicatedStorage.Shared.Start)
local Constantes = require(ReplicatedStorage.Enums.Constante)

local Assets = ReplicatedStorage.Assets
local _Towers = {}
local super = {}

local World: matter.World = require(ServerStorage.World)
local SystemsFolder = ServerStorage.Systems.TowerSystems
local SystemPrefix = "%sSystem"
local BASE_LEVELDAMAGE = 1.075

export type ITower = typeof(new())
type IPlayer = playerInterface.IPlayer
type DatastoreTower = {Name: string, Experience: number, Level: number}

local IncrementId = 0

Start(World, SystemsFolder)

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
            Price = GlobalTowerInfo.price;
            Updated = 1;
            _DAMAGECALCULATION = 0;
            _Component = nil;
        },
        {
            __index = super
        }
    )


    self.PlayerTowerInfo = self.IPlayer:GetTower(self.Name) :: DatastoreTower
    self.Level = self.PlayerTowerInfo.Level
    self._DAMAGECALCULATION = self.Damage[self.Updated] + (self.Level - 1) * BASE_LEVELDAMAGE
    self._Component = components(string.format(SystemPrefix, self.Prefix))


    self.Id = IncrementId + 1
    IncrementId = self.Id


    _Towers[tostring(self.Id)] = self



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
    self.Model.Parent = workspace.Map.Towers

    self.Model:AddTag(Constantes.TowerTag)
    self.Model:SetAttribute("Id", self.Id)


    World:spawnAt(self.Id, self._Component({

        Owner = self.Owner;
        Model = self.Model;
        Radius = self.Radius[self.Updated];
        Damage = self._DAMAGECALCULATION;
        Delay = self.Delay[self.Updated];

    }))
end


function super.Update(self: ITower)


    if self.Updated > 3 then
        return
    end

    self.Updated += 1

    self._DAMAGECALCULATION = self.Damage[self.Updated] + (self.Level - 1) * BASE_LEVELDAMAGE

    World:replace(self.Id, self._Component({
        Owner = self.Owner;
        Model = self.Model;
        Radius = self.Radius[self.Updated];
        Damage = self._DAMAGECALCULATION;
        Delay = self.Delay[self.Updated];
    }))
end

function super.Delete(self: ITower)
    _Towers[tostring(self.Id)] = nil
    self.Model:Destroy()
    World:despawn(self.Id)

    print(_Towers)
    self.IPlayer.SessionData:Update("Coins", math.round(self.Price * self.Updated / 2))
end


function super.Get(self: ITower, Instance: string, updated: number): number -- return only Radius, Damage, Delay
    local accept = {"Radius", "Damage", "Delay"}

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

