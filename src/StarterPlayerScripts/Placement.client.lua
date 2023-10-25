--/services
local ContextActionService = game:GetService("ContextActionService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

--/ require
local red = require(ReplicatedStorage.Libraries.red)
local hotbarController = require(script.Parent:WaitForChild("Controllers").HotbarController.HotbarController)
local RaycastMouse = require(ReplicatedStorage.Shared.RaycastMouse)
local GetTower = require(ReplicatedStorage.Shared.GetElement).GetTower

--// Constante
local Player: Player = Players.LocalPlayer
local Assets: Folder = ReplicatedStorage.Assets
local TowersFolder: Folder = Assets.Towers
local placementScreen: ScreenGui = Player.PlayerGui:WaitForChild("Placement")
local PlacementNetwork = red.Client("PlacementNetwork")
local hotbar: hotbarController.hotbarController = hotbarController.new()
local offset = 50


--// Dynamic
local Actions = {"place", "rotate", "remove"}
local Colors = {[true] = Color3.fromRGB(44, 218, 128), [false] = Color3.fromRGB(246, 81, 81)}
local Inputs = {[Enum.KeyCode.One] = 1, [Enum.KeyCode.Two] = 2, [Enum.KeyCode.Three] = 3, [Enum.KeyCode.Four] = 4, [Enum.KeyCode.Five] = 5}
local Rotation = 0
local SelectedTowers: Model = nil
local selected = false
local canPlace = false



--// function

local function place(actionName, inputState, _inputObject)
    if inputState == Enum.UserInputState.Begin and canPlace then
       PlacementNetwork:Fire("Placement", SelectedTowers.Name, SelectedTowers:GetPivot())
        selected = false
        SelectedTowers:Destroy()
        SelectedTowers = nil
    end
end

local function remove(actionName, inputState, _inputObject)
    if inputState == Enum.UserInputState.Begin then
         selected = false
         SelectedTowers:Destroy()
         SelectedTowers = nil
     end
end

local function rotate(actionName, inputState, _inputObject)
    if inputState == Enum.UserInputState.Begin then
        Rotation += 90
     end
end

local function placementGui(MousePos: Vector2)
    if UserInputService.KeyboardEnabled then
        placementScreen.Canva.Visible = selected
        placementScreen.Canva.Position = UDim2.new(0 , MousePos.X, 0, MousePos.Y - offset)
    end
end

local function CreatePlaceholder(tower:  string)
    local ModelToClone: Model = TowersFolder:FindFirstChild(tower)

    if not ModelToClone then
        return
    end
    
    local ClonedModel = ModelToClone:Clone()
    selected = true

    SelectedTowers = ClonedModel
    SelectedTowers.Name = tower

    for _, part:Part in pairs(SelectedTowers:GetChildren()) do
        if part:IsA("BasePart") then
            part.Transparency = 0.5
            part.Material = Enum.Material.ForceField
        end
    end

    ClonedModel.Parent = workspace.PlaceholderTowers

end

local function updateColor(color:Color3)
    for _, part:Part in pairs(SelectedTowers:GetChildren()) do
        if part:IsA("BasePart") then
            part.Transparency = 0.5
            part.Color = color
        end
    end
end

local function AllowToPlace(Instance: Instance)
    local TowerInfo = GetTower(SelectedTowers.Name)

    if table.find(TowerInfo.placeAreas, Instance.Name) then
        canPlace = true
        updateColor(Colors[canPlace])
    else
        canPlace = false
        updateColor(Colors[canPlace])
    end
end

local function checkInput(input:InputObject, procssed)
    if procssed then
        return
    end

    local keycode = Inputs[input.KeyCode]

    if keycode and not selected then
        local SlotTower = hotbar.Towers[keycode]

        print(SlotTower)

        if SlotTower then
            CreatePlaceholder(SlotTower)
        end
    end
end

--// Event
UserInputService.InputBegan:Connect(checkInput)

hotbar.OnSelected:Connect(function(tower)
    if not selected then
        CreatePlaceholder(tower)
    end
end)

RunService.RenderStepped:Connect(function(deltaTime)
    local RaycastResult: RaycastResult = RaycastMouse({ Player.Character , SelectedTowers })
    local MousePos: Vector2 = UserInputService:GetMouseLocation()

    for _, Action in Actions do
        ContextActionService:UnbindAction(Action)
    end

    placementGui(MousePos)

    if RaycastResult and SelectedTowers then
        AllowToPlace(RaycastResult.Instance)
        ContextActionService:BindAction("place", place, false, Enum.UserInputType.MouseButton1)
        ContextActionService:BindAction("rotate", rotate, false, Enum.KeyCode.R)
        ContextActionService:BindAction("remove", remove, false, Enum.KeyCode.Q)

        SelectedTowers:PivotTo(CFrame.new(RaycastResult.Position) * CFrame.Angles(0, math.rad(Rotation), 0))
    end
end)