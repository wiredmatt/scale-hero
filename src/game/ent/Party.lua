local Object = require "lib.object"
local WithID = require "src.game.ent.WithID"

---@class Party : WithID
---@field super WithID
local Party = WithID:extend()

--- @param members table<string, Character> The characters in the party
function Party:new(members)
  self.super.new(self)
  self.members = members
end

return Party
