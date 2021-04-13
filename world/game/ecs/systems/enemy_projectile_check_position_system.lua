local COMMON = require "libs.common"
local ECS = require 'libs.ecs'
local ENUMS = require "world.enums.enums"

local FACTORY = {}


---@class EnemyProjectileCheckPositionSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.filter("enemy_projectile")
System.name = "EnemyProjectileCheckPositionSystem"



function System:init()

end

---@param e EntityGame
function System:process(e, dt)
    if(e.position.y < -50) then
        self.world:removeEntity(e)
    end
end

return System