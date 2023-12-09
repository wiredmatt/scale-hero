local Character = require "src.game.ent.Character"
require("src.game.enum")

---@class Hero : Character
---@field super Character
---@overload fun(x: number, y: number)
local Hero = Character:extend()

---@param x number
---@param y number
---@param hp? number
---@param atk_melee? number
---@param atk_range? number
---@param def? number
function Hero:new(sprite, x, y, hp, atk_melee, atk_range, def)
  Hero.super.new(self, sprite, x, y, 'idle_base', hp or 100, atk_melee or 10, atk_range or 1, def or 1)
  self.isHero = true
end

return Hero
