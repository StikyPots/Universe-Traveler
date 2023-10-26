local ServerStorage = game:GetService("ServerStorage")
local playerInterface = require(ServerStorage.PlayerManager.PlayerInterface)


local COINS_ON_KILL = 350

return function(Owner: Player, Target: Model, Damage: number)
   local Humanoid: Humanoid = Target:FindFirstChild("Humanoid")

   if not Humanoid then
        return
   end


   local Iplayer = playerInterface.GetIPlayerFromPlayerInstance(Owner)

   Humanoid:TakeDamage(Damage)

   Iplayer.SessionData:Update("DamageDeal", Damage)

   print('Hotbar')

   Humanoid.Died:Connect(function()
      Iplayer.SessionData:Update("Coins", COINS_ON_KILL)
      Target:Destroy()
   end)

end