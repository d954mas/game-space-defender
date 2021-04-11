local COMMON = require "libs.common"

---@class CommandBase
local Command = COMMON.class("CommandBase")

function Command:initialize(data)
    self.name = self.class.name
    self.data = data or {}
    self.world = reqf "models.world"
    self.act_time = 0
    self:check_data(data)
end

function Command:check_data(data)
    checks("?","table")
end

--inside coroutine
function Command:act(dt)
    self.act_time = self.act_time + dt
end

function Command:__tostring()
    return string.format("Command<%s>", self.name)
end

return Command
