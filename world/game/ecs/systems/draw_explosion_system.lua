local COMMON = require "libs.common"
local ECS = require 'libs.ecs'
local ENUMS = require "world.enums.enums"

local FACTORY = msg.url("game_scene:/factories#explosion")

---@class DrawExplosionSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.filter("explosion")
System.name = "DrawExplosionSystem"

local V3 = vmath.vector3(0, 0, 0.1)

function System:init()

end

---@param e EntityGame
function System:process(e, dt)
    if(not e.explosion_go) then
        e.explosion_go = msg.url(factory.create(FACTORY, e.position,vmath.quat(),{},vmath.vector3(3)))
        self.world:addEntity(e)
    end
    if (e.explosion_go) then
        V3.x, V3.y, V3.z = e.position.x, e.position.y, e.position.z
        go.set_position(V3, e.explosion_go)
    end
end

return System