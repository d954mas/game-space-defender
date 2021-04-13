local COMMON = require "libs.common"
---@type SceneManagerProject
local SM = COMMON.LUME.meta_getter(function() return reqf "libs_project.sm" end)
---@type Sounds
local SOUNDS = COMMON.LUME.meta_getter(function() return reqf "libs.sounds" end)
local SCENE_ENUMS = require "libs.sm.enums"

local TAG = "ADS"

local Ads = COMMON.class("Ads")

---@param world World
function Ads:initialize(world)
    checks("?", "class:World")
    self.world = world
    self.interstitial_ad_next_time = os.clock()
    self.interstitial_ad_next_time = 4 * 60
    self:gdsdk_init()
end

function Ads:gdsdk_init()
    if (gdsdk) then
        COMMON.w("init gdsdk", TAG)
        gdsdk.set_listener(function(self, event, message)
            COMMON.w("event:" .. tostring(event), TAG)
            pprint(message)
            if event == gdsdk.SDK_GAME_PAUSE then
                SOUNDS:pause()
                local scene = SM:get_top()
                if (scene and scene._state == SCENE_ENUMS.STATES.RUNNING) then
                    scene:pause()
                end
            elseif event == gdsdk.SDK_GAME_START then
                SOUNDS:resume()
                local scene = SM:get_top()
                if (scene and scene._state == SCENE_ENUMS.STATES.PAUSED) then
                    scene:resume()
                end
            end
        end)
    end
end

function Ads:show_interstitial_ad()
    if (os.clock() > self.interstitial_ad_next_time) then
        COMMON.w("interstitial_ad show", TAG)
        if (gdsdk) then gdsdk.show_interstitial_ad() else
            COMMON.w("interstitial_ad no provider")
        end
        self.interstitial_ad_next_time = os.clock() + self.interstitial_ad_next_time
    else
        COMMON.w("interstitial_ad need wait", TAG)
    end
end

function Ads:rewarded_ad_show()
    if (gdsdk) then
        gdsdk.show_rewarded_ad()
    end
end

function Ads:rewarded_ad_exist()
    if (gdsdk) then return true

    else
        return true
    end
end

return Ads
