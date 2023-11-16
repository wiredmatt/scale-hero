local Atlas = require "src.tool.atlas"
local utils = require "src.game.utils"
local pprint = require "lib.pprint"

local level = {
  ---@type {s: string, x: number,y: number, r: number, sx: number, sy: number}[]
  data = {},
  current_active_region_q = {
    ---@type love.Quad
    q = nil,
    on_scale = {
      x = _G.SCALE_X,
      y = _G.SCALE_Y
    }
  },
  ---@type table<string, {sb: love.SpriteBatch, quad: love.Quad}>
  batches = {}
}

function level:setup()
  self.data = {}

  for _, v in ipairs(Atlas.names) do
    local img, q = Atlas.lib.getSprite(v)
    self.batches[v] = {
      sb = love.graphics.newSpriteBatch(img,
        5000),
      quad = q
    }
  end

  -- prefill the data table with just ground_base_1
  for i = 0, _G.WIDTH, _G.TILE_SIZE do
    for j = 0, _G.HEIGHT, _G.TILE_SIZE do
      if love.math.random(1, 10) < 3 then
        table.insert(self.data, { x = i, y = j, s = "ground_base_2", r = 0, sx = 1, sy = 1 })
      else
        table.insert(self.data, { x = i, y = j, s = "ground_base_1", r = 0, sx = 1, sy = 1 })
      end
    end
  end

  self:setupSpriteBatch()
end

function level:getActiveRegion()
  if self.current_active_region_q.on_scale == { x = _G.SCALE_X, y = _G.SCALE_Y } and self.current_active_region_q.q then
    return self.current_active_region_q.q
  end

  local x, y = 0, 0

  local w = _G.WIDTH / _G.SCALE_X
  local h = _G.HEIGHT / _G.SCALE_Y

  local q = love.graphics.newQuad(x, y, w, h, _G.WIDTH, _G.HEIGHT)

  self.current_active_region_q = {
    q = q,
    on_scale = {
      x = _G.SCALE_X,
      y = _G.SCALE_Y
    }
  }

  return q
end

function level:update(dt)
  self:setupSpriteBatch()
end

function level:setupSpriteBatch()
  for _, b in pairs(self.batches) do
    b.sb:clear()
  end

  for _, v in ipairs(self.data) do
    local b = self.batches[v.s]

    if utils.isInQuad(self:getActiveRegion(), v.x, v.y, _G.TILE_SIZE, _G.TILE_SIZE) then
      b.sb:setColor(1, 1, 1, 1)
    else
      b.sb:setColor(1, 1, 1, 0.25)
    end

    b.sb:add(b.quad, v.x, v.y)
  end
end

function level:draw()
  local active_region_quad = self:getActiveRegion()

  for _, name in pairs(Atlas.names) do
    local b = self.batches[name]
    -- print("drawing", name, b.sb:getCount())
    love.graphics.setColor(1, 1, 1, 1)
    love.graphics.draw(b.sb)
  end

  -- for _, v in ipairs(self.data) do
  --   local style = "line"

  --   if utils.isInQuad(active_region_quad, v.x, v.y, _G.TILE_SIZE, _G.TILE_SIZE) then
  --     love.graphics.setColor(1, 1, 1, 1)
  --     style = "line"
  --   else
  --     -- darken the tile
  --     love.graphics.setColor(0, 0, 0, 0.75)
  --     style = "fill"
  --   end

  --   love.graphics.rectangle(style, v.x, v.y, _G.TILE_SIZE, _G.TILE_SIZE)
  -- end

  -- local x, y, w, h = active_region_quad:getViewport()

  -- love.graphics.setColor(1, 0.2, 0.8, 1)
  -- love.graphics.rectangle("line", x, y, w, h)
end

return level
