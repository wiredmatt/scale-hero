local uuid = require("lib.uuid")
local Object = require "lib.object"
local flux = require "lib.flux"

---@class Flux.TweenArgs
---@field t table
---@field duration number
---@field value table

---@class TweenAnim : Object
---@overload fun(... : Flux.TweenArgs) : TweenAnim
local TweenAnim = Object:extend()

---@param ... Flux.TweenArgs
function TweenAnim:new(...)
  self.id = uuid.new()

  self.tweens = { ... }

  self.queued_tweens = {}
  self.time_to_delay_next_tween = 0

  ---@type Flux
  self.group = flux.group()
end

function TweenAnim:play(dt)
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

  self.group:update(dt)
end

return TweenAnim
