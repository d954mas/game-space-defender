local COMMON = require "libs.common"
local ECS = require 'libs.ecs'
local ENUMS = require "world.enums.enums"
local CAMERAS = require "libs_project.cameras"

local FACTORY = {}

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