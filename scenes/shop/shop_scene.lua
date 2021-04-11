local BaseScene = require "libs.sm.scene"


---@class GameScene:Scene
local Scene = BaseScene:subclass("ShopScene")
function Scene:initialize()
    BaseScene.initialize(self, "ShopScene", "/shop_scene#collectionproxy")
end

return Scene