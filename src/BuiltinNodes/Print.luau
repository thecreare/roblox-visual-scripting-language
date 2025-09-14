local NodeBuilder = require(script.Parent.Parent.NodeBuilder)

return function()
    local builder = NodeBuilder.new()
    builder:AddInput("Message", "any")
    builder:AddInputSignal("Log", function(ctx)
        local message = ctx:ExtractInput("Message")
        print(message)
    end)
    builder.ui_name = "Print"
    return builder
end
