local NodeBuilder = require(script.Parent.Parent.NodeBuilder)

return function()
    local builder = NodeBuilder.new()
    builder.ui_name = "Condition"
    builder:AddInput("Value", "any")
    builder:AddInput("Compare", "any")
    builder:AddOutput("True")
    builder:AddOutput("False")
    builder:AddInputSignal("Check", function(ctx)
        local a = ctx:ExtractInput("Value")
        local b = ctx:ExtractInput("Compare")
        if a == b then
            ctx:SetOutput("True")
        else
            ctx:SetOutput("False")
        end
    end)
    return builder
end
