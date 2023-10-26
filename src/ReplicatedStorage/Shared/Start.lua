local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local matter = require(ReplicatedStorage.Libraries.matter)




local start = function(world, folder)
	local state = {}
	
	local systems = {}
	
	local loop = matter.Loop.new(world, state)



	

	for i, system in folder:GetChildren() do
		local ok, result = pcall(require, system)

		if not ok then
			warn("error the module won't load")
			return
		end

		table.insert(systems, result)
	end
	
	loop:scheduleSystems(systems)
	
	local begin = {}
	
	if RunService:IsClient() then
		begin = {
			default = RunService.Heartbeat,
			stepped = RunService.Stepped
		}
	else
		begin = {
			default = RunService.Heartbeat,
		}
	end
	
	loop:begin(begin)
	
	return world, state
end

return start
