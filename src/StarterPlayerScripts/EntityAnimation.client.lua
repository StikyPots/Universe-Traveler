local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local GetEntity = require(ReplicatedStorage.Shared.GetElement).GetEntity
local Constantes = require(ReplicatedStorage.Enums.Constante)


local animPath = "rbxassetid://"

CollectionService:GetInstanceAddedSignal(Constantes.EntityTag):Connect(function(Entity: Instance)
    local AnimationId = GetEntity(Entity.Name).Animations.Walking

    local Animation = Instance.new("Animation")
    Animation.AnimationId = animPath..AnimationId


    local Humanoid = Entity:WaitForChild("Humanoid")



    local Animator: Animator = Humanoid:FindFirstChild("Animator")

    

    if Animator then
        local AnimationTrack = Animator:LoadAnimation(Animation)
        AnimationTrack.Priority = Enum.AnimationPriority.Movement
        AnimationTrack:Play()
    end


    Entity:GetAttributeChangedSignal("OnSummon"):Connect(function(IsOnSummon)
        local AnimationId = GetEntity(Entity.Name).Animations.OnSummon


        local Animation = Instance.new("Animation")
        Animation.AnimationId = animPath..AnimationId

        local Animator: Animator = Entity.Humanoid:FindFirstChild("Animator")

        if Animator then
            local AnimationTrack = Animator:LoadAnimation(Animation)
            AnimationTrack.Priority = Enum.AnimationPriority.Action
            AnimationTrack:Play()
        end
    end)
end)

