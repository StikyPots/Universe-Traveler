local ReplicatedStorage = game:GetService("ReplicatedStorage")
local matter = require(ReplicatedStorage.Libraries.matter)

local components = {}

return function (name)
	if not components[name] then
		components[name] = matter.component(name)
	end
	
	return components[name]
end
