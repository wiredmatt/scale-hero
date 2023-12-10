local WithID = require "src.game.ent.WithID"

---@class Party : WithID
---@field super WithID
---@overload fun(members: table<number, Character>)
local Party = WithID:extend()

--- @param members table<number, Character> The characters in the party
function Party:new(members)
  Party.super.new(self)
  self.members = members or {}

  for id, member in ipairs(self.members) do
    member.id = id
  end
end

--- @param member Character
function Party:addMember(member)
  self.members[member.id] = member
end

return Party
