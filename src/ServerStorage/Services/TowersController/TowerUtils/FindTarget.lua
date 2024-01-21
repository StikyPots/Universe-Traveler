return function(Model: Model, Radius: number)
    local EntitiesFolder = workspace.Map.Entities
    local Target = {}

    for _, Entity in EntitiesFolder:GetChildren() do
        local Distance: number = ( Entity.HumanoidRootPart.Position - Model.PrimaryPart.Position ).Magnitude

        if (Distance <= Radius) and not table.find(Target, Entity) then
            table.insert(Target, Entity)
        end

    end

    return Target[1]
end