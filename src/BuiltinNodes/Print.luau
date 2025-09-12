local NodeBuilder = require(script.Parent.Parent.NodeBuilder)

return function()
    local builder = NodeBuilder.new()
    builder.ui_name = "Print"
    builder:AddInput("Message", "any")
    builder:AddInputSignal("Log", function(ctx)
        local message = ctx:ExtractInput("Message")
        print(message)
    end)
    return builder
end
