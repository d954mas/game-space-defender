local SM = require "libs.sm.scene_manager"

--MAIN SCENE MANAGER
local sm = SM()

local scenes = {
    require "scenes.game.game_scene",
    require "scenes.menu.menu_scene",
    require "scenes.shop.shop_scene",
    require "scenes.highscore.highscore_scene",
    require "scenes.game_lose.game_lose_scene"
}

sm.SCENES = {
    GAME = "GameScene",
    GAME_LOSE = "GameLoseScene",
    MENU = "MenuScene",
    SHOP = "ShopScene",
    HIGHSCORE = "HighscoreScene"
}

function sm:register_scenes()
    local reg_scenes = {}
    for i, v in ipairs(scenes) do reg_scenes[i] = v() end --create instances
    self:register(reg_scenes)
end

return sm