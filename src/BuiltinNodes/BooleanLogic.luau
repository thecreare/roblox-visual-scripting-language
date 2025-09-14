local NodeBuilder = require(script.Parent.Parent.NodeBuilder)

return function()
    local nodes = {}

    do -- OR
        local builder = NodeBuilder.new()
        builder:AddVarLenInput("Input", "boolean")
        builder:AddOutput("Result", "boolean")
        builder:AddInputSignal("Compute", function(ctx)
            for _, v in ctx:ExtractInput("Input") do
                if v then
                    ctx:SetOutput("Result", true)
                    return
                end
            end
            ctx:SetOutput("Result", false)
        end)
        builder.ui_name = "Boolean Logic"
        nodes["OR"] = builder
    end

    do -- AND
        local builder = NodeBuilder.new()
        builder:AddVarLenInput("Input", "boolean")
        builder:AddOutput("Result", "boolean")
        builder:AddInputSignal("Compute", function(ctx)
            for _, v in ctx:ExtractInput("Input") do
                if not v then
                    ctx:SetOutput("Result", false)
                    return
                end
            end
            ctx:SetOutput("Result", true)
        end)
        builder.ui_name = "Boolean Logic"
        nodes["AND"] = builder
    end

    do -- NOT
        local builder = NodeBuilder.new()
        builder:AddInput("Input", "boolean")
        builder:AddOutput("Result", "boolean")
        builder:AddInputSignal("Compute", function(ctx)
            ctx:SetOutput("Result", not ctx:ExtractInput("Input"))
        end)
        builder.ui_name = "Boolean Logic"
        nodes["NOT"] = builder
    end

    return nodes
end