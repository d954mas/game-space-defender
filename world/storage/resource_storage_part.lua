local COMMON = require "libs.common"
local StoragePart = require "world.storage.storage_part_base"

---@class ResourcePartOptions:StoragePartBase
local Storage = COMMON.class("ResourcePartOptions",StoragePart)

function Storage:initialize(...)
    StoragePart.initialize(self,...)
    self.resource = self.storage.data.resource
end

function Storage:score_change(v)
    checks("?","number")
    self.resource.score = math.max(self.resource.score+v,0)
    self:save_and_changed(true)
end
function Storage:score_get()
    return self.resource.score
end



return Storage