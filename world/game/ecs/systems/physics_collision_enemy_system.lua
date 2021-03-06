local BaseSystem = require "world.game.ecs.systems.physics_collision_base_system"
---@class PhysicsCollisionEnemySystem:PhysicsCollisionBaseSystem
local System = BaseSystem.new()
System.name = "PhysicsCollisionEnemySystem"

---@param info NativePhysicsCollisionInfo
function System:is_handle_collision(info)
    local e1, e2 = info.body1:get_user_data(), info.body2:get_user_data()
    return (e1.enemy or e2.enemy)
end

---@param info NativePhysicsCollisionInfo
function System:handle_collision(info)
    local e1, e2 = info.body1:get_user_data(), info.body2:get_user_data()
    local first = (e1.enemy or e1.obstacle) and true or false;
    local manifold = info.manifolds[1]
    local point = manifold.points[1]
    self:handle(first and e1 or e2, vmath.vector3(-point.normal.x, point.normal.y, point.normal.z), point.depth)
end
---@param e EntityGame
function System:handle(e, normal, distance)
    assert(e);
    assert(normal);
    assert(distance)
    self.world:addEntity(self.world.game_world.game.ecs_game.entities:create_explosion(e.position.x, e.position.y - 12))
    self.world.game_world.game:enemy_on_kill(e)
    self.world:removeEntity(e)

end

return System