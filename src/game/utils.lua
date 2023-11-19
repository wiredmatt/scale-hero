local utils = {}

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
end

return utils
