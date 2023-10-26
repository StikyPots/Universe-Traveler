local CollectionService = game:GetService("CollectionService")


return function(context)
    for _, entity in CollectionService:GetTagged("Entities") do
        task.wait(.05)
        entity:RemoveTag("Entities")
        entity:Destroy()
    end
end