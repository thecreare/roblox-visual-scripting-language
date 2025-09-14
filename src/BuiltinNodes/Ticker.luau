local NodeBuilder = require(script.Parent.Parent.NodeBuilder)

return function()
    local builder = NodeBuilder.new()
    builder:AddInput("Interval", "number")
    builder:AddOutput("Start")
    builder:AddOutput("Tick")
    builder.ui_name = "Ticker"
    return builder
end
