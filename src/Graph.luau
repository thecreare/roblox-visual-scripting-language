--[[
    Container for a list of nodes,
    contains helper functions to connect nodes together
]]

local Package = script.Parent
local signal = require(Package.Parent.signal)
local Node = require(Package.Node)
local Types = require(Package.Types)

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

    ConnectionAdded: signal.Signal<Connection>,
    ConnectionRemoved: signal.Signal<Connection>,
    NodeAdded: signal.Signal<Node>,
    NodeRemoved: signal.Signal<Node>,
}, Graph))

--- Construct a new node graph
--- @return Graph
function Graph.new(nodes: {[string]: Builder}): Graph
    local self = setmetatable({
        NodeDictionary = nodes,
        GraphNodes = {},
        GraphConnections = {},
        _CleanupFunctions = {},

        ConnectionAdded = signal.new(),
        ConnectionRemoved = signal.new(),
        NodeAdded = signal.new(),
        NodeRemoved = signal.new(),
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
    table.insert(node_b.Inputs[port_b].Connections, connection)
    self.ConnectionAdded:Fire(connection)
end

function Graph.RemoveConnection(self: Graph, connection: Connection)
    local function remove(haystack: {Connection}, needle: Connection)
        local index = table.find(haystack, connection)
        if index then
            table.remove(haystack, index)
        end
    end

    self.ConnectionRemoved:Fire(connection)
    remove(self.GraphConnections, connection)
    remove(connection.SourceNode.Outputs[connection.SourcePortName].Connections, connection)
    remove(connection.TargetNode.Inputs[connection.TargetPortName].Connections, connection)    
end

function Graph.GetConnectionBetween(self: Graph, node_a: Node, port_a: string, node_b: Node, port_b: string): Connection?
    for _, connection in node_a.Outputs[port_a].Connections do
        if connection.TargetNode == node_b and connection.TargetPortName == port_b then
            return connection
        end
    end
    return nil
end

function Graph.DisconnectNodes(self: Graph, node_a: Node, port_a: string, node_b: Node, port_b: string)
    local connection = self:GetConnectionBetween(node_a, port_a, node_b, port_b)
    if connection then
        self:RemoveConnection(connection)
    end
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
