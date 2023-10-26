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
            Model = nil;
            PlayerTowerInfo = nil;
            Level = 0;
            Id = 0;
            Radius = GlobalTowerInfo.radius;
            Damage = GlobalTowerInfo.damage;
            Delay = GlobalTowerInfo.delay;
            Updated = 0;
        },
        {
            __index = super
        }
    )

    _Towers[#_Towers+1] = self
    self.PlayerTowerInfo = self.IPlayer:GetTower(self.Name) :: DatastoreTower
    self.Id = #_Towers
    self.Level = self.PlayerTowerInfo.Level

    self:Spawn()

    return self
end


function super.Spawn(self: ITower)
    
    local ModelToClone: Model = Assets.Towers:FindFirstChild(self.Name)
    local Component = components(string.format(SystemPrefix, self.Prefix))

    if not ModelToClone then
        print("no model")
        return
    end

    self.Model = ModelToClone:Clone()
    self.Model:PivotTo(self.CFrame)
    self.Model.Parent = workspace.LoadedMap.Towers

    World:spawnAt(self.Id, Component({

        Owner = self.Owner;
        Model = self.Model;
        Radius = self.Radius[1];
        Damage = self.Damage[1];
        Delay = self.Delay[1];

    }))
end


function super.Update()

end

function super.Remove()

end

return {
    new = new
}