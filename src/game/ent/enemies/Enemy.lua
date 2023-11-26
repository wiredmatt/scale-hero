local Character = require "src.game.ent.Character"
require("src.game.enum")

---@class Enemy : Character
---@field super Character
---@overload fun(x: number, y: number)
local Enemy = Character:extend()

---@param x number
---@param y number
function Enemy:new(sprite, x, y)
  Enemy.super.new(self, sprite, x, y)
  self.isEnemy = true
end

return Enemy
