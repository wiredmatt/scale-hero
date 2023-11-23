local Base      = require "src.game.ent.Base"
local TweenAnim = require "src.game.ent.TweenAnim"
local logger    = require "src.tool.logger"

---@class Character : Base
---@field super Base
---@overload fun(sprite: string, x: number, y: number)
local Character = Base:extend()

---@param x number
---@param y number
---@param default_animation? string
function Character:new(sprite, x, y, default_animation)
  self.super.new(self, sprite, x, y, _G.TILE_SIZE, _G.TILE_SIZE)
  self.sx = _G.CHARACTER_SCALE
  self.sy = _G.CHARACTER_SCALE

  self.default_animation = default_animation or "idle_base"

  self.animations = {
    ["idle_base"] = TweenAnim(
      ANIMATION_TYPE.loop,

      { t = self, duration = 0.3, value = { sy = self.sy + 0.1 } },
      { t = self, duration = 0.3, value = { sy = self.sy - 0.1 } }
    ),
    ["hit_right"] = TweenAnim(
      ANIMATION_TYPE.once,

      { t = self, duration = 0, value = { ky = 0.1 } },
      { t = self, duration = 0.2, value = { x = self.x + _G.TILE_SIZE / 2 } },
      { t = self, duration = 0.5, value = { x = self.x - 0.5 } },
      { t = self, duration = 0, value = { x = self.x } },
      { t = self, duration = 0.5, value = { ky = 0 } }
    ),
    ["hit_left"] = TweenAnim(
      ANIMATION_TYPE.once,

      { t = self, duration = 0, value = { ky = 0.1 } },
      { t = self, duration = 0.2, value = { x = self.x - _G.TILE_SIZE / 2 } },
      { t = self, duration = 0.5, value = { x = self.x + 0.5 } },
      { t = self, duration = 0, value = { x = self.x } },
      { t = self, duration = 0.5, value = { ky = 0 } }
    ),
    ["hit_down"] = TweenAnim(
      ANIMATION_TYPE.once,

      { t = self, duration = 0, value = { ky = 0.1 } },
      { t = self, duration = 0.1, value = { y = self.y + _G.TILE_SIZE / 2 } },
      { t = self, duration = 1, value = { y = self.y - 0.2 } },
      { t = self, duration = 0, value = { y = self.y } },
      { t = self, duration = 0.5, value = { ky = 0 } }
    ),
    ["hit_up"] = TweenAnim(
      ANIMATION_TYPE.once,

      { t = self, duration = 0, value = { ky = 0.1 } },
      { t = self, duration = 0.1, value = { y = self.y - _G.TILE_SIZE / 2 } },
      { t = self, duration = 1, value = { y = self.y + 0.2 } },
      { t = self, duration = 0, value = { y = self.y } },
      { t = self, duration = 0.5, value = { ky = 0 } }
    ),

    ["get_hit_x"] = TweenAnim(
      ANIMATION_TYPE.once,

      { t = self, duration = 0.05, value = { x = self.x - 0.25 } },
      { t = self, duration = 0.05, value = { x = self.x + 0.25 } },
      { t = self, duration = 0.05, value = { x = self.x - 0.25 } },
      { t = self, duration = 0.05, value = { x = self.x + 0.25 } },
      { t = self, duration = 0.05, value = { x = self.x - 0.25 } },
      { t = self, duration = 0.05, value = { x = self.x + 0.25 } },
      { t = self, duration = 0.05, value = { x = self.x - 0.25 } },
      { t = self, duration = 0.05, value = { x = self.x + 0.25 } },

      { t = self, duration = 0, value = { x = self.x } }
    ),

    ["get_hit_y"] = TweenAnim(
      ANIMATION_TYPE.once,

      { t = self, duration = 0.05, value = { y = self.y - 0.25 } },
      { t = self, duration = 0.05, value = { y = self.y + 0.25 } },
      { t = self, duration = 0.05, value = { y = self.y - 0.25 } },
      { t = self, duration = 0.05, value = { y = self.y + 0.25 } },
      { t = self, duration = 0.05, value = { y = self.y - 0.25 } },
      { t = self, duration = 0.05, value = { y = self.y + 0.25 } },
      { t = self, duration = 0.05, value = { y = self.y - 0.25 } },
      { t = self, duration = 0.05, value = { y = self.y + 0.25 } },

      { t = self, duration = 0, value = { y = self.y } }
    ),
  }

  self.current_animation = self.default_animation
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
  local fixed_scale = (_G.CHARACTER_SCALE >= 0.6 and _G.CHARACTER_SCALE or 1)

  ---@format disable
  return self.sprite,
      (self.x * _G.TILE_SCALE / fixed_scale) +
      (_G.TILE_SIZE * _G.TILE_SCALE / 2 / fixed_scale) -
      (_G.TILE_SCALE > 3 and _G.TILE_SIZE or _G.TILE_SIZE / 1.5),

      (self.y * _G.TILE_SCALE / fixed_scale) +
      (_G.TILE_SIZE * _G.TILE_SCALE / 2 / fixed_scale) -
      (_G.TILE_SCALE > 3 and _G.TILE_SIZE or _G.TILE_SIZE / 1.5),

      self.rotation,

      self.sx, self.sy,
      self.ox, self.oy,
      self.kx, self.ky
  ---@format enable
end

function Character:updateAnimation(dt)
  if self.current_animation ~= nil then
    local anim = self.animations[self.current_animation]

    if anim.mode == ANIMATION_TYPE.once and anim.played_once then
      self:setAnimation(self.default_animation)
      return
    else
      anim:play(dt)
    end
  end
end

function Character:setAnimation(key)
  local prev = self.current_animation

  if prev ~= key then
    self.current_animation = key
    self.animations[prev]:reset()
  end
end

function Character:update(dt)
  self:updateAnimation(dt)

  if love.mouse.isDown(1) then
    self:setAnimation("hit_right")
  end
end

return Character
