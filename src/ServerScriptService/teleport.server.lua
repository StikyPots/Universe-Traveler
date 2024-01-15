local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")


Players.PlayerAdded:Connect(function(player)
   local tpData = player:GetJoinData()

   print(HttpService:JSONEncode(tpData.TeleportData))
   print(tpData.Members)
   
end)