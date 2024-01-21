local CollectionService = game:GetService("CollectionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local signal = require(ReplicatedStorage.Libraries.signal)
local red = require(ReplicatedStorage.Libraries.red)
local matter = require(ReplicatedStorage.Libraries.matter)
local MapLoader = require(ServerStorage.MapLoader)
local WaveController = require(script.Parent.WaveController)
local World: matter.World = require(ServerStorage.World)
local Start = require(ReplicatedStorage.Shared.Start)
local PlayerInterface = require(ServerStorage.PlayerManager.PlayerInterface)
local BaseModule = require(ServerStorage.Services.BaseController)
local Constante = require(ReplicatedStorage.Enums.Constante)




local BASE_COINS = 95
local INCREMENT = 100


local SystemsFolder = ServerStorage.Systems.EntitiesSystems

local CurrentSequence

local SequenceController = {}


export type SequenceController = typeof(SequenceController.new())

function SequenceController.new(WavesNumber: number, Entities: {string})


    print(workspace.Map:GetAttribute("Difficulty"))

    local self = setmetatable(
        {
            Entities = Entities;
            WavesNumber = WavesNumber;
            SpawnRate = Constante.GlobalWaveSettings.spawnRatePerDifficulty[workspace.Map:GetAttribute("Difficulty")],
            StartAmount = Constante.GlobalWaveSettings.StartAmountPerDifficulty[workspace.Map:GetAttribute("Difficulty")];
            Base = BaseModule.new(Constante.BaseHealth[workspace.Map:GetAttribute("Difficulty")]),
            NewWaveStarted = signal.new(); -- Signal
            WaveEnded = signal.new();
            SequenceEnded = signal.new();
            Finished = false;
            skipBoolean = false;
        },
        {
            __index = SequenceController
        }
    )

   

    if CurrentSequence == nil then
        CurrentSequence = self
    else
        error("you cannot create a sequence if there is already a sequence", 2)
    end
   
    return self
end

function SequenceController.Start(self: SequenceController)

    local Map: MapLoader.MapInstance = workspace.Map
    local EntitesNumber = #self.Entities
    local Previous = {}

    self.Base:Initialize()

    Start(World, SystemsFolder)

    task.defer(function()
        for wave = 1, self.WavesNumber do
            self.NewWaveStarted:Fire(wave)

            if self.Finished then
                break
            end

            local EntityChosen = math.ceil(wave * EntitesNumber / self.WavesNumber)


            for pos, PreviousEntity in Previous do
                WaveController(PreviousEntity, math.round((wave * self.SpawnRate + self.StartAmount) / pos), wave)
            end

            if Previous[EntityChosen] == nil then
                table.insert(Previous, self.Entities[EntityChosen])
                WaveController(self.Entities[EntityChosen], self.StartAmount, wave)
            end
            
            repeat
            task.wait()
            until #Map.Entities:GetChildren() == 0 or self.skipBoolean

            self.skipBoolean = false
            self:GiveWaveAmountCoins(Players:GetPlayers(), wave)
            self.WaveEnded:Fire(wave)
        end
        self.SequenceEnded:Fire()
        CurrentSequence = nil
    end)
end


function SequenceController.Finish(self: SequenceController)
    self.Finished = true
    
    task.defer(function()
        for _, entity in CollectionService:GetTagged("Entities") do
            entity:RemoveTag("Entities")
            entity:Destroy()
            task.wait()
        end
    end)
end

function SequenceController.skip(self: SequenceController)
    self.skipBoolean = true
end

function SequenceController.GiveWaveAmountCoins(self: SequenceController, Players: {Player}, currentWave)
    for _, Player: Player in Players do
        local IPlayer = PlayerInterface.GetIPlayerFromPlayerInstance(Player)
        IPlayer.SessionData:Update("Coins", BASE_COINS + (currentWave - 1) * INCREMENT)
    end
end

--Get the current Sequence
function SequenceController.GetSequence()
    return CurrentSequence
end


return SequenceController