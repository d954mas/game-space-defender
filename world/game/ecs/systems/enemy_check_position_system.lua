local COMMON = require "libs.common"
local ECS = require 'libs.ecs'
local ENUMS = require "world.enums.enums"

local FACTORY = {}


---@class EnemyCheckPositionSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.filter("enemy")
System.name = "EnemyCheckPositionSystem"



function System:init()

end

---@param e EntityGame
function System:process(e, dt)
    if(e.position.y < -50) then
        e.position.y = self.world.game_world.balance.game_area.height + e.position.y
    end
end

return System