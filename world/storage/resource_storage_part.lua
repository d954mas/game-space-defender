local COMMON = require "libs.common"
local StoragePart = require "world.storage.storage_part_base"

---@class ResourcePartOptions:StoragePartBase
local Storage = COMMON.class("ResourcePartOptions",StoragePart)

function Storage:initialize(...)
    StoragePart.initialize(self,...)
    self.resource = self.storage.data.resource
end

function Storage:money_add(v)
    checks("?","number")
    assert(v > 0)
    self.resource.score = math.max(self.resource.money+v,0)
    self:save_and_changed()
end
function Storage:money_get()
    return self.resource.score
end



return Storage