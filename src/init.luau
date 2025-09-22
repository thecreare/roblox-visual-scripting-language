--[[
    Root module
]]

local BuiltinNodes = require(script.BuiltinNodes) -- should this be required even if bool is false?
local Graph = require(script.Graph)
local NodeBuilder = require(script.NodeBuilder)
local Types = require(script.Types)

export type Builder = Types.Builder
export type Node = Types.Node
export type Graph = Graph.Graph

local Language = {}
Language.__index = Language

--- Create a new node. Remember to register it with `Language:RegisterNode(name, node)`
--- @return new Node
Language.BuildNode = NodeBuilder.new

export type Language = typeof(setmetatable({} :: {
    Nodes: {[string]: Builder}
}, Language))

function Language.new(load_builtin_nodes: boolean): Language
    local self = setmetatable({
        Nodes = {},
    }, Language)

    if load_builtin_nodes then
        for name, node in BuiltinNodes do
            self.Nodes[name] = node
        end
    end

    return self
end

--- Registers a new node so it can be used by the language
function Language.RegisterNode(self: Language, name: string, node: Builder)
    assert(not self.Nodes[name], `Node "{name}" already exists`)
    self.Nodes[name] = node
end

--- Creates a blank graph that can be populated with Nodes
--- @return Graph
function Language.CreateBlankGraph(self: Language)
    local graph = Graph.new(self.Nodes)
    return graph
end

return Language
