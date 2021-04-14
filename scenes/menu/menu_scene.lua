local BaseScene = require "libs.sm.scene"


---@class MenuScene:Scene
local Scene = BaseScene:subclass("Menu")
function Scene:initialize()
    BaseScene.initialize(self, "MenuScene", "/menu_scene#collectionproxy")
    self._config.keep_loaded = true
    self.world = reqf "world.world"
end

function Scene:show_done()
    BaseScene.show_done(self)
    self.world.ads:banner_show("menu")
end

function Scene:hide_done()
    self.world.ads:banner_hide("menu")
end

return Scene