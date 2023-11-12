local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local signal = require(ReplicatedStorage.Libraries.signal)
local red = require(ReplicatedStorage.Libraries.red)
local WavesSettings = require(script.Parent.Settings)
local MapLoader = require(ServerStorage.MapLoader)
local WaveController = require(script.Parent.WaveController)
local TimerModule = require(ServerStorage.Services.Timer)
local SequenceController = {}

local TimerNetwork = red.Server("Timer")

export type SequenceController = typeof(new())

function new(WavesNumber: number, Entities: {string})
    local self = setmetatable(
        {
            Entities = Entities;
            WavesNumber = WavesNumber;
            SpawnRate = WavesSettings.spawnRate,
            StartAmount = WavesSettings.StartAmount;
            NewWaveStarted = signal.new();
            WaveEnded = signal.new();
            SequenceEnded = signal.new();
            Finished = false;
        },
        {
            __index = SequenceController
        }
    )
    return self
end

function SequenceController.Start(self: SequenceController)

    local LoadedMap: MapLoader.MapInstance = workspace.LoadedMap
    local EntitesNumber = #self.Entities
    local Previous = {}

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
            until #LoadedMap.Entities:GetChildren() == 0

            self.WaveEnded:Fire(wave)
        end

        self.SequenceEnded:Fire()

    end)
end


function SequenceController.Finish(self: SequenceController)
    self.Finished = true
end

return {
    new = new
}