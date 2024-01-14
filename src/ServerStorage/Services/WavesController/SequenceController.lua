local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local signal = require(ReplicatedStorage.Libraries.signal)
local red = require(ReplicatedStorage.Libraries.red)
local WavesSettings = require(script.Parent.Settings)
local matter = require(ReplicatedStorage.Libraries.matter)
local MapLoader = require(ServerStorage.MapLoader)
local WaveController = require(script.Parent.WaveController)
local World: matter.World = require(ServerStorage.World)
local Start = require(ReplicatedStorage.Shared.Start)


local SystemsFolder = ServerStorage.Systems.EntitiesSystems

local CurrentSequence

local SequenceController = {}


export type SequenceController = typeof(SequenceController.new())

function SequenceController.new(WavesNumber: number, Entities: {string})
    local self = setmetatable(
        {
            Entities = Entities;
            WavesNumber = WavesNumber;
            SpawnRate = WavesSettings.spawnRate,
            StartAmount = WavesSettings.StartAmount;
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

    local LoadedMap: MapLoader.MapInstance = workspace.LoadedMap
    local EntitesNumber = #self.Entities
    local Previous = {}

    Start(World, SystemsFolder)

    task.defer(function()
        for wave = 1, self.WavesNumber do
            self.NewWaveStarted:Fire(wave)

            if self.Finished then
                break
            end

            local EntityChosen = math.ceil(wave * EntitesNumber / self.WavesNumber)


            for _, PreviousEntity in Previous do
                WaveController(PreviousEntity, math.round(wave * self.SpawnRate + self.StartAmount))
            end

            if Previous[EntityChosen] == nil then
                table.insert(Previous, self.Entities[EntityChosen])
                WaveController(self.Entities[EntityChosen], self.StartAmount)
            end
            
            repeat
            task.wait()
            until #LoadedMap.Entities:GetChildren() == 0 or self.skipBoolean

            self.skipBoolean = false
            self.WaveEnded:Fire(wave)
        end
        self.SequenceEnded:Fire()
        CurrentSequence = nil
    end)
end


function SequenceController.Finish(self: SequenceController)
    self.Finished = true
    
    local thread = task.defer(function()
        for _, entity in CollectionService:GetTagged("Entities") do
            entity:RemoveTag("Entities")
            entity:Destroy()
        end
    end)
end

function SequenceController.skip(self: SequenceController)
    self.skipBoolean = true
end



--Get the current Sequence
function SequenceController.GetSequence()
    return CurrentSequence
end


return SequenceController