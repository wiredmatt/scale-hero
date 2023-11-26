local Character = require "src.game.ent.Character"
require("src.game.enum")

---@class Hero : Character
---@field super Character
---@overload fun(x: number, y: number)
local Hero = Character:extend()

---@param x number
---@param y number
function Hero:new(sprite, x, y)
  Hero.super.new(self, sprite, x, y)
  self.isHero = true
end

return Hero
