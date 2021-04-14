local ECS = require 'libs.ecs'

local FACTORY = msg.url("game_scene:/factories#enemy_shooting_projectile")

---@class DrawEnemyProjectileSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.filter("enemy_projectile")
System.name = "DrawEnemyProjectileSystem"

local V3 = vmath.vector3(0, 0, 0.3)

function System:init()

end

---@param e EntityGame
function System:process(e, dt)
    if(not e.enemy_projectile_go) then
        e.enemy_projectile_go = msg.url(factory.create(FACTORY, e.position))
        self.world:addEntity(e)
    end
    if (e.enemy_projectile_go) then
        V3.x, V3.y, V3.z = e.position.x, e.position.y, e.position.z
        go.set_position(V3, e.enemy_projectile_go)
    end
end

return System