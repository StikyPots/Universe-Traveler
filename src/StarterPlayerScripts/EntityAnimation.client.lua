local CollectionService = game:GetService("CollectionService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local red = require(ReplicatedStorage.Libraries.red)
-- local AnimationNetwork = red.Client("AnimationNetwork")
local GetEntity = require(ReplicatedStorage.Shared.GetElement).GetEntity

local animPath = "rbxassetid://"


-- AnimationNetwork:On("OnSummon", function(name: string, Humanoid: Humanoid)
--     local AnimationId = GetEntity(name).Animations.OnSummon


--     local Animation = Instance.new("Animation")
--     Animation.AnimationId = animPath..AnimationId

--     local Animator: Animator = Humanoid:FindFirstChild("Animator")

--     if Animator then

--         task.defer(function()
--             local AnimationTrack = Animator:LoadAnimation(Animation)
--             AnimationTrack.Priority = Enum.AnimationPriority.Action
--             AnimationTrack:Play()
--         end)
--     end
-- end)


CollectionService:GetInstanceAddedSignal("Entities"):Connect(function(Entity: Instance)
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

