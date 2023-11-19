local Atlas = require "src.tool.atlas"
local level = require "src.game.level"
local Center = require "lib.center"

-- canvases to draw specific content to
-- each canvas is drawn to the screen with a different scale
---@type love.Canvas
local tile_canvas = {}      -- ground tiles, obstacles ...
---@type love.Canvas
local character_canvas = {} -- characters, enemies ...
---@type love.Canvas
local overlay_canvas = {}   -- indicators ...
---@type love.Canvas
local gui_canvas = {}       -- buttons and such

function love.load()
  love.window.setMode(_G.SCREEN_WIDTH, _G.SCREEN_HEIGHT,
    { resizable = true, vsync = true, fullscreen = false })

  -- _G.SCREEN_WIDTH, _G.SCREEN_HEIGHT = love.graphics.getDimensions()

  lg.setDefaultFilter("nearest", "nearest")

  Atlas.Export() -- generates assets/main_atlas.xml
  Atlas.Load()   -- loads assets/main_atlas.xml into memory, `main_atlas` is now available

  tile_canvas = lg.newCanvas(_G.WIDTH, _G.HEIGHT)
  character_canvas = lg.newCanvas(_G.WIDTH, _G.HEIGHT)
  overlay_canvas = lg.newCanvas(_G.WIDTH, _G.HEIGHT)

  Center:setupScreen(_G.WIDTH, _G.HEIGHT)

  level:setup()
end

-- NOTE(mateo): Order matters!
function love.draw()
  ---@format disable
  lg.setCanvas(tile_canvas)
    lg.clear()
    level:draw_tiles()
  lg.setCanvas()

  lg.setCanvas(character_canvas)
    lg.clear()
    level:draw_characters()
  lg.setCanvas()

  lg.setCanvas(overlay_canvas)
    lg.clear()
    level:draw_overlays()
  lg.setCanvas()

  Center:start()
    lg.setColor(1, 1, 1, 1)
    lg.setBlendMode('alpha', 'premultiplied')
    lg.draw(tile_canvas, 0, 0, 0, _G.TILE_SCALE, _G.TILE_SCALE)
    lg.draw(character_canvas, 0, 0, 0, _G.CHARACTER_SCALE, _G.CHARACTER_SCALE)
    lg.draw(overlay_canvas, 0, 0, 0, _G.TILE_SCALE, _G.TILE_SCALE)
    lg.setBlendMode('alpha')
  Center:finish()


  lg.print(tostring(_G.TILE_SCALE),20,20)

  ---@format enable
end

function love.resize(width, height)
  Center:resize(width, height)
  _G.SCREEN_WIDTH, _G.SCREEN_HEIGHT = width, height
end

function love.keypressed(k)
  if k == "a" then
    _G.TILE_SCALE = _G.TILE_SCALE + 1
  elseif k == "1" then
    love.window.setFullscreen(true)
    _G.FSCALE_MUL = 1.45
  else
    if _G.TILE_SCALE > 2 then
      _G.TILE_SCALE = _G.TILE_SCALE - 1
      -- _G.WIDTH = _G.WIDTH + _G.TILE_SIZE
      -- _G.HEIGHT = _G.HEIGHT + _G.TILE_SIZE
      -- level:next() ; 1 = standard terrain ; 2 = terrain with obstacles ; 3 = terrain with environmental stuff...
    end
  end

  if _G.TILE_SCALE == 3 then
    _G.CHARACTER_SCALE = 1.5
  elseif _G.TILE_SCALE == 2 then
    _G.CHARACTER_SCALE = 1.35
  elseif _G.TILE_SCALE > 3 then
    _G.CHARACTER_SCALE = _G.INITIAL_CHARACTER_SCALE
  end
end

function love.mousemoved(x, y, dx, dy, istouch)
  level:mousemoved(x, y, dx, dy, istouch)
end

function love.update(dt)
  level:update(dt)
end
