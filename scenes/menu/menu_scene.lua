local WORLD = require "world.world"

local BaseScene = require "libs.sm.scene"


---@class MenuScene:Scene
local Scene = BaseScene:subclass("Menu")
function Scene:initialize()
    BaseScene.initialize(self, "MenuScene", "/menu_scene#collectionproxy")
    self._config.keep_loaded = true
end

function Scene:show_done()
    BaseScene.show_done(self)
    WORLD.ads:banner_show("menu")
end

function Scene:hide_done()
    WORLD.ads:banner_hide("menu")
end

return Scene