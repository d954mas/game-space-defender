local M = {}

--ecs systems created in require.
--so do not cache then

-- luacheck: push ignore require

local require_old = require
local require_no_cache
local require_no_cache_name
require_no_cache = function(k)
    require = require_old
    local m = require_old(k)
    if (k == require_no_cache_name) then
        print("load require no_cache_name:" .. k)
        package.loaded[k] = nil
    end
    require_no_cache_name = nil
    require = require_no_cache
    return m
end

local creator = function(name)
    return function(...)
        require_no_cache_name = name
        local system = require_no_cache(name)
        if (system.init) then system.init(system, ...) end
        return system
    end
end

require = creator

M.ActionsUpdateSystem = require "world.game.ecs.systems.actions_update_system"
M.AutoDestroySystem = require "world.game.ecs.systems.auto_destroy_system"
M.DebugDrawPhysicsBodiesSystem = require "world.game.ecs.systems.debug_draw_physics_bodies_system"
M.InputSystem = require "world.game.ecs.systems.input_system"
M.MoveSystem = require "world.game.ecs.systems.move_system"

M.PhysicsUpdateBodyPositionSystem = require "world.game.ecs.systems.physics_update_body_position_system"
M.DrawPlayerSystem = require "world.game.ecs.systems.draw_player_system"
M.DrawEnemySystem = require "world.game.ecs.systems.draw_enemy_system"

require = require_old

-- luacheck: pop

return M