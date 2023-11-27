---melee attacks are one square beside the player
local Attacks = {
    ["melee_default"] = {
        max_range = 1, -- how many tiles away from the player
        damage_multiplier = 1 -- 1x character.melee_damage, example: 1x 10 = 10
    },
    ["range_default"] = {
        max_range = 2, -- scales with _G.TILE_SCALE
        damage_multiplier = 1 -- 1x character.range_damage, example: 1x 10 = 10
    }
}

return Attacks