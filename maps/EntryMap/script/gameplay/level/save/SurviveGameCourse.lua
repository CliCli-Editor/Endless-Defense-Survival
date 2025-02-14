local GameUtils = require "gameplay.utils.GameUtils"
local LogicBase = include("gameplay.level.logic.LogicBase")
local SurviveGameCourse = class("SurviveGameCourse", LogicBase)
-- 首次登陆时间
-- 通关场次
-- 地图等级
-- 存档评分
-- 收集藏品数量
-- 最高通关难度
local CFG_DATA = {
    { id = 1, name = "首次登陆时间" },
    { id = 2, name = "通关场次" },
    { id = 3, name = "地图等级" },
    { id = 4, name = "存档评分" },
    { id = 5, name = "收集藏品数量" },
    { id = 6, name = "最高通关难度" },
}

function SurviveGameCourse:ctor(level)
    SurviveGameCourse.super.ctor(self, level)
    self:_initData()
    y3.game:event('玩家-发送消息', function(trg, data)
        self:input(data.str1, data.player)
    end)
end

function SurviveGameCourse:input(input, player)
    if self._passwordKeyConst[input] then
        self:addPasswordKey(player:get_id(), input)
    end
end

function SurviveGameCourse:_initData()
    local saveInfo = y3.userData:loadTable("PlayerInfo")
    self._playerInfo = saveInfo

    local cdk = include("gameplay.config.cdk")
    self._passwordKeyConst = {}
    local len = cdk.length()
    for i = 1, len do
        local cfg = cdk.indexOf(i)
        assert(cfg, "")
        self._passwordKeyConst[cfg.key] = cfg
    end
end

function SurviveGameCourse:addServerTime(serverTime)
    if y3.game.is_debug_mode() then
        if self._playerInfo.serverTime then
            self._playerInfo.serverTime = self._playerInfo.serverTime + serverTime
        else
            self._playerInfo.serverTime = serverTime
        end
    end
end

function SurviveGameCourse:getServerTime()
    if y3.game.is_debug_mode() then
        if self._playerInfo.serverTime then
            return self._playerInfo.serverTime
        end
    end
    return 0
end

function SurviveGameCourse:getCfgList()
    local game_player_history = include("gameplay.config.game_player_history")
    local len = game_player_history.length()
    local result = {}
    for i = 1, len do
        local cfg = game_player_history.indexOf(i)
        assert(cfg, "")
        local data = {}
        data.id = cfg.id
        data.name = cfg.game_history_name
        table.insert(result, data)
    end
    return result
end

function SurviveGameCourse:addPasswordKey(playerId, uniqueKey)
    if playerId ~= y3.gameApp:getMyPlayerId() then
        return
    end
    xpcall(function(...)
        local saveInfo = self._playerInfo
        if not saveInfo.passwordKeys then
            saveInfo.passwordKeys = {}
        end
        local encryptUniqueKey = y3.gameApp:encryptString(uniqueKey)
        --if not saveInfo.passwordKeys[encryptUniqueKey] then
        if not y3.gameApp:isArchiveDataExists(saveInfo.passwordKeys, encryptUniqueKey) then
            saveInfo.passwordKeys[encryptUniqueKey] = encryptUniqueKey
            local cfg = self._passwordKeyConst[uniqueKey]
            if cfg and cfg.type == 1 then
                if cfg.reward ~= "" then
                    local rewards = string.split(cfg.reward, "|")
                    assert(rewards, "")
                    for i = 1, #rewards do
                        y3.userDataHelper.dropSaveItem(playerId, rewards[i])
                    end
                end
            end
        end
    end, __G__TRACKBACK__)
end

function SurviveGameCourse:dropHeroSkin(playerId, heroSkinId)
    if playerId ~= y3.gameApp:getMyPlayerId() then
        return
    end
    xpcall(function()
        local saveInfo = self._playerInfo
        if not saveInfo.heroSkins then
            saveInfo.heroSkins = {}
        end
        local encryptHeroSkinId = y3.gameApp:encryptString(heroSkinId)
        saveInfo.heroSkins[encryptHeroSkinId] = 1
    end, __G__TRACKBACK__)
end

