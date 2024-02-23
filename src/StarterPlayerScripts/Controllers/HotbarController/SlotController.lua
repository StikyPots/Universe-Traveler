local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")
local TemplateFolder = StarterGui:WaitForChild("Templates")
local SlotTemplate: TextButton = TemplateFolder.Hotbar.SlotTemplate
local GetEnums = require(ReplicatedStorage.Shared.GetEnum)
local GetTowers = require(ReplicatedStorage.Shared.GetElement).GetTower
local offset = 2.5
local super = {}

export type SlotController = typeof(new())

function new(Name: string, Index: number, Screen: ScreenGui)
    local self = setmetatable(
        {
            Name = Name;
            Screen = Screen :: ScreenGui;
            Slot = SlotTemplate:Clone() :: TextButton;
            Index = Index;
            TowerRarity = nil;
            Connections = {};
        },
        {
            __index = super
        }
    )

    self:_addToList()
    return self
end

function super._addToList(self: SlotController)
    local HotbarList = self.Screen.hotbar.Container
    local slot = self.Slot
    local ViewPort: ViewportFrame = slot.ViewportFrame
    local SlotNumber: TextLabel = slot.SlotNumber
    local Camera = Instance.new("Camera", ViewPort)
    local UIGradient: UIGradient = slot.UIStroke.UIGradient

    local ModelToClone: Model = ReplicatedStorage.Assets.Towers:FindFirstChild(self.Name)


    if self.Name == "none" then
        SlotNumber.Text = self.Index
        slot.Price.Text = " "
        self:Disconnect()
        slot.Parent = HotbarList
        return
    end

    if not ModelToClone then
        return
    end

    self.TowerRarity = GetTowers(self.Name).rarity
    local RarityColors = GetEnums("Colors", "Rarity")
    local ClonedModel = ModelToClone:Clone()

    local HumanoidRootPart = ClonedModel:FindFirstChild("HumanoidRootPart")
    UIGradient.Color = ColorSequence.new(RarityColors[self.TowerRarity])


    if self.TowerRarity == "Ultimate" then
        local TweenInfo = TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.In, -1)
        TweenService:Create(UIGradient, TweenInfo, {Rotation = 180}):Play()
    end

    slot.Name = self.Name
    ViewPort.CurrentCamera = Camera
    Camera.CameraSubject = ClonedModel
    ClonedModel.Parent = ViewPort
    SlotNumber.Text = self.Index
    slot.Price.Text = "$".. GetTowers(self.Name).price

    Camera.CFrame = CFrame.new(
        HumanoidRootPart.Position + (HumanoidRootPart.CFrame.LookVector * offset),
        HumanoidRootPart.Position
    )

   
    slot.Parent = HotbarList
end



function super.Delete(self: SlotController)

    self:Disconnect()

    self.Connections = {}
end

function super.Disconnect(self: SlotController)

    for _, Connection: RBXScriptConnection in self.Connections do
        Connection:Disconnect()
    end

    self.Connections = {}
end



return {
    new = new
}