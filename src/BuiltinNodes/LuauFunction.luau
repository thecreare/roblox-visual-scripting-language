local NodeBuilder = require(script.Parent.Parent.NodeBuilder)

local function ExecuteLuauCode(code: string, env: any)
    error("TODO")
end

return function()
    local builder = NodeBuilder.new()

    builder:AddInput("Code", "string")
    builder:AddVarLenInput("Inputs", "any")
    builder:AddVarLenOutput("Outputs", "any")
    builder:AddInputSignal("Run", function(ctx)
        local luau_env = {
            Node = {
                read = function(id: number)
                    return ctx:ExtractVarLenInput("Inputs", id)
                end,
                write = function(id: number, value: any)
                    ctx:SetVarLenOutput("Outputs", id, value)
                end
            }
        }
        ExecuteLuauCode(ctx:ExtractInput("Code"), luau_env)
    end)
    builder.ui_name = "Lua Function"
    return builder
end
