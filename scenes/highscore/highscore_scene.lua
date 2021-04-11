local BaseScene = require "libs.sm.scene"


---@class HighscoreScene:Scene
local Scene = BaseScene:subclass("HighscoreScene")
function Scene:initialize()
    BaseScene.initialize(self, "HighscoreScene", "/highscore_scene#collectionproxy")

end

return Scene