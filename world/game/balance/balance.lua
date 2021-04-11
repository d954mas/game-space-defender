local CAMERAS = require "libs_project.cameras"
local COMMON = require "libs.common"

local BALANCE = {}

BALANCE.BAD_PERCENT = 0

BALANCE.S03_SIZE_MIN = 0.001
BALANCE.S03_SIZE_MAX = 0.02

BALANCE.S03_SPEED_MIN = 0.05
BALANCE.S03_SPEED_MAX = 0.4

BALANCE.S03_DENSITY_MIN = 1
BALANCE.S03_DENSITY_MAX = 2

BALANCE.SQUARE_SPAWN_MULTIPLY = 1

--game zone is take all available space. margin depends on width
BALANCE.GAME_ZONE_MARGIN_PERCENT = 0.05445151
BALANCE.GAME_ZONE = {
    x = 0, y = 0, w = 0, h = 0, left_top = { x = 0, y = 0 }, right_bottom = { x = 0, y = 0 }
}


BALANCE.SQUARE_TYPE = {
    SQUARE_1 = "SQUARE_1",
    SQUARE_2 = "SQUARE_2",
    SQUARE_3 = "SQUARE_3",
    SQUARE_4 = "SQUARE_4"
}
BALANCE.SQUARE_TYPE_LIST = {}
for _,v in pairs(BALANCE.SQUARE_TYPE)do
    table.insert(BALANCE.SQUARE_TYPE_LIST,v)
end


BALANCE.SQUARE_TYPE_CONFIG = {
    [BALANCE.SQUARE_TYPE.SQUARE_1] = {image = COMMON.HASHES.hash("square_1")},
    [BALANCE.SQUARE_TYPE.SQUARE_2] = {image = COMMON.HASHES.hash("square_2")},
    [BALANCE.SQUARE_TYPE.SQUARE_3] = {image = COMMON.HASHES.hash("square_3")},
    [BALANCE.SQUARE_TYPE.SQUARE_4] = {image = COMMON.HASHES.hash("square_4")}
}

function BALANCE.on_screen_changed()
    local w = CAMERAS.game_camera.view_area.x - CAMERAS.game_camera.view_area.x * BALANCE.GAME_ZONE_MARGIN_PERCENT * 2
    local h = CAMERAS.game_camera.view_area.y - CAMERAS.game_camera.view_area.y * BALANCE.GAME_ZONE_MARGIN_PERCENT * 2

    BALANCE.GAME_ZONE.x = -w / 2
    BALANCE.GAME_ZONE.y = -h / 2
    BALANCE.GAME_ZONE.w = w
    BALANCE.GAME_ZONE.h = h

    BALANCE.GAME_ZONE.left_top.x = BALANCE.GAME_ZONE.x
    BALANCE.GAME_ZONE.left_top.y = BALANCE.GAME_ZONE.y + h

    BALANCE.GAME_ZONE.right_bottom.x = BALANCE.GAME_ZONE.x + w
    BALANCE.GAME_ZONE.right_bottom.y = BALANCE.GAME_ZONE.y
end

---@param squares EntityGame[]
function BALANCE.square_count_score(squares)
    local len = #squares
    if(len == 0) then return -5 end
    if(len == 1) then return 1 end
    return math.pow(len,2)

end



function BALANCE.init()
    BALANCE.on_screen_changed()
end

function BALANCE.game_zone_coords_to_world(x, y)
    x = BALANCE.GAME_ZONE.x + BALANCE.GAME_ZONE.w * x
    y = BALANCE.GAME_ZONE.y + BALANCE.GAME_ZONE.h * y
    return x, y
end

return BALANCE