local ViewportController = {}


export type ViewportController = typeof(new())

function new(viewport: ViewportFrame)
    local self = setmetatable(
        {
            ViewportFrame = viewport;
            Camera = Instance.new("Camera", viewport);
            WorldModel = viewport:WaitForChild("WorldModel");
        }, 
        {
            __index = ViewportController
        }
    )

    return self
end

function ViewportController.update(self: ViewportController, Model: Model)
    local viewport = self.ViewportFrame
end

return {
    new = new
}
