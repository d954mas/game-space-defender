local COMMON = require "libs.common"
local CONSTANTS = require "libs.constants"
local JSON = require "libs.json"
local OptionsStoragePart = require "world.storage.options_storage_part"
local DebugStoragePart = require "world.storage.debug_storage_part"
local ResourceStoragePart = require "world.storage.resource_storage_part"
local HighscoreStoragePart = require "world.storage.highscore_storage_part"
local GameStoragePart = require "world.storage.game_storage_part"

local TAG = "Storage"

---@class Storage
local Storage = COMMON.class("Storage")

Storage.VERSION = 14
Storage.AUTOSAVE = 30 --seconds
Storage.CLEAR = CONSTANTS.VERSION_IS_DEV and false --BE CAREFUL. Do not use in prod
Storage.LOCAL = CONSTANTS.VERSION_IS_DEV and CONSTANTS.PLATFORM_IS_PC and true --BE CAREFUL. Do not use in prod

---@param world World
function Storage:initialize(world)
    checks("?", "class:World")
    self.world = world
    self:_load_storage()
    self.prev_save_time = os.clock()
    self.save_on_update = false

    self.options = OptionsStoragePart(self)
    self.debug = DebugStoragePart(self)
    self.resource = ResourceStoragePart(self)
    self.highscore = HighscoreStoragePart(self)
    self.game = GameStoragePart(self)
end

function Storage:changed()
    self.change_flag = true
end

function Storage:_get_path()
    if (Storage.LOCAL) then
        return "storage.json"
    end
    return sys.get_save_file("game_name", "storage.json")
end

function Storage:_load_storage()
    local path = self:_get_path()
    local file = io.open(path, "r")
    if (file and not Storage.CLEAR) then
        COMMON.i("load", TAG)
        local contents, read_err = file:read("*a")
        COMMON.i("from file:\n" .. contents, TAG)
        local result, data = pcall(JSON.decode, contents)
        if (result) then
            self.data = assert(data)
        else
            print("can't load from file:" .. tostring(read_err))
            self:_init_storage()
            self:save(true)
        end
    else
        self:_init_storage()
    end
    self:_migration()
    self:save(true)
    COMMON.i("loaded", TAG)
end

function Storage:update(dt)
    if (self.change_flag) then
        COMMON.EVENT_BUS:event(COMMON.EVENTS.STORAGE_CHANGED)
        self.change_flag = false
    end
    if (self.save_on_update) then
        self:save(true)
    end
    if (Storage.AUTOSAVE and Storage.AUTOSAVE ~= -1) then
        if (os.clock() - self.prev_save_time > Storage.AUTOSAVE) then
            COMMON.i("autosave", TAG)
            self:save(true)
        end
    end

end

function Storage:_init_storage()
    COMMON.i("init new", TAG)
    ---@class StorageData
    self.data = {
        debug = {
            developer = true,
            physics_debug_draw = true,
        },
        options = {
            sound = true,
            music = false
        },
        resource = {
            money = 0
        },
        highscores = {
            0, 0, 0, 0, 0
        },
        game = {
            firerate_level = 1,
        },
        version = Storage.VERSION
    }
end

function Storage:_migration()
    if (self.data.version < Storage.VERSION) then
        COMMON.i(string.format("migrate from:%s to %s", self.data.version, Storage.VERSION), TAG)

        if (self.data.version < 14) then
            self:_init_storage()
        end

        self.data.version = Storage.VERSION
    end
end

function Storage:save(force)
    if (force) then
        COMMON.i("save", TAG)
        self.prev_save_time = os.clock()
        local data = self:_get_path()
        local file = io.open(data, "w+")
        file:write(JSON.encode(self.data, true))
        file:close()
        self.save_on_update = false
    else
        self.save_on_update = true
    end
end

return Storage

