local NodeBuilder = require(script.Parent.Parent.NodeBuilder)

local function TwoToOne(fn: (any)->())
    local builder = NodeBuilder.new()
    builder:AddInput("A", "number")
    builder:AddInput("B", "number")
    builder:AddOutput("Result", "number")
    builder:AddInputSignal("Compute", fn)
    return builder
end

local function OneToOne(fn: (any)->())
    local builder = NodeBuilder.new()
    builder:AddInput("Value", "number")
    builder:AddOutput("Result", "number")
    builder:AddInputSignal("Compute", fn)
    return builder
end

return function()
    local nodes = {}

    -- Add
    nodes.Add = TwoToOne(function(ctx)
        local sum = ctx:ExtractInput("A") + ctx:ExtractInput("B")
        ctx:SetOutput("Result", sum)
    end)
    -- Subtract
    nodes.Subtract = TwoToOne(function(ctx)
        local sum = ctx:ExtractInput("A") - ctx:ExtractInput("B")
        ctx:SetOutput("Result", sum)
    end)
    -- Multiply
    nodes.Multiply = TwoToOne(function(ctx)
        local sum = ctx:ExtractInput("A") * ctx:ExtractInput("B")
        ctx:SetOutput("Result", sum)
    end)
    -- Divide
    nodes.Divide = TwoToOne(function(ctx)
        local sum = ctx:ExtractInput("A") / ctx:ExtractInput("B")
        ctx:SetOutput("Result", sum)
    end)
    -- Mod
    nodes.Mod = TwoToOne(function(ctx)
        local sum = ctx:ExtractInput("A") % ctx:ExtractInput("B")
        ctx:SetOutput("Result", sum)
    end)
    
    -- Round
    nodes.Round = OneToOne(function(ctx)
        ctx:SetOutput("Result", math.round(ctx:ExtractInput("Value")))
    end)
    -- Floor
    nodes.Floor = OneToOne(function(ctx)
        ctx:SetOutput("Result", math.floor(ctx:ExtractInput("Value")))
    end)
    -- Ceil
    nodes.Ceil = OneToOne(function(ctx)
        ctx:SetOutput("Result", math.ceil(ctx:ExtractInput("Value")))
    end)

    return nodes
end