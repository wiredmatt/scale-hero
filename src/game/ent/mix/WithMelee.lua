local Object = require "lib.object"
local TweenAnim = require "src.game.ent.TweenAnim"
local Animations = require "src.game.animationkeys"

---@class WithMelee : Character
local WithMelee = Object:extend()

function WithMelee:applyMelee()
  self.animations = self.animations or {}

  self.animations[Animations.hit_right] = TweenAnim(
    AnimationType.once,

    { t = self, duration = 0, value = { ky = 0.1 } },
    { t = self, duration = 0.2, value = { x = self.x + _G.TILE_SIZE / 1.5 }, signal = "hit" },
    { t = self, duration = 0.5, value = { x = self.x - 0.5 } },
    { t = self, duration = 0, value = { x = self.x } },
    { t = self, duration = 0.5, value = { ky = 0 } }
  )

  self.animations[Animations.hit_left] = TweenAnim(
    AnimationType.once,

    { t = self, duration = 0, value = { ky = 0.1 } },
    { t = self, duration = 0.2, value = { x = self.x - _G.TILE_SIZE / 1.5 }, signal = "hit" },
    { t = self, duration = 0.5, value = { x = self.x + 0.5 } },
    { t = self, duration = 0, value = { x = self.x } },
    { t = self, duration = 0.5, value = { ky = 0 } }
  )

  self.animations[Animations.hit_down] = TweenAnim(
    AnimationType.once,

    { t = self, duration = 0, value = { ky = 0.1 } },
    { t = self, duration = 0.1, value = { y = self.y + _G.TILE_SIZE / 1.5 }, signal = "hit" },
    { t = self, duration = 1, value = { y = self.y - 0.2 } },
    { t = self, duration = 0, value = { y = self.y } },
    { t = self, duration = 0.5, value = { ky = 0 } }
  )

  self.animations[Animations.hit_up] = TweenAnim(
    AnimationType.once,

    { t = self, duration = 0, value = { ky = 0.1 } },
    { t = self, duration = 0.1, value = { y = self.y - _G.TILE_SIZE / 1.5 }, signal = "hit" },
    { t = self, duration = 1, value = { y = self.y + 0.2 } },
    { t = self, duration = 0, value = { y = self.y } },
    { t = self, duration = 0.5, value = { ky = 0 } }
  )


  self.animations[Animations.hit_down_right] = TweenAnim( -- diagonal down right
    AnimationType.once,

    { t = self, duration = 0, value = { ky = 0.1 } },
    {
      t = self,
      duration = 0.2,
      value = { y = self.y + _G.TILE_SIZE / 1.5, x = self.x + _G.TILE_SCALE / 2 },
      signal = "hit"
    },
    { t = self, duration = 1, value = { y = self.y - 0.2, x = self.x - 0.2 } },
    { t = self, duration = 0, value = { y = self.y, x = self.x } },
    { t = self, duration = 1, value = { ky = 0 } }
  )


  self.animations[Animations.hit_down_left] = TweenAnim( -- diagonal down left
    AnimationType.once,

    { t = self, duration = 0, value = { ky = 0.1 } },
    {
      t = self,
      duration = 0.2,
      value = { y = self.y + _G.TILE_SIZE / 1.5, x = self.x - _G.TILE_SCALE / 2 },
      signal = "hit"
    },
    { t = self, duration = 1, value = { y = self.y + 0.2, x = self.x + 0.2 } },
    { t = self, duration = 0, value = { y = self.y, x = self.x } },
    { t = self, duration = 1, value = { ky = 0 } }
  )


  self.animations[Animations.hit_up_left] = TweenAnim( -- diagonal up left
    AnimationType.once,

    { t = self, duration = 0, value = { ky = 0.1 } },
    {
      t = self,
      duration = 0.2,
      value = { y = self.y - _G.TILE_SIZE / 1.5, x = self.x - _G.TILE_SCALE / 2 },
      signal = "hit"
    },
    { t = self, duration = 1, value = { y = self.y + 0.2, x = self.x + 0.2 } },
    { t = self, duration = 0, value = { y = self.y, x = self.x } },
    { t = self, duration = 1, value = { ky = 0 } }
  )


  self.animations[Animations.hit_up_right] = TweenAnim( -- diagonal up left
    AnimationType.once,

    { t = self, duration = 0, value = { ky = 0.1 } },
    {
      t = self,
      duration = 0.2,
      value = { y = self.y - _G.TILE_SIZE / 1.5, x = self.x + _G.TILE_SCALE / 2 },
      signal = "hit"
    },
    { t = self, duration = 1, value = { y = self.y + 0.2, x = self.x - 0.2 } },
    { t = self, duration = 0, value = { y = self.y, x = self.x } },
    { t = self, duration = 1, value = { ky = 0 } }
  )
end

return WithMelee
