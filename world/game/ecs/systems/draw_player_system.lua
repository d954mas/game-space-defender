local COMMON = require "libs.common"
local ECS = require 'libs.ecs'

---@class DrawPlayerSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.filter("player")
System.name = "DrawPlayerSystem"

local V3 = vmath.vector3(0, 0, 0.1)

function System:init()

end

---@param e EntityGame
function System:process(e, dt)
    if (e.player_go) then
        V3.x, V3.y, V3.z = e.position.x, e.position.y, e.position.z
        go.set_position(V3, e.player_go)
    end
end

return System