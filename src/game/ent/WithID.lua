local uuid = require("lib.uuid")
local Object = require "lib.object"

---@class WithID : Object
local WithID = Object:extend()

function WithID:new()
  self.id = uuid.new()
end

return WithID
