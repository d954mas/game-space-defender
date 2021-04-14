local ECS = require 'libs.ecs'


---@class EnemyCheckPositionSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.filter("enemy")
System.name = "EnemyCheckPositionSystem"



function System:init()

end

---@param e EntityGame
function System:process(e, dt)
    if(e.position.y < -50) then
        e.position.y = self.world.game_world.balance.game_area.height + e.position.y
        local half_w = 82/2
        e.position.x =  math.random(-270+half_w,270-half_w)

    end
end

return System