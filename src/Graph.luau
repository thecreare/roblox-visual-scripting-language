--[[
    Container for a list of nodes,
    contains helper functions to connect nodes together
]]

local Node = require(script.Parent.Node)
local Types = require(script.Parent.Types)

type Builder = Types.Builder
type Node = Types.Node

local Graph = {}
Graph.__index = Graph

export type Graph = typeof(setmetatable({} :: {
    --- Node definitions
    NodeDictionary: {[string]: Builder},
    --- Nodes in this graph
    GraphNodes: {Node},
}, Graph))

--- Construct a new node graph
--- @return Graph
function Graph.new(nodes: {[string]: Builder}): Graph
    local self = setmetatable({
        NodeDictionary = nodes,
        GraphNodes = {},
    }, Graph)

    return self
end

--- Creates a new Node and adds it to the graph
--- @return Node
function Graph.CreateNode(self: Graph, node_name: string)
    local node_type = self.NodeDictionary[node_name]

    local node = Node.new(node_type)
    table.insert(self.GraphNodes, node)
    return node
end

--- Connects two nodes together
function Graph.ConnectNodes(self: Graph, node_a: Node, port_a: string, node_b: Node, port_b: string)
    assert(node_a.Outputs[port_a], `{node_a.Type.ui_name}.{port_a} Is not a valid output property`)
    table.insert(node_a.Outputs[port_a].Connections, {
        Node = node_b,
        TargetPortName = port_b,
    })
end

--- Prints the entire graph to the console
function Graph.Debug(self: Graph)
    print("\n\nDebugging graph...\n")
    for i, node in self.GraphNodes do
        local input_count = 0
        local input_vals = {}
        for name, port in node.Inputs do
            input_count += 1
            table.insert(input_vals, `{name}:{node.Type.Inputs[name].Type}="{port.Value}"`)
        end
        print(`#{i} "{node.Type.ui_name}" with {input_count} inputs ({table.concat(input_vals, ", ")})`)
        for output_id, port in node.Outputs do
            print(`\t\tOutput "{output_id}" ->`)
            for _, connection in port.Connections do
                print(`\t\t\t{connection.Node.Type.ui_name}.{connection.TargetPortName}`)
            end
        end
        print("")
    end
    print("==")
end

return Graph
