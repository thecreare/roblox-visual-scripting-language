return function(ty: string): any
    if ty == "none" then
        return nil
    elseif ty == "any" then
        return true
    elseif ty == "signal" then
        return "signal"
    elseif ty == "boolean" then
        return true
    elseif ty == "string" then
        return ""
    elseif ty == "number" then
        return 0
    elseif ty == "Vector3" then
        return Vector3.zero
    end
    error(`Unsupported type "{ty}"`)
end