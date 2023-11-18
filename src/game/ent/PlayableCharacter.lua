local Base = require "src.game.ent.Base"

---@class PlayableCharacter : Base
---@field super Base
local PlayableCharacter = Base:extend()

---@param x number
---@param y number
function PlayableCharacter:new(sprite, x, y)
  self.super.new(self, sprite, x, y, _G.TILE_SIZE, _G.TILE_SIZE)
end

return PlayableCharacter
