
local SignalEffects = {
    ---@param axis "x" | "y"
    ["hit"] = function (axis)
        return "get_hit_" .. axis
    end
}

return SignalEffects