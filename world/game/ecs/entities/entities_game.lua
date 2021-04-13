local COMMON = require "libs.common"
local TAG = "Entities"
local ENUMS = require "world.enums.enums"
local ACTIONS = require "libs.actions.actions"
---@type Sounds
local SOUNDS = COMMON.LUME.meta_getter(function()
    return reqf "libs.sounds"
end)

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
---@field acceleration vector3
---@field velocity vector3
---@field direction vector3
---@field to_point nil|vector3
---@field max_speed number
---@field accel number
---@field deaccel number
---@field ignore_y boolean can't move up(hero)
---@field gravity boolean use gravity

---@class ShootingConfig
---@field firerate vector3
---@field shoot_delay number


---@class EntityGame
---@field _in_world boolean is entity in world
---@field tag string tag can search entity by tag
---@field position vector3
---@field move_curve_config MoveCurveConfig
---@field input_info InputInfo
---@field auto_destroy_delay number
---@field auto_destroy boolean
---@field physics_body_origin vector3
---@field physics_body NativePhysicsRectBody base collision. Not rotated.
---@field physics_static boolean|nil static bodies can't move.
---@field physics_dynamic boolean|nil dynamic bodies update their positions
---@field debug_physics_body_go DebugPhysicsBodyGo|nil
---@field movement EntityMovement
---@field player boolean
---@field player_go url
---@field player_projectile boolean
---@field player_projectile_go url
---@field enemy boolean
---@field enemy_go url
---@field enemy_type string
---@field enemy_projectile boolean
---@field enemy_projectile_go url
---@field actions Action[]
---@field shooting_config ShootingConfig[]
---@field explosion boolean
---@field explosion_go url


---@class ENTITIES
local Entities = COMMON.class("Entities")

---@param world World
function Entities:initialize(world)
    self.world = world
    ---@type EntityGame[]
    self.by_tag = {}
    self.enemies = 0
    self.physic_groups = {
        PLAYER = bit.tobit(1),
        ENEMY = bit.tobit(2),
        PLAYER_PROJECTILE = bit.tobit(4),
        ENEMY_PROJECTILE = bit.tobit(8)
    }
    self.physic_mask = {
        PLAYER = bit.bor(self.physic_groups.ENEMY, self.physic_groups.ENEMY_PROJECTILE),
        PLAYER_PROJECTILE = bit.bor(self.physic_groups.ENEMY),
        ENEMY = bit.bor(self.physic_groups.PLAYER, self.physic_groups.PLAYER_PROJECTILE),
        ENEMY_PROJECTILE = bit.bor(self.physic_groups.PLAYER)
    }
end

function Entities:find_by_tag(tag)
    return self.by_tag[assert(tag)]
end


--region ecs callbacks
---@param e EntityGame
function Entities:on_entity_removed(e)
    e._in_world = false
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

    if (e.player_go) then
        go.delete(e.player_go, true)
        e.player_go = nil
    end

    if (e.enemy_go) then
        go.delete(e.enemy_go, true)
        e.enemy_go = nil
    end

    if (e.player_projectile_go) then
        go.delete(e.player_projectile_go, true)
        e.player_projectile_go = nil
    end
    if (e.enemy_projectile_go) then
        go.delete(e.enemy_projectile_go, true)
        e.enemy_projectile_go = nil
    end

    if (e.explosion_go) then
        go.delete(e.explosion_go, true)
        e.explosion_go = nil
    end

    if (e.enemy) then
        self.enemies = self.enemies - 1
    end
end

---@param e EntityGame
function Entities:on_entity_added(e)
    e._in_world = true
    if (e.tag) then
        COMMON.i("entity with tag:" .. e.tag, TAG)
        assert(not self.by_tag[e.tag])
        self.by_tag[e.tag] = e
    end
    if (e.enemy) then
        self.enemies = self.enemies + 1
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
    player.position = vmath.vector3(0, -50, 0.5)
    player.movement = {
        velocity = vmath.vector3(0, 0, 0),
        direction = vmath.vector3(0, 0, 0),
        max_speed = 270,
        acceleration = 1000,
        deaccel = 1000,
        ignore_y = true,
        gravity = true
    }
    player.actions = {}
    player.physics_dynamic = true
    player.physics_body_origin = vmath.vector3(0, 6, 0)
    player.physics_body = physics3d.create_rect(0, -50, 0, 64, 36, 20, false,
            self.physic_mask.PLAYER, self.physic_groups.PLAYER)
    player.shooting_config = {
        firerate = self.world.balance:firerate_get(),
        shoot_delay = self.world.balance:firerate_get()
    }
    player.physics_body:set_user_data(player)

    return player
