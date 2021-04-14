local ECS = require 'libs.ecs'
local ENUMS = require "world.enums.enums"

local FACTORY = {}
FACTORY[ENUMS.ENEMY_TYPE.BASE]= msg.url("game_scene:/factories#enemy_base")
FACTORY[ENUMS.ENEMY_TYPE.SHOOTING]= msg.url("game_scene:/factories#enemy_shooting")

---@class DrawEnemySystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.filter("enemy")
System.name = "DrawEnemySystem"

local V3 = vmath.vector3(0, 0, 0.1)

function System:init()

end

---@param e EntityGame
function System:process(e, dt)
    if(not e.enemy_go) then
        e.enemy_go = msg.url(factory.create(FACTORY[e.enemy_type], e.position))
        self.world:addEntity(e)
    end
    if (e.enemy_go) then
        V3.x, V3.y, V3.z = e.position.x, e.position.y, e.position.z
        go.set_position(V3, e.enemy_go)
    end
end

return System