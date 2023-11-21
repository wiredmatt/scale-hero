local Base = require "src.game.ent.Base"
local flux = require "lib.flux"

---@class Character : Base
---@field super Base
---@overload fun(sprite: string, x: number, y: number)
local Character = Base:extend()

---@param x number
---@param y number
function Character:new(sprite, x, y)
  self.super.new(self, sprite, x, y, _G.TILE_SIZE, _G.TILE_SIZE)
  self.sx = _G.CHARACTER_SCALE
  self.sy = _G.CHARACTER_SCALE
end

---@return SpriteName, number, number, number, number, number, number, number, number, number
function Character:getDrawArgs()
  ---@format disable
  return self.sprite,
      (self.x * _G.TILE_SCALE / _G.CHARACTER_SCALE) +
      (_G.TILE_SIZE * _G.TILE_SCALE / 2 / _G.CHARACTER_SCALE) -
      (_G.TILE_SCALE > 3 and _G.TILE_SIZE or _G.TILE_SIZE / 1.5),

      (self.y * _G.TILE_SCALE / _G.CHARACTER_SCALE) +
      (_G.TILE_SIZE * _G.TILE_SCALE / 2 / _G.CHARACTER_SCALE) -
      (_G.TILE_SCALE > 3 and _G.TILE_SIZE or _G.TILE_SIZE / 1.5),

      0, -- CHANGEME

      self.sx, self.sy,
      self.ox, self.oy,
      self.kx, self.ky
  ---@format enable
end

function Character:idle()
  if self.isTweenOngoing then
    return
  end

  flux.to(self, 0.5, { sy = self.sy + 0.125 }):ease("quadinout"):onstart(function()
    self.isTweenOngoing = true
  end):oncomplete(function()
    flux.to(self, 0.5, { sy = self.sy - 0.125 }):ease("quadinout"):oncomplete(function()
      self.isTweenOngoing = false
    end)
  end)
end

function Character:update(dt)
  self:idle()
end

return Character
