local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")

local signal = require(ReplicatedStorage.Libraries.signal)
local WavesSettings = require(script.Parent.Settings)
local MapLoader = require(ServerStorage.MapLoader)
local WaveController = require(script.Parent.WaveController)
local super = {}

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
        },
        {
            __index = super
        }
    )
    return self
end

function super.Start(self: SequenceController)

    local LoadedMap: MapLoader.MapInstance = workspace.LoadedMap
    local EntitesNumber = #self.Entities
    local Previous = {}

    task.defer(function()

        for wave = 1, self.WavesNumber do
            self.NewWaveStarted:Fire()

            local EntityChosen = math.ceil(wave * EntitesNumber / self.WavesNumber)


            for _, PreviousEntity in Previous do
                WaveController(PreviousEntity, math.max(wave * self.SpawnRate))
            end

            if Previous[EntityChosen] == nil then
                print("hello")
                table.insert(Previous, self.Entities[EntityChosen])
                WaveController(self.Entities[EntityChosen], self.StartAmount)
            end
            
            repeat
            task.wait()
            until #LoadedMap.Entities:GetChildren() == 0

            self.WaveEnded:Fire()
        end

        self.SequenceEnded:Fire()

    end)
end

return {
    new = new
}