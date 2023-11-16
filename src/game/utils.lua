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

---@param active_region_quad love.Quad
---@param x number
---@param y number
---@param w number
---@param h number
function utils.isInQuad(active_region_quad, x, y, w, h)
  local ax, ay, aw, ah = active_region_quad:getViewport()

  local bx, by, bw, bh = x, y, w, h

  local a = { x = ax, y = ay, w = aw, h = ah }
  local b = { x = bx, y = by, w = bw, h = bh }

  return a.x <= b.x and
      a.y <= b.y and
      b.x + b.w <= a.x + a.w and
      b.y + b.h <= a.y + a.h

  -- return b.x >= a.x --  and b.x + b.w <= (a.w + b.x)
end

setmetatable(utils, {
  __call = function(self)
    self:getScreenCenter()
    self:getScreen00()
    return self
  end
})

return utils
