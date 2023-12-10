local Enemy = require "src.game.ent.enemies.Enemy"
local WithMelee = require "src.game.ent.mix.WithMelee"
require("src.game.enum")

---@class EnemyCacti : Enemy, WithMelee
---@field super Enemy
---@overload fun(x: number, y: number)
local EnemyCacti = Enemy:extend()
EnemyCacti:implement(WithMelee)

---@param x number
---@param y number
function EnemyCacti:new(x, y)
  EnemyCacti.super.new(self, SpriteName.enemy_cacti, x, y, 10)
  self:applyMelee()
end

return EnemyCacti
