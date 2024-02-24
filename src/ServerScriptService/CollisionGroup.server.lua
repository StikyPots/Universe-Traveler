local Players = game:GetService("Players")
local CollisionGroup = "Player"



Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Wait()
    for _, part: Part in player.Character:GetChildren() do
        if part:IsA("BasePart") then
            part.CollisionGroup = CollisionGroup
        end
    end
end)