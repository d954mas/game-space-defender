local COMMON = require "libs.common"
local ACTIONS = require "libs.actions.actions"
local CAMERAS = require "libs_project.cameras"
local CommandBase = require "world.commands.command_base"

---@class EnemiesSpawnCommand:CommandBase
local EnemiesSpawnCommand = COMMON.class("EnemiesSpawnCommand", CommandBase)

function EnemiesSpawnCommand:act(dt)
    local level = self.world.game.level
    local half_w = 82/2
    for i=1, self.world.balance:level_enemy_base_count(level) do
        local x = math.random(-270+half_w,270-half_w)
        local y = math.random(self.world.balance.game_area.height,self.world.balance.game_area.height*2)
        y = y - (self.world.balance.game_area.height-CAMERAS.game_camera.view_area.y)+100
    end

    for i=1, self.world.balance:level_enemy_shooting_count(level) do
        local x = math.random(-270+half_w,270-half_w)
        local y = math.random(self.world.balance.game_area.height,self.world.balance.game_area.height*2)
        y = y - (self.world.balance.game_area.height-CAMERAS.game_camera.view_area.y)+100
    end

end

return EnemiesSpawnCommand