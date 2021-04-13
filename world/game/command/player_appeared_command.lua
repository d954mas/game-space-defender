local COMMON = require "libs.common"
local ACTIONS = require "libs.actions.actions"
local CommandBase = require "world.commands.command_base"

---@class PlayerAppearedCommand:CommandBase
local PlayerAppearedCommand = COMMON.class("PlayerAppearedCommand", CommandBase)

function PlayerAppearedCommand:act(dt)
    ---@type EntityGame
    local player = self.world.game.ecs_game.player
    self.world.game.ecs_game.player.position.y = -50
    local action = ACTIONS.TweenTable { object = player, property = "position", v3 = true, from = vmath.vector3(0, -50, 0) ,
                                        to =  vmath.vector3(0, 55, 0) , time = 1.5 }
    table.insert(player.actions, action)
    while (not action:is_finished()) do  coroutine.yield() end
end

return PlayerAppearedCommand