function SurviveGameCourse:heroSkinIsUnlock(playerId, heroSkinId)
    local cfg = include("gameplay.config.hero").get(heroSkinId)
    if not cfg then
        return false
    end
    if cfg.default_own == 1 then
        return true
    end
    local playerData = y3.userData:getPlayerData(playerId)
    local player = playerData:getPlayer()
    local saveInfo = y3.userData:loadTableByPlayer(player, "PlayerInfo")
    if not saveInfo.heroSkins then
        return false
    end
    local encryptHeroSkinId = y3.gameApp:encryptString(heroSkinId)
    --return saveInfo.heroSkins[encryptHeroSkinId] == 1
    local temp = y3.gameApp:getArchiveData(saveInfo.heroSkins, encryptHeroSkinId)
    if type(temp) ~= "number" then
        return false
    end
    return temp == 1
end

function SurviveGameCourse:dropStageTower(playerId, stageTowerId)
    if playerId ~= y3.gameApp:getMyPlayerId() then
        return
    end
    xpcall(function()
        local saveInfo = self._playerInfo
        if not saveInfo.stageTowers then
            saveInfo.stageTowers = {}
        end
        local encryptStageTowerId = y3.gameApp:encryptString(stageTowerId)
        saveInfo.stageTowers[encryptStageTowerId] = 1
    end, __G__TRACKBACK__)
end

function SurviveGameCourse:stageTowerIsUnlock(playerId, stageTowerId)
    local cfg = include("gameplay.config.stage_tower").get(stageTowerId)
    if not cfg then
        return false
    end
    if cfg.tower_default_own == 1 then
        return true
    end
    local playerData = y3.userData:getPlayerData(playerId)
    local player = playerData:getPlayer()
    local saveInfo = y3.userData:loadTableByPlayer(player, "PlayerInfo")
    if not saveInfo.stageTowers then
        return false
    end
    local encryptStageTowerId = y3.gameApp:encryptString(stageTowerId)
    --return saveInfo.stageTowers[encryptStageTowerId] == 1
    local temp = y3.gameApp:getArchiveData(saveInfo.stageTowers, encryptStageTowerId)
    if type(temp) ~= "number" then
        return false
    end
    return temp == 1
end

function SurviveGameCourse:recordStageTower(playerId, stageTowerId)
    if playerId ~= y3.gameApp:getMyPlayerId() then
        return
    end
    xpcall(function(...)
        local saveInfo = self._playerInfo
        saveInfo.selectStagePower = stageTowerId
    end, __G__TRACKBACK__)
end

function SurviveGameCourse:getSelectStagePower(playerId)
    local playerData = y3.userData:getPlayerData(playerId)
    local player = playerData:getPlayer()
    local saveInfo = playerId == y3.gameApp:getMyPlayerId() and self._playerInfo or
        y3.userData:loadTableByPlayer(player, "PlayerInfo")
    if saveInfo.selectStagePower then
        return saveInfo.selectStagePower
    end
    return 0
end

function SurviveGameCourse:setShowDamageText(isshow)
    self._playerInfo.isShowDamageText = isshow
    y3.surviveHelper.isShowDamageText = isshow
end

function SurviveGameCourse:isShowDamageText()
    if self._playerInfo.isShowDamageText ~= nil then
        return self._playerInfo.isShowDamageText
    end
    return true
end

function SurviveGameCourse:setShowEffect(isShow)
    self._playerInfo.isShowEffect = isShow
    print("isShowEffect", isShow)
    local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    if isShow then
        y3.game.sfx_switch(playerData:getPlayer(), true)
    else
        y3.game.sfx_switch(playerData:getPlayer(), false)
    end
end

function SurviveGameCourse:isShowEffect()
    if self._playerInfo.isShowEffect ~= nil then
        return self._playerInfo.isShowEffect
    end
    return true
end

function SurviveGameCourse:setShowCallSoul(isShow)
    self._playerInfo.isShowCallSoul = isShow
    local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local mainActor = playerData:getMainActor()
    if mainActor then
        mainActor:getUnit():kv_save("callsoul", isShow)
    end
end

function SurviveGameCourse:isShowCallSoul()
    if self._playerInfo.isShowCallSoul ~= nil then
        return self._playerInfo.isShowCallSoul
    end
    return true
end

function SurviveGameCourse:recordShopHelperWeanponSort(playerId, sortList)
    if playerId ~= y3.gameApp:getMyPlayerId() then
        return
    end
    xpcall(function(...)
        local saveInfo = self._playerInfo
        if not saveInfo.shopHelperWeanponSort then
            saveInfo.shopHelperWeanponSort = {}
        end
        for i = 1, #sortList do
            saveInfo.shopHelperWeanponSort[i] = sortList[i]
        end
    end, __G__TRACKBACK__)
