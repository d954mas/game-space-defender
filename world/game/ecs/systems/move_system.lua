local ECS = require 'libs.ecs'
---@class MovementSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("position", "movement")
System.name = "MovementSystem"

---@param e EntityGame
function System:process(e, dt)
    e.position.x = e.position.x + e.movement.velocity.x * e.movement.speed * dt
    e.position.y = e.position.y + e.movement.velocity.y * e.movement.speed * dt
end

return System