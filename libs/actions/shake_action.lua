local COMMON = require "libs.common"
local TweenAction = require "libs.actions.tween_action"

---@class ShakeAction:SequenceAction
local Action = COMMON.class("ShakeAction", TweenAction)

function Action:config_check(config)
    assert(self.config.magnitude)
    TweenAction.config_check(self,config)
end

function Action:initialize(config)
    assert(config.object)
    config.property = "a"
    config.go_object = assert(config.object)
    config.object = {}
    config.to = { a = 1 }
    config.from = { a = 0 }
    self.position = go.get_position(config.go_object)
    TweenAction.initialize(self, config)
end

function Action:set_property(...)
    TweenAction.set_property(self, ...)
    local position = vmath.vector3(self.position)

    go.set_position(position + vmath.vector3(math.random(-self.config.magnitude, self.config.magnitude),
            math.random(-self.config.magnitude, self.config.magnitude), 0), self.config.go_object)

end

return Action