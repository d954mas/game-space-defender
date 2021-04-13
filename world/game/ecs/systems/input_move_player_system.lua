local ECS = require 'libs.ecs'
local INPUT = require "libs.input_receiver"
local COMMON = require "libs.common"
local CAMERAS = require "libs_project.cameras"

---@class InputMovePlayer:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.requireAll("player")
System.name = "InputMovePlayer"

---@param e EntityGame
function System:process(e, dt)
    if (INPUT.PRESSED_KEYS[COMMON.HASHES.INPUT.TOUCH] and INPUT.TOUCH[1]) then
        local action = INPUT.TOUCH[1]
        local pos = CAMERAS.game_camera:screen_to_world_2d(action.screen_x, action.screen_y, false)
        self.world.game_world.game.ecs_game.player.movement.to_point = pos
    end
end

return System