local ServerStorage = game:GetService("ServerStorage")
local playerInterface = require(ServerStorage.PlayerManager.PlayerInterface)



return function(Owner: Player, Target: Model, Damage: number)
   local Humanoid: Humanoid = Target:FindFirstChild("Humanoid")
   local COINS_ON_KILL = Humanoid.MaxHealth
   

   if not Humanoid then
        return
   end

   local Iplayer = playerInterface.GetIPlayerFromPlayerInstance(Owner)

   print(Damage)
   Humanoid:TakeDamage(Damage)
   

   Humanoid.Died:Connect(function()

      if not Iplayer then
         return 
      end
      Iplayer.SessionData:Update("Coins", COINS_ON_KILL)
      Iplayer.SessionData:Update("DamageDeal", Humanoid.MaxHealth)
      Target:Destroy()
   end)
end