end

function SurviveGameCourse:getShopHelperWeanponSort(playerId)
    local playerData = y3.userData:getPlayerData(playerId)
    local player = playerData:getPlayer()
    local saveInfo = playerId == y3.gameApp:getMyPlayerId() and self._playerInfo or
        y3.userData:loadTableByPlayer(player, "PlayerInfo")
    if saveInfo.shopHelperWeanponSort then
        return saveInfo.shopHelperWeanponSort, true
    end
    local cfg = include("gameplay.config.stage_shop_helper").get(1)
    assert(cfg, "")
    local shop_helper_weapon_types = string.split(cfg.shop_helper_weapon_type, "|")
    assert(shop_helper_weapon_types, "")
    local result = {}
    for i = 1, #shop_helper_weapon_types do
        table.insert(result, tonumber(shop_helper_weapon_types[i]))
    end
    return result, false
end

function SurviveGameCourse:recordShopHelperWeanponAddSort(playerId, sortList)
    if playerId ~= y3.gameApp:getMyPlayerId() then
        return
    end
    xpcall(function(...)
        local saveInfo = self._playerInfo
        if not saveInfo.shopHelperWeanponAddSort then
            saveInfo.shopHelperWeanponAddSort = {}
        end
        for i = 1, #sortList do
            saveInfo.shopHelperWeanponAddSort[i] = sortList[i]
        end
    end, __G__TRACKBACK__)
end

function SurviveGameCourse:getShopHelperWeanponAddSort(playerId)
    local playerData = y3.userData:getPlayerData(playerId)
    local player = playerData:getPlayer()
    local saveInfo = playerId == y3.gameApp:getMyPlayerId() and self._playerInfo or
        y3.userData:loadTableByPlayer(player, "PlayerInfo")
    if saveInfo.shopHelperWeanponAddSort then
        return saveInfo.shopHelperWeanponAddSort, true
    end
    local cfg = include("gameplay.config.stage_shop_helper").get(1)
    assert(cfg, "")
    local shop_helper_weapon_types = string.split(cfg.shop_helper_damage_addition_lable, "|")
    assert(shop_helper_weapon_types, "")
    local result = {}
    for i = 1, #shop_helper_weapon_types do
        table.insert(result, tonumber(shop_helper_weapon_types[i]))
    end
    return result, false
end

function SurviveGameCourse:recordShopHelperWeanponOtherAddSort(playerId, sortList)
    if playerId ~= y3.gameApp:getMyPlayerId() then
        return
    end
    xpcall(function(...)
        local saveInfo = self._playerInfo
        if not saveInfo.shopHelperWeanponOtherAddSort then
            saveInfo.shopHelperWeanponOtherAddSort = {}
        end
        for i = 1, #sortList do
            saveInfo.shopHelperWeanponOtherAddSort[i] = sortList[i]
        end
    end, __G__TRACKBACK__)
end

function SurviveGameCourse:getShopHelperWeaponOtherAddSort(playerId)
    local playerData = y3.userData:getPlayerData(playerId)
    local player = playerData:getPlayer()
    local saveInfo = playerId == y3.gameApp:getMyPlayerId() and self._playerInfo or
        y3.userData:loadTableByPlayer(player, "PlayerInfo")
    if saveInfo.shopHelperWeanponOtherAddSort then
        return saveInfo.shopHelperWeanponOtherAddSort, true
    end
    local cfg = include("gameplay.config.stage_shop_helper").get(1)
    assert(cfg, "")
    local shop_helper_weapon_types = string.split(cfg.shop_helper_normal_addition_lable, "|")
    assert(shop_helper_weapon_types, "")
    local result = {}
    for i = 1, #shop_helper_weapon_types do
        table.insert(result, tonumber(shop_helper_weapon_types[i]))
    end
    return result, false
end

function SurviveGameCourse:recordShopHelperWeanponQualitySort(playerId, sortList)
    if playerId ~= y3.gameApp:getMyPlayerId() then
        return
    end
    xpcall(function(...)
        local saveInfo = self._playerInfo
        if not saveInfo.shopHelperWeanponQualitySort then
            saveInfo.shopHelperWeanponQualitySort = {}
        end
        for i = 1, #sortList do
            saveInfo.shopHelperWeanponQualitySort[i] = sortList[i]
        end
    end, __G__TRACKBACK__)
end

