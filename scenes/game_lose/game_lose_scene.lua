local BaseScene = require "libs.sm.scene"

---@class GameLoseScene:Scene
local Scene = BaseScene:subclass("GameLoseScene")
function Scene:initialize()
    BaseScene.initialize(self, "GameLoseScene", "/game_lose_scene#collectionproxy")
    self._config.modal = true
end

return Scene