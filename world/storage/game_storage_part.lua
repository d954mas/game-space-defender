local COMMON = require "libs.common"
local StoragePart = require "world.storage.storage_part_base"

---@class GamePartOptions:StoragePartBase
local Storage = COMMON.class("GamePartOptions", StoragePart)

function Storage:initialize(...)
    StoragePart.initialize(self, ...)
    self.game = self.storage.data.game
end

function Storage:firerate_level_upgrade()
end

function Storage:firerate_level_can_upgrade()
    return self.world.balance:firerate_level_cost_upgrade_get() > self.world.storage.resource:money_get()
end

function Storage:firerate_level_get()
    return self.game.firerate_level
end

return Storage