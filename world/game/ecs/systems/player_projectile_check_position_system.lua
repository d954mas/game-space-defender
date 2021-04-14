local ECS = require 'libs.ecs'
local CAMERAS = require "libs_project.cameras"

---@class PlayerProjectileCheckPositionSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.filter("player_projectile")
System.name = "PlayerProjectileCheckPositionSystem"

function System:init()

end

---@param e EntityGame
function System:process(e, dt)
    if (e.position.y > CAMERAS.game_camera.view_area.y + 40) then
        self.world:removeEntity(e)
    end
end

return System