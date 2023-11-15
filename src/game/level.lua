local Atlas = require "src.tool.atlas"
local utils = require "src.game.util"
local pprint = require "lib.pprint"

local level = {
  ---@type table<{s: string, x: number,y: number, r: number, sx: number, sy: number}>
  data = {}
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

function level:getCenterTile()
  local x = (math.floor(_G.WIDTH / 2 / _G.TILE_SIZE) * _G.TILE_SIZE) - (_G.TILE_SIZE / 2)
  local y = (math.floor(_G.HEIGHT / 2 / _G.TILE_SIZE) * _G.TILE_SIZE) - (_G.TILE_SIZE / 2)
  return x, y
end

function level:getActiveRegion()
  local cx, cy = self:getCenterTile()

  local x = cx - cx / _G.SCALE + _G.TILE_SIZE / 2 - _G.TILE_SIZE
  local y = cy - cy / _G.SCALE + _G.TILE_SIZE / 2 - 1

  local w = (_G.WIDTH / _G.SCALE + _G.TILE_SIZE * 2) - 1
  local h = (_G.HEIGHT / _G.SCALE + _G.TILE_SIZE * 2) - (_G.TILE_SIZE * 2) + 1

  local q = love.graphics.newQuad(x, y, w, h, 1, 1)

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


    -- Atlas.lib.drawSprite(v.s, v.x, v.y, v.r)
    love.graphics.rectangle("line", v.x, v.y, _G.TILE_SIZE, _G.TILE_SIZE)
  end

  -- local x, y, w, h = self:getActiveRegion()

  -- love.graphics.rectangle("line", x, y, w, h)


  -- local cx, cy = self:getCenterTile()
  -- love.graphics.rectangle("line", cx, cy, _G.TILE_SIZE, _G.TILE_SIZE)


  -- local x, y, w, h = self:getActiveRegion()
  -- love.graphics.rectangle("line", x, y, w, h)

  -- love.graphics.rectangle("line", cx, cy, _G.TILE_SIZE, _G.TILE_SIZE)



  --center tile
  -- love.graphics.rectangle("line", cx, cy, _G.TILE_SIZE, _G.TILE_SIZE)
  -- love.graphics.rectangle("line", cx, cy - _G.TILE_SIZE, _G.TILE_SIZE, _G.TILE_SIZE)
  -- love.graphics.rectangle("line", cx, cy, _G.TILE_SIZE + _G.TILE_SIZE, _G.TILE_SIZE)

  -- 4 tiles right to center
  -- for i = 1, 4 do
  --   love.graphics.rectangle("line", cx + i * _G.TILE_SIZE, cy, _G.TILE_SIZE, _G.TILE_SIZE)
  -- end

  -- -- 4 tiles left to center
  -- for i = 1, 4 do
  --   love.graphics.rectangle("line", cx - i * _G.TILE_SIZE, cy, _G.TILE_SIZE, _G.TILE_SIZE)
  -- end

  -- for i = 1, 4 do
  --   love.graphics.rectangle("line", cx - i * _G.TILE_SIZE, cy - _G.TILE_SIZE, _G.TILE_SIZE, _G.TILE_SIZE)
  -- end


  -- for i = 1, 4 do
  --   love.graphics.rectangle("line", cx - i * _G.TILE_SIZE, cy + _G.TILE_SIZE, _G.TILE_SIZE, _G.TILE_SIZE)
  -- end
end

return level
