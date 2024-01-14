local CollectionService = game:GetService("CollectionService")
local TweenService = game:GetService("TweenService")


local TowerUpdateRotation = "TowerUpdateRotation"

local Connections = {} 
local IncrementId = 0
local duration = 0.5

CollectionService:GetInstanceAddedSignal(TowerUpdateRotation):Connect(function(Model: Model)


	local id = Model:GetAttribute("Id")
	
    Connections[id] = Model:GetAttributeChangedSignal("TargetVector3"):Connect(function()
        
        local ModelVector3: Vector3 = Model:GetAttribute("ModelVector3")
        local TargetVector3: Vector3 = Model:GetAttribute("TargetVector3")


        local Goal = CFrame.lookAt(
            ModelVector3,
            Vector3.new(TargetVector3.X, ModelVector3.Y, TargetVector3.Z)
        )

        -- Model.PrimaryPart.CFrame = Model.PrimaryPart.CFrame:Lerp(Goal, alpha)
        TweenService:Create(Model.PrimaryPart, TweenInfo.new(duration), {CFrame = Goal}):Play()
    end)
end)


CollectionService:GetInstanceRemovedSignal("TowerUpdateRotation"):Connect(function(Model: Model)
	print(Model:GetAttribute("Id"))
    Connections[Model:GetAttribute("Id")]:Disconnect()
end)