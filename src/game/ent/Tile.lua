local Base = require "src.game.ent.Base"
require("src.game.enum")

---@class Tile : Base
---@field super Base
---@overload fun(sprite: string, x: number, y: number)
---@overload fun(sprite: string, x: number, y: number, type: TileType)
---@overload fun(sprite: string, x: number, y: number, type: TileType, w: number, h: number)
local Tile = Base:extend()

---@overload fun(self, sprite: string, x: number, y: number)
---@overload fun(self, sprite: string, x: number, y: number, type: TileType)
---@overload fun(self, sprite: string, x: number, y: number, type: TileType, w: number, h: number)
function Tile:new(sprite, x, y, type, w, h)
  self.super.new(self, sprite, x, y, w or _G.TILE_SIZE, h or _G.TILE_SIZE)
  self.type = type or TILE_TYPES.ground
end

return Tile
