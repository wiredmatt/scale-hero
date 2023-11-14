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

function level:draw()
  for _, v in ipairs(self.data) do
    -- love.graphics.rectangle("line", v.x, v.y, _G.TILE_SIZE, _G.TILE_SIZE)
    Atlas.lib.drawSprite(v.s, v.x, v.y, v.r, v.sx, v.sy)
  end

  love.graphics.rectangle("line", 0, 0, _G.WIDTH, _G.HEIGHT)
end

return level