end

---@return EntityGame
function Entities:create_player_projectile(x, y)
    ---@type EntityGame
    local e = {}
    e.player_projectile = true
    e.position = vmath.vector3(x, y, 0.55)
    e.movement = {
        velocity = vmath.vector3(0, 0, 0),
        direction = vmath.vector3(0, 1, 0),
        max_speed = 250,
        acceleration = 1000,
        deaccel = 1000,
        ignore_y = true,
        gravity = false
    }
    e.physics_dynamic = true
    e.physics_body_origin = vmath.vector3(0, 6, 0)
    e.physics_body = physics3d.create_rect(e.position.x, e.position.y, 0, 34, 60, 20, false,
            self.physic_mask.PLAYER_PROJECTILE, self.physic_groups.PLAYER_PROJECTILE)
    e.physics_body:set_user_data(e)
    return e
end

function Entities:create_enemy_projectile(x, y)
    ---@type EntityGame
    local e = {}
    e.enemy_projectile = true
    e.position = vmath.vector3(x, y, 0.7)
    e.movement = {
        velocity = vmath.vector3(0, 0, 0),
        direction = vmath.vector3(0, -1, 0),
        max_speed = 250,
        acceleration = 1000,
        deaccel = 1000,
        gravity = false
    }
    e.physics_dynamic = true
    e.physics_body_origin = vmath.vector3(0, 0, 0)
    e.physics_body = physics3d.create_rect(e.position.x, e.position.y, 0, 18, 18, 18, false,
            self.physic_mask.ENEMY_PROJECTILE, self.physic_groups.ENEMY_PROJECTILE)
    e.physics_body:set_user_data(e)

    return e
end
---@return EntityGame
function Entities:create_enemy_base(x, y)
    ---@type EntityGame
    local e = {}
    e.enemy = true
    e.position = vmath.vector3(x, y, 0.1)
    e.enemy_type = ENUMS.ENEMY_TYPE.BASE
    e.movement = {
        velocity = vmath.vector3(0, -1, 0),
        direction = vmath.vector3(0, -1, 0),
        max_speed = 200,
        acceleration = 1000,
        deaccel = 1000,
        gravity = false,
    }
    e.actions = {}
    e.physics_dynamic = true
    e.physics_body_origin = vmath.vector3(0, -6, 0)
    e.physics_body = physics3d.create_rect(e.position.x, e.position.y, 0, 64, 50, 20, false,
            self.physic_mask.ENEMY, self.physic_groups.ENEMY)
    e.physics_body:set_user_data(e)

    return e
end

function Entities:create_enemy_shooting(x, y)
    ---@type EntityGame
    local e = {}
    e.enemy = true
    e.position = vmath.vector3(x, y, 0.2)
    e.enemy_type = ENUMS.ENEMY_TYPE.SHOOTING
    e.movement = {
        velocity = vmath.vector3(0, 0, 0),
        direction = vmath.vector3(0, -1, 0),
        max_speed = 150,
        acceleration = 1000,
        deaccel = 1000,
        gravity = false,
    }
    e.actions = {}
    e.physics_dynamic = true
    e.physics_body_origin = vmath.vector3(0, 6, 0)
    e.physics_body = physics3d.create_rect(e.position.x, e.position.y, 0, 64, 36, 20, false,
            self.physic_mask.ENEMY, self.physic_groups.ENEMY)
    e.physics_body:set_user_data(e)
    e.shooting_config = {
        firerate = 3.5,
        shoot_delay = 2.5 + math.random()
    }
    return e
end

function Entities:create_explosion(x, y)
    ---@type EntityGame
    local e = {}
    e.position = vmath.vector3(x, y, 0.05)
    e.explosion = true
    e.actions = {
        ACTIONS.Function { fun = function()
            SOUNDS:play_sound(SOUNDS.sounds.explosion)
        end }
    }
    e.auto_destroy_delay = 0.4 + 16 / 24 --16 frame per 24(fps)
    return e
end

return Entities




