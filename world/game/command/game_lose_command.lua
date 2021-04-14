local COMMON = require "libs.common"
local SM = require "libs_project.sm"
local CommandBase = require "world.commands.command_base"

---@class GameLoseCommand:CommandBase
local GameLoseCommand = COMMON.class("GameLoseCommand", CommandBase)

function GameLoseCommand:act(dt)
    COMMON.coroutine_wait(0.25)
    SM:show(SM.SCENES.GAME_LOSE)
    self.world.storage.resource:money_add(self.world.balance:score_to_money(self.world.game.score))
    self.world.storage.highscore:highscore_add(self.world.game.score)
end

return GameLoseCommand