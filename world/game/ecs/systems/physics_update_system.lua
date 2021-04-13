local ECS = require 'libs.ecs'
---@class PhysicsUpdateSystem:ECSSystem
local System = ECS.system()
System.name = "PhysicsUpdateSystem"

function System:update(dt)
    physics3d.update()
end


return System