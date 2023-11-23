local uuid = require("lib.uuid")
local Object = require "lib.object"
local flux = require "lib.flux"

---@class Flux.TweenArgs
---@field t table
---@field duration number
---@field value table

---@class TweenAnim : Object
---@overload fun(mode: AnimationType,... : Flux.TweenArgs) : TweenAnim
local TweenAnim = Object:extend()

---@param mode AnimationType
---@param ... Flux.TweenArgs
function TweenAnim:new(mode, ...)
  self.id = uuid.new()

  self.mode = mode
  self.played_once = false

  self.tweens = { ... }

  self.queued_tweens = {}
  self.time_to_delay_next_tween = 0

  ---@type Flux
  self.group = flux.group()

  self.duration = 0

  for _, tween in ipairs(self.tweens) do
    self.duration = self.duration + tween.duration
  end
end

function TweenAnim:setMode(mode)
  self.mode = mode
end

function TweenAnim:prepare()
  if #self.group == 0 then
    self.time_to_delay_next_tween = 0

    for _, tween in ipairs(self.tweens) do
      self.queued_tweens[#self.queued_tweens + 1] = tween
    end
  end

  if #self.queued_tweens > 0 then
    local tween = self.queued_tweens[1]
    self.group:to(tween.t, tween.duration, tween.value):delay(self.time_to_delay_next_tween)
    self.time_to_delay_next_tween = tween.duration
    table.remove(self.queued_tweens, 1)
  end
end

function TweenAnim:reset()
  self.group:remove()
  self.queued_tweens = {}
  self.time_to_delay_next_tween = 0
  self.played_once = false

  self.group = flux.group()
  self:prepare()
end

function TweenAnim:play(dt)
  if #self.group == 0 and self.mode == ANIMATION_TYPE.once then
    self.played_once = true
    return
  end

  self:prepare()
  self.group:update(dt)
end

return TweenAnim
