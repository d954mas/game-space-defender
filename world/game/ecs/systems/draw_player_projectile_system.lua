local ECS = require 'libs.ecs'

local FACTORY_PLAYER_PROJECTILE = msg.url("game_scene:/factories#player_projectile")

---@class DrawPlayerProjectileSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.filter("player_projectile")
System.name = "DrawPlayerProjectileSystem"

local V3 = vmath.vector3(0, 0, 0.3)

function System:init()

end

---@param e EntityGame
function System:process(e, dt)
    if(not e.player_projectile_go) then
        e.player_projectile_go = msg.url(factory.create(FACTORY_PLAYER_PROJECTILE, e.position))
        self.world:addEntity(e)
    end
    if (e.player_projectile_go) then
        V3.x, V3.y, V3.z = e.position.x, e.position.y, e.position.z
        go.set_position(V3, e.player_projectile_go)
    end
end

return System