local Atlas = require "src.tool.atlas"

local utils = {}

function utils:getScreenCenter()
  local cx, cy = _G.WIDTH, _G.HEIGHT

  self.cx = cx
  self.cy = cy

  return cx, cy
end

function utils:getScreen00()
  local cw, ch = self:getScreenCenter()

  local zx, zy = cw / 2, ch / 2

  self.zx = zx
  self.zy = zy

  return zx, zy
end

function utils:getSpriteCenter(sname)
  local _, quad = Atlas.lib.getSprite(sname)

  local _, _, w, h = quad:getViewport()
  return w / 2, h / 2
end

setmetatable(utils, {
  __call = function(self)
    self:getScreenCenter()
    self:getScreen00()
    return self
  end
})

return utils()
