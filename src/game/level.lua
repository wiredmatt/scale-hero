local Atlas = require "src.tool.atlas"
local utils = require "src.game.utils"
local Tile = require "src.game.ent.Tile"
local Party = require "src.game.ent.Party"
local Character = require "src.game.ent.Character"
local uuid = require "lib.uuid"
local logger = require "src.tool.logger"
local rs = require "lib.rs"

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
    on_scale = 0
  }, -- active region is basically what's fully on screen (tiles that don't fit 100% are shown with a darker color)
  last_drawn_on_scale = 0,
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
  for i = 0, rs.game_width, _G.TILE_SIZE do
    for j = 0, rs.game_height, _G.TILE_SIZE do
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
    [16] = Party({}),
    [12] = Party({}),
    [9] = Party({}),
    [8] = Party({}),
    [6] = Party({}),
    [4] = Party({}),
    [3] = Party({}),
    [2] = Party({}),
  }

  self:setupTileSpriteBatches()
  self:setupCharacterSpriteBatches()
end

function level:makeEnemyPartyForScale(on_scale)
  local q = self:getActiveRegion()
  local x, y, w, h = q:getViewport()

  local hero_party_members = self.hero_party.members

  local free_spots = {}

  -- while true do
  --   -- _x must be in the range of x, w and be a multiple of on_scale at the same time
  --   -- example: 16, 32, 48, 64, 80, 96, 112, 128
  --   local _x = _G.TILE_SIZE * love.math.random(1, (w - _G.TILE_SIZE) / _G.TILE_SIZE)
  --   local _y = _G.TILE_SIZE * love.math.random(1, (h - _G.TILE_SIZE) / _G.TILE_SIZE)

  --   local is_valid = true

  --   for _, hero in pairs(hero_party_members) do
  --     if hero.x == _x and hero.y == _y then
  --       is_valid = false
  --       break
  --     end
  --   end

  --   if is_valid then
  --     table.insert(free_spots, { x = _x, y = _y })
  --     break
  --   end
  -- end

  for i = 0, w, _G.TILE_SIZE do
    for j = 0, h, _G.TILE_SIZE do
      if utils.isInQuad(q, i, j, _G.TILE_SIZE, _G.TILE_SIZE) then
        local is_valid = true

        for _, hero in pairs(hero_party_members) do
          if hero.x == i and hero.y == j then
            is_valid = false
            break
          end
        end

        if is_valid then
          table.insert(free_spots, { x = i, y = j })
        end
      end
    end
  end

  local enemy_party = self.enemy_parties[on_scale]

  -- the higher the scale, the less enemies we to use.
  -- the amount of enemies must not exceed the free_spots, but it can be less.
  local max_enemies = #free_spots

  local min_enemies = #free_spots / 2

  local extra_enemies = 0
  local base_chance = 100    -- initial chance of spawning an enemy
  local decrease_factor = 10 -- decrease factor for each additional enemy

  local used_spots = {}      -- keep track of used spots

  for i = 1, max_enemies do
    -- generate a random spot that hasn't been used before
    local random_spot
    repeat
      random_spot = love.math.random(1, #free_spots)
    until not used_spots[random_spot]

    used_spots[random_spot] = true -- mark the spot as used

    if #enemy_party.members < min_enemies then
      local enemy = Character("enemy_cacti", free_spots[random_spot].x, free_spots[random_spot].y)
      table.insert(enemy_party.members, enemy)
    else
      -- calculate the chance of spawning an enemy based on the number of extra enemies
      local chance = base_chance / (1 + extra_enemies * decrease_factor)

      if love.math.random(1, 100) < chance then
        local enemy = Character("enemy_cacti", free_spots[random_spot].x, free_spots[random_spot].y)
        table.insert(enemy_party.members, enemy)
        extra_enemies = extra_enemies + 1
      end
    end
  end

  self.enemy_parties[on_scale] = enemy_party
end

function level:getActiveRegion()
  if self.current_active_region_q.on_scale == _G.TILE_SCALE and self.current_active_region_q.q ~= nil then
    return self.current_active_region_q.q
  end


  local x, y, w, h = 0, 0, rs.game_width / _G.TILE_SCALE, rs.game_height / _G.TILE_SCALE

  local q = lg.newQuad(x, y, w, h, 1, 1)

  self.current_active_region_q = {
    q = q,
    on_scale = _G.TILE_SCALE
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
  if self.last_drawn_on_scale == _G.TILE_SCALE then
    return
  end

  self:getActiveRegion()

  ---@type Tile[]
  local __selectable_tiles = {}

  for _, b in pairs(self.batches) do
    b.sb:clear()
  end

  for _, v in ipairs(self.ground_tiles) do
    local b = self.batches[v.sprite]

    if utils.isInQuad(self.current_active_region_q.q, v.x, v.y, _G.TILE_SIZE, _G.TILE_SIZE) then
      b.sb:setColor(1, 1, 1, 1)
      table.insert(__selectable_tiles, v)
    else
      b.sb:setColor(1, 1, 1, 0.25)
    end

    b.sb:add(b.quad, v.x, v.y)
  end

  self.selectable_tiles = __selectable_tiles

  self.last_drawn_on_scale = _G.TILE_SCALE
end

function level:draw_tiles()
  lg.setColor(1, 1, 1, 1)

  lg.push()

  lg.scale(_G.TILE_SCALE, _G.TILE_SCALE)

  for _, name in pairs(Atlas.ground_keys) do
    local b = self.batches[name]
    lg.draw(b.sb)
  end

  local active_region_quad = self:getActiveRegion()

  -- debug all tiles
  for _, v in ipairs(self.selectable_tiles) do
    local style = "line"
    love.graphics.setColor(1, 1, 1, 1)

    -- if utils.isInQuad(active_region_quad, v.x, v.y, _G.TILE_SIZE, _G.TILE_SIZE) then
    --   style = "line"
    -- else
    --   -- darken the tile
    --   love.graphics.setColor(0, 0, 0, 0.75)
    --   style = "fill"
    -- end

    love.graphics.rectangle(style, v.x, v.y, _G.TILE_SIZE, _G.TILE_SIZE)
  end

  if self.hovered_tile ~= nil then
    Atlas.lib.drawSprite(
      SPRITE_NAMES.indicator_base,
      self.hovered_tile.x,
      self.hovered_tile.y,
      0
    )
  end

  -- debug active viewport
  local x, y, w, h = active_region_quad:getViewport()
  lg.setColor(1, 0.2, 0.8, 1)
  lg.rectangle("line", x, y, w, h)

  lg.pop()
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
  lg.rectangle("fill", _G.mouseX, _G.mouseY, _G.TILE_SIZE, _G.TILE_SIZE)
end

function level:mousemoved()
  local gameMouseX, gameMouseY = rs.to_game(_G.mouseX, _G.mouseY)

  -- check if the mouse position is still inside the previously selected tile, to avoid looping again unnecesarily
  if self.hovered_tile ~= nil then
    local tileQuad = lg.newQuad(self.hovered_tile.x, self.hovered_tile.y, _G.TILE_SIZE, _G.TILE_SIZE, 1, 1)

    if utils.isInQuad(tileQuad, gameMouseX / _G.TILE_SCALE, gameMouseY / _G.TILE_SCALE, 0.25, 0.25) then
      return
    end
  end

  for _, v in ipairs(self.selectable_tiles) do
    local tileQuad = lg.newQuad(v.x, v.y, _G.TILE_SIZE, _G.TILE_SIZE, 1, 1)

    if utils.isInQuad(tileQuad, gameMouseX / _G.TILE_SCALE, gameMouseY / _G.TILE_SCALE, 0.25, 0.25) then
      self.hovered_tile = v
      break
    end
  end
end

function level:onScaleChange()
  if _G.SCALES[_G.TILE_SCALE] == true then
    self:makeEnemyPartyForScale(_G.TILE_SCALE)
  end
end

return level
