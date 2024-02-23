local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Red = require(ReplicatedStorage.Libraries.red)
local Notification = require(script.Parent.Notification)

local NotificationNetwork = Red.Client("NotificationNetwork")


NotificationNetwork:On("Notify", function(Body: Notification.NotificationBody)
   Notification.new(Body)
end)



