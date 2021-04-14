local COMMON = require "libs.common"
local CAMERAS = require "libs_project.cameras"
local CommandBase = require "world.commands.command_base"

---@class GameWinCommand:CommandBase
local GameWinCommand = COMMON.class("GameWinCommand", CommandBase)

function GameWinCommand:act(dt)
    ---@type EntityGame
    local player = self.world.game.ecs_game.player
    player.movement.direction.x = 0
    player.movement.direction.y = 1
    while (player.position.y < CAMERAS.game_camera.view_area.y+50) do  coroutine.yield() end
    player.movement.direction.y = 0
    player.movement.direction.x = 0

    COMMON.coroutine_wait(0.5)

    self.world.game:level_next()

end

return GameWinCommand