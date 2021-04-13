local COMMON = require "libs.common"
local ECS = require 'libs.ecs'


---@class PlayerShootingSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.filter("player")
System.name = "PlayerShootingSystem"


function System:init()

end

---@param e EntityGame
function System:process(e, dt)
    e.shooting_config.shoot_delay = e.shooting_config.shoot_delay - dt
    if(e.shooting_config.shoot_delay < 0) then
        e.shooting_config.shoot_delay = e.shooting_config.firerate
        self.world:addEntity(self.world.game_world.game.ecs_game.entities:create_player_projectile(e.position.x,e.position.y + 40))
    end
end

return System