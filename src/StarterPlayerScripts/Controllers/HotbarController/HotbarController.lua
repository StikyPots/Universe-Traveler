local LocalizationService = game:GetService("LocalizationService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")

local Red = require(ReplicatedStorage.Libraries.red)
local SlotController = require(script.Parent.SlotController)
local Signal = require(ReplicatedStorage.Libraries.signal)

local PlayerGui = Players.LocalPlayer.PlayerGui
local hotbar = PlayerGui:WaitForChild("Hotbar")
local GettingTower = Red.Client("GettingTower")

local super = {}
local Towers = {}

export type hotbarController = typeof(new())

function new()
    local self = setmetatable({},{__index = super})

    self.Slots = {}
    self.Towers = {}
    self.OnSelected = Signal.new() :: Signal.Signal;
    self.Towers = GettingTower:Call("GettingTower"):Catch(function(err) error(err) end):Await()
        
    self:_CreateSlots()
    self:_createConnections()

    return self
end

function super._CreateSlots(self: hotbarController)

    for i, slot in self.Towers do
        local Success, Islot = pcall(SlotController.new, slot, i, hotbar)
        if not Success then warn(Islot, slot) continue end
        Islot.Slot.LayoutOrder = i
        table.insert(self.Slots, Islot)
    end

    for i = #self.Towers + 1, 5 do
        local Success, Islot = pcall(SlotController.new, "none", i, hotbar)
        if not Success then warn(Islot, "none") continue end
        Islot.Slot.LayoutOrder = i
        table.insert(self.Slots, Islot)
    end

end

function super._createConnections(self: hotbarController)
    local selected

    for _, slot: SlotController.SlotController in self.Slots do

        local function OnMouseButton()
            selected = slot.Name
            self.OnSelected:Fire(selected)
        end

        slot.Connections.OnMouseButton = slot.Slot.MouseButton1Click:Connect(OnMouseButton)
    end
end

function super.clearSlots(self: hotbarController)
    for _, slot: SlotController.SlotController in self.Slots do
        slot:Delete()
    end
    self.Slots = {}
end

return {
    new = new
}