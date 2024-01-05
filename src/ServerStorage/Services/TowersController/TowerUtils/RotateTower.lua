local TweenService = game:GetService("TweenService")
return function (Model: Model, Target: Model)

    -- Model.PrimaryPart.CFrame = CFrame.lookAt(
    --     Model.PrimaryPart.Position,
    --     Vector3.new(Target.PrimaryPart.Position.X, Model.PrimaryPart.Position.Y, Target.PrimaryPart.Position.Z)
    -- )


    local TweenTime = 0.5

    local TweenInfo = TweenInfo.new(TweenTime)

    local Goal = CFrame.lookAt(
        Model.PrimaryPart.Position,
        Vector3.new(Target.PrimaryPart.Position.X, Model.PrimaryPart.Position.Y, Target.PrimaryPart.Position.Z)
    )

    TweenService:Create(Model.PrimaryPart, TweenInfo, {CFrame = Goal}):Play()
    
end
