local BaseScene = require "libs.sm.scene"


---@class MenuScene:Scene
local Scene = BaseScene:subclass("Menu")
function Scene:initialize()
    BaseScene.initialize(self, "MenuScene", "/menu_scene#collectionproxy")
    self._config.keep_loaded = true
end

return Scene