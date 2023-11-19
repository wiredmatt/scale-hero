local Base = require "src.game.ent.Base"

---@class Character : Base
---@field super Base
local Character = Base:extend()

---@param x number
---@param y number
function Character:new(sprite, x, y)
  self.super.new(self, sprite, x, y, _G.TILE_SIZE, _G.TILE_SIZE)
end

return Character
