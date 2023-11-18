local Atlas = require "src.tool.atlas"
local level = require "src.game.level"
local Center = require "lib.center"

---@type love.Canvas
local canvas = {}

function love.load()
  love.window.setMode(_G.SCREEN_WIDTH, _G.SCREEN_HEIGHT,
    { resizable = false, vsync = true, fullscreen = false })

  lg.setDefaultFilter("nearest", "nearest")

  Atlas.Export() -- generates assets/main_atlas.xml
  Atlas.Load()   -- loads assets/main_atlas.xml into memory, `main_atlas` is now available

  canvas = lg.newCanvas(_G.WIDTH, _G.HEIGHT)

  Center:setupScreen(_G.WIDTH, _G.HEIGHT)

  level:setup()
end

function love.draw()
  ---@format disable
  lg.setCanvas(canvas)
    lg.clear()
    level:draw()
  lg.setCanvas()

  Center:start()
    lg.setColor(1, 1, 1, 1)
    lg.setBlendMode('alpha', 'premultiplied')
    lg.draw(canvas, 0, 0, 0, _G.SCALE_X, _G.SCALE_Y)
    lg.setBlendMode('alpha')
  Center:finish()


  -- lg.print(tostring(_G.SCALE_X),20,20)

  ---@format enable
end

function love.resize(width, height)
  Center:resize(width, height)
end

function love.keypressed(k)
  if k == "a" then
    _G.SCALE_X = _G.SCALE_X + 1
    _G.SCALE_Y = _G.SCALE_Y + 1
  else
    if _G.SCALE_X > 1 then
      _G.SCALE_X = _G.SCALE_X - 1
      _G.SCALE_Y = _G.SCALE_Y - 1
      -- _G.WIDTH = _G.WIDTH + _G.TILE_SIZE
      -- _G.HEIGHT = _G.HEIGHT + _G.TILE_SIZE
      -- level:next() ; 1 = standard terrain ; 2 = terrain with obstacles ; 3 = terrain with environmental stuff...
    end
  end
end

function love.mousemoved(x, y, dx, dy, istouch)
  level:mousemoved(x, y, dx, dy, istouch)
end

function love.update(dt)
  level:update(dt)
end
