local Types = require(script.Parent.Types)

type Builder = Types.Builder

-- Automatically gather nodes
local modules: {[string]: Builder} = {}
for _, module in script:GetDescendants() do
    assert(module:IsA("ModuleScript"), `{module:GetFullName()} Is not a module script`)
    local required = (require)(module)()

    -- Temporarily just un-nest the nested node definitions
    -- until we get proper node variant support
    if required.Inputs == nil then
        for name, node in required do
            modules[name] = node
        end
    else
        modules[module.Name] = required
    end
end

return modules
