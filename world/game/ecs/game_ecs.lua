local COMMON = require "libs.common"
local ECS = require "libs.ecs"
local SYSTEMS = require "world.game.ecs.game_systems"
local Entities = require "world.game.ecs.entities.entities_game"

---@class GameEcsWorld
local EcsWorld = COMMON.class("EcsWorld")

---@param world World
function EcsWorld:initialize(world)
    self.world = assert(world)

    self.ecs = ECS.world()
    self.ecs.game = self
    self.ecs.game_world = self.world

    self.entities = Entities(world)
    self.ecs.on_entity_added = function(_, ...) self.entities:on_entity_added(...) end
    self.ecs.on_entity_updated = function(_, ...) self.entities:on_entity_updated(...) end
    self.ecs.on_entity_removed = function(_, ...) self.entities:on_entity_removed(...) end
    self.player = self.entities:create_player()
    self:add_entity(self.player)
end

function EcsWorld:find_by_id(id)
    return self.entities:find_by_id(assert(id))
end

function EcsWorld:add_systems()
    self.ecs:addSystem(SYSTEMS.ActionsUpdateSystem())
    self.ecs:addSystem(SYSTEMS.InputSystem())
    self.ecs:addSystem(SYSTEMS.MoveSystem())
    self.ecs:addSystem(SYSTEMS.PhysicsUpdateBodyPositionSystem())

    self.ecs:addSystem(SYSTEMS.DebugDrawPhysicsBodiesSystem())

    self.ecs:addSystem(SYSTEMS.DrawPlayerSystem())

    self.ecs:addSystem(SYSTEMS.AutoDestroySystem())
end

function EcsWorld:update(dt)
    --if dt will be too big. It can create a lot of objects.
    --big dt can be in htlm when change page and then return
    --or when move game window in Windows.
    local max_dt = 0.1 * COMMON.GLOBAL.speed_game
    if (dt > max_dt) then dt = max_dt end
    self.ecs:update(dt)
end

function EcsWorld:clear()
    self.ecs:clear()
    self.ecs:refresh()
    self.draw_debug_physics = nil
end

function EcsWorld:add(...)
    self.ecs:add(...)
end

function EcsWorld:add_entity(e)
    self.ecs:addEntity(e)
end

function EcsWorld:remove_entity(e)
    self.ecs:removeEntity(e)
end

return EcsWorld



