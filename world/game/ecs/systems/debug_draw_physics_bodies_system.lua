local ECS = require 'libs.ecs'


local URLS = {
	factory = {
		debug_physics_body_static = msg.url("game:/factories/debug#debug_physics_body_static"),
		debug_physics_body_dynamic = msg.url("game:/factories/debug#debug_physics_body_dynamic"),
	}
}

---@class DrawDebugPhysicsBodiesSystem:ECSSystem
local System = ECS.processingSystem()
System.filter = ECS.filter("physics_body")
System.name = "DebugDrawPhysicsBodies"

---@class DebugPhysicsBodyGo
---@field root url

---@param physics NativePhysicsRectBody
---@return DebugPhysicsBodyGo
local function create_go(physics)
	local x, y = physics:get_position()
	local w, h = physics:get_size()
	local f = URLS.factory
	local root = msg.url(factory.create(physics:is_static() and f.debug_physics_body_static or f.debug_physics_body_dynamic,
			vmath.vector3(x, y, 0.3), nil, nil, vmath.vector3(w/64, h/64, 1)))
	return { root = root }
end

---@param e EntityGame
function System:process(e, dt)
	if(not e.debug_physics_body_go) then
		e.debug_physics_body_go = create_go(e.physics_body)
	end

	if(e.debug_physics_body_go and e.physics_dynamic)then
		local x, y = e.physics_body:get_position()
		go.set_position(vmath.vector3(x, y, 0.3),e.debug_physics_body_go.root)
	end
end

return System