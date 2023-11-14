_G.TILE_SIZE = 16
_G.WIDTH = 1366
_G.HEIGHT = 768
_G.SCREEN_WIDTH = 1366
_G.SCREEN_HEIGHT = 768


local Atlas = require "src.tool.atlas"
local Animation = require "src.tool.animation"
local pprint = require "lib.pprint"
local level = require "src.game.level"
local Camera = require "lib.camera"
local Center = require "lib.center"

---@type love.Canvas
local canvas = {}
---@type Camera.Camera
local cam = nil

function love.load()
  love.window.setMode(_G.SCREEN_WIDTH, _G.SCREEN_HEIGHT,
    { resizable = false, vsync = true, fullscreen = false })

  love.graphics.setDefaultFilter("nearest", "nearest")
  cam = Camera.new()
  cam.scale = 15

  Atlas.Export() -- generates assets/main_atlas.xml
  Atlas.Load()   -- loads assets/main_atlas.xml into memory, `main_atlas` is now available

  canvas = love.graphics.newCanvas(_G.WIDTH, _G.HEIGHT)

  Center:setupScreen(_G.WIDTH, _G.HEIGHT)

  level:setup()
end

function love.draw()
  ---@format disable
  love.graphics.setCanvas(canvas)
    love.graphics.clear()
    level:draw()
  love.graphics.setCanvas()

  cam:attach()
    Center:start()
      love.graphics.setColor(1, 1, 1, 1)
      love.graphics.setBlendMode('alpha', 'premultiplied')
      love.graphics.draw(canvas, 0, 0, 0, 1, 1)
      love.graphics.setBlendMode('alpha')
    Center:finish()
  cam:detach()

  ---@format enable
end

function love.resize(width, height)
  Center:resize(width, height)
end

function love.keypressed(k)
  if k == "a" then
    cam.scale = cam.scale + 1
  else
    if cam.scale > 3 then
      cam.scale = cam.scale - 1
      -- _G.WIDTH = _G.WIDTH + _G.TILE_SIZE
      -- _G.HEIGHT = _G.HEIGHT + _G.TILE_SIZE
      -- level:next() ; 1 = standard terrain ; 2 = terrain with obstacles ; 3 = terrain with environmental stuff...
    end
  end
end

function love.update(dt)
  cam:update(dt)
end
