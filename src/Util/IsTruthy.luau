return function(value: any)
    return if typeof(value) == "boolean" then value
        elseif typeof(value) == "number" then value > 0
        elseif typeof(value) == "Vector3" then value:Max(Vector3.zero) ~= Vector3.zero
        elseif typeof(value) == "Vector2" then value:Max(Vector2.zero) ~= Vector2.zero
        elseif typeof(value) == "string" then #value > 0
        else value
end