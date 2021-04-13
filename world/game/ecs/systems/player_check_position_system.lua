local ECS = require 'libs.ecs'
local COMMON = require "libs.common"

---@class PlayerCheckPositionSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.filter("player")
System.name = "PlayerCheckPositionSystem"



function System:init()

end

---@param e EntityGame
function System:process(e, dt)
    e.position.x = COMMON.LUME.clamp(e.position.x,-270+25,270-25)
end

return System