local NodeBuilder = require(script.Parent.Parent.NodeBuilder)

return function()
    local builder = NodeBuilder.new()
    builder.ui_name = "Ticker"
    builder:AddInput("Interval", "number")
    builder:AddOutput("Start")
    builder:AddOutput("Tick")
    return builder
end
