local LevelManager = class("LevelManager")

function LevelManager:ctor()
end

function LevelManager:switchLevel(levelID)
    GameAPI.request_switch_level((levelID))
end

function LevelManager:getCurLevelName()
    local lvid = GameAPI.get_current_level()
    local mapName = GlobalAPI.map_to_str(lvid)
    return mapName
end

return LevelManager
