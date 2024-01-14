local TweenService = game:GetService("TweenService")

return function (Model: Model, Target: Model)
    Model:SetAttribute("ModelVector3", Model.PrimaryPart.Position)
    Model:SetAttribute("TargetVector3", Target.PrimaryPart.Position)
end
