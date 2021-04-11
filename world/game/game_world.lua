local COMMON = require "libs.common"
local EcsGame = require "world.game.ecs.game_ecs"

---@class GameWorld
local GameWorld = COMMON.class("GameWorld")

---@param world World
function GameWorld:initialize(world)
    self.world = assert(world)
    self.ecs_game = EcsGame(self.world)

end

function GameWorld:init()
    physics3d.init()
    self.ecs_game:add_systems()
end


function GameWorld:update(dt)
    self.ecs_game:update(dt)
    --do not update physics.
    --update it only when touch
    --physics3d.update(dt)
end

function GameWorld:final()
    self.ecs_game:clear()
    physics3d.clear()
end

function GameWorld:on_input(action_id,action)
    self.ecs_game:add_entity(self.ecs_game.entities:create_input(action_id,action))
end


return GameWorld



