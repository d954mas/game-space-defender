local COMMON = require "libs.common"
local Balance = COMMON.class("Balance")

---@param world World
function Balance:initialize(world)
    checks("?", "class:World")
    self.world = world
    self.game_area = {
        width = 540,
        height = 540 * 2.2
    }
end

function Balance:firerate_get()
    local level = self.world.storage.game:firerate_level_get()
    return 0.5 * math.pow(0.85, level - 1);
end

function Balance:firerate_level_cost_upgrade_get()
    local level = self.world.storage.game:firerate_level_get()
    return math.ceil(1000 * math.pow(1.5, level-1));
end

function Balance:level_enemy_base_count(level)
    return level * 10
end

--- 0, 0, 2, 5, 7, 10
function Balance:level_enemy_shooting_count(level)
    return math.max(0, math.floor(self:level_enemy_base_count(level) / 10 - 2) * 2.5)
end

function Balance:score_to_money(score)
    assert(score)
    return math.ceil(score * 0.03)
end

return Balance