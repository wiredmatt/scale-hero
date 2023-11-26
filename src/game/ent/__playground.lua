local Object = require "lib.object"
local pprint = require "lib.pprint"

---@class Point : Object
---@overload fun(x: number, y: number): Point
Point = Object:extend()

---@param x number
---@param y number
function Point:new(x, y)
  self.x = x or 0
  self.y = y or 0
end

-- autocomplete here works because of the @overload annotation
local p = Point(10, 20)
-- otherwise we can do this and we get the same.
-- local p = Point:new(10, 20)

---@class Rect : Point
---@field super Point
---@overload fun(x: number, y: number, width: number, height: number): Rect
Rect = Point:extend()

---@param x number
---@param y number
---@param width number
---@param height number
function Rect:new(x, y, width, height)
  Rect.super.new(self, x, y)
  self.width = width or 0
  self.height = height or 0
end

Hexagon = Rect:extend()
function Hexagon:new(x,y, width, height)
  Hexagon.super.new(self, x, y, width, height)
end

Octagon = Hexagon:extend()
function Octagon:new(x,y, width, height)
  Octagon.super.new(self, x, y, width, height)
  self.isOct = true
end

local rect = Rect(10, 20, 30, 40)

local hex = Hexagon(10, 20, 30, 40)

local oct = Octagon(10, 20, 30, 40)

pprint(oct)