local ECS = require 'libs.ecs'
local COMMON = require "libs.common"

---@class InputSystem:ECSSystemProcessing
local System = ECS.processingSystem()
System.filter = ECS.filter("input_info")
System.name = "InputSystem"

function System:init()
    self.input_handler = COMMON.INPUT()
    --self.input_handler:add_mouse(self.input_mouse_move)
    --self.input_handler:add(COMMON.HASHES.INPUT.INTERACT, self.input_interact, true)
end


---@param e EntityGame
function System:process(e, dt)
    self.input_handler:on_input(self, e.input_info.action_id, e.input_info.action)
end

System:init()

return System
