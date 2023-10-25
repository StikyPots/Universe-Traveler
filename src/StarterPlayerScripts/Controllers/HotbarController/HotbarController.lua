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

export type hotbarController = typeof(new())

function new()
    local self = setmetatable(
        {
            Slots = {};
            Towers = GettingTower:Call("GettingTower"):Await();
            OnSelected = Signal.new() :: Signal.Signal;
        },
        {
            __index = super
        }
    )

    print(self.Towers)
    self:_CreateSlots()
    self:_createConnections()
    return self
end

function super._CreateSlots(self: hotbarController)
    for i, slot in self.Towers do
        print(i, slot)
        local Islot = SlotController.new(slot, i, hotbar)
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

return {
    new = new
}