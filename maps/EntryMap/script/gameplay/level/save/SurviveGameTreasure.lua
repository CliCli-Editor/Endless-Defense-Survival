local LogicBase = include("gameplay.level.logic.LogicBase")
local SurviveGameTreasure = class("SurviveGameTreasure", LogicBase)
local treasure = include("gameplay.config.treasure")
local GameUtils = include("gameplay.utils.GameUtils")

function SurviveGameTreasure:ctor(level)
    SurviveGameTreasure.super.ctor(self, level)
    self:_initCfg()
end

function SurviveGameTreasure:_initCfg()
    local treasureSaveData = y3.userData:loadTable("Treasure")
    self._treasureSaveData = treasureSaveData

    self._treasureMap = {}
    local len = treasure.length()
    for i = 1, len do
        local cfg = treasure.indexOf(i)
        assert(cfg, "")
        if not self._treasureMap[cfg.treasure_type] then
            self._treasureMap[cfg.treasure_type] = {}
        end
        table.insert(self._treasureMap[cfg.treasure_type], cfg)
    end
    self._recordPacks = {}
end

function SurviveGameTreasure:upgradeTreasure(playerId, treasureId)
    if playerId ~= y3.gameApp:getMyPlayerId() then
        return
    end
    xpcall(function(...)
        local saveItemLogic = y3.gameApp:getLevel():getLogic("SurviveGameSaveItem")
        local saveData = self._treasureSaveData[treasureId]
        if not saveData then
            return
        end
        local params = y3.userDataHelper.getSaveDataDecryptConcat(saveData)

        local treasureCfg = treasure.get(treasureId)
        assert(treasureCfg, "")
        local costItem = tonumber(treasureCfg.cost_up_item)
        local cost_up_num = string.split(treasureCfg.cost_up_num, "|")
        assert(cost_up_num, "")
        local level = tonumber(params[2]) or 0 -- saveData.level
        if level >= treasureCfg.max_level then
            y3.Sugar.localTips(playerId, y3.Lang.get("treasure_level_max_tip"))
            return
        end
        local costNum = tonumber(cost_up_num[level + 1])
        if not costNum then
            y3.Sugar.localTips(playerId, y3.Lang.get("treasure_lv_up_cost_tip"))
            return
        end
        local haveNum = saveItemLogic:getSaveItemNum(playerId, costItem)
        if haveNum >= costNum then
            saveItemLogic:dropSaveItem(playerId, costItem, -costNum)
            level = level + 1
            self._treasureSaveData[treasureId] = y3.userDataHelper.getSaveDataEncryptConcat(treasureId, level)
            y3.Sugar.localTips(playerId, y3.Lang.get("treasure_lv_up_success"))
            y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SURVIVE_TRAESURE_LV_UP)
        else
            y3.Sugar.localTips(playerId, y3.Lang.get("treasure_lv_up_cost_tip"))
        end
    end, __G__TRACKBACK__)
end

function SurviveGameTreasure:initTreasureAttr()
    local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    self:_initSignalTreasureAttr(playerData)
end

function SurviveGameTreasure:_initSignalTreasureAttr(playerData)
    local attrPackList = self:getTreasureAttrList(playerData)
    y3.SyncMgr:sync(y3.SyncConst.SYNC_ATTR_PACK_LIST, { attrPackList = attrPackList })
end

function SurviveGameTreasure:getTreasureAttrList(playerData)
    local player = playerData:getPlayer()
    local treasureSaveData = y3.userData:loadTableByPlayer(player, "Treasure")
    local len = treasure.length()
    local treasureTypeNumMap = {}
    local attrPackList = {}
    local haveNum = 0
    local recordPacks = {}
    for i = 1, len do
        local cfg = treasure.indexOf(i)
        assert(cfg, "")
        local saveData = treasureSaveData[cfg.id]
        if saveData then
            haveNum = haveNum + 1
            if not treasureTypeNumMap[cfg.treasure_type] then
                treasureTypeNumMap[cfg.treasure_type] = 0
            end
            treasureTypeNumMap[cfg.treasure_type] = treasureTypeNumMap[cfg.treasure_type] + 1
            table.insert(attrPackList, cfg.attr_pack)
            table.insert(recordPacks, { treasureId = cfg.id, pack = cfg.attr_pack, own = 1 })
            local params = y3.userDataHelper.getSaveDataDecryptConcat(saveData)
            local level = tonumber(params[2]) or 0 --saveData.level
            for lv = 1, level do
                table.insert(attrPackList, cfg.attr_pack_up)
                table.insert(recordPacks, { treasureId = cfg.id, pack = cfg.attr_pack_up, lv = lv })
            end
        end
    end
    local treasure_progress = include("gameplay.config.treasure_progress")
    local len = treasure_progress.length()
    for i = 1, len do
        local cfg = treasure_progress.indexOf(i)
        assert(cfg, "")
        local typeHaveNum = treasureTypeNumMap[cfg.progress_type] or 0
        if typeHaveNum >= cfg.progress then
            table.insert(attrPackList, cfg.attr_pack)
            table.insert(recordPacks, { treasurePro = cfg.id, pack = cfg.attr_pack, progress = 1 })
        end
    end
    self._recordPacks = recordPacks
    return attrPackList
