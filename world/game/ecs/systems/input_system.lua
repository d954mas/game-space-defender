local ECS = require 'libs.ecs'
local COMMON = require "libs.common"
local INPUT = require "libs.input_receiver"

---@class InputSystem:ECSSystemProcessing
local System = ECS.processingSystem()
System.filter = ECS.filter("input_info")
System.name = "InputSystem"

function System:init()
    self.input_handler = COMMON.INPUT()
end

---@param e EntityGame
function System:process(e, dt)
    self.input_handler:on_input(self, e.input_info.action_id, e.input_info.action)
end

System:init()

return System
