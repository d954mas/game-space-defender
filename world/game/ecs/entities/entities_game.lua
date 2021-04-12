local COMMON = require "libs.common"
local TAG = "Entities"


---@class MoveCurveConfig
---@field curve Curve
---@field a number position in curve [0,1]
---@field speed number
---@field deviation number
---@field position_descriptor number

---@class InputInfo
---@field action_id hash
---@field action table

---@class Size
---@field w number
---@field h number

---@class SquareHitScore
---@field score number
---@field touch_pos vector3 world coords
---@field hit_squares EntityGame[]

---@class EntityMovement
---@field velocity vector3
---@field speed number



---@class EntityGame
---@field tag string tag can search entity by tag
---@field position vector3
---@field move_curve_config MoveCurveConfig
---@field input_info InputInfo
---@field auto_destroy_delay number
---@field auto_destroy boolean
---@field physics_body NativePhysicsRectBody base collision. Not rotated.
---@field physics_static boolean|nil static bodies can't move.
---@field physics_dynamic boolean|nil dynamic bodies update their positions
---@field debug_physics_body_go DebugPhysicsBodyGo|nil
---@field movement EntityMovement
---@field player boolean
---@field player_go url
---@field actions Action[]

---@class ENTITIES
local Entities = COMMON.class("Entities")

function Entities:initialize()
    ---@type EntityGame[]
    self.by_tag = {}
    self.physic_groups = {
        SQUARE = bit.tobit(1),
        TOUCH = bit.tobit(2)
    }
    self.physic_mask = {
        TOUCH = bit.bor(self.physic_groups.SQUARE),
        SQUARE = bit.bor(self.physic_groups.TOUCH)
    }
end

function Entities:find_by_tag(tag)
    return self.by_tag[assert(tag)]
end

---@param ecs ECSWorld
function Entities:set_ecs_world(ecs)
    self.ecs_world = assert(ecs)
end

--region ecs callbacks
---@param e EntityGame
function Entities:on_entity_removed(e)
    if (e.tag) then
        self.by_tag[e.tag] = nil
    end
    if (e.debug_physics_body_go) then
        go.delete(e.debug_physics_body_go.root, true)
        e.debug_physics_body_go = nil
    end
    if (e.physics_body) then
        physics3d.destroy_rect(e.physics_body)
    end
end

---@param e EntityGame
function Entities:on_entity_added(e)
    if (e.tag) then
        COMMON.i("entity with tag:" .. e.tag, TAG)
        assert(not self.by_tag[e.tag])
        self.by_tag[e.tag] = e
    end
end

---@param e EntityGame
function Entities:on_entity_updated(e)
end
--endregion


--region Entities

---@return EntityGame
function Entities:create_input(action_id, action)
    return { input_info = { action_id = action_id, action = action }, auto_destroy = true }
end

---@return EntityGame
function Entities:create_player()
    ---@type EntityGame
    local player = {}
    player.player = true
    player.position = vmath.vector3(0, -50, 0)
    player.actions = {}
    player.player_go = msg.url("game_scene:/player")

    return player
end

return Entities