end

function SurviveGameTreasure:printRecordPacks()
    print("藏品增加属性:")
    for i = 1, #self._recordPacks do
        local record = self._recordPacks[i]
        dump_all(record)
        print("属性:")
        local attrPackList = y3.userDataHelper.getAttrListByPack(record.pack)
        for j = 1, #attrPackList do
            print(attrPackList[j].name, attrPackList[j].value)
        end
    end
end

function SurviveGameTreasure:getTreasureNumByType(playerId, treasureType)
    local playerData = y3.userData:getPlayerData(playerId)
    local player = playerData:getPlayer()
    local treasureSaveData = y3.userData:loadTableByPlayer(player, "Treasure")
    local len = treasure.length()
    local treasureTypeNumMap = {}
    for i = 1, len do
        local cfg = treasure.indexOf(i)
        assert(cfg, "")
        local saveData = treasureSaveData[cfg.id]
        if saveData then
            if not treasureTypeNumMap[cfg.treasure_type] then
                treasureTypeNumMap[cfg.treasure_type] = 0
            end
            treasureTypeNumMap[cfg.treasure_type] = treasureTypeNumMap[cfg.treasure_type] + 1
        end
    end
    return treasureTypeNumMap[treasureType] or 0
end

function SurviveGameTreasure:getAllTreasureNum(playerId)
    local count = 0
    for i = 1, 5 do
        count = count + self:getTreasureNumByType(playerId, i)
    end
    return count
end

function SurviveGameTreasure:treasureIsUnlock(playerId, treasureId)
    local playerData = y3.userData:getPlayerData(playerId)
    local player = playerData:getPlayer()
    local treasureSaveData = y3.userData:loadTableByPlayer(player, "Treasure")
    local cfg = treasure.get(treasureId)
    assert(cfg, "can not found cfg by id=" .. treasureId)
    local saveData = treasureSaveData[cfg.id]
    if saveData then
        return true
    end
    return false
end

function SurviveGameTreasure:getTreasureLevel(playerId, treasureId)
    local playerData = y3.userData:getPlayerData(playerId)
    local player = playerData:getPlayer()
    local treasureSaveData = y3.userData:loadTableByPlayer(player, "Treasure")
    local cfg = treasure.get(treasureId)
    assert(cfg, "can not found cfg by id=" .. treasureId)
    local saveData = treasureSaveData[cfg.id]
    if saveData then
        local params = y3.userDataHelper.getSaveDataDecryptConcat(saveData)
        return tonumber(params[2]) or 0 --saveData.level
    end
    return 0
end

function SurviveGameTreasure:dropTreasure(playerId, treasureId)
    if playerId ~= y3.gameApp:getMyPlayerId() then
        return
    end
    xpcall(function(...)
        local playerData = y3.userData:getPlayerData(playerId)
        local player = playerData:getPlayer()
        local treasureSaveData = y3.userData:loadTableByPlayer(player, "Treasure")
        local cfg = treasure.get(treasureId)
        assert(cfg, "can not found cfg by id=" .. treasureId)
        if not treasureSaveData[cfg.id] then
            treasureSaveData[cfg.id] = y3.userDataHelper.getSaveDataEncryptConcat(cfg.id, 0)
            -- local saveData = treasureSaveData[cfg.id]
            -- saveData.id = cfg.id
            -- saveData.level = 0
        end
    end, __G__TRACKBACK__)
end

return SurviveGameTreasure
