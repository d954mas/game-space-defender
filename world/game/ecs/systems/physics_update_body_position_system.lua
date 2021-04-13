local ECS = require 'libs.ecs'
---@class PhysicsUpdateBodyPositionSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.filter("physics_body&physics_dynamic")
System.name = "PhysicsUpdateBodyPositionSystem"

---@param e EntityGame
function System:process(e, dt)
    if (e.physics_body_origin) then
        e.physics_body:set_position(e.position.x + e.physics_body_origin.x,
                e.position.y + e.physics_body_origin.y, e.position.z + e.physics_body_origin.z)
    else
        e.physics_body:set_position(e.position.x, e.position.y, e.position.z)
    end

end

return System