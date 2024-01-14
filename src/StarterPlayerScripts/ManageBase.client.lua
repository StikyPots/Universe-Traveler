local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local red = require(ReplicatedStorage.Libraries.red)


local BaseNetwork = red.Client("BaseNetwork")

local local_player = Players.LocalPlayer
local HealthBarScreen = local_player.PlayerGui:WaitForChild("HealthBar")


BaseNetwork:On("OnUpdateHealth", function(MaxHealth, currentHealth)
    local FrameHealthBar: Frame = HealthBarScreen.HealthBar.MovingHealthBar
    local health = math.clamp(currentHealth / MaxHealth, 0, 1)
    FrameHealthBar.Size = UDim2.fromScale(health, 1)

    FrameHealthBar.Parent.PerHealth.Text = health * 100 .."%"

end)