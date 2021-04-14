local COMMON = require "libs.common"
local Storage = require "world.storage.storage"
local GameWorld = require "world.game.game_world"
local CommandExecutor = require "world.commands.command_executor"
local Balance = require "world.balance.balance"
local Ads = require "libs.ads.ads"

local TAG = "WORLD"
---@class World
local M = COMMON.class("World")

function M:initialize()
    COMMON.i("init", TAG)
    self.storage = Storage(self)
    self.command_executor = CommandExecutor()
    self.balance = Balance(self)
    self.game = GameWorld(self)
    self.ads = Ads(self)
end

function M:update(dt)
    self.command_executor:act(dt)
    self.storage:update(dt)
end

function M:final()
    COMMON.i("final", TAG)
end

return M()