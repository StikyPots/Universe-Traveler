local Players = game:GetService("Players")

local function safePlayerAdded(onPlayerAddedCallback: (Player) -> nil)
	for _, player in ipairs(Players:GetPlayers()) do
		task.spawn(onPlayerAddedCallback, player)
	end
	return Players.PlayerAdded:Connect(onPlayerAddedCallback)
end

return safePlayerAdded
