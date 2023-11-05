local ButtonController = {}


export type ButtonController = typeof(new())

function new(Button: GuiButton, MouseButton1Click: () -> ())
    local self = setmetatable(
        {
            Button = Button;
            func = MouseButton1Click;
            Connections = {};
        },

        {
            __index = ButtonController
        }
    )
    return self
end

function ButtonController._createConnections(self: ButtonController)
    self.Connections.MouseButton1Click = self.Button.Activated:Connect(self.func)
end

function ButtonController.disconnect(self: ButtonController)
    for _, Connection: RBXScriptConnection in self.Connections do
        Connection:Disconnect()
    end
    self.Connections = {}
end


return {
    new = new;
}