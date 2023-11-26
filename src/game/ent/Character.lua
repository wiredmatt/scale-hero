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
  Character.super.new(self, sprite, x, y, _G.TILE_SIZE, _G.TILE_SIZE)
  self.sx = _G.INITIAL_CHARACTER_SCALE
  self.sy = _G.INITIAL_CHARACTER_SCALE

  self.default_animation = default_animation or "idle_base"

  self.animations = {
    --- [[ BASE ANIMATIONS ]]
    ["idle_base"] = TweenAnim(
      AnimationType.loop,

      { t = self, duration = 0.3, value = { sy = self.sy + 0.1 } },
      { t = self, duration = 0.3, value = { sy = self.sy - 0.1 } }
    ),


    --- [[ ATTACK ANIMATIONS ]]
    ["hit_right"] = TweenAnim(
      AnimationType.once,

      { t = self, duration = 0, value = { ky = 0.1 } },
      { t = self, duration = 0.2, value = { x = self.x + _G.TILE_SIZE / 2 } },
      { t = self, duration = 0.5, value = { x = self.x - 0.5 } },
      { t = self, duration = 0, value = { x = self.x } },
      { t = self, duration = 0.5, value = { ky = 0 } }
    ),
    ["hit_left"] = TweenAnim(
      AnimationType.once,

      { t = self, duration = 0, value = { ky = 0.1 } },
      { t = self, duration = 0.2, value = { x = self.x - _G.TILE_SIZE / 2 } },
      { t = self, duration = 0.5, value = { x = self.x + 0.5 } },
      { t = self, duration = 0, value = { x = self.x } },
      { t = self, duration = 0.5, value = { ky = 0 } }
    ),
    ["hit_down"] = TweenAnim(
      AnimationType.once,

      { t = self, duration = 0, value = { ky = 0.1 } },
      { t = self, duration = 0.1, value = { y = self.y + _G.TILE_SIZE / 2 } },
      { t = self, duration = 1, value = { y = self.y - 0.2 } },
      { t = self, duration = 0, value = { y = self.y } },
      { t = self, duration = 0.5, value = { ky = 0 } }
    ),
    ["hit_up"] = TweenAnim(
      AnimationType.once,

      { t = self, duration = 0, value = { ky = 0.1 } },
      { t = self, duration = 0.1, value = { y = self.y - _G.TILE_SIZE / 2 } },
      { t = self, duration = 1, value = { y = self.y + 0.2 } },
      { t = self, duration = 0, value = { y = self.y } },
      { t = self, duration = 0.5, value = { ky = 0 } }
    ),


    ["hit_down_right"] = TweenAnim( -- diagonal down right
      AnimationType.once,

      { t = self, duration = 0, value = { ky = 0.1 } },
      { t = self, duration = 0.2, value = { y = self.y + _G.TILE_SIZE / 2, x = self.x + _G.TILE_SCALE / 2 } },
      { t = self, duration = 1, value = { y = self.y - 0.2, x = self.x - 0.2 } },
      { t = self, duration = 0, value = { y = self.y, x = self.x } },
      { t = self, duration = 1, value = { ky = 0 } }
    ),


    ["hit_down_left"] = TweenAnim( -- diagonal down left
      AnimationType.once,

      { t = self, duration = 0, value = { ky = 0.1 } },
      { t = self, duration = 0.2, value = { y = self.y + _G.TILE_SIZE / 2, x = self.x - _G.TILE_SCALE / 2 } },
      { t = self, duration = 1, value = { y = self.y + 0.2, x = self.x + 0.2 } },
      { t = self, duration = 0, value = { y = self.y, x = self.x } },
      { t = self, duration = 1, value = { ky = 0 } }
    ),


    ["hit_up_left"] = TweenAnim( -- diagonal up left
      AnimationType.once,

      { t = self, duration = 0, value = { ky = 0.1 } },
      { t = self, duration = 0.2, value = { y = self.y - _G.TILE_SIZE / 2, x = self.x - _G.TILE_SCALE / 2 } },
      { t = self, duration = 1, value = { y = self.y + 0.2, x = self.x + 0.2 } },
      { t = self, duration = 0, value = { y = self.y, x = self.x } },
      { t = self, duration = 1, value = { ky = 0 } }
    ),


    ["hit_up_right"] = TweenAnim( -- diagonal up left
      AnimationType.once,

      { t = self, duration = 0, value = { ky = 0.1 } },
      { t = self, duration = 0.2, value = { y = self.y - _G.TILE_SIZE / 2, x = self.x + _G.TILE_SCALE / 2 } },
      { t = self, duration = 1, value = { y = self.y + 0.2, x = self.x - 0.2 } },
      { t = self, duration = 0, value = { y = self.y, x = self.x } },
      { t = self, duration = 1, value = { ky = 0 } }
    ),


    --- [[ EFFECT ANIMATIONS ]]
    ["get_hit_x"] = TweenAnim(
      AnimationType.once,

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
      AnimationType.once,

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

---@return SpriteName sprite_name
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
         (self.x * _G.TILE_SCALE / _G.CHARACTER_SCALE) + (_G.TILE_SIZE * _G.TILE_SCALE / 2 / _G.CHARACTER_SCALE) - (_G.TILE_SIZE),
         (self.y * _G.TILE_SCALE / _G.CHARACTER_SCALE) + (_G.TILE_SIZE * _G.TILE_SCALE / 2 / _G.CHARACTER_SCALE) - (_G.TILE_SIZE),
         self.rotation,
         self.sx, self.sy,
         self.ox, self.oy,
         self.kx, self.ky
  ---@format enable
end

function Character:updateAnimation(dt)
  if self.current_animation ~= nil then
    local anim = self.animations[self.current_animation]

    if anim.mode == AnimationType.once and anim.played_once then
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

  -- if love.mouse.isDown(1) then
  --   self:setAnimation("hit_up_right")
  -- end
end

---@param action ActionAnimation
function Character:doAction(action)
  local duration = self.animations[action].duration
  -- TODO: Return the duration it takes to reach the key keyframe when something important actually happens
  -- example: when the player hits an enemy, the enemy should be able to react to the hit at the exact moment
  -- local duration = self.animations[action]:getDurationToKeyframe(self.animations[action].key_keyframe)
  -- another approach would be to have two separate animations:
  --  1. the actual hit animation, where the last keyframe is the one where the hit happens
  --  2. the traceback animation, where the player comes back to the original position
  self:setAnimation(action)
  return duration
end

return Character
