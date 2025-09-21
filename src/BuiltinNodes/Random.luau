local NodeBuilder = require(script.Parent.Parent.NodeBuilder)

local random = Random.new()

return function()
    local builder = NodeBuilder.new()
    builder:AddInput("Min", "number")
    builder:AddInput("Max", "number")
    builder:AddInput("Step", "number")
    builder:AddOutput("Result", "number")
    builder:AddInputSignal("Generate", function(ctx)
        local min = ctx:ExtractInput("Min")
        local max = ctx:ExtractInput("Max")
        local step = ctx:ExtractInput("Step")
        if step == 0 then
            ctx:SetOutput("Result", random:NextNumber(min, max))
        else
            ctx:SetOutput("Result", random:NextInteger(min / step, max / step) * step)
        end
    end)
    builder.ui_name = "Random"
    return builder
end
