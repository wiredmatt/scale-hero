local Enemy = require "src.game.ent.enemies.Enemy"
local WithMelee = require "src.game.ent.mix.WithMelee"
require("src.game.enum")

---@class EnemyGhost : Enemy, WithMelee
---@field super Enemy
---@overload fun(x: number, y: number): EnemyGhost
local EnemyGhost = Enemy:extend()
EnemyGhost:implement(WithMelee)

---@param x number
---@param y number
function EnemyGhost:new(x, y)
    EnemyGhost.super.new(self, SpriteName.enemy_ghost, x, y, 20)
    self:applyMelee()
end

return EnemyGhost
