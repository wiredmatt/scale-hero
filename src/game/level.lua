local Atlas = require "src.tool.atlas"
local utils = require "src.game.utils"
local Tile = require "src.game.ent.Tile"
local Party = require "src.game.ent.Party"
local Character = require "src.game.ent.Character"
local uuid = require "lib.uuid"
local logger = require "src.tool.logger"

local mouseX, mouseY = 0, 0

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
      x = _G.TILE_SCALE,
      y = _G.TILE_SCALE
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
      sb = lg.newSpriteBatch(img, 2000),
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

  -- generate the spritebatches for each enemy character we want to draw
  for _, v in ipairs(Atlas.character_keys) do
    local img, q = Atlas.lib.getSprite(v)

    self.batches[v] = {
      sb = lg.newSpriteBatch(img, 2000),
      quad = q
    }
  end

  self.hero_party = Party(
    {
      [uuid()] = Character("hero_bob", 0, 0),
      -- [uuid()] = Character("hero_knight", 16, 0),
      -- [uuid()] = Character("hero_knight", 32, 0),
    }
  )

  self.enemy_parties = {
    [_G.INITIAL_TILE_SCALE] = Party({
      [uuid()] = Character("enemy_cacti", 32, 16),
    }),
    [16] = Party({
      [uuid()] = Character("enemy_cacti", 16, 0),
      [uuid()] = Character("enemy_cacti", 32, 0),
      [uuid()] = Character("enemy_bat", 48, 0),
      [uuid()] = Character("enemy_bat", 64, 0),
    })
  }

  self:setupTileSpriteBatches()
  self:setupCharacterSpriteBatches()
end

function level:getActiveRegion()
  if self.current_active_region_q.on_scale.x == _G.TILE_SCALE and self.current_active_region_q.on_scale.y == _G.TILE_SCALE and self.current_active_region_q.q ~= nil then
    return self.current_active_region_q.q
  end

  local x, y, w, h = 0, 0, _G.WIDTH / _G.TILE_SCALE, _G.HEIGHT / _G.TILE_SCALE

  local q = lg.newQuad(x, y, w, h, _G.WIDTH, _G.HEIGHT)

  self.current_active_region_q = {
    q = q,
    on_scale = {
      x = _G.TILE_SCALE,
      y = _G.TILE_SCALE
    }
  }

  return q
end

function level:update(dt)
  for _, hero in pairs(self.hero_party.members) do
    hero:update(dt)
  end

  if self.enemy_parties[_G.TILE_SCALE] ~= nil then
    for _, enemy in pairs(self.enemy_parties[_G.TILE_SCALE].members) do
      enemy:update(dt)
    end
  end

  self:setupTileSpriteBatches()
  self:setupCharacterSpriteBatches()
end

-- since this is called every frame, we want to make sure we only update the spritebatch if the active region has changed, otherwise there's no need to re-process everything.
function level:setupCharacterSpriteBatches()
  for _, name in ipairs(Atlas.character_keys) do
    local b = self.batches[name]

    if b ~= nil then
      b.sb:clear()
    else
      logger:error("batch is nil for " .. name)
    end
  end

  if self.enemy_parties[_G.TILE_SCALE] ~= nil then
    for _, enemy in pairs(self.enemy_parties[_G.TILE_SCALE].members) do
      local b = self.batches[enemy.sprite]
      local _, x, y, r, sx, sy, ox, oy, kx, ky = enemy:getDrawArgs()
      b.sb:add(b.quad, x, y, r, sx, sy, ox, oy, kx, ky)
    end
  end

  for _, hero in pairs(self.hero_party.members) do
    local b = self.batches[hero.sprite]
    local _, x, y, r, sx, sy, ox, oy, kx, ky = hero:getDrawArgs()
    b.sb:add(b.quad, x, y, r, sx, sy, ox, oy, kx, ky)
  end
end

function level:setupTileSpriteBatches()
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

function level:draw_tiles()
  lg.setColor(1, 1, 1, 1)

  for _, name in pairs(Atlas.ground_keys) do
    local b = self.batches[name]
    lg.draw(b.sb)
  end

  -- local active_region_quad = self:getActiveRegion()

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
  -- local x, y, w, h = active_region_quad:getViewport()
  -- lg.setColor(1, 0.2, 0.8, 1)
  -- lg.rectangle("line", x, y, w, h)

  -- local mouseX, mouseY = love.mouse.getPosition()
  -- local correctedMouseX, correctedMouseY = (mouseX / _G.TILE_SCALE), (mouseY / _G.TILE_SCALE)
  -- debug mouse position
  -- love.graphics.rectangle("fill", correctedMouseX, correctexMouseY, 0.25, 0.25)
end

function level:draw_characters()
  lg.setColor(1, 1, 1, 1)
  for _, character in pairs(Atlas.character_keys) do
    local b = self.batches[character]
    lg.draw(b.sb)
  end
end

function level:draw_overlays()
  lg.setColor(1, 1, 1, 1)

  if self.hovered_tile ~= nil then
    lg.push()
    lg.scale(_G.TILE_SCALE, _G.TILE_SCALE)
    Atlas.lib.drawSprite(
      SPRITE_NAMES.indicator_base,
      self.hovered_tile.x,
      self.hovered_tile.y
    )
    lg.pop()
  end

  love.graphics.rectangle("fill", mouseX, mouseY, 20, 20)
end

---@param x number
---@param y number
---@param dx number
---@param dy number
---@param istouch boolean
function level:mousemoved(x, y, dx, dy, istouch)
  mouseX, mouseY = (x), (y)


  local offsetX, offsetY = (x / _G.TILE_SCALE), (y / _G.TILE_SCALE)


  -- check if the mouse position is still inside the previously selected tile, to avoid looping again unnecesarily
  if self.hovered_tile ~= nil then
    local tileQuad = lg.newQuad(self.hovered_tile.x, self.hovered_tile.y, _G.TILE_SIZE, _G.TILE_SIZE, 1, 1)

    if utils.isInQuad(tileQuad, offsetX, offsetY, 0.25, 0.25) then
      return
    end
  end

  for _, v in ipairs(self.selectable_tiles) do
    local tileQuad = lg.newQuad(v.x, v.y, _G.TILE_SIZE, _G.TILE_SIZE, 1, 1)

    if utils.isInQuad(tileQuad, offsetX, offsetY, 0.25, 0.25) then
      self.hovered_tile = v
      break
    end
  end
end

return level
