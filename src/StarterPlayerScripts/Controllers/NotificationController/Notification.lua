local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")





local NotificationTemplate: Folder = StarterGui.Templates.Notifications


local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui

local NotificationHolder = PlayerGui:WaitForChild("Notification"):WaitForChild("NotificationContainer")

local Notification = {}
local NotificationContainer = {}


export type NotificationBody = {Description: string, Type: string, Duration: number}
export type Notification = typeof(Notification.new())

function Notification.new(Body: NotificationBody)
    local self = setmetatable({}, {__index = Notification})

    self.Description = Body.Description
    self.Type = Body.Type
    self.InitialDuration = Body.Duration
    self.Duration = self.InitialDuration
    self.Frame = nil :: Frame
    self.Id = HttpService:GenerateGUID(false)

    self.Connections = {}


    task.spawn(self.Insert, self)

    return self
end

function Notification.Create(self: Notification)
    local NotificationToCreate = NotificationTemplate:FindFirstChild(self.Type)

    if not NotificationToCreate then
        error(self.Type, " This type of notification doesn't exsit !!")
        return
    end

    self.Frame = NotificationToCreate:Clone()
    self.Frame.Parent = NotificationHolder

    self.Frame.Size = UDim2.fromScale(0,0)

    local TweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
    local Tween = TweenService:Create(self.Frame, TweenInfo, {Size = UDim2.fromScale(1, 0.1)})


    Tween:Play()
    Tween.Completed:Wait()

    self.Frame.Description.Text = self.Description
end

function Notification.Insert(self: Notification)
    self:Create()
    task.wait(self.Duration)
    self:Delete()
end


function Notification.ResetTimer()
    
end

function Notification.Delete(self: Notification)
    local TweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
    local Tween = TweenService:Create(self.Frame, TweenInfo, {Size = UDim2.fromScale(0, 0)})
    Tween:Play()
    Tween.Completed:Wait()
    
    self.Frame:Destroy()
end


return Notification