local Atlas = require "src.tool.atlas"
local utils = require "src.game.util"
local pprint = require "lib.pprint"

local level = {
  ---@type table<{s: string, x: number,y: number, r: number, sx: number, sy: number}>
  data = {},
  current_active_region_q = {
    ---@type love.Quad
    q = nil,
    on_scale = _G.SCALE
  }
}

function level:setup()
  self.data = {}

  -- step 1: prefill the data table with just ground_base_1
  for i = 0, _G.WIDTH, _G.TILE_SIZE do
    for j = 0, _G.HEIGHT, _G.TILE_SIZE do
      table.insert(self.data, { x = i, y = j, s = "ground_base_1", r = 0, sx = 1, sy = 1 })
    end
  end

  -- step 2: replace some tiles with ground_base_2
  for i = 0, _G.WIDTH, _G.TILE_SIZE do
    for j = 0, _G.HEIGHT, _G.TILE_SIZE do
      if love.math.random(1, 10) < 3 then
        table.insert(self.data, { x = i, y = j, s = "ground_base_2", r = 0, sx = 1, sy = 1 })
      end
    end
  end

  pprint(#self.data)
end

function level:getActiveRegion()
  if self.current_active_region_q.on_scale == _G.SCALE and self.current_active_region_q.q then
    return self.current_active_region_q.q
  end

  local x, y = 0, 0

  local w = _G.WIDTH / _G.SCALE
  local h = _G.HEIGHT / _G.SCALE

  local q = love.graphics.newQuad(x, y, w, h, _G.WIDTH, _G.HEIGHT)

  self.current_active_region_q = {
    q = q,
    on_scale = _G.SCALE
  }

  return q
end

function level:draw()
  local active_region_quad = self:getActiveRegion()

  for _, v in ipairs(self.data) do
    if utils.isInQuad(active_region_quad, v.x, v.y, _G.TILE_SIZE, _G.TILE_SIZE) then
      love.graphics.setColor(1, 1, 1, 1)
    else
      -- darken the tile
      love.graphics.setColor(0.5, 0.5, 0.5, 1)
    end

    Atlas.lib.drawSprite(v.s, v.x, v.y, v.r)

    love.graphics.setColor(0, 0, 0, 1)
    love.graphics.rectangle("line", v.x, v.y, _G.TILE_SIZE, _G.TILE_SIZE)
  end

  local x, y, w, h = active_region_quad:getViewport()

  love.graphics.setColor(1, 0.2, 0.8, 1)
  love.graphics.rectangle("line", x, y, w, h)
end

return level
