local COMMON = require "libs.common"

local STAR_FACTORY = msg.url("main:/factories#star")

local STARS_CONFIG = {
    small = 80, mid = 40, big = 12,
    size = { w = 32, h = 32 },
    small_scale = 10 / 32, mid_scale = 16 / 32, big_scale = 26 / 32
}

---@class StarView
local Star = COMMON.class("StarView")

---@param world World
function Star:initialize(world)
    self.world = assert(world)
    self.position = vmath.vector3(0)
    self.position.x = math.random(-270, 270)
    self.position.y = math.random(0, world.balance.game_area.height)
    self.position.z = -1
    self.velocity = vmath.vector3(0, -100, 0)
    self.go = msg.url(factory.create(STAR_FACTORY, self.position))
    self.scale = 1
    self.velocity_scale = COMMON.LUME.random(0.9,1.33)
end

function Star:scale_set(scale)
    self.scale = assert(scale)
    go.set_scale(self.scale, self.go)
end

function Star:update(dt)
    self.position.y = self.position.y + self.velocity.y * self.velocity_scale * dt;
    if (self.position.y < -STARS_CONFIG.size.h) then
        self.position.y = self.world.balance.game_area.height
        self.position.x = math.random(-270, 270)
        self.velocity_scale = COMMON.LUME.random(0.9,1.33)
    end
    go.set_position(self.position,self.go)
end

local Stars = COMMON.class("StarsView")

---@param world World
function Stars:initialize(world)
    self.world = assert(world)
    ---@type StarView[]
    self.stars = {}

    for i = 1, STARS_CONFIG.small do
        local star = Star(self.world)
        star:scale_set(STARS_CONFIG.small_scale)
        table.insert(self.stars, star)
    end

    for i = 1, STARS_CONFIG.mid do
        local star = Star(self.world)
        star:scale_set(STARS_CONFIG.mid_scale)
        table.insert(self.stars, star)
    end

    for i = 1, STARS_CONFIG.big do
        local star = Star(self.world)
        star:scale_set(STARS_CONFIG.big_scale)
        table.insert(self.stars, star)
    end


end

function Stars:update(dt)
    dt = 0.016
    for _, star in ipairs(self.stars) do
        star:update(dt)
    end
end

return Stars