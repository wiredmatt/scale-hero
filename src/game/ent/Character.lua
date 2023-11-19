local Base = require "src.game.ent.Base"

---@class Character : Base
---@field super Base
---@overload fun(sprite: string, x: number, y: number)
local Character = Base:extend()

---@param x number
---@param y number
function Character:new(sprite, x, y)
  self.super.new(self, sprite, x, y, _G.TILE_SIZE, _G.TILE_SIZE)
end

function Character:getDrawArgs()
  return self.sprite,
      (self.x * _G.TILE_SCALE / _G.CHARACTER_SCALE) + (_G.TILE_SIZE * _G.TILE_SCALE / 2 / _G.CHARACTER_SCALE) -
      (_G.TILE_SCALE > 3 and _G.TILE_SIZE or _G.TILE_SIZE / 1.5),
      (self.y * _G.TILE_SCALE / _G.CHARACTER_SCALE) + (_G.TILE_SIZE * _G.TILE_SCALE / 2 / _G.CHARACTER_SCALE) -
      (_G.TILE_SCALE > 3 and _G.TILE_SIZE or _G.TILE_SIZE / 1.5),
      0, -- CHANGEME
      _G.CHARACTER_SCALE, _G.CHARACTER_SCALE
end

return Character
