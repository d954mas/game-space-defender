local BaseScene = require "libs.sm.scene"


---@class GameScene:Scene
local Scene = BaseScene:subclass("Menu")
function Scene:initialize()
    BaseScene.initialize(self, "MenuScene", "/menu_scene#collectionproxy")
end

return Scene