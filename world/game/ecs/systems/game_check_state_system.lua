local COMMON = require "libs.common"
local ECS = require 'libs.ecs'
local ENUMS = require "world.enums.enums"
local COMMANDS = require "world.game.command.commands"

---@class GameCheckState:ECSSystem
local System = ECS.system()
System.name = "GameCheckState"

function System:init()

end

function System:update(dt)
    if (self.world.game_world.game.state == ENUMS.GAME_STATE.RUN) then
        if (not self.world.game_world.game.ecs_game.player._in_world) then
            COMMON.i("lose", "GAME")
            self.world.game_world.game.command_executor:command_add(COMMANDS.GameLoseCommand())
            self.world.game_world.game.state = ENUMS.GAME_STATE.LOSE
        elseif (self.world.game_world.game.ecs_game.entities.enemies == 0) then
            COMMON.i("win", "GAME")
            self.world.game_world.game.command_executor:command_add(COMMANDS.GameWinCommand())
            self.world.game_world.game.state = ENUMS.GAME_STATE.WIN
        end
    end

end

return System