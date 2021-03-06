local COMMON = require "libs.common"
local GOOEY = require "gooey.themes.dirtylarry.dirtylarry"


---@class ButtonGUI
local Btn = COMMON.class("ButtonGUI")

function Btn:initialize(root_name)
	self.vh = {
		root = gui.get_node(root_name .. "/root"),
	}
	self.root_name = root_name
	self.gooey_listener = function()
		if self.input_listener then self.input_listener() end
	end
end

function Btn:set_input_listener(listener)
	self.input_listener = listener
end

function Btn:on_input(action_id,action)
	return not self.ignore_input and GOOEY.button(self.root_name,action_id,action,self.gooey_listener).consumed
end


function Btn:set_ignore_input(ignore)
	self.ignore_input = ignore
end

return Btn



