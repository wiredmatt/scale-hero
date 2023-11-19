_G.INITIAL_TILE_SCALE = 22
_G.INITIAL_CHARACTER_SCALE = math.floor(_G.INITIAL_TILE_SCALE / 10)

_G.TILE_SIZE = 16
_G.WIDTH = 1366
_G.HEIGHT = 768
_G.SCREEN_WIDTH = 1366
_G.SCREEN_HEIGHT = 768
_G.FSCALE_MUL = 1
_G.TILE_SCALE = _G.INITIAL_TILE_SCALE
_G.CHARACTER_SCALE = _G.INITIAL_CHARACTER_SCALE
_G.lg = love.graphics            -- cache love.graphics

_G.print = require("lib.pprint") -- override the default print function to be able to pretty print tables
require("lib.uuid").seed()
