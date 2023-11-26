local Character = require "src.game.ent.Character"
require("src.game.enum")

---@class EnemyCacti : Character
---@field super Character
---@overload fun(x: number, y: number)
local EnemyCacti = Character:extend()

---@param x number
---@param y number
function EnemyCacti:new(x, y)
  EnemyCacti.super.new(self, SPRITE_NAMES.enemy_cacti, x, y)
end

return EnemyCacti
