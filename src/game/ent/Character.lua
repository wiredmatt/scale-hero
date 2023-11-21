local Base = require "src.game.ent.Base"
local TweenAnim = require "src.game.ent.TweenAnim"
local flux = require "lib.flux"
local logger = require "src.tool.logger"

---@class Character : Base
---@field super Base
---@overload fun(sprite: string, x: number, y: number)
local Character = Base:extend()

---@param x number
---@param y number
function Character:new(sprite, x, y)
  self.super.new(self, sprite, x, y, _G.TILE_SIZE, _G.TILE_SIZE)
  self.sx = _G.CHARACTER_SCALE
  self.sy = _G.CHARACTER_SCALE

  self.animations = {
    ["idle"] = TweenAnim(
      { t = self, duration = 0.5, value = { sy = self.sy + 0.125 } },
      { t = self, duration = 0.5, value = { sy = self.sy - 0.125 } }
    )
  }

  self.current_animation = "idle"

  -- self.animations = {
  --   ["idle"] = {
  --     play = function()
  --       if playing == "idle" then
  --         return
  --       end

  --       flux.to(self, 0.5, { sy = self.sy + 0.125 }):ease("quadinout"):onstart(function()
  --         playing = "idle"
  --       end):oncomplete(function()
  --         flux.to(self, 0.5, { sy = self.sy - 0.125 }):ease("quadinout"):oncomplete(function()
  --           playing = nil
  --         end)
  --       end)
  --     end
  --   }
  -- }
end

---@return AtlasKey atlas_key
---@return number x
---@return number y
---@return number r
---@return number sx
---@return number sy
---@return number ox
---@return number oy
---@return number kx
---@return number ky
function Character:getDrawArgs()
  ---@format disable
  return self.sprite,
      (self.x * _G.TILE_SCALE / _G.CHARACTER_SCALE) +
      (_G.TILE_SIZE * _G.TILE_SCALE / 2 / _G.CHARACTER_SCALE) -
      (_G.TILE_SCALE > 3 and _G.TILE_SIZE or _G.TILE_SIZE / 1.5),

      (self.y * _G.TILE_SCALE / _G.CHARACTER_SCALE) +
      (_G.TILE_SIZE * _G.TILE_SCALE / 2 / _G.CHARACTER_SCALE) -
      (_G.TILE_SCALE > 3 and _G.TILE_SIZE or _G.TILE_SIZE / 1.5),

      self.rotation, -- CHANGEME

      self.sx, self.sy,
      self.ox, self.oy,
      self.kx, self.ky
  ---@format enable
end

function Character:animate(dt)
  if self.current_animation ~= nil then
    self.animations[self.current_animation]:play(dt)
  end
end

function Character:update(dt)
  self:animate(dt)

  -- if love.mouse.isDown(1) then
  --   self.current_animation = nil
  -- end
end

return Character
