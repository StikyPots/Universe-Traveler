local Players = game:GetService("Players")
local player = Players.LocalPlayer
local TowerUpdateController = { }

export type TowerUpdateController = typeof(new)

function new(ScreenGui: ScreenGui)
    local self = setmetatable(
        {
            ScreenGui = ScreenGui;
            Frame = ScreenGui
            
        },
        {
            __index = TowerUpdateController
        }
    )


    return self
end



return {
    new = new,
}