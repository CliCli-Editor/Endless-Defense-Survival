local LogicBase = include("gameplay.level.logic.LogicBase")
local SurviveGameAchievementTitle = class("SurviveGameAchievementTitle", LogicBase)

function SurviveGameAchievementTitle:ctor(level)
    SurviveGameAchievementTitle.super.ctor(self, level)
    self:_initData()
end

function SurviveGameAchievementTitle:_initData()
    self._randomNum = math.random(1, 10001) - 1
    local saveInfo = y3.userData:loadTable("PlayerInfo")
    self._playerInfo = saveInfo
    if not self._playerInfo.titleList then
        self._playerInfo.titleList = {}
    end
    local title = include("gameplay.config.title")
    self._titleListMap = {}
    local len = title.length()
    for i = 1, len do
        local cfg = title.indexOf(i)
        assert(cfg, "")
        if not self._titleListMap[cfg.type] then
            self._titleListMap[cfg.type] = {}
        end
        if cfg.if_own == 1 then
            table.insert(self._titleListMap[cfg.type], cfg)
        end
    end
    self:_initTitleMap()
end

function SurviveGameAchievementTitle:_randomTitleSync(typeIndex)
    local list = self._titleListMap[typeIndex]
    if list and #list > 0 then
        local index = self._randomNum % #list + 1
        local titleId = list[index].id
        y3.SyncMgr:sync(y3.SyncConst.SYNC_EQUIP_TITLE, { titleId = titleId })
    end
end

function SurviveGameAchievementTitle:syncTitle()
    if self:getPreTitleId(y3.gameApp:getMyPlayerId()) == 0 then
        self:_randomTitleSync(1)
    else
        y3.SyncMgr:sync(y3.SyncConst.SYNC_EQUIP_TITLE, { titleId = self:getPreTitleId(y3.gameApp:getMyPlayerId()) })
    end
    if self:getConnectTitleId(y3.gameApp:getMyPlayerId()) == 0 then
        self:_randomTitleSync(2)
    else
        y3.SyncMgr:sync(y3.SyncConst.SYNC_EQUIP_TITLE, { titleId = self:getConnectTitleId(y3.gameApp:getMyPlayerId()) })
    end
    if self:getSuffixTtileId(y3.gameApp:getMyPlayerId()) == 0 then
        self:_randomTitleSync(3)
    else
        y3.SyncMgr:sync(y3.SyncConst.SYNC_EQUIP_TITLE, { titleId = self:getSuffixTtileId(y3.gameApp:getMyPlayerId()) })
    end
end

function SurviveGameAchievementTitle:_initTitleMap()
    local list = self._playerInfo.titleList or {}
    self._titleMap = {}
    for titleId, _ in pairs(list) do
        if titleId then
            local titleIdDe = tonumber(y3.gameApp:decryptString(titleId))
            if titleIdDe and titleIdDe > 0 then
                self._titleMap[titleIdDe] = true
            end
        end
    end
end

function SurviveGameAchievementTitle:dropTitle(playerId, titleId)
    if playerId ~= y3.gameApp:getMyPlayerId() then
        return
    end
    xpcall(function(...)
        if not self._titleMap[titleId] then
            self._titleMap[titleId] = true
            local list = self._playerInfo.titleList
            local titleIdEn = y3.gameApp:encryptString(tostring(titleId))
            list[titleIdEn] = 1
        end
    end, __G__TRACKBACK__)
end

function SurviveGameAchievementTitle:titleIsUnLock(playerId, titleId)
    local cfg = include("gameplay.config.title").get(titleId)
    if not cfg then
        return false
    end
    if cfg.if_own == 1 then
        return true
    end
    local playerData = y3.userData:getPlayerData(playerId)
    local player = playerData:getPlayer()
    local saveInfo = y3.userData:loadTableByPlayer(player, "PlayerInfo")
    local list = saveInfo.titleList
    local titleMap = {}
    for titleId, _ in pairs(list) do
        local titleIdDe = tonumber(y3.gameApp:decryptString(titleId))
        if titleIdDe then
            titleMap[titleIdDe] = true
        end
    end
    if titleMap[titleId] then
        return true
    end
    return false
end

function SurviveGameAchievementTitle:initTitleAttr()
    local attrPackList = self:getAttrPackList(y3.gameApp:getMyPlayerId())
    y3.SyncMgr:sync(y3.SyncConst.SYNC_ATTR_PACK_LIST, { attrPackList = attrPackList })
end

function SurviveGameAchievementTitle:getAttrPackList(playerId)
    local playetData = y3.userData:getPlayerData(playerId)
    local player = playetData:getPlayer()
    local title = include("gameplay.config.title")
    local len = title.length()
    local attrPackList = {}
    for i = 1, len do
        local cfg = title.indexOf(i)
        if self:titleIsUnLock(player:get_id(), cfg.id) then
            table.insert(attrPackList, cfg.attr_pack)
        end
    end
    
    local function addTitleAttrPack(titleId)
        local cfg = include("gameplay.config.title").get(titleId)
        if cfg and cfg.equip_attr_pack ~= "" then
            table.insert(attrPackList, cfg.equip_attr_pack)
        end
    end

    local preTitleId = playetData:getPreTitleId()
    addTitleAttrPack(preTitleId)
    local connectTitleId = playetData:getConnectTitleId()
    addTitleAttrPack(connectTitleId)
    local suffixTitleId = playetData:getSuffixTtileId()
    addTitleAttrPack(suffixTitleId)
    return attrPackList
end

function SurviveGameAchievementTitle:equipTitile(playerId, titleId)
    if playerId ~= y3.gameApp:getMyPlayerId() then
        return
    end
    xpcall(function(...)
        local playerData = y3.userData:getPlayerData(playerId)
        local player = playerData:getPlayer()
        local saveInfo = y3.userData:loadTableByPlayer(player, "PlayerInfo")
        local cfg = include("gameplay.config.title").get(titleId)
        if not cfg then
            return
        end
        if cfg.type == 1 then
            saveInfo["preTitleId"] = y3.gameApp:encryptString(tostring(titleId))
        elseif cfg.type == 2 then
            saveInfo["connectTitleId"] = y3.gameApp:encryptString(tostring(titleId))
        elseif cfg.type == 3 then
            saveInfo["suffixTtileId"] = y3.gameApp:encryptString(tostring(titleId))
        end
    end, __G__TRACKBACK__)
end

function SurviveGameAchievementTitle:getPreTitleId(playerId)
    local playerData = y3.userData:getPlayerData(playerId)
    local player = playerData:getPlayer()
    local saveInfo = y3.userData:loadTableByPlayer(player, "PlayerInfo")
    if saveInfo["preTitleId"] then
        return tonumber(y3.gameApp:decryptString(saveInfo["preTitleId"])) or 0
    end
    return 0
end

function SurviveGameAchievementTitle:getConnectTitleId(playerId)
    local playerData = y3.userData:getPlayerData(playerId)
    local player = playerData:getPlayer()
    local saveInfo = y3.userData:loadTableByPlayer(player, "PlayerInfo")
    if saveInfo["connectTitleId"] then
        return tonumber(y3.gameApp:decryptString(saveInfo["connectTitleId"])) or 0
    end
    return 0
end

function SurviveGameAchievementTitle:getSuffixTtileId(playerId)
    local playerData = y3.userData:getPlayerData(playerId)
    local player = playerData:getPlayer()
    local saveInfo = y3.userData:loadTableByPlayer(player, "PlayerInfo")
    if saveInfo["suffixTtileId"] then
        return tonumber(y3.gameApp:decryptString(saveInfo["suffixTtileId"])) or 0
    end
    return 0
end

return SurviveGameAchievementTitle
