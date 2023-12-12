local WithID = require "src.game.ent.WithID"

---@class Party : WithID
---@field super WithID
---@overload fun(members: Character[])
local Party = WithID:extend()

--- @param members Character[] The characters in the party
function Party:new(members)
  Party.super.new(self)
  self.members = members or {}

  for id, member in ipairs(self.members) do
    member.id = id
  end
end

--- @param member Character
function Party:removeMember(member)
  for id, m in ipairs(self.members) do
    if m == member then
      table.remove(self.members, id)
      return
    end
  end
end

return Party
