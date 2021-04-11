local ECS = require 'libs.ecs'
---@class PhysicsUpdateBodyPositionSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.filter("physics_body&physics_dynamic")
System.name = "PhysicsUpdateBodyPositionSystem"

---@param e EntityGame
function System:process(e, dt)
	e.physics_body:set_position(e.position.x, e.position.y, e.position.z)
end


return System