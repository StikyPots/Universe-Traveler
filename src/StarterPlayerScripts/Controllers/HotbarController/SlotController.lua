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

    self.TowerRarity = GetTowers(self.Name).rarity
    self:_addToList()
    return self
end

function super._addToList(self: SlotController)
    local HotbarList = self.Screen.hotbar.Container
    local slot = self.Slot
    local ViewPort: ViewportFrame = slot.ViewportFrame
    local SlotNumber: TextLabel = slot.SlotNumber
    local Camera = Instance.new("Camera", ViewPort)
    local UIGradient: UIGradient = slot.RarityColor.UIGradient

    local ModelToClone: Model = ReplicatedStorage.Assets.Towers:FindFirstChild(self.Name)

    if not ModelToClone then
        print("created")
        return
    end

    print("hello, world")

   local RarityColors = GetEnums("Colors", "Rarity")

   print(RarityColors)

    local ClonedModel = ModelToClone:Clone()
    local HumanoidRootPart = ClonedModel:FindFirstChild("HumanoidRootPart")

    UIGradient.Color = ColorSequence.new(RarityColors[self.TowerRarity])

    if self.TowerRarity == "Ultimate" then
        local TweenInfo = TweenInfo.new(5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out, -1)
        TweenService:Create(UIGradient, TweenInfo, {Rotation = 180}):Play()
    end

    slot.Name = self.Name
    ViewPort.CurrentCamera = Camera
    Camera.CameraSubject = ClonedModel
    ClonedModel.Parent = ViewPort
    SlotNumber.Text = self.Index

    Camera.CFrame = CFrame.new(
        HumanoidRootPart.Position + (HumanoidRootPart.CFrame.LookVector * offset),
        HumanoidRootPart.Position
    )

    

    slot.Parent = HotbarList
end

return {
    new = new
}