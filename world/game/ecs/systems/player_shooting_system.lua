local COMMON = require "libs.common"
local ECS = require 'libs.ecs'
local ENUMS = require "world.enums.enums"


---@class PlayerShootingSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.filter("player")
System.name = "PlayerShootingSystem"


function System:init()

end

---@param e EntityGame
function System:process(e, dt)
    if(self.world.game_world.game.state == ENUMS.GAME_STATE.RUN)then
        e.shooting_config.shoot_delay = e.shooting_config.shoot_delay - dt
        if(e.shooting_config.shoot_delay < 0) then
            e.shooting_config.shoot_delay = e.shooting_config.firerate
            self.world:addEntity(self.world.game_world.game.ecs_game.entities:create_player_projectile(e.position.x,e.position.y + 40))
        end
    end

end

return System