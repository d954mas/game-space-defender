
local COMMON = require "libs.common"
local Balance = COMMON.class("Balance")

---@param world World
function Balance:initialize(world)
    checks("?","class:World")
    self.world = world
end


function Balance:firerate_get()
    local level = self.world.storage.game:firerate_level_get()
    return 	0.25 * math.pow(0.75, level);
end

function Balance:firerate_level_cost_upgrade_get()
    local level = self.world.storage.game:firerate_level_get()
    return math.ceil(1000*math.pow(1.5, level));
end


return Balance