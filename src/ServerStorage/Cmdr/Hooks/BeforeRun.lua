local ServerStorage = game:GetService("ServerStorage")
local adminList = {
    592874928;
}

return function(registry)
    registry:RegisterHook("BeforeRun", function(context)
		if context.Group == "DefaultAdmin" and not table.find(adminList, context.Executor.UserId) then
			return "You don't have permission to run this command"
		end
    end)
end
