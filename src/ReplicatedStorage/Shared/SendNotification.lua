local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local StarterGui = game:GetService('StarterGui')

local red = require(ReplicatedStorage.Libraries.red)

local NotificationTemplate: Folder = StarterGui.Templates.Notifications
local NotificationNetworkServer = red.Server("NotificationNetwork")


local Notification = {}

export type NotificationBody = {Description: string, Type: string, Duration: number}

function Notification.Notify(Player: Player, Body: NotificationBody)
  
    if RunService:IsClient() then
        return error("You must send notification from the server side")
    end
    NotificationNetworkServer:Fire(Player, "Notify", Body)
end

function Notification.NotifyPlayerList(Players: {Player}, Body: NotificationBody)
    if RunService:IsClient() then
        return error("You must send notification from the server side")
    end
    NotificationNetworkServer:FireList(Players, "Notify", Body)
end

function Notification.NotifyAll(Body: NotificationBody)
    if RunService:IsClient() then
        return error("You must send notification from the server side")
    end
    NotificationNetworkServer:FireAll("Notify", Body)
end



return Notification