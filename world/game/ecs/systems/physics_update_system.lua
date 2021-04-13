local ECS = require 'libs.ecs'
local ENUMS = require "world.enums.enums"

---@class PhysicsUpdateSystem:ECSSystem
local System = ECS.system()
System.name = "PhysicsUpdateSystem"

function System:update(dt)
    if (self.world.game_world.game.state ~= ENUMS.GAME_STATE.PREPARE) then
        physics3d.update()

    end
end

return System