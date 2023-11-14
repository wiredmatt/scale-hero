local Atlas = require "src.tool.atlas"
local Animation = {}

---@param name string an identifier for the animation
---@param atlas string the name of the atlas to use, loaded from iffy
---@param frames table<number, string> a table of frame numbers and sprite names, mapped to the atlas defined keys
---@param fps number the number of frames per second to play
---@param loop boolean whether or not to loop the animation
function Animation.new(name, atlas, frames, fps, loop)
  local self = {}

  self.name = name
  self.atlas = atlas
  self.frames = frames
  self.fps = fps
  self.loop = loop

  self.currentFrame = 1
  self.currentTime = 0

  function self.update(dt)
    if dt > 0.1 then -- clamp to prevent the animation from updating too quickly and freezing the game
      dt = 0.1
    end
    self.currentTime = self.currentTime + dt
    if self.currentTime >= 1 / self.fps then
      self.currentTime = self.currentTime - 1 / self.fps
      self.currentFrame = self.currentFrame + 1
      if self.currentFrame > #self.frames then
        if self.loop then
          self.currentFrame = 1
        else
          self.currentFrame = #self.frames
        end
      elseif self.currentFrame < 1 then
        if self.loop then
          self.currentFrame = #self.frames
        else
          self.currentFrame = 1
        end
      end
    end
  end

  function self.draw(x, y, r, sx, sy)
    Atlas.lib.drawSprite(self.frames[self.currentFrame], x, y, r, sx, sy) -- Atlas.lib = iffy
  end

  return self
end

return Animation


-- EXAMPLE USAGE:
-- local Atlas = require "src.tool.atlas"
-- local Animation = require "src.tool.animation"

-- local random_npc_reward = {}

-- function love.load()
--   love.graphics.setDefaultFilter("nearest", "nearest")

--   Atlas.Export() -- generates assets/main_atlas.xml
--   Atlas.Load()   -- loads assets/main_atlas.xml into memory, `main_atlas` is now available

--   random_npc_reward = Animation.new("random_npc_reward", "main_atlas", {
--     [1] = "npc_merchant",
--     [2] = "npc_knight",
--     [3] = "npc_kid",
--   }, 3, true)
-- end

-- function love.draw()
--   random_npc_reward.draw(200, 200, 0, 4, 4)
-- end

-- function love.update(dt)
--   random_npc_reward.update(dt)
-- end
