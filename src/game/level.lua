local Atlas = require "src.tool.atlas"
local utils = require "src.game.utils"
local Tile = require "src.game.ent.Tile"
local Party = require "src.game.ent.Party"
local Character = require "src.game.ent.Character"



local level = {
  ---@type Tile[]
  ground_tiles = {},     -- all ground tiles
  ---@type Tile[]
  selectable_tiles = {}, -- ground tiles that are in the active region
  ---@type Tile
  hovered_tile = nil,    -- the tile the mouse is currently hovering over
  ---@type table<string, {sb: love.SpriteBatch, quad: love.Quad}>
  batches = {},          -- spritebatches for each type of tile, improves performance vastly.
  current_active_region_q = {
    ---@type love.Quad
    q = nil,
    on_scale = {
      x = _G.SCALE_X,
      y = _G.SCALE_Y
    }
  }, -- active region is basically what's fully on screen (tiles that don't fit 100% are shown with a darker color)
  ---@type Party
  hero_party = nil,
  ---@type table<number, Party>
  enemy_parties = {} -- enemy "waves" - each wave is a party of enemies that will spawn at a certain scale.
}

function level:setup()
  -- generate the spritebatches for each tile we want to draw
  for _, v in ipairs(Atlas.ground_keys) do
    local img, q = Atlas.lib.getSprite(v)
    self.batches[v] = {
      sb = lg.newSpriteBatch(img,
        5000),
      quad = q
    }
  end

  -- prefill the ground_tiles table with random ground tiles
  for i = 0, _G.WIDTH, _G.TILE_SIZE do
    for j = 0, _G.HEIGHT, _G.TILE_SIZE do
      if love.math.random(1, 10) < 3 then
        table.insert(self.ground_tiles, Tile("ground_base_2", i, j, TILE_TYPES.ground))
      else
        table.insert(self.ground_tiles, Tile("ground_base_1", i, j, TILE_TYPES.ground))
      end
    end
  end

  self.hero_party = Party()

  local hero_knight = Character("hero_knight", 0, 0)

  self:setupSpriteBatch()
end

function level:getActiveRegion()
  if self.current_active_region_q.on_scale.x == _G.SCALE_X and self.current_active_region_q.on_scale.y == _G.SCALE_Y and self.current_active_region_q.q ~= nil then
    return self.current_active_region_q.q
  end

  local x, y, w, h = 0, 0, _G.WIDTH / _G.SCALE_X, _G.HEIGHT / _G.SCALE_Y

  local q = lg.newQuad(x, y, w, h, _G.WIDTH, _G.HEIGHT)

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

-- since this is called every frame, we want to make sure we only update the spritebatch if the active region has changed, otherwise there's no need to re-process everything.
function level:setupSpriteBatch()
  if self.current_active_region_q.q == self:getActiveRegion() then
    return
  end

  ---@type Tile[]
  local __selectable_tiles = {}

  for _, b in pairs(self.batches) do
    b.sb:clear()
  end

  for _, v in ipairs(self.ground_tiles) do
    local b = self.batches[v.sprite]

    if utils.isInQuad(self:getActiveRegion(), v.x, v.y, _G.TILE_SIZE, _G.TILE_SIZE) then
      b.sb:setColor(1, 1, 1, 1)
      table.insert(__selectable_tiles, v)
    else
      b.sb:setColor(1, 1, 1, 0.25)
    end

    b.sb:add(b.quad, v.x, v.y)
  end

  self.selectable_tiles = __selectable_tiles
end

function level:draw()
  lg.setColor(1, 1, 1, 1)

  for _, name in pairs(Atlas.ground_keys) do
    local b = self.batches[name]
    lg.draw(b.sb)
  end

  local active_region_quad = self:getActiveRegion()

  -- debug all tiles
  -- for _, v in ipairs(self.selectable_tiles) do
  --   local style = "line"
  --   love.graphics.setColor(1, 1, 1, 1)

  --   -- if utils.isInQuad(active_region_quad, v.x, v.y, _G.TILE_SIZE, _G.TILE_SIZE) then
  --   --   style = "line"
  --   -- else
  --   --   -- darken the tile
  --   --   love.graphics.setColor(0, 0, 0, 0.75)
  --   --   style = "fill"
  --   -- end

  --   love.graphics.rectangle(style, v.x, v.y, _G.TILE_SIZE, _G.TILE_SIZE)
  -- end

  -- debug active viewport
  local x, y, w, h = active_region_quad:getViewport()
  lg.setColor(1, 0.2, 0.8, 1)
  lg.rectangle("line", x, y, w, h)

  -- local mouseX, mouseY = love.mouse.getPosition()
  -- local correctedMouseX, correctedMouseY = (mouseX / _G.SCALE_X), (mouseY / _G.SCALE_Y)
  -- debug mouse position
  -- love.graphics.rectangle("fill", correctedMouseX, correctexMouseY, 0.25, 0.25)

  if self.hovered_tile ~= nil then
    lg.setColor(1, 1, 1, 1)
    lg.rectangle("line", self.hovered_tile.x, self.hovered_tile.y, _G.TILE_SIZE, _G.TILE_SIZE)
  end

  Atlas.lib.drawSprite(SPRITE_NAMES.hero_knight, self.selectable_tiles[1].x + 2, self.selectable_tiles[1].y + 2, 0, 1, 1)
end

---@param x number
---@param y number
---@param dx number
---@param dy number
---@param istouch boolean
function level:mousemoved(x, y, dx, dy, istouch)
  self.hovered_tile = nil

  local correctedMouseX, correctedMouseY = (x / _G.SCALE_X), (y / _G.SCALE_Y)

  -- check if the mouse position is still inside the previously selected tile, to avoid looping again unnecesarily
  if self.hovered_tile ~= nil then
    local tileQuad = lg.newQuad(self.hovered_tile.x, self.hovered_tile.y, _G.TILE_SIZE, _G.TILE_SIZE, 1, 1)

    if utils.isInQuad(tileQuad, correctedMouseX, correctedMouseY, 0.25, 0.25) then
      return
    end
  end

  for _, v in ipairs(self.selectable_tiles) do
    local tileQuad = lg.newQuad(v.x, v.y, _G.TILE_SIZE, _G.TILE_SIZE, 1, 1)

    if utils.isInQuad(tileQuad, correctedMouseX, correctedMouseY, 0.25, 0.25) then
      self.hovered_tile = v
      break
    end
  end
end

return level
