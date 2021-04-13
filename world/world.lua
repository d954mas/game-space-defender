local COMMON = require "libs.common"
local Storage = require "world.storage.storage"
local GameWorld = require "world.game.game_world"
local CommandExecutor = require "world.commands.command_executor"
local Balance = require "world.balance.balance"

local TAG = "WORLD"
---@class World
local M = COMMON.class("World")

function M:initialize()
    COMMON.i("init", TAG)
    self.storage = Storage(self)
    self.command_executor = CommandExecutor()
    self.balance = Balance(self)
    self.game = GameWorld(self)
end

function M:update(dt)
    self.command_executor:act(dt)
    self.storage:update(dt)
    if (COMMON.CONTEXT:exist(COMMON.CONTEXT.NAMES.GAME)) then
        local ctx = COMMON.CONTEXT:set_context_top_game()
        self.game:update(dt)
        ctx:remove()
    end

end

function M:final()
    COMMON.i("final", TAG)
end

return M()