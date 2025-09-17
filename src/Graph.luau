--[[
    Container for a list of nodes,
    contains helper functions to connect nodes together
]]

local Node = require(script.Parent.Node)
local Types = require(script.Parent.Types)

type Builder = Types.Builder
type Node = Types.Node
type Connection = Types.Connection

local Graph = {}
Graph.__index = Graph

export type Graph = typeof(setmetatable({} :: {
    --- Node definitions
    NodeDictionary: {[string]: Builder},
    --- Nodes in this graph
    GraphNodes: {Node},
    GraphConnections: {Connection},
    _CleanupFunctions: {() -> ()},
}, Graph))

--- Construct a new node graph
--- @return Graph
function Graph.new(nodes: {[string]: Builder}): Graph
    local self = setmetatable({
        NodeDictionary = nodes,
        GraphNodes = {},
        GraphConnections = {},
        _CleanupFunctions = {},
    }, Graph)

    return self
end

--- Runs the graph, calling all node callbacks
function Graph.Run(self: Graph)
    for _, node in self.GraphNodes do
        if node.Type.OnGraphRunCallback then
            local cleanup = node.Type.OnGraphRunCallback(node)
            table.insert(self._CleanupFunctions, cleanup)
        end
    end
end

--- Cleans up the result of `Graph:Run()`
function Graph.Cleanup(self: Graph)
    for _, fn in self._CleanupFunctions do
        fn()
    end
    table.clear(self._CleanupFunctions)
end

Graph.Destroy = Graph.Cleanup
Graph.destroy = Graph.Cleanup

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
    local connection = {
        TargetNode = node_b,
        TargetPortName = port_b,
        SourceNode = node_a,
        SourcePortName = port_a,
    }
    table.insert(self.GraphConnections, connection)
    table.insert(node_a.Outputs[port_a].Connections, connection)
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
                print(`\t\t\t{connection.TargetNode.Type.ui_name}.{connection.TargetPortName}`)
            end
        end
        print("")
    end
    print("==")
end

return Graph
