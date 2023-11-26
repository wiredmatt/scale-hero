local Hero = require "src.game.ent.heroes.Hero"
local WithMelee = require "src.game.ent.mix.WithMelee"

require("src.game.enum")

---@class HeroBob : Hero, WithMelee
---@field super Hero
---@overload fun(x: number, y: number)
local HeroBob = Hero:extend()
HeroBob:implement(WithMelee)

---@param x number
---@param y number
function HeroBob:new(x, y)
  HeroBob.super.new(self, SpriteName.hero_bob, x, y)
  self:applyMelee()
end

return HeroBob