function SurviveGameCourse:getShopHelperWeaponQualitySort(playerId)
    local playerData = y3.userData:getPlayerData(playerId)
    local player = playerData:getPlayer()
    local saveInfo = playerId == y3.gameApp:getMyPlayerId() and self._playerInfo or
        y3.userData:loadTableByPlayer(player, "PlayerInfo")
    if saveInfo.shopHelperWeanponQualitySort then
        return saveInfo.shopHelperWeanponQualitySort, true
    end
    local cfg = include("gameplay.config.stage_shop_helper").get(1)
    assert(cfg, "")
    local shop_helper_quality_types = string.split(cfg.shop_helper_quality, "|")
    assert(shop_helper_quality_types, "")
    local result = {}
    for i = 1, #shop_helper_quality_types do
        table.insert(result, tonumber(shop_helper_quality_types[i]))
    end
    return result, false
end

function SurviveGameCourse:isShopHelperOpen(playerId)
    local playerData = y3.userData:getPlayerData(playerId)
    local player = playerData:getPlayer()
    local saveInfo = playerId == y3.gameApp:getMyPlayerId() and self._playerInfo or
        y3.userData:loadTableByPlayer(player, "PlayerInfo")
    if saveInfo.shopHelperOpen == nil then
        return false
    end
    return saveInfo.shopHelperOpen
end

function SurviveGameCourse:setShopHelperOpen(playerId, isOpen)
    log.info("setShopHelperOpen", playerId, isOpen)
    if playerId ~= y3.gameApp:getMyPlayerId() then
        return
    end
    log.info("setShopHelperOpen", playerId, isOpen)
    xpcall(function(...)
        local saveInfo = self._playerInfo
        saveInfo.shopHelperOpen = isOpen
    end, __G__TRACKBACK__)
end

function SurviveGameCourse:isShopHelperAutoRefresh(playerId)
    local playerData = y3.userData:getPlayerData(playerId)
    local player = playerData:getPlayer()
    local saveInfo = playerId == y3.gameApp:getMyPlayerId() and self._playerInfo or
        y3.userData:loadTableByPlayer(player, "PlayerInfo")
    if saveInfo.shopHelperAutoRefresh == nil then
        return false
    end
    return saveInfo.shopHelperAutoRefresh
end

function SurviveGameCourse:setShopHelperAutoRefresh(playerId, isAuto)
    log.info("setShopHelperOpen", playerId, isAuto)
    if playerId ~= y3.gameApp:getMyPlayerId() then
        return
    end
    log.info("setShopHelperOpen", playerId, isAuto)
    xpcall(function(...)
        local saveInfo = self._playerInfo
        saveInfo.shopHelperAutoRefresh = isAuto
    end, __G__TRACKBACK__)
end

--------------------------------------------塔幻化---------------------------------------------
function SurviveGameCourse:dropTowerSkin(playerId, towerSkinId)
    if playerId ~= y3.gameApp:getMyPlayerId() then
        return
    end
    xpcall(function(...)
        local saveInfo = self._playerInfo
        if not saveInfo.towerSkins then
            saveInfo.towerSkins = {}
        end
        local encryptStageTowerId = y3.gameApp:encryptString(towerSkinId)
        print(encryptStageTowerId)
        saveInfo.towerSkins[encryptStageTowerId] = 1
    end, __G__TRACKBACK__)
end

function SurviveGameCourse:towerSkinIsUnlock(playerId, towerSkinId)
    print(towerSkinId)
    local cfg = include("gameplay.config.stage_tower_skin").get(towerSkinId)
    if not cfg then
        return false
    end
    local playerData = y3.userData:getPlayerData(playerId)
    local player = playerData:getPlayer()
    local saveInfo = playerId == y3.gameApp:getMyPlayerId() and self._playerInfo or
        y3.userData:loadTableByPlayer(player, "PlayerInfo")
    if not saveInfo.towerSkins then
        return false
    end
    local encryptStageTowerId = y3.gameApp:encryptString(towerSkinId)
    --local flag = saveInfo.towerSkins[encryptStageTowerId] or 0
    local flag = y3.gameApp:isArchiveDataExists(saveInfo.towerSkins, encryptStageTowerId) and 1 or 0
    return flag == 1
end

function SurviveGameCourse:equipTowerSkin(playerId, towerSkinId)
    if playerId ~= y3.gameApp:getMyPlayerId() then
        return
    end
    xpcall(function(...)
        local saveInfo = self._playerInfo
        saveInfo.equipTowerSkin = y3.gameApp:encryptString(towerSkinId)
    end, __G__TRACKBACK__)
