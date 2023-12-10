_G.lg = love.graphics -- cache love.graphics

_G.INITIAL_TILE_SCALE = 24
_G.INITIAL_CHARACTER_SCALE = 2.5

_G.TILE_SIZE = 16
_G.TILE_SCALE = _G.INITIAL_TILE_SCALE
_G.CHARACTER_SCALE = _G.INITIAL_CHARACTER_SCALE

_G.mouseX = 0
_G.mouseY = 0

_G.SCALES = { -- levels
  [_G.INITIAL_TILE_SCALE] = true,
  [16] = true,
  [12] = true,
  [9] = true,
  [8] = true,
  [6] = true,
  [4] = true,
  [3] = true,
}

_G.print = require("lib.pprint") -- override the default print function to be able to pretty print tables
print.setup({
  wrap_string = false
})


_G.Timer = require("lib.timer") -- override the default timer to be able to use it in a more convenient way

_G.actionTimer = Timer.new()


require("lib.uuid").seed()

function table.shallow_copy(t)
  local t2 = {}
  for k, v in pairs(t) do
    t2[k] = v
  end
  return t2
end
