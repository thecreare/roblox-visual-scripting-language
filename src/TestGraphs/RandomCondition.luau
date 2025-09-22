local VisualScriptingLanguage = require(script.Parent.Parent)

return function()
    local language = VisualScriptingLanguage.new(true)
    local graph = language:CreateBlankGraph()

    local ticker_node = graph:CreateNode("Ticker")
    local rng_node = graph:CreateNode("Random")
    local condition_node = graph:CreateNode("Condition")
    local print_false_node = graph:CreateNode("Print")
    local print_true_node = graph:CreateNode("Print")

    ticker_node.Position = Vector2.new(0, 150)

    rng_node:_SetInput("Min", 1)
    rng_node:_SetInput("Max", 2)
    rng_node:_SetInput("Step", 1)
    rng_node.Position = Vector2.new()

    condition_node:_SetInput("Compare", 1)
    condition_node:_SetInput("Value", 99) -- guarantee
    condition_node.Position = Vector2.new(300, 0)

    print_true_node:_SetInput("Message", "Value is True")
    print_false_node:_SetInput("Message", "Value is False")
    print_true_node.Position = Vector2.new(300, 100)
    print_false_node.Position = Vector2.new(300, 200)

    graph:ConnectNodes(ticker_node, "Tick", rng_node, "Generate")
    graph:ConnectNodes(rng_node, "Result", condition_node, "Value")
    graph:ConnectNodes(rng_node, "Result", condition_node, "Check")
    graph:ConnectNodes(condition_node, "True", print_true_node, "Log")
    graph:ConnectNodes(condition_node, "False", print_false_node, "Log")

    return graph
end
