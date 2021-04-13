local COMMON = require "libs.common"
local ACTIONS = require "libs.actions.actions"
local SM = require "libs_project.sm"
local CommandBase = require "world.commands.command_base"

---@class GameLoseCommand:CommandBase
local GameLoseCommand = COMMON.class("GameLoseCommand", CommandBase)

function GameLoseCommand:act(dt)
    COMMON.coroutine_wait(0.5)
    self.world.storage.resource:money_add(self.world.balance:score_to_money(self.world.game.score))
    SM:back()
end

return GameLoseCommand