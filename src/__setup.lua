_G.INITIAL_TILE_SCALE = 24
_G.INITIAL_CHARACTER_SCALE = 2.5

_G.TILE_SIZE = 16
_G.WIDTH = 1366
_G.HEIGHT = 768
_G.SCREEN_WIDTH = 1366
_G.SCREEN_HEIGHT = 768
_G.TILE_SCALE = _G.INITIAL_TILE_SCALE
_G.CHARACTER_SCALE = _G.INITIAL_CHARACTER_SCALE
_G.lg = love.graphics -- cache love.graphics

require("lib.uuid").seed()


_G.print = require("lib.pprint") -- override the default print function to be able to pretty print tables
print.setup({
  wrap_string = false
})
