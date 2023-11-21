local WithID = require "src.game.ent.WithID"

---@class Base : WithID
---@field super WithID
Base = WithID:extend()

---@param sprite string
---@param x number
---@param y number
---@param width number
---@param height number
---@param rotation ?number
---@param sx ?number
---@param sy ?number
---@param ox ?number
---@param oy ?number
---@param kx ?number
---@param ky ?number
function Base:new(sprite, x, y, width, height, rotation, sx, sy, ox, oy, kx, ky)
  Base.super.new(self)
  self.sprite = sprite
  self.x = x or 0
  self.y = y or 0
  self.width = width
  self.height = height
  self.rotation = rotation or 0
  self.ox = ox or 0
  self.oy = oy or 0
  self.sx = sx or 1
  self.sy = sy or 1
  self.kx = kx or 0
  self.ky = ky or 0
  self.isTweenOngoing = false
end

function Base:update(dt)

end

return Base
