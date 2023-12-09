local Character = require "src.game.ent.Character"
require("src.game.enum")

---@class Enemy : Character
---@field super Character
---@overload fun(x: number, y: number)
local Enemy = Character:extend()

---@param x number
---@param y number
---@param hp? number
---@param atk_melee? number
---@param atk_range? number
---@param def? number
function Enemy:new(sprite, x, y, hp, atk_melee, atk_range, def)
  Enemy.super.new(self, sprite, x, y, 'idle_base', hp or 1, atk_melee or 10, atk_range or 1, def or 1)
  self.isEnemy = true
end

return Enemy
