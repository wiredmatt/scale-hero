local rs = require "lib.rs"
local logger = require "src.tool.logger"

rs.conf({ game_width = 1366, game_height = 768, scale_mode = 1 })
rs.setMode(rs.game_width, rs.game_height, { resizable = true })

local Camera = require "lib.camera"

local cam = Camera(1366, 768)

local Atlas = require "src.tool.atlas"
local level = require "src.game.level"
local flux = require "lib.flux"

---@type love.Canvas
local camera_canvas = {} -- what the camera sees

function love.load()
  lg.setDefaultFilter("nearest", "nearest")

  Atlas.Export() -- generates assets/main_atlas.xml
  Atlas.Load()   -- loads assets/main_atlas.xml into memory, `main_atlas` is now available

  camera_canvas = lg.newCanvas(rs.game_width, rs.game_height)

  level:setup()
end

-- NOTE(mateo): Order matters!
function love.draw()
  ---@format disable
  cam:attach(0, 0, rs.game_width, rs.game_height)

    lg.setCanvas(camera_canvas)
      lg.clear()
      level:draw_tiles()
      level:draw_characters()
      level:draw_overlays()
    lg.setCanvas()

  cam:detach()

  rs.push()

    lg.setColor(1, 1, 1, 1)
    lg.setBlendMode('alpha', 'premultiplied')
    lg.draw(camera_canvas)
    lg.setBlendMode('alpha')

  rs.pop()

  local x, y = love.mouse.getPosition()


  -- lg.print(tostring(_G.TILE_SCALE),20,20)
  lg.print(tostring(x) .. ", " .. tostring(y) ,20,20)
  love.graphics.rectangle("fill", x, y, 20, 20)

  ---@format enable
end

love.resize = function(w, h)
  rs.resize()
end

function love.keypressed(k)
  if k == "a" then
    _G.TILE_SCALE = _G.TILE_SCALE + 1
  elseif k == "1" then
    love.window.setFullscreen(true)
  else
    if _G.TILE_SCALE > 2 then
      _G.TILE_SCALE = _G.TILE_SCALE - 1
      level:onScaleChange()
    end
  end

  if _G.TILE_SCALE == 9 then
    _G.CHARACTER_SCALE = 2
  elseif _G.TILE_SCALE == 8 then
    _G.CHARACTER_SCALE = 1.5
  elseif _G.TILE_SCALE == 6 then
    _G.CHARACTER_SCALE = 1.3
  elseif _G.TILE_SCALE == 4 then
    _G.CHARACTER_SCALE = 1
  elseif _G.TILE_SCALE == 3 then
    _G.CHARACTER_SCALE = 0.6
  end
end

function love.mousemoved(x, y, dx, dy, istouch)
  level:mousemoved(x, y, dx, dy, istouch)
end

function love.update(dt)
  flux.update(dt) -- update all tweens
  level:update(dt)

  local current_x, current_y = cam:position()

  logger:debug("CAMERA: ", current_x, current_y)
  cam:lookAt(rs.game_width / 2, rs.game_height / 2)
end
