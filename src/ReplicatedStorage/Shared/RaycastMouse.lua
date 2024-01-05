local userInPutService = game:GetService("UserInputService")
local camera = workspace.Camera
local Distance = 1000

return function (blacklist:{}?)
    local mousePosition = userInPutService:GetMouseLocation()
    local mouseRay = camera:ViewportPointToRay(mousePosition.X, mousePosition.Y)

    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = blacklist
    local raycastResult = workspace:Raycast(mouseRay.Origin, mouseRay.Direction * Distance, raycastParams)

    return raycastResult
end