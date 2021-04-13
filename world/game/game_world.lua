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
    self.ecs_game = EcsGame(self.world)
    self.command_executor = CommandExecutor()
    self.score = 0
    self.level = 1
    self.state = ENUMS.GAME_STATE.PREPARE
end

function GameWorld:level_start()
    self.score = 0
    self.level = 1
    self.state = ENUMS.GAME_STATE.PREPARE
    self.command_executor:command_add(COMMANDS.PlayerAppearedCommand())
    self.command_executor:command_add(COMMANDS.EnemiesSpawnCommand())
end

function GameWorld:level_next()
    self.state = ENUMS.GAME_STATE.PREPARE
    self.level = self.level + 1
    self.command_executor:command_add(COMMANDS.PlayerAppearedCommand())
    self.command_executor:command_add(COMMANDS.EnemiesSpawnCommand())
end

---@param e EntityGame
function GameWorld:enemy_on_kill(e)
    assert(e.enemy)
    if (self.state == ENUMS.GAME_STATE.RUN) then
        if (e.enemy_type == ENUMS.ENEMY_TYPE.BASE) then
            self.score = self.score + 100
        elseif (e.enemy_type == ENUMS.ENEMY_TYPE.SHOOTING) then
            self.score = self.score + 200
        end
    end
end

function GameWorld:init()
    physics3d.init()
    self.ecs_game:player_init()
    self.ecs_game:add_systems()
    self:level_start()
end

function GameWorld:update(dt)
    self.command_executor:act(dt)
    self.ecs_game:update(dt)
end

function GameWorld:final()
    self.ecs_game:clear()
    physics3d.clear()
end

function GameWorld:on_input(action_id, action)
    self.ecs_game:add_entity(self.ecs_game.entities:create_input(action_id, action))
end

return GameWorld



