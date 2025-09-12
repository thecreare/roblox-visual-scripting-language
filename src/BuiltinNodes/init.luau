local Types = require(script.Parent.Types)

type Builder = Types.Builder

-- Automatically gather nodes
local modules: {[string]: Builder} = {}
for _, module in script:GetDescendants() do
    assert(module:IsA("ModuleScript"), `{module:GetFullName()} Is not a module script`)
    modules[module.Name] = (require)(module)()
end

return modules
