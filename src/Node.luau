--[[
    A node is the data structure the graph traverses when running
]]

local Types = require(script.Parent.Types)

type Node = Types.Node
type Connection = Types.Connection
type Builder = Types.Builder

local Node = {}
Node.__index = Node

function Node.new(node_type: Builder): Node
    local PresetInputs = {}
    for a, b in node_type.Inputs do
        PresetInputs[a] = {
            Connections = {},
            Value = b.DefaultValue,
            Type = b,
        }
    end

    local OutputConnections = {}
    for a, b in node_type.Outputs do
        OutputConnections[a] = {
            Connections = {},
            Override = b.DefaultOverride,
            Type = b,
        }
    end

    local self: Node = setmetatable({
        Type = node_type,
        Inputs = PresetInputs,
        Outputs = OutputConnections,
    }, Node) :: any

    return self
end

function Node._SetInput(self: Node, name: string, value: any)
    local Execute = self.Type.Inputs[name].Execute
    if Execute then
        Execute(self)
    else
        self.Inputs[name].Value = value
    end
end

function Node.ExtractInput(self: Node, name: string)
    return self.Inputs[name].Value
end

function Node.SetOutput(self: Node, name: string, value: any?)
    local port = self.Outputs[name]
    local override = port.Override

    -- Only output the provided value if an override isn't provided
    local final = if override == nil then value else override

    -- First, update static values
    for _, connection in port.Connections do
        local execute = connection.TargetNode.Type.Inputs[connection.TargetPortName].Execute
        if not execute then
            connection.TargetNode:_SetInput(connection.TargetPortName, final)
        end
    end

    -- Then, trigger signals
    for _, connection in port.Connections do
        local execute = connection.TargetNode.Type.Inputs[connection.TargetPortName].Execute
        if execute then
            connection.TargetNode:_SetInput(connection.TargetPortName, final)
        end
    end
end

function Node.ExtractVarLenInput(self: Node, name: string, id: number)
    
end

function Node.SetVarLenOutput(self: Node, name: string, id: number, value: any)
    
end

return Node :: Node
