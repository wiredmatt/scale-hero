local Object = require "lib.object"

---@class Base : Object
Base = Object:extend()

---@param sprite string
---@param x number
---@param y number
---@param width number
---@param height number
function Base:new(sprite, x, y, width, height)
  self.sprite = sprite
  self.x = x or 0
  self.y = y or 0
  self.width = width
  self.height = height
end

return Base
