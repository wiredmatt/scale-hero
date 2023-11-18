local pprint = require "lib.pprint"

_G.TILE_SIZE = 16
_G.WIDTH = 1366
_G.HEIGHT = 768
_G.SCREEN_WIDTH = 1366
_G.SCREEN_HEIGHT = 768
_G.SCALE_X = 22
_G.SCALE_Y = 22
_G.print = pprint -- override the default print function to be able to pretty print tables
