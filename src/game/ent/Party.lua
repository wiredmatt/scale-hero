local WithID = require "src.game.ent.WithID"

---@class Party : WithID
---@field super WithID
---@overload fun(members: table<string, Character>)
local Party = WithID:extend()

--- @param members table<string, Character> The characters in the party
function Party:new(members)
  self.super.new(self)
  self.members = members or {}
end

--- @param member Character
function Party:addMember(member)
  self.members[member.id] = member
end

return Party
