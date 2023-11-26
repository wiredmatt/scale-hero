local Enemy = require "src.game.ent.enemies.Enemy"
require("src.game.enum")

---@class EnemyCacti : Enemy
---@field super Enemy
---@overload fun(x: number, y: number)
local EnemyCacti = Enemy:extend()

---@param x number
---@param y number
function EnemyCacti:new(x, y)
  EnemyCacti.super.new(self, SpriteName.enemy_cacti, x, y)
end

return EnemyCacti
