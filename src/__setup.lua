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

_G.SCALES = {         -- levels
  [24] = true,
  [16] = true,
  [12] = true,
  [9] = true,
  [8] = true,
  [6] = true,
  [4] = true,
  [3] = true,
}

table.exists = function(t, v)
  for _, _v in ipairs(t) do
    if _v == v then
      return true
    end
  end

  return false
end

require("lib.uuid").seed()


_G.print = require("lib.pprint") -- override the default print function to be able to pretty print tables
print.setup({
  wrap_string = false
})
