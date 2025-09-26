--[[
    NodeBuilders create and store static content about a node,
    such as its description or name.
    They also contain callbacks for the node.
]]

local Types = require(script.Parent.Types)
local GetDefaultForType = require(script.Parent.Util.GetDefaultForType)

type Builder = Types.Builder
type ComputeFunction = Types.ComputeFunction

local Builder = {}
Builder.__index = Builder

function Builder.new(): Builder
    local self: Builder = setmetatable({
        ui_name = "Node",
        ui_description = "Nobody knows how it works...",
        Inputs = {},
        Outputs = {},
    }, Builder) :: any

    return self
end

function Builder.AddInputSignal(self: Builder, name: string, compute: ComputeFunction)
    self.Inputs[name] = {
        Execute = compute,
        Type = "signal",
        Name = name,
        Description = "No Description",
    }
end

function Builder.AddInput(self: Builder, name: string, type: string)
    self.Inputs[name] = {
        Type = type,
        DefaultValue = GetDefaultForType(type),
        Name = name,
        Description = "No Description",
    }
end

function Builder.AddVarLenInput(self: Builder, name: string, type: string)
    
end

function Builder.AddOutput(self: Builder, name: string, type: string?)
    self.Outputs[name] = {
        Type = type or "signal",
        Override = if type then GetDefaultForType(type) else nil,
        Name = name,
        Description = "No Description",
    }
end

function Builder.AddVarLenOutput(self: Builder, name: string, type: string?)
    
end

function Builder.OnGraphRun(self: Builder, run: Types.OnGraphRunFunction)
    self.OnGraphRunCallback = run
end

return Builder :: Builder
