local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local TemplateFolder = StarterGui:WaitForChild("Templates")
local SlotTemplate: TextButton = TemplateFolder.Hotbar.SlotTemplate
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

    local ModelToClone: Model = ReplicatedStorage.Assets.Towers:FindFirstChild(self.Name)

    if not ModelToClone then
        print("created")

        return
    end

    local ClonedModel = ModelToClone:Clone()
    local HumanoidRootPart = ClonedModel:FindFirstChild("HumanoidRootPart")

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