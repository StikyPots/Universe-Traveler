local ReplicatedStorage = game:GetService("ReplicatedStorage")
local ServerStorage = game:GetService("ServerStorage")
local Cmdr = require(ReplicatedStorage.Libraries.cmdr)


Cmdr:RegisterDefaultCommands()
Cmdr:RegisterCommandsIn(ServerStorage.Cmdr.Commands)
Cmdr:RegisterTypesIn(ServerStorage.Cmdr.Types)
Cmdr:RegisterHooksIn(ServerStorage.Cmdr.Hooks)