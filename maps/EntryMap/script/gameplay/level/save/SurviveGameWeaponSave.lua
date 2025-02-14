local GlobalConfigHelper = include "gameplay.level.logic.helper.GlobalConfigHelper"
local LogicBase = include("gameplay.level.logic.LogicBase")
local SurviveGameWeaponSave = class("SurviveGameWeaponSave", LogicBase)

function SurviveGameWeaponSave:ctor(level)
    SurviveGameWeaponSave.super.ctor(self, level)
    self:_initData()
end

function SurviveGameWeaponSave:_initData()
    local WeaponSave = y3.userData:loadTable("Weapon")
    self._weaponSave = WeaponSave
    local weapon_book = include("gameplay.config.weapon_book")
    local len = weapon_book.length()
    self._weaponLvMap = {}
    self._bookWeaponList = {}
    for i = 1, len do
        local cfg = weapon_book.indexOf(i)
        assert(cfg, "")
        if not self._weaponLvMap[cfg.weapon_id] then
            self._weaponLvMap[cfg.weapon_id] = {}
            table.insert(self._bookWeaponList, cfg.weapon_id)
        end
        table.insert(self._weaponLvMap[cfg.weapon_id], cfg)
    end
    self._weaponTypeMap = {}
    for i = 1, #self._bookWeaponList do
        local skillId = self._bookWeaponList[i]
        local skillCfg = include("gameplay.config.config_skillData").get(tostring(skillId))
        assert(skillCfg, "")
        if not self._weaponTypeMap[skillCfg.type] then
            self._weaponTypeMap[skillCfg.type] = {}
        end
        table.insert(self._weaponTypeMap[skillCfg.type], skillId)
    end
end

function SurviveGameWeaponSave:getBookWeaponList()
    return self._bookWeaponList
end

function SurviveGameWeaponSave:getBookWeaponTypeList(weaponType)
    return self._weaponTypeMap[weaponType] or {}
end

function SurviveGameWeaponSave:getWeanponLvList(weaponId)
    return self._weaponLvMap[weaponId] or {}
end

function SurviveGameWeaponSave:dropWeaponExp(playerId, weaponId, exp)
    if playerId ~= y3.gameApp:getMyPlayerId() then
        return
    end
    xpcall(function(...)
        y3.Sugar.recordPlayerDrop(playerId,
            { type = y3.SurviveConst.DROP_TYPE_WEANPON_EXP, value = weaponId, size = exp })
        log.info("dropWeaponExp", playerId, weaponId, exp)
        local saveData = y3.userDataHelper.getSaveDataDecryptConcatPro(self._weaponSave[weaponId])
        dump_all(saveData)
        saveData.id = weaponId
        local curLevel = saveData.level or 0
        saveData.level = curLevel
        saveData.exp = (saveData.exp or 0) + exp
        local lvList = self._weaponLvMap[weaponId] or {}
        self:_doWeaponLvUp(saveData, lvList, curLevel)
        -- local lvCfg = lvList[curLevel + 1]
        -- if lvCfg then
        --     if saveData.exp >= lvCfg.exp_cost then
        --         saveData.exp = saveData.exp - lvCfg.exp_cost
        --         saveData.level = curLevel + 1
        --     end
        -- end
        self._weaponSave[weaponId] = y3.userDataHelper.getSaveDataEncryptConcatPro(saveData)
    end, __G__TRACKBACK__)
end

function SurviveGameWeaponSave:_doWeaponLvUp(saveData, lvList, curLevel)
    local lvCfg = lvList[curLevel + 1]
    if lvCfg then
        if saveData.exp >= lvCfg.exp_cost then
            saveData.exp = saveData.exp - lvCfg.exp_cost
            saveData.level = curLevel + 1
            self:_doWeaponLvUp(saveData, lvList, curLevel + 1)
        end
    end
end

function SurviveGameWeaponSave:getMaxExp(weaponLevel, lvList, addLv)
    local maxExp = 0
    for i = 1, addLv do
        local lvCfg = lvList[weaponLevel + i]
        if lvCfg then
            maxExp = maxExp + lvCfg.exp_cost
        end
    end
    return maxExp
end

function SurviveGameWeaponSave:upgradeWeapon(playerId, weaponId, addLv)
    if playerId ~= y3.gameApp:getMyPlayerId() then
        return
    end
    xpcall(function(...)
        local saveData = y3.userDataHelper.getSaveDataDecryptConcatPro(self._weaponSave[weaponId])
        saveData.id = weaponId
        local level = saveData.level or 0
        local exp = saveData.exp or 0
        local lvList = self._weaponLvMap[weaponId] or {}
        local lvCfg = lvList[level + addLv]
        local upSuccess = false
        if lvCfg then
            local exp_item = string.split(lvCfg.exp_item, "#")
            assert(exp_item, "")
            local itemType = tonumber(exp_item[1])
            local itemValue = tonumber(exp_item[2])
            if itemType == y3.SurviveConst.DROP_TYPE_SAVE_ITEM then
                local saveItem = y3.gameApp:getLevel():getLogic("SurviveGameSaveItem")
                local curNum = saveItem:getSaveItemNum(playerId, itemValue)
                local maxExp = self:getMaxExp(level, lvList, addLv)
                local needExp = math.max(0, maxExp - exp)
                if curNum >= needExp then
                    saveData.level = level + addLv
                    saveData.exp = 0
                    saveItem:dropSaveItem(playerId, itemValue, -needExp)
                    y3.Sugar.localTips(playerId, GameAPI.get_text_config('#-784991155#lua'))
                    upSuccess = true
                else
                    y3.Sugar.localTips(playerId, GameAPI.get_text_config('#-1579164664#lua'))
                end
            end
        else
            y3.Sugar.localTips(playerId, GameAPI.get_text_config('#-1385594544#lua'))
        end
        self._weaponSave[weaponId] = y3.userDataHelper.getSaveDataEncryptConcatPro(saveData)
        if upSuccess then
            y3.gameApp:dispatchEvent(y3.EventConst.EVENT_WEAPON_LV_SUCCESS, weaponId)
        end
    end, __G__TRACKBACK__)
end

function SurviveGameWeaponSave:getWeaponLevel(playerId, weaponId)
    local playerData = y3.userData:getPlayerData(playerId)
    local weaponSave = y3.userData:loadTableByPlayer(playerData:getPlayer(), "Weapon")
    local saveData = y3.userDataHelper.getSaveDataDecryptConcatPro(weaponSave[weaponId])
    return saveData.level or 0
end

function SurviveGameWeaponSave:getWeaponExp(playerId, weaponId)
    local playerData = y3.userData:getPlayerData(playerId)
    local weaponSave = y3.userData:loadTableByPlayer(playerData:getPlayer(), "Weapon")
    local saveData = y3.userDataHelper.getSaveDataDecryptConcatPro(weaponSave[weaponId])
    return saveData.exp or 0
end

function SurviveGameWeaponSave:getWeaponCurUpgradeMaxExp(playerId, weaponId)
    local playerData = y3.userData:getPlayerData(playerId)
    local weaponSave = y3.userData:loadTableByPlayer(playerData:getPlayer(), "Weapon")
    local saveData = y3.userDataHelper.getSaveDataDecryptConcatPro(weaponSave[weaponId])
    local level = saveData.level or 0
    local lvList = self._weaponLvMap[weaponId] or {}
    local lvCfg = lvList[level + 1]
    if lvCfg then
        return lvCfg.exp_cost
    else
        return 0
    end
end

function SurviveGameWeaponSave:getWeaponCurUpgradeCfg(playerId, weaponId)
    local playerData = y3.userData:getPlayerData(playerId)
    local weaponSave = y3.userData:loadTableByPlayer(playerData:getPlayer(), "Weapon")
    local saveData = y3.userDataHelper.getSaveDataDecryptConcatPro(weaponSave[weaponId])
    local level = saveData.level or 0
    local lvList = self._weaponLvMap[weaponId] or {}
    local lvCfg = lvList[level + 1]
    if lvCfg then
        return lvCfg
    else
        return nil
    end
end

function SurviveGameWeaponSave:getWeanponTypeAllLevel(playerId, weaponType)
    local allLevel = 0
    local list = self._weaponTypeMap[weaponType] or {}
    for i = 1, #list do
        local weaponId = tonumber(list[i])
        local level = self:getWeaponLevel(playerId, weaponId)
        allLevel = allLevel + level
    end
    return allLevel
end

function SurviveGameWeaponSave:getWeaponResonanceLevel(playerId)
    local minLevel = 999999999
    for i = 1, #y3.SurviveConst.WEAPON_TYPE_LIST do
        local weaponType = y3.SurviveConst.WEAPON_TYPE_LIST[i]
        local level = self:getWeanponTypeAllLevel(playerId, weaponType)
        if level < minLevel then
            minLevel = level
        end
    end
    return minLevel
end

function SurviveGameWeaponSave:initWeaponAttr()
    local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    self:_initSignalWeaponAttr(playerData)
end

function SurviveGameWeaponSave:_initSignalWeaponAttr(playerData)
    local attrPackList, weaponEffectList = self:getWeaponAttrList(playerData)
    y3.SyncMgr:sync(y3.SyncConst.SYNC_ATTR_PACK_LIST, { attrPackList = attrPackList })
    y3.SyncMgr:sync(y3.SyncConst.SYNC_WEAPON_EFFECT, { weaponEffectList = weaponEffectList })
end

function SurviveGameWeaponSave:getWeaponAttrList(playerData)
    local attrPackList = {}
    local weaponEffectList = {}
    for i = 1, #self._bookWeaponList do
        local weaponId = self._bookWeaponList[i]
        local saveData = y3.userDataHelper.getSaveDataDecryptConcatPro(self._weaponSave[weaponId])
        local level = saveData.level or 0
        local lvList = self._weaponLvMap[weaponId] or {}
        for lv = 1, level do
            local lvCfg = lvList[lv]
            if lvCfg then
                if lvCfg.attr_pack ~= "" then
                    table.insert(attrPackList, lvCfg.attr_pack)
                end
                if lvCfg.weapon_effect ~= "" then
                    table.insert(weaponEffectList, { weaponId = weaponId, effect = lvCfg.weapon_effect })
                end
            end
        end
    end
    local resonanceLevel = self:getWeaponResonanceLevel(playerData:getId())
    local weapon_echo = GlobalConfigHelper.get(35)
    for lv = 1, resonanceLevel do
        table.insert(attrPackList, weapon_echo)
    end
    return attrPackList, weaponEffectList
end

function SurviveGameWeaponSave:getResonanceLevelAttr(playerId)
    local resonanceLevel = self:getWeaponResonanceLevel(playerId)
    local weapon_echo = GlobalConfigHelper.get(35)
    local attrMap = { { name = "最终伤害加成", value = 0 } }
    for lv = 1, resonanceLevel do
        local attrList = y3.userDataHelper.getAttrListByPack(weapon_echo)
        attrMap[1].name = attrList[1].name
        attrMap[1].value = attrMap[1].value + attrList[1].value
    end
    return attrMap
end

return SurviveGameWeaponSave
