--[[
    Types file, primarily needs to exist for Node and NodeBuilder
    without this they would circularly reference each other
]]

-- MARK: Node Definition
export type ComputeFunction = (Node) -> ()
export type OnGraphRunFunction = (Node) -> (() -> ())
export type BuilderPortInput = {
    Execute: ((Node) -> ())?,
    DefaultValue: any?,
    Type: string,
    Name: string,
    Description: string,
}
export type BuilderPortOutput = {
    DefaultOverride: any?,
    Type: string?,
    Name: string,
    Description: string,
}
export type Builder = {
    ui_name: string,
    ui_description: string,
    Inputs: {[string]: BuilderPortInput},
    Outputs: {[string]: BuilderPortOutput},
    OnGraphRunCallback: OnGraphRunFunction?,

    __index: Builder,

    --- Creates a new node definition.
    --- These are used to store constant data about a node,
    --- such as its description or execution code
    --- @return Builder
    new: () -> Builder,
    --- Add an input port to this node that will call `compute` when it receives a signal
    AddInputSignal: (self: Builder, name: string, compute: ComputeFunction) -> (),
    --- Add an input port to this node
    AddInput: (self: Builder, name: string, type: string) -> (),
    --- TODO Same as `AddInput` except for var lens
    AddVarLenInput: (self: Builder, name: string, type: string) -> (),
    --- Adds an output port to this node.
    --- Output ports act like event/signal sources,
    --- when they are triggered, they send a message to every connected port.
    AddOutput: (self: Builder, name: string, type: string?) -> (),
    --- Set a callback that runs on each instance of this node when the graph runs.
    --- Useful for binding to events and things.
    --- Should return a cleanup function.
    OnGraphRun: (self: Builder, run: OnGraphRunFunction) -> (),
    --- TODO Same as `AddOutput` except for var lens
    AddVarLenOutput: (self: Builder, name: string, type: string?) -> (),
}

-- MARK: Compute Node

export type PortInput = {
    Value: any?,
}

export type Connection = {
    Node: Node,
    TargetPortName: string,
}

export type PortOutput = {
    --- For this port, every input that it connects to
    Connections: {Connection},
    Override: any?,
}

export type Node = {
    --- Maps this node to its definition
    Type: Builder,
    --- Map name of input to its value
    Inputs: {[string]: PortInput},
    --- Map name of output to its connections
    Outputs: {[string]: PortOutput},
    
    __index: Node,

    --- Creates a new Node, nodes are the data structure the graph traverses when running
    --- @return Node
    new: (node_type: Builder) -> Node,
    --- Sets the value of a port on this node.
    --- `SetOutput` uses this method to send data to its connections.
    --- Automatically choses wether to set a port property or call a port function.
    _SetInput: (self: Node, name: string, value: any) -> (),
    --- Gets the value of one of this node's input ports
    ExtractInput: (self: Node, name: string) -> any,
    --- Sends a signal to every port connected to this port
    SetOutput: (self: Node, name: string, value: any?) -> (),
    --- TODO Same as ExtractInput but operates on var lens
    ExtractVarLenInput: (self: Node, name: string, id: number) -> any,
    --- TODO Same as SetOutput but operates on var lens
    SetVarLenOutput: (self: Node, name: string, id: number, value: any) -> (),
}

return nil