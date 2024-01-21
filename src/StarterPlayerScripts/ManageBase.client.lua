local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local red = require(ReplicatedStorage.Libraries.red)


local BaseNetwork = red.Client("BaseNetwork")

local local_player = Players.LocalPlayer
local HealthBarScreen = local_player.PlayerGui:WaitForChild("Topbar")

BaseNetwork:On("OnUpdateHealth", function(MaxHealth, currentHealth)
    local FrameHealthBar: Frame = HealthBarScreen.HealthBar.MovingHealthBar
    local Icon: ImageLabel = FrameHealthBar.Parent.Icon
    local health = math.clamp(currentHealth / MaxHealth, 0, 1)

    FrameHealthBar.Size = UDim2.fromScale(health, 1)

    FrameHealthBar.Parent.PerHealth.Text = math.round(health * 100) .."%"

    if health == 0 then
        FrameHealthBar.Visible = false
        Icon.ImageColor3 = Color3.fromHex("#2d2e3a")
    end
end)