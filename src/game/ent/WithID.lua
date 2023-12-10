local uuid = require("lib.uuid")
local Object = require "lib.object"

---@class WithID : Object
local WithID = Object:extend()

function WithID:new()
  ---@type number
  self.id = nil
  self.global_id = uuid.new()
end

return WithID
