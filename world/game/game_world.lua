local COMMON = require "libs.common"
local EcsGame = require "world.game.ecs.game_ecs"
local CommandExecutor = require "world.commands.command_executor"
local COMMANDS = require "world.game.command.commands"
local ENUMS = require "world.enums.enums"

---@class GameWorld
local GameWorld = COMMON.class("GameWorld")

---@param world World
function GameWorld:initialize(world)
    self.world = assert(world)
    physics3d.init()
    self.ecs_game = EcsGame(self.world)
    self.command_executor = CommandExecutor()
    self.level = 1
    self.state = ENUMS.GAME_STATE.PREPARE
end

function GameWorld:level_start()
    self.command_executor:command_add(COMMANDS.PlayerAppearedCommand())
    self.command_executor:command_add(COMMANDS.EnemiesSpawnCommand())
end

function GameWorld:init()
    self.ecs_game:add_systems()
    self:level_start()
end

function GameWorld:update(dt)
    self.command_executor:act(dt)
    self.ecs_game:update(dt)
    --do not update physics.
    --update it only when touch
    --physics3d.update(dt)
end

function GameWorld:final()
    pprint("GAME CLEAR")
    self.ecs_game:clear()
    physics3d.clear()
end

function GameWorld:on_input(action_id, action)
    self.ecs_game:add_entity(self.ecs_game.entities:create_input(action_id, action))
end

return GameWorld