end

function SurviveGameCourse:syncTowerSkin()
    local saveInfo = self._playerInfo
    if saveInfo.equipTowerSkin then
        local towerSkinId = y3.gameApp:decryptString(saveInfo.equipTowerSkin)
        y3.SyncMgr:sync(y3.SyncConst.SYNC_EQUIP_TOWER_SKIN, { towerSkinId = tonumber(towerSkinId) })
    end
end

function SurviveGameCourse:initTowerSkinAttr()
    local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local attrPackList = self:getTowerSkinAttrList(playerData:getId())
    y3.SyncMgr:sync(y3.SyncConst.SYNC_ATTR_PACK_LIST, { attrPackList = attrPackList })
end

function SurviveGameCourse:getTowerSkinAttrList(playerId)
    local playerData = y3.userData:getPlayerData(playerId)
    local player = playerData:getPlayer()
    local saveInfo = y3.userData:loadTableByPlayer(player, "PlayerInfo")
    local stage_tower_skin = include("gameplay.config.stage_tower_skin")
    local len = stage_tower_skin.length()
    local attrPackList = {}
    for i = 1, len do
        local cfg = stage_tower_skin.indexOf(i)
        assert(cfg, "")
        local encryptStageTowerId = y3.gameApp:encryptString(cfg.id)
        --if saveInfo.towerSkins and saveInfo.towerSkins[encryptStageTowerId] == 1 then
        local temp = y3.gameApp:getArchiveData(saveInfo.towerSkins, encryptStageTowerId)
        if temp and type(temp) == "number" and temp == 1 then
            table.insert(attrPackList, cfg.tower_skin_possess_attr_pack)
        end
    end
    return attrPackList
end

-----------------------------------------------------------------------------------------------

function SurviveGameCourse:recordFirstTime(playerId)
    if playerId ~= y3.gameApp:getMyPlayerId() then
        return
    end
    xpcall(function(...)
        local saveInfo = self._playerInfo
        if not saveInfo.firstLoginTime then
            local result = y3.gameUtils.get_server_time(8)
            saveInfo.firstLoginTime = y3.gameApp:encryptString(result.timestamp) --result.timestamp
        end
    end, __G__TRACKBACK__)
end

function SurviveGameCourse:getValue(playerId, cfgId)
    local playerData = y3.userData:getPlayerData(playerId)
    local player = playerData:getPlayer()
    local saveInfo = y3.userData:loadTableByPlayer(player, "PlayerInfo")
    local get_value = self["_get_value_" .. cfgId]
    if get_value then
        return get_value(self, playerId, saveInfo)
    else
        return 0
    end
end

function SurviveGameCourse:_get_value_1(playerId, saveInfo)
    if saveInfo.firstLoginTime then
        local serverTime = y3.gameApp:decryptString(saveInfo.firstLoginTime)
        local year, month, day, hour, minu, seco = GameUtils.getCurrentDate2(serverTime)
        return string.format("%d-%d-%d %d:%d:%d", year, month, day, hour, minu, seco)
    else
        return "未记录"
    end
end

function SurviveGameCourse:_get_value_2(playerId, saveInfo)
    local stagepass = y3.gameApp:getLevel():getLogic("SurviveGameStagePass")
    return stagepass:getPassCountAll(playerId)
end

function SurviveGameCourse:_get_value_3(playerId, saveInfo)
    local playerData = y3.userData:getPlayerData(playerId)
    local player = playerData:getPlayer()
    return player:get_map_level()
end

function SurviveGameCourse:_get_value_4(playerId, saveInfo)
    local playerData = y3.userData:getPlayerData(playerId)
    local player = playerData:getPlayer()
    return player:get_save_data_int(y3.userData:getSaveSlot("maxPower"))
end

function SurviveGameCourse:_get_value_5(playerId, saveInfo)
    local treasureLogic = y3.gameApp:getLevel():getLogic("SurviveGameTreasure")
    return treasureLogic:getAllTreasureNum(playerId)
end

function SurviveGameCourse:_get_value_6(playerId, saveInfo)
    local stagepass = y3.gameApp:getLevel():getLogic("SurviveGameStagePass")
    local maxStageId = stagepass:getMaxPassStageId(playerId)
    local cfg = include("gameplay.config.stage_config").get(maxStageId)
    if not cfg then
        return ""
    end
    return cfg.stage_name
end

return SurviveGameCourse
