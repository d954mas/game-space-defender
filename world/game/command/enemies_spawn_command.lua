local COMMON = require "libs.common"
local CAMERAS = require "libs_project.cameras"
local ENUMS = require "world.enums.enums"
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
        self.world.game.ecs_game:add_entity(self.world.game.ecs_game.entities:create_enemy_base(x,y))
    end

    for i=1, self.world.balance:level_enemy_shooting_count(level) do
        local x = math.random(-270+half_w,270-half_w)
        local y = math.random(self.world.balance.game_area.height,self.world.balance.game_area.height*2)
        y = y - (self.world.balance.game_area.height-CAMERAS.game_camera.view_area.y)+100
        self.world.game.ecs_game:add_entity(self.world.game.ecs_game.entities:create_enemy_shooting(x,y))
    end
    self.world.game.ecs_game.ecs:refresh()
    self.world.game.state = ENUMS.GAME_STATE.RUN
end

return EnemiesSpawnCommand