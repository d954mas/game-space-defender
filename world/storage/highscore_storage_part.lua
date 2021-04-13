local COMMON = require "libs.common"
local StoragePart = require "world.storage.storage_part_base"

---@class HighscorePartOptions:StoragePartBase
local Storage = COMMON.class("HighscorePartOptions", StoragePart)

function Storage:initialize(...)
    StoragePart.initialize(self, ...)
    self.highscores = self.storage.data.highscores
end

function Storage:highscore_add(v)
    checks("?", "number")
    local add = false
    for i = 1, #self.highscores do
        if (v > self.highscores[i]) then
            table.insert(self.highscores,i, v)
            add = true
            break
        end
    end
    if (add) then
        --remove prev score from end
        table.remove(self.highscores)
    end
    self:save_and_changed()
end

function Storage:highscores_get()
    return COMMON.LUME.clone_shallow(self.highscores)
end

return Storage