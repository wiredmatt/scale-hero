---@class Attack
---@field max_range number
---@field damage_multiplier number
---@field damage number?

---@param base_key string
---@param from Character
---@param to Character
---@return AnimationKey
local get_melee_animation = function(base_key, from, to)
    local animation = base_key

    if from.y == to.y then
        if from.x < to.x then
            animation = animation .. "right"
        else
            animation = animation .. "left"
        end
    elseif from.x == to.x then
        if from.y < to.y then
            animation = animation .. "down"
        else
            animation = animation .. "up"
        end
    else
        if from.y < to.y then     -- from is above
            animation = animation .. "down_"
            if from.x < to.x then -- from is to the left
                animation = animation .. "right"
            else                  -- from is to the right
                animation = animation .. "left"
            end
        else
            animation = animation .. "up_"
            if from.x < to.x then -- from is to the left
                animation = animation .. "right"
            else                  -- from is to the right
                animation = animation .. "left"
            end
        end
    end

    return animation
end

---melee attacks are one square beside the player
local Attacks = {
    ["melee_default"] = {
        max_range = 1,         -- how many tiles away from the player
        damage_multiplier = 1, -- 1x character.melee_damage, example: 1x 10 = 10
        ---@param from Character
        ---@param to Character
        get_animation = function(from, to)
            return get_melee_animation("hit_", from, to)
        end
    },
    ["range_default"] = {
        max_range = 2, -- scales with _G.TILE_SCALE
        damage_multiplier = 1,
        ---@param from Character
        ---@param to Character
        get_animation = function(from, to)
            return get_melee_animation("hit_", from, to)
        end
    }
}

return Attacks
