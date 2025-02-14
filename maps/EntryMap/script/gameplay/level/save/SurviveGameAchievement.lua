local GameUtils = include "gameplay.utils.GameUtils"
local LogicBase = include("gameplay.level.logic.LogicBase")
local SurviveGameAchievement = class("SurviveGameAchievement", LogicBase)

function SurviveGameAchievement:ctor(level)
    SurviveGameAchievement.super.ctor(self, level)
    self:_initCfg()
    y3.gameApp:addTimerLoop(1 / y3.GameConst.GAME_FPS, handler(self, self._onTickCmdList))
end

function SurviveGameAchievement:_initCfg()
    local collect = include("gameplay.config.collect")
    local len = collect.length()
    local achieveSave = y3.userData:loadTable("Achievement")
    self._achievementList = {}
    self._achievementMap = {}
    self._recordMap = {}
    self._killFinalBossMap = {}
    self._recordAchievementData = {}
    self._cacheSaveCondition = {}

    self._condAchieveMap = {}

    self._cacheCmdList = {}
    self._cmdRefreshMap = {}
    self._stagePassTime = 0

    for i = 1, len do
        local cfg = collect.indexOf(i)
        assert(cfg, "")
        if not achieveSave[cfg.id] or type(achieveSave[cfg.id]) ~= "string" then
            self:addDefaultEncryptedSaveData(achieveSave, cfg)
        end
        table.insert(self._achievementList, cfg)
        local conditions = string.split(cfg.condition, "|")
        assert(conditions, "")
        for _, cond in ipairs(conditions) do
            if not self._condAchieveMap[cond] then
                self._condAchieveMap[cond] = {}
            end
            table.insert(self._condAchieveMap[cond], cfg)
        end
    end
    self._achieveSave = achieveSave
end

local DataIndex = {
    id = 1,
    year = 2,
    month = 3,
    day = 4,
    condition1 = 5,
    condition2 = 6,
    condition3 = 7,
    condition4 = 8,
    itemGet = 9,
}

function SurviveGameAchievement:addDefaultEncryptedSaveData(achieveSaveData, cfg)
    if not cfg or not achieveSaveData then
        return
    end

    local defaultData = {}
    defaultData[DataIndex.id] = cfg.id
    defaultData[DataIndex.year] = 0
    defaultData[DataIndex.month] = 0
    defaultData[DataIndex.day] = 0
    defaultData[DataIndex.condition1] = 0
    defaultData[DataIndex.condition2] = 0
    defaultData[DataIndex.condition3] = 0
    defaultData[DataIndex.condition4] = 0
    defaultData[DataIndex.itemGet] = 0

    local tempString = table.concat(defaultData, "#")
    local encryptedData = y3.gameApp:encryptString(tempString)
    achieveSaveData[cfg.id] = encryptedData
end

function SurviveGameAchievement:updateSaveData(player, cfg, paramIndex, paramValue, isSupportCacheData)
    if not cfg or not player then
        return
    end

    local cfgId = cfg.id
    local playerId = player:get_id()
    local isCacheSaveData = cfg.collect_type and cfg.collect_type == 2 or false
    if isSupportCacheData and isCacheSaveData then
        if not self._cacheSaveCondition[cfgId] then
            self._cacheSaveCondition[cfgId] = {}
        end
        self._cacheSaveCondition[cfgId][paramIndex] = paramValue
        return
    end

    local localPlayerId = y3.gameApp:getMyPlayerId()
    if playerId ~= localPlayerId then
        return
    end

    local achieveSave = self._achieveSave --y3.userData:loadTableByPlayer(player, "Achievement")
    if not achieveSave then
        return
    end

    local encryptedData = achieveSave[cfgId]
    if not encryptedData then
        return
    end

    if type(encryptedData) ~= "string" then
        return
    end

    local decryptedData = y3.gameApp:decryptString(encryptedData)
    local params = string.split(decryptedData, "#")
    if not params or #params == 0 then
        return
    end

    params[paramIndex] = paramValue

    local tempString = table.concat(params, "#")
    local encryptedData = y3.gameApp:encryptString(tempString)

    achieveSave[cfgId] = encryptedData
end

function SurviveGameAchievement:updateSaveDataDic(player, cfg, paramDic)
    if not cfg or not player or getTableLength(paramDic) == 0 then
        return
    end

    local playerId = player:get_id()
    local localPlayerId = y3.gameApp:getMyPlayerId()
    if playerId ~= localPlayerId then
        return
    end

    local cfgId = cfg.id
    local achieveSave = self._achieveSave --y3.userData:loadTableByPlayer(player, "Achievement")
    if not achieveSave then
        return
    end

    local encryptedData = achieveSave[cfgId]
    if not encryptedData then
        return
    end

    if type(encryptedData) ~= "string" then
        return
    end

    if not paramDic or getTableLength(paramDic) == 0 then
        return
    end

    local decryptedData = y3.gameApp:decryptString(encryptedData)
    local params = string.split(decryptedData, "#")
    if not params or #params == 0 then
        return
    end

    for index, value in pairs(paramDic) do
        params[index] = value
    end

    local tempString = table.concat(params, "#")
    local encryptedData = y3.gameApp:encryptString(tempString)
    achieveSave[cfgId] = encryptedData
end

function SurviveGameAchievement:getSaveData(cfgId, player)
    local result = {}

    -- print("-------------------------------------------------------")
    player = not player and y3.player(y3.gameApp:getMyPlayerId()) or player
    -- print(player)
    local achieveSave = player:get_id() == y3.gameApp:getMyPlayerId() and self._achieveSave or
        y3.userData:loadTableByPlayer(player, "Achievement")
    -- print("SurviveGameAchievement 1 ", cfgId)
    if not achieveSave or not achieveSave[cfgId] then
        return result
    end
    -- print("SurviveGameAchievement 2")
    local encryptedData = achieveSave[cfgId]
    if not encryptedData then
        return result
    end
    -- print("SurviveGameAchievement 3")
    if type(encryptedData) ~= "string" then
        return result
    end

    -- print("SurviveGameAchievement 4")
    local decryptedData = y3.gameApp:decryptString(encryptedData)
    local params = string.split(decryptedData, "#")
    if not params or #params == 0 then
        return result
    end
    -- if cfgId == 1001 then
    --     print("--------------xxxxx")
    -- end
    for index, value in ipairs(params) do
        -- if cfgId == 1001 then
        --     print("SurviveGameAchievement:getSaveData", index, value)
        -- end
        if tonumber(value) ~= nil then
            table.insert(result, index, tonumber(value))
        else
            table.insert(result, index, value)
        end
    end
    -- print("SurviveGameAchievement 5")
    return result
end

function SurviveGameAchievement:setKillFinalBossTime(playerId, time)
    if self._killFinalBossMap[playerId] then
        local oldTime = self._killFinalBossMap[playerId]
        if time < oldTime then
            self._killFinalBossMap[playerId] = time
        end
    else
        self._killFinalBossMap[playerId] = time
    end
    self:updateAchievement(playerId, y3.SurviveConst.ACHIEVEMENT_REFRESH_KILL_FINAL_BOSS)
end

function SurviveGameAchievement:recordAchievementDataIncrement(playerId, cond, value)
    if not self._recordAchievementData[playerId] then
        self._recordAchievementData[playerId] = {}
    end
    if not self._recordAchievementData[playerId][cond] then
        self._recordAchievementData[playerId][cond] = 0
    end
    self._recordAchievementData[playerId][cond] = self._recordAchievementData[playerId][cond] + value
end

function SurviveGameAchievement:_getCondIndex(conditions, cond)
    local indexRets = {}
    for i = 1, #conditions do
        if conditions[i] == cond then
            table.insert(indexRets, i)
        end
    end
    return indexRets
end

function SurviveGameAchievement:_onTickCmdList()
    if #self._cacheCmdList > 0 then
        local cmd = table.remove(self._cacheCmdList, 1)
        xpcall(function()
            -- print("SurviveGameAchievement:onTickCmdList", cmd.playerId, cmd.refreshType)
            self:_updateAchievement(cmd.playerId, cmd.refreshType)
            self._cmdRefreshMap[cmd.refreshType] = nil
        end, __G__TRACKBACK__)
    end
end

function SurviveGameAchievement:updateAchievement(playerId, refreshType)
    if playerId ~= y3.gameApp:getMyPlayerId() then
        return
    end
    xpcall(function(...)
        if not self._cmdRefreshMap[refreshType] then
            self._cmdRefreshMap[refreshType] = 1
            table.insert(self._cacheCmdList, { playerId = playerId, refreshType = refreshType })
        end
    end, __G__TRACKBACK__)
end

function SurviveGameAchievement:getPlayedEndTime()
    return self._stagePassTime
end

function SurviveGameAchievement:getOldMaxLiveTime()
    return self._oldMaxLiveTime or 0
end

function SurviveGameAchievement:_updateAchievement(playerId, refreshType)
    if refreshType == y3.SurviveConst.ACHIEVEMENT_REFRESH_TYPE_PLAYED then
        local gameStatus = y3.gameApp:getLevel():getLogic("SurviveGameStatus")
        local readyEndTotalTime = math.floor(gameStatus:getReadyEndTotalTime())
        self._stagePassTime = readyEndTotalTime
        local maxLiveTime = self._achieveSave.maxLiveTime or 0
        if readyEndTotalTime > maxLiveTime then
            self._oldMaxLiveTime = maxLiveTime
            self._achieveSave.maxLiveTime = readyEndTotalTime
        end
        y3.userDataHelper.unloadMaxPower(playerId)
    end
    local curStageId = y3.userData:getCurStageId()
    local curStageCfg = include("gameplay.config.stage_config").get(curStageId)
    if curStageCfg then
        if curStageCfg.stage_update_achievement <= 0 then
            return
        end
    end

    local condMap    = y3.SurviveConst.ACHIEVEMENT_REFRESH_TYPE_MAP[refreshType]
    local playerData = y3.userData:getPlayerData(playerId)
    local player     = playerData:getPlayer()
    for cond, _ in pairs(condMap) do
        local list = self._condAchieveMap[cond] or {}
        local updateFunc = self["_update_condition_" .. cond]
        for i = 1, #list do
            local cfg = list[i]
            local conditions = string.split(cfg.condition, "|")
            assert(conditions, "")
            local lastUnlock = self:achievementIsUnLock(playerId, cfg)
            if updateFunc then
                local indexRets = self:_getCondIndex(conditions, cond)
                if #indexRets > 0 then
                    for _, index in ipairs(indexRets) do
                        updateFunc(self, cfg, index, playerData)
                    end
                end
            end
            local curUnlock = self:achievementIsUnLock(playerId, cfg)
            if curUnlock and not lastUnlock then
                print(GameAPI.get_text_config('#30000001#lua71') .. cfg.name)
            end
            if cfg.collect_type == 2 then
                self:_specialConditionUpdate(playerId, cfg, conditions)
            end
            if cfg.reward_item ~= "" then
                if self:_conditionAll(conditions, cfg, player) then
                    local saveData = self:getSaveData(cfg.id, player)
                    local flag = saveData[DataIndex.itemGet]
                    -- dump_all(saveData)
                    -- print("获得奖励道具 " .. flag)
                    if nil == saveData[DataIndex.itemGet] or 0 == saveData[DataIndex.itemGet] then
                        print(GameAPI.get_text_config('#30000001#lua72') .. cfg.reward_item)
                        self:updateSaveData(player, cfg, DataIndex.itemGet, 1, false)
                        y3.userDataHelper.dropSaveItem(playerId, cfg.reward_item)
                    end
                end
            end
        end
    end
end

function SurviveGameAchievement:_specialConditionUpdate(playerId, cfg, conditions)
    local conCount = 0
    local cacheSaveData = self._cacheSaveCondition[cfg.id] or {}
    for index, cond in ipairs(conditions) do
        local checkFunc = self["_check_condition_" .. cond]
        if checkFunc then
            local playerData = y3.userData:getPlayerData(playerId)
            local isRet = checkFunc(self, cacheSaveData, cfg, index, playerData:getPlayer())
            if isRet then
                conCount = conCount + 1
            else
                break
            end
        end
    end

    local playerData = y3.userData:getPlayerData(playerId)
    local player     = playerData:getPlayer()
    local saveData   = self:getSaveData(cfg.id, player)
    local oldCount   = saveData[DataIndex.condition1] or 0
    if conCount > oldCount then
        self:updateSaveData(player, cfg, DataIndex.condition1, conCount, false)

        -- if conCount ==1 then
        -- y3.Sugar.recordPlayerDrop(playerId,{type=y3.SurviveConst.DROP_TYPE_SAVE_ITEM,value=})
        -- elseif conCount ==2 then
        --     y3.Sugar.recordPlayerDrop(playerId,{type=y3.SurviveConst.DROP_TYPE_SAVE_ITEM,value=})
        -- elseif conCount ==3 then
        -- y3.Sugar.recordPlayerDrop(playerId,{type=y3.SurviveConst.DROP_TYPE_SAVE_ITEM,value=})
        -- elseif conCount ==4 then
        -- y3.Sugar.recordPlayerDrop(playerId,{type=y3.SurviveConst.DROP_TYPE_SAVE_ITEM,value=})
        -- end
    end
end

function SurviveGameAchievement:achievementIsUnLock(playerId, cfg)
    local playerData = y3.userData:getPlayerData(playerId)
    --local achieveSave = y3.userData:loadTableByPlayer(playerData:getPlayer(), "Achievement")
    if cfg.condition ~= "" then
        local conditions = string.split(cfg.condition, "|")
        assert(conditions)
        if cfg.collect_type == 2 then
            if self:_checkCollectType2Pure(cfg, conditions, playerData) then
                return true
            end
        else
            if self:_checkCollectTypeOtherPure(cfg, conditions, playerData) then
                return true
            end
        end
    end
    return false
end

function SurviveGameAchievement:getTotalAchievementPoint(playerId)
    local playerData = y3.userData:getPlayerData(playerId)
    --local achieveSave = y3.userData:loadTableByPlayer(playerData:getPlayer(), "Achievement")
    local totalPoint = 0
    for i = 1, #self._achievementList do
        local cfg = self._achievementList[i]
        if cfg.condition ~= "" then
            local conditions = string.split(cfg.condition, "|")
            assert(conditions)
            if cfg.collect_type == 2 then
                if self:_checkCollectType2Pure(cfg, conditions, playerData) then
                    if cfg.point > 0 then
                        totalPoint = totalPoint + cfg.point
                    end
                end
            else
                if self:_checkCollectTypeOtherPure(cfg, conditions, playerData) then
                    if cfg.point > 0 then
                        totalPoint = totalPoint + cfg.point
                    end
                end
            end
        end
    end
    return totalPoint
end

function SurviveGameAchievement:_checkCollectType2Pure(cfg, conditions, playerData)
    local reward_attr_packs = string.split(cfg.reward_attr_pack, "|")
    assert(reward_attr_packs)
    assert(conditions)
    local saveData = self:getSaveData(cfg.id, playerData:getPlayer())
    if saveData[DataIndex.condition1] then
        local conCount = saveData[DataIndex.condition1]
        if conCount > 0 then
            return true
        end
    end
    return false
end

function SurviveGameAchievement:_checkCollectTypeOtherPure(cfg, conditions, playerData)
    local isAllTrue = true
    local haveCond = false
    local saveData = self:getSaveData(cfg.id, playerData:getPlayer())
    for index, cond in ipairs(conditions) do
        local checkFunc = self["_check_condition_" .. cond]
        if checkFunc then
            haveCond = true
            local ret = checkFunc(self, saveData, cfg, index, playerData:getPlayer())
            if not ret then
                isAllTrue = false
            end
        end
    end
    if isAllTrue and haveCond then
        return true
    end
    return false
end

function SurviveGameAchievement:initAchievementReward()
    -- local allPlayers = y3.userData:getAllInPlayers()
    -- for _, playerData in ipairs(allPlayers) do
    local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    self:_initSignalPlayerAchievementReward(playerData)
    -- end
end

function SurviveGameAchievement:_initSignalPlayerAchievementReward(playerData)
    --local achieveSave = y3.userData:loadTableByPlayer(playerData:getPlayer(), "Achievement")
    local attrPackList = self:getAchievementAttrList(playerData)
    y3.SyncMgr:sync(y3.SyncConst.SYNC_ATTR_PACK_LIST, { attrPackList = attrPackList })
end

function SurviveGameAchievement:getAchievementAttrList(playerData)
    local mainActor = playerData:getMainActor()
    local attrPackList = {}
    for i = 1, #self._achievementList do
        local cfg = self._achievementList[i]
        if cfg.condition ~= "" then
            local conditions = string.split(cfg.condition, "|")
            assert(conditions)
            if cfg.collect_type == 2 then
                self:_checkCollectType2(cfg, conditions, playerData, mainActor, attrPackList)
            else
                self:_checkCollectTypeOther(cfg, conditions, playerData, mainActor, attrPackList)
            end
        end
    end
    return attrPackList
end

function SurviveGameAchievement:_checkCollectType2(cfg, conditions, playerData, mainActor, attrPackList)
    local reward_attr_packs = string.split(cfg.reward_attr_pack, "|")
    assert(reward_attr_packs)
    assert(conditions)
    local saveData = self:getSaveData(cfg.id, playerData:getPlayer())
    if saveData[DataIndex.condition1] then
        local conCount = saveData[DataIndex.condition1]
        for index = 1, conCount do
            local attrPackId = reward_attr_packs[index] or ""
            -- print("_checkCollectType2 " .. cfg.id, attrPackId)
            -- mainActor:addAttrPack(attrPackId)
            table.insert(attrPackList, attrPackId)
        end
    end
end

function SurviveGameAchievement:_checkCollectTypeOther(cfg, conditions, playerData, mainActor, attrPackList)
    local isAllTrue = true
    local haveCond = false
    local saveData = self:getSaveData(cfg.id, playerData:getPlayer())
    for index, cond in ipairs(conditions) do
        local checkFunc = self["_check_condition_" .. cond]
        if checkFunc then
            haveCond = true
            local ret = checkFunc(self, saveData, cfg, index, playerData:getPlayer())
            if not ret then
                isAllTrue = false
            end
        end
    end
    if isAllTrue and haveCond then
        -- print("_checkCollectTypeOther " .. cfg.id, cfg.reward_attr_pack, cfg.condition)
        -- mainActor:addAttrPack(cfg.reward_attr_pack)
        table.insert(attrPackList, cfg.reward_attr_pack)
    end
end

function SurviveGameAchievement:_conditionAll(conditions, cfg, player)
    local isAllTrue = true
    local saveData  = self:getSaveData(cfg.id, player)
    for index, cond in ipairs(conditions) do
        local checkFunc = self["_check_condition_" .. cond]
        if checkFunc then
            local ret = checkFunc(self, saveData, cfg, index, player)
            if not ret then
                isAllTrue = false
            end
        end
    end
    return isAllTrue
end

function SurviveGameAchievement:getAchievementConditionValue(playerId, cfgId, index)
    local playerData = y3.userData:getPlayerData(playerId)
    local saveData   = self:getSaveData(cfgId, playerData:getPlayer())
    local tempIndex  = DataIndex.condition1 + index - 1
    return saveData[tempIndex] or 0
end

--------------------------------------------------------------------------------------
function SurviveGameAchievement:refreshSaveAchievementTime(player, saveData, cfg, index)
    if not cfg or not player then
        return
    end

    local isCacheSaveData           = cfg.collect_type == 2
    local timeRet                   = y3.gameUtils.get_server_time(8)
    local year, month, day          = GameUtils.getCurrentDate(timeRet.timestamp)
    local oldYear, oldMonth, oldDay = saveData[DataIndex.year] or 0, saveData[DataIndex.month] or 0,
        saveData[DataIndex.day] or 0
    if oldYear == year and oldMonth == month and oldDay == day then
        return
    end

    local paramDid = {}
    if cfg.if_daily == 1 then
        local tempIndex = DataIndex.condition1 + index - 1
        if isCacheSaveData then
            saveData[tempIndex] = 0
            saveData[DataIndex.itemGet] = 0
        else
            paramDid[DataIndex.condition1 + index - 1] = 0
            paramDid[DataIndex.itemGet] = 0
        end
    end

    if isCacheSaveData then
        saveData[DataIndex.year]  = year
        saveData[DataIndex.month] = month
        saveData[DataIndex.day]   = day
    else
        paramDid[DataIndex.year] = year
        paramDid[DataIndex.month] = month
        paramDid[DataIndex.day] = day

        self:updateSaveDataDic(player, cfg, paramDid)
    end
end

function SurviveGameAchievement:_getAchieveSaveData(player, cfg)
    if cfg.collect_type == 2 then
        local retData = self._cacheSaveCondition[cfg.id] or {}
        self._cacheSaveCondition[cfg.id] = retData
        return retData
    else
        return self:getSaveData(cfg.id, player)
    end
end

function SurviveGameAchievement:_checkNoInTimeLimit(cfg)
    if cfg.timestamp == "" then
        return false
    end
    local params = string.split(cfg.timestamp, "|")
    assert(params, "")
    local time1 = tonumber(params[1]) or 0
    local time2 = tonumber(params[2]) or 0
    if time1 > 0 and time2 > 0 then
        print("time1, time2", time1, time2)
        -- time1 = y3.gameUtils.convertConfigTimestamp(time1)
        -- time2 = y3.gameUtils.convertConfigTimestamp(time2)
        local curTime = y3.game.get_current_server_time().timestamp
        print("curTime", curTime)
        if curTime >= time1 and curTime <= time2 then
            return false
        else
            return true
        end
    end
    return false
end

----------------------------------- 刷新成就 ------------------------------------
function SurviveGameAchievement:_update_condition_1(cfg, index, playerData) -- 通关关卡
    if self:_checkNoInTimeLimit(cfg) then
        return
    end
    local stageId = y3.userData:getCurStageId()
    local params = string.split(cfg.param, "|")
    assert(params, "")
    local values = string.split(cfg.value, "|")
    assert(values, "")
    local conStageId = tonumber(params[index]) or stageId
    if conStageId == 0 then
        conStageId = stageId
    end
    local conCount = tonumber(values[index]) or 0
    local player = playerData:getPlayer()
    local saveData = self:_getAchieveSaveData(player, cfg) --self._achieveSave[cfg.id]
    if conStageId == stageId then
        local tampIndex = DataIndex.condition1 + index - 1
        self:refreshSaveAchievementTime(player, saveData, cfg, index)
        local oldData = saveData[tampIndex] or 0
        local tempValue = oldData + 1
        print(cfg.id)
        print(tempValue)
        self:updateSaveData(player, cfg, tampIndex, tempValue, true)
    end
end

function SurviveGameAchievement:_update_condition_2(cfg, index, playerData) -- 不死通关
    if self:_checkNoInTimeLimit(cfg) then
        return
    end
    local stageId = y3.userData:getCurStageId()
    --local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local mainActor = playerData:getMainActor()
    local params = string.split(cfg.param, "|")
    assert(params, "")
    local values = string.split(cfg.value, "|")
    assert(values, "")
    local conStageId = tonumber(params[index]) or stageId
    if conStageId == 0 then
        conStageId = stageId
    end
    local conCount = tonumber(values[index]) or 0
    local player = playerData:getPlayer()
    local saveData = self:_getAchieveSaveData(player, cfg) --self._achieveSave[cfg.id]
    if conStageId == stageId and mainActor:getDieCount() == 0 then
        local tampIndex = DataIndex.condition1 + index - 1
        self:refreshSaveAchievementTime(player, saveData, cfg, index)
        local oldData = saveData[tampIndex] and tonumber(saveData[tampIndex]) or 0
        local tempValue = oldData + 1
        self:updateSaveData(player, cfg, tampIndex, tempValue, true)
    end
end

function SurviveGameAchievement:_update_condition_3(cfg, index, playerData) --购买单系通关
    if self:_checkNoInTimeLimit(cfg) then
        return
    end
    local stageId = y3.userData:getCurStageId()
    local params = string.split(cfg.param, "|")
    assert(params, "")
    local values = string.split(cfg.value, "|")
    assert(values, "")
    local conStageId = tonumber(params[index]) or stageId
    if conStageId == 0 then
        conStageId = stageId
    end
    local conCount = tonumber(values[index]) or 0
    local player = playerData:getPlayer()
    local saveData = self:_getAchieveSaveData(player, cfg) --self._achieveSave[cfg.id]
    local refreshSkill = y3.gameApp:getLevel():getLogic("SurviveRefreshSkill")
    if conStageId == stageId and refreshSkill:buySkillIsSingal(y3.gameApp:getMyPlayerId()) then
        local tampIndex = DataIndex.condition1 + index - 1
        self:refreshSaveAchievementTime(player, saveData, cfg, index)
        local oldData = saveData[tampIndex] and tonumber(saveData[tampIndex]) or 0
        local tempValue = oldData + 1
        self:updateSaveData(player, cfg, tampIndex, tempValue, true)
    end
end

function SurviveGameAchievement:_update_condition_4(cfg, index, playerData) --全局无伤通关
    if self:_checkNoInTimeLimit(cfg) then
        return
    end
    local stageId = y3.userData:getCurStageId()
    local params = string.split(cfg.param, "|")
    assert(params, "")
    local values = string.split(cfg.value, "|")
    assert(values, "")
    local conStageId = tonumber(params[index]) or stageId
    if conStageId == 0 then
        conStageId = stageId
    end
    local conCount = tonumber(values[index]) or 0
    local saveData = self:_getAchieveSaveData(playerData:getPlayer(), cfg) --self._achieveSave[cfg.id]
    --local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local player = playerData:getPlayer()
    local mainActor = playerData:getMainActor()
    local spawnEnemy = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy")
    if spawnEnemy:isWin() and conStageId == stageId and mainActor:getBeDamage() == 0 then
        local tampIndex = DataIndex.condition1 + index - 1
        self:refreshSaveAchievementTime(player, saveData, cfg, index)
        local oldData = saveData[tampIndex] or 0
        local tempValue = oldData + 1
        self:updateSaveData(player, cfg, tampIndex, tempValue, true)
    end
end

function SurviveGameAchievement:_update_condition_5(cfg, index, playerData) -- 累计击杀敌人
    if self:_checkNoInTimeLimit(cfg) then
        return
    end
    local params = string.split(cfg.param, "|")
    assert(params, "")
    local values = string.split(cfg.value, "|")
    assert(values, "")
    local killId = tonumber(params[index]) or 0
    local killCount = tonumber(values[index]) or 0
    local player = playerData:getPlayer()
    local playerId = player:get_id()
    local saveData = self:_getAchieveSaveData(player, cfg) --self._achieveSave[cfg.id]
    local tampIndex = DataIndex.condition1 + index - 1
    if not self._recordMap[cfg.id .. "_" .. index] then
        self._recordMap[cfg.id .. "_" .. index] = saveData[tampIndex] or 0
    end
    self:refreshSaveAchievementTime(player, saveData, cfg, index)
    local tempValue = self._recordMap[cfg.id .. "_" .. index] + playerData:getKillNum(killId)
    self:updateSaveData(player, cfg, tampIndex, tempValue, true)
end

function SurviveGameAchievement:_update_condition_6(cfg, index, playerData) --累计金币收入
    if self:_checkNoInTimeLimit(cfg) then
        return
    end
    local params = string.split(cfg.param, "|")
    assert(params, "")
    local values = string.split(cfg.value, "|")
    assert(values, "")
    local goldId = tonumber(params[index]) or 0
    local goldCount = tonumber(values[index]) or 0
    local player = playerData:getPlayer()
    local playerId = player:get_id()
    local saveData = self:_getAchieveSaveData(player, cfg) --self._achieveSave[cfg.id]
    local surRes = y3.gameApp:getLevel():getLogic("SurviveResource")
    local tampIndex = DataIndex.condition1 + index - 1
    if not self._recordMap[cfg.id .. "_" .. index] then
        self._recordMap[cfg.id .. "_" .. index] = saveData[tampIndex] or 0
    end
    self:refreshSaveAchievementTime(player, saveData, cfg, index)
    local tempValue = self._recordMap[cfg.id .. "_" .. index] +
        math.floor(surRes:getTotalGoldAdd(y3.gameApp:getMyPlayerId()))
    self:updateSaveData(player, cfg, tampIndex, tempValue, true)
end

function SurviveGameAchievement:_update_condition_7(cfg, index, playerData) -- 单局特定属性达到
    if self:_checkNoInTimeLimit(cfg) then
        return
    end
    local params = string.split(cfg.param, "|")
    assert(params, "")
    local values = string.split(cfg.value, "|")
    assert(values, "")
    local attrId = tonumber(params[index]) or 0
    local attrValue = tonumber(values[index]) or 0
    local curAttrValue = 0
    --local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local player = playerData:getPlayer()
    local mainActor = playerData:getMainActor()
    curAttrValue = mainActor:getAttrValue(attrId)
    if curAttrValue >= attrValue then
        local saveData = self:_getAchieveSaveData(player, cfg) --self._achieveSave[cfg.id]
        local tampIndex = DataIndex.condition1 + index - 1
        self:refreshSaveAchievementTime(player, saveData, cfg, index)
        local tempValue = math.floor(curAttrValue)
        self:updateSaveData(player, cfg, tampIndex, tempValue, true)
    end
end

function SurviveGameAchievement:_update_condition_8(cfg, index, playerData) -- 一局内购买指定技能/升级次数
    if self:_checkNoInTimeLimit(cfg) then
        return
    end
    local params = string.split(cfg.param, "|")
    assert(params, "")
    local values = string.split(cfg.value, "|")
    assert(values, "")
    local skillId = tonumber(params[index]) or 0
    local skillCount = tonumber(values[index]) or 0
    print("check condition 8", skillId, skillCount)
    local refreshSkill = y3.gameApp:getLevel():getLogic("SurviveRefreshSkill")
    local curCount = refreshSkill:buySkillCount(y3.gameApp:getMyPlayerId(), skillId)
    if curCount >= skillCount then
        local player = playerData:getPlayer()
        local saveData = self:_getAchieveSaveData(player, cfg) --self._achieveSave[cfg.id]
        local tampIndex = DataIndex.condition1 + index - 1
        self:refreshSaveAchievementTime(player, saveData, cfg, index)
        self:updateSaveData(player, cfg, tampIndex, curCount, true)
    end
end

function SurviveGameAchievement:_update_condition_9(cfg, index, playerData) -- 局内当前金币达到xxx
    if self:_checkNoInTimeLimit(cfg) then
        return
    end
    local params = string.split(cfg.param, "|")
    assert(params, "")
    local values = string.split(cfg.value, "|")
    assert(values, "")
    local goldId = tonumber(params[index]) or 0
    local goldNum = tonumber(values[index]) or 0
    --local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local player = playerData:getPlayer()
    local curGold = player:get_attr("gold")
    if curGold >= goldNum then
        local saveData = self:_getAchieveSaveData(player, cfg) --self._achieveSave[cfg.id]
        local tampIndex = DataIndex.condition1 + index - 1
        self:refreshSaveAchievementTime(player, saveData, cfg, index)
        local tempValue = math.floor(curGold)
        self:updateSaveData(player, cfg, tampIndex, tempValue, true)
    end
end

function SurviveGameAchievement:_update_condition_10(cfg, index, playerData) -- 累计闪避次数
    if self:_checkNoInTimeLimit(cfg) then
        return
    end
    local params = string.split(cfg.param, "|")
    assert(params, "")
    local values = string.split(cfg.value, "|")
    assert(values, "")
    local paramId = tonumber(params[index]) or 0
    local paramValue = tonumber(values[index]) or 0
    local missValue = 0
    local conditions = string.split(cfg.condition, "|")
    assert(conditions, "")
    local cond = conditions[index] or ""
    local playerId = y3.gameApp:getMyPlayerId()
    if self._recordAchievementData[playerId] and self._recordAchievementData[playerId][cond] then
        missValue = self._recordAchievementData[playerId][cond]
    end
    local player = playerData:getPlayer()
    local playerId = player:get_id()
    local saveData = self:_getAchieveSaveData(player, cfg) --self._achieveSave[cfg.id]
    local tampIndex = DataIndex.condition1 + index - 1
    if not self._recordMap[cfg.id .. "_" .. index] then
        self._recordMap[cfg.id .. "_" .. index] = saveData[tampIndex] or 0
    end
    self:refreshSaveAchievementTime(player, saveData, cfg, index)
    local tempValue = self._recordMap[cfg.id .. "_" .. index] + missValue
    print(tempValue)
    self:updateSaveData(player, cfg, tampIndex, tempValue, true)
end

function SurviveGameAchievement:_update_condition_11(cfg, index, playerData) --组队通关次数
    if self:_checkNoInTimeLimit(cfg) then
        return
    end
    local stageId = y3.userData:getCurStageId()
    local params = string.split(cfg.param, "|")
    assert(params, "")
    local values = string.split(cfg.value, "|")
    assert(values, "")
    local paramId = tonumber(params[index]) or 0
    if paramId == 0 then
        paramId = stageId
    end
    local paramValue = tonumber(values[index]) or 0
    local spawnEnemy = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy")
    local allPlayers = y3.userData:getAllInPlayers()
    if spawnEnemy:isWin() and paramId == stageId and #allPlayers > 1 then
        local player = playerData:getPlayer()
        local saveData = self:_getAchieveSaveData(player, cfg) --self._achieveSave[cfg.id]
        local tampIndex = DataIndex.condition1 + index - 1
        self:refreshSaveAchievementTime(player, saveData, cfg, index)
        local oldData = saveData[tampIndex] or 0
        local tempValue = oldData + 1
        self:updateSaveData(player, cfg, tampIndex, tempValue, true)
    end
end

function SurviveGameAchievement:_update_condition_12(cfg, index, playerData) --累计商店刷新次数
    if self:_checkNoInTimeLimit(cfg) then
        return
    end
    local params = string.split(cfg.param, "|")
    assert(params, "")
    local values = string.split(cfg.value, "|")
    assert(values, "")
    local paramId = tonumber(params[index]) or 0
    local paramValue = tonumber(values[index]) or 0
    local refreshValue = 0
    local conditions = string.split(cfg.condition, "|")
    assert(conditions, "")
    local cond = conditions[index] or ""
    local playerId = y3.gameApp:getMyPlayerId()
    if self._recordAchievementData[playerId] and self._recordAchievementData[playerId][cond] then
        refreshValue = self._recordAchievementData[playerId][cond]
    end
    local player = playerData:getPlayer()
    local playerId = player:get_id()
    local saveData = self:_getAchieveSaveData(player, cfg) --self._achieveSave[cfg.id]
    local tampIndex = DataIndex.condition1 + index - 1
    if not self._recordMap[cfg.id .. "_" .. index] then
        self._recordMap[cfg.id .. "_" .. index] = saveData[tampIndex] or 0
    end
    self:refreshSaveAchievementTime(player, saveData, cfg, index)
    local tempValue = self._recordMap[cfg.id .. "_" .. index] + refreshValue
    self:updateSaveData(player, cfg, tampIndex, tempValue, true)
end

function SurviveGameAchievement:_update_condition_13(cfg, index, playerData) --购买单系通关xx难度以上
    if self:_checkNoInTimeLimit(cfg) then
        return
    end
    local params = string.split(cfg.param, "|")
    assert(params, "")
    local values = string.split(cfg.value, "|")
    assert(values, "")
    local paramId = tonumber(params[index]) or 0
    local paramValue = tonumber(values[index]) or 0
    local stageId = y3.userData:getCurStageId()
    local refreshSkill = y3.gameApp:getLevel():getLogic("SurviveRefreshSkill")
    local spawnEnemy = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy")
    if spawnEnemy:isWin() and stageId >= paramId and refreshSkill:buySkillIsSingal(y3.gameApp:getMyPlayerId()) then
        local player = playerData:getPlayer()
        local saveData = self:_getAchieveSaveData(player, cfg) --self._achieveSave[cfg.id]
        self:refreshSaveAchievementTime(player, saveData, cfg, index)
        local tampIndex = DataIndex.condition1 + index - 1
        local oldData = saveData[tampIndex] or 0
        local tempValue = oldData + 1
        self:updateSaveData(player, cfg, tampIndex, tempValue, true)
    end
end

function SurviveGameAchievement:_update_condition_14(cfg, index, playerData) --单局游戏某类型武器数量超过100个
    if self:_checkNoInTimeLimit(cfg) then
        return
    end
    local params = string.split(cfg.param, "|")
    assert(params, "")
    local values = string.split(cfg.value, "|")
    assert(values, "")
    local paramId    = tonumber(params[index]) or 0
    local paramValue = tonumber(values[index]) or 0
    --local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local mainActor  = playerData:getMainActor()
    if mainActor then
        local skillNum = mainActor:getSkillTypeNum(paramId)
        if skillNum >= paramValue then
            local player = playerData:getPlayer()
            local saveData = self:_getAchieveSaveData(player, cfg) --self._achieveSave[cfg.id]
            local tampIndex = DataIndex.condition1 + index - 1
            self:refreshSaveAchievementTime(player, saveData, cfg, index)
            self:updateSaveData(player, cfg, tampIndex, skillNum, true)
        end
    end
end

function SurviveGameAchievement:_update_condition_15(cfg, index, playerData) --未购买橙色品质武器通关N2以上难度
    if self:_checkNoInTimeLimit(cfg) then
        return
    end
    local params = string.split(cfg.param, "|")
    assert(params, "")
    local values = string.split(cfg.value, "|")
    assert(values, "")
    local paramId      = tonumber(params[index]) or 0
    local paramValue   = tonumber(values[index]) or 0
    local stageId      = y3.userData:getCurStageId()
    --local playerData   = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local refreshSkill = y3.gameApp:getLevel():getLogic("SurviveRefreshSkill")
    local buyCount     = refreshSkill:buySkillClassCount(playerData:getId(), 4)
    if stageId >= paramId and buyCount == 0 then
        local player = playerData:getPlayer()
        local saveData = self:_getAchieveSaveData(player, cfg) --self._achieveSave[cfg.id]
        local tampIndex = DataIndex.condition1 + index - 1
        self:refreshSaveAchievementTime(player, saveData, cfg, index)
        self:updateSaveData(player, cfg, tampIndex, paramValue, true)
    end
end

function SurviveGameAchievement:_update_condition_16(cfg, index, playerData) --累计通过尖刺伤害击杀敌人
    if self:_checkNoInTimeLimit(cfg) then
        return
    end
    local params = string.split(cfg.param, "|")
    assert(params, "")
    local values = string.split(cfg.value, "|")
    assert(values, "")
    local paramId = tonumber(params[index]) or 0
    local paramValue = tonumber(values[index]) or 0
    local refreshValue = 0
    local conditions = string.split(cfg.condition, "|")
    assert(conditions, "")
    local cond = conditions[index] or ""
    local playerId = y3.gameApp:getMyPlayerId()
    if self._recordAchievementData[playerId] and self._recordAchievementData[playerId][cond] then
        refreshValue = self._recordAchievementData[playerId][cond]
    end
    local player = playerData:getPlayer()
    local playerId = player:get_id()
    local saveData = self:_getAchieveSaveData(player, cfg) --self._achieveSave[cfg.id]
    local tampIndex = DataIndex.condition1 + index - 1
    if not self._recordMap[cfg.id .. "_" .. index] then
        self._recordMap[cfg.id .. "_" .. index] = saveData[tampIndex] or 0
    end
    self:refreshSaveAchievementTime(player, saveData, cfg, index)
    local tempValue = self._recordMap[cfg.id .. "_" .. index] + refreshValue
    self:updateSaveData(player, cfg, tampIndex, tempValue, true)
end

function SurviveGameAchievement:_update_condition_17(cfg, index, playerData) --累计挑战失败
    if self:_checkNoInTimeLimit(cfg) then
        return
    end
    local params = string.split(cfg.param, "|")
    assert(params, "")
    local values = string.split(cfg.value, "|")
    assert(values, "")
    local paramId = tonumber(params[index]) or 0
    local paramValue = tonumber(values[index]) or 0
    local spawnEnemy = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy")
    if not spawnEnemy:isWin() then
        local player = playerData:getPlayer()
        local saveData = self:_getAchieveSaveData(player, cfg) --self._achieveSave[cfg.id]
        local tampIndex = DataIndex.condition1 + index - 1
        self:refreshSaveAchievementTime(player, saveData, cfg, index)
        local oldData = saveData[tampIndex] or 0
        local tempValue = oldData + 1
        self:updateSaveData(player, cfg, tampIndex, tempValue, true)
    end
end

function SurviveGameAchievement:_update_condition_18(cfg, index, playerData) -- 单局内刷新次数
    if self:_checkNoInTimeLimit(cfg) then
        return
    end
    local params = string.split(cfg.param, "|")
    assert(params, "")
    local values = string.split(cfg.value, "|")
    assert(values, "")
    local paramId = tonumber(params[index]) or 0
    local paramValue = tonumber(values[index]) or 0
    local refreshValue = 0
    local conditions = string.split(cfg.condition, "|")
    assert(conditions, "")
    local cond = conditions[index] or ""
    local playerId = y3.gameApp:getMyPlayerId()
    if self._recordAchievementData[playerId] and self._recordAchievementData[playerId][cond] then
        refreshValue = self._recordAchievementData[playerId][cond]
    end
    if refreshValue >= paramValue then
        local player = playerData:getPlayer()
        local saveData = self:_getAchieveSaveData(player, cfg) --self._achieveSave[cfg.id]
        local tampIndex = DataIndex.condition1 + index - 1
        self:refreshSaveAchievementTime(player, saveData, cfg, index)
        self:updateSaveData(player, cfg, tampIndex, refreshValue, true)
    end
end

function SurviveGameAchievement:_update_condition_19(cfg, index, playerData) -- 一局游戏内,5种系列武器数量均超过
    if self:_checkNoInTimeLimit(cfg) then
        return
    end
    local params = string.split(cfg.param, "|")
    assert(params, "")
    local values = string.split(cfg.value, "|")
    assert(values, "")
    local paramId    = tonumber(params[index]) or 0
    local paramValue = tonumber(values[index]) or 0
    --local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local mainActor  = playerData:getMainActor()
    if mainActor then
        local minCount = -1
        for i = 1, 5 do
            local count = mainActor:getSkillTypeNum(i)
            if minCount == -1 or count < minCount then
                minCount = count
            end
        end
        if minCount >= paramValue then
            local player = playerData:getPlayer()
            local saveData = self:_getAchieveSaveData(player, cfg) --self._achieveSave[cfg.id]
            local tampIndex = DataIndex.condition1 + index - 1
            self:refreshSaveAchievementTime(player, saveData, cfg, index)
            self:updateSaveData(player, cfg, tampIndex, paramValue, true)
        end
    end
end

function SurviveGameAchievement:_update_condition_20(cfg, index, playerData) -- 击杀最终boss时间
    if self:_checkNoInTimeLimit(cfg) then
        return
    end
    local params = string.split(cfg.param, "|")
    assert(params, "")
    local values = string.split(cfg.value, "|")
    assert(values, "")
    local paramId    = tonumber(params[index]) or 0
    local paramValue = tonumber(values[index]) or 0
    local spawnEnemy = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy")
    local totalTime  = self._killFinalBossMap[y3.gameApp:getMyPlayerId()]
    log.info("_update_condition_20 totalTime", totalTime)
    if spawnEnemy:isWin() and (totalTime and totalTime <= paramId) then
        local player = playerData:getPlayer()
        local saveData = self:_getAchieveSaveData(player, cfg)
        local tampIndex = DataIndex.condition1 + index - 1
        self:refreshSaveAchievementTime(player, saveData, cfg, index)
        local tempValue = math.floor(totalTime) <= 0 and 1 or math.floor(totalTime)
        self:updateSaveData(player, cfg, tampIndex, tempValue, true)
    end
end

function SurviveGameAchievement:_update_condition_21(cfg, index, playerData) -- 一局游戏内,连续20次商店刷新都未购买
    if self:_checkNoInTimeLimit(cfg) then
        return
    end
    local params = string.split(cfg.param, "|")
    assert(params, "")
    local values = string.split(cfg.value, "|")
    assert(values, "")
    local paramId      = tonumber(params[index]) or 0
    local paramValue   = tonumber(values[index]) or 0
    local refreshSkill = y3.gameApp:getLevel():getLogic("SurviveRefreshSkill")
    local totalRefresh = refreshSkill:getRefreshShopTotal()
    if totalRefresh >= paramValue then
        local player = playerData:getPlayer()
        local saveData = self:_getAchieveSaveData(player, cfg) --self._achieveSave[cfg.id]
        local tampIndex = DataIndex.condition1 + index - 1
        self:refreshSaveAchievementTime(player, saveData, cfg, index)
        self:updateSaveData(player, cfg, tampIndex, totalRefresh, true)
    end
end

function SurviveGameAchievement:_update_condition_22(cfg, index, playerData) -- 通过任意难度有极小概率获取
    if self:_checkNoInTimeLimit(cfg) then
        return
    end
    local params = string.split(cfg.param, "|")
    assert(params, "")
    local values = string.split(cfg.value, "|")
    assert(values, "")
    local paramId    = tonumber(params[index]) or 0
    local paramValue = tonumber(values[index]) or 0
    local spawnEnemy = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy")
    local wanfenyi   = math.random(1, 10000) -- spawnEnemy:getWanfenyi()
    if spawnEnemy:isWin() and wanfenyi <= paramValue then
        local player = playerData:getPlayer()
        local saveData = self:_getAchieveSaveData(player, cfg) --self._achieveSave[cfg.id]
        local tampIndex = DataIndex.condition1 + index - 1
        self:refreshSaveAchievementTime(player, saveData, cfg, index)
        self:updateSaveData(player, cfg, tampIndex, paramValue, true)
    end
end

function SurviveGameAchievement:_update_condition_23(cfg, index, playerData) -- 血量未低于%x通关
    if self:_checkNoInTimeLimit(cfg) then
        return
    end
    local params = string.split(cfg.param, "|")
    assert(params, "")
    local values = string.split(cfg.value, "|")
    assert(values, "")
    local paramId    = tonumber(params[index]) or 0
    local paramValue = tonumber(values[index]) or 0
    local stageId    = y3.userData:getCurStageId()
    if paramId == 0 then
        paramId = stageId
    end
    local mainActor = playerData:getMainActor()
    local hpPer     = mainActor:getGlobalHpPer()
    if paramId == stageId and hpPer >= paramValue then
        local player = playerData:getPlayer()
        local saveData = self:_getAchieveSaveData(player, cfg) --self._achieveSave[cfg.id]
        local tampIndex = DataIndex.condition1 + index - 1
        self:refreshSaveAchievementTime(player, saveData, cfg, index)
        self:updateSaveData(player, cfg, tampIndex, paramValue, true)
    end
end

function SurviveGameAchievement:_update_condition_24()
end

function SurviveGameAchievement:_update_condition_25()
end

function SurviveGameAchievement:_update_condition_26()
end

function SurviveGameAchievement:_update_condition_27()
end

function SurviveGameAchievement:_update_condition_28(cfg, index, playerData) --英雄属性达到，param：属性ID; VALUE:属性值
    if self:_checkNoInTimeLimit(cfg) then
        return
    end
    local params = string.split(cfg.param, "|")
    assert(params, "")
    local values = string.split(cfg.value, "|")
    assert(values, "")
    local attrId = tonumber(params[index]) or 0
    local attrValue = tonumber(values[index]) or 0
    local curAttrValue = 0
    --local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local player = playerData:getPlayer()
    local mainActor = playerData:getMainActor()
    local heroSoulActor = mainActor:getSoulHeroActor()
    curAttrValue = heroSoulActor:getAttrValue(attrId)
    if curAttrValue >= attrValue then
        local saveData = self:_getAchieveSaveData(player, cfg) --self._achieveSave[cfg.id]
        local tampIndex = DataIndex.condition1 + index - 1
        self:refreshSaveAchievementTime(player, saveData, cfg, index)
        local tempValue = math.floor(curAttrValue)
        self:updateSaveData(player, cfg, tampIndex, tempValue, true)
    end
end

function SurviveGameAchievement:_update_condition_29(cfg, index, playerData) --持有saveitem数量达到，param:道具ID;VALUE:数量
    if self:_checkNoInTimeLimit(cfg) then
        return
    end
    local params = string.split(cfg.param, "|")
    assert(params, "")
    local values = string.split(cfg.value, "|")
    assert(values, "")
    local itemId = tonumber(params[index]) or 0
    local itemSize = tonumber(values[index]) or 0
    local saveItem = y3.gameApp:getLevel():getLogic("SurviveGameSaveItem")
    local curSize = saveItem:getSaveItemNum(playerData:getId(), itemId)
    local player = playerData:getPlayer()
    local saveData = self:_getAchieveSaveData(player, cfg) --self._achieveSave[cfg.id]
    local tampIndex = DataIndex.condition1 + index - 1
    local oldSize = saveData[tampIndex] or 0
    if curSize >= oldSize then
        self:refreshSaveAchievementTime(player, saveData, cfg, index)
        self:updateSaveData(player, cfg, tampIndex, curSize, true)
    end
end

function SurviveGameAchievement:_update_condition_30(cfg, index, playerData) --组队通关，param：等级差（玩家地图等级-通关后与其他玩家地图等级>=param），value：通关次数
    if self:_checkNoInTimeLimit(cfg) then
        return
    end
    local stageId = y3.userData:getCurStageId()
    local params = string.split(cfg.param, "|")
    assert(params, "")
    local values = string.split(cfg.value, "|")
    assert(values, "")
    local paramId = tonumber(params[index]) or 0
    local paramValue = tonumber(values[index]) or 0
    local spawnEnemy = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy")
    local allPlayers = y3.userData:getAllInPlayers()
    local otherMinLevel = 9999999
    local myLevel = playerData:getPlayer():get_map_level()
    for _, otherPlayerData in ipairs(allPlayers) do
        if otherPlayerData:getId() ~= playerData:getId() then
            local mapLevel = playerData:getPlayer():get_map_level()
            if mapLevel < otherMinLevel then
                otherMinLevel = mapLevel
            end
        end
    end
    if spawnEnemy:isWin() and #allPlayers > 1 and (myLevel - otherMinLevel) >= paramId then
        local player = playerData:getPlayer()
        local saveData = self:_getAchieveSaveData(player, cfg) --self._achieveSave[cfg.id]
        local tampIndex = DataIndex.condition1 + index - 1
        self:refreshSaveAchievementTime(player, saveData, cfg, index)
        local oldData = saveData[tampIndex] or 0
        local tempValue = oldData + 1
        self:updateSaveData(player, cfg, tampIndex, tempValue, true)
    end
end

function SurviveGameAchievement:_update_condition_31(cfg, index, playerData) --累计魂石收入：VALUE:数量
    if self:_checkNoInTimeLimit(cfg) then
        return
    end
    local params = string.split(cfg.param, "|")
    assert(params, "")
    local values = string.split(cfg.value, "|")
    assert(values, "")
    -- local goldId = tonumber(params[index]) or 0
    local diamondCount = tonumber(values[index]) or 0
    local player = playerData:getPlayer()
    local saveData = self:_getAchieveSaveData(player, cfg) --self._achieveSave[cfg.id]
    local surRes = y3.gameApp:getLevel():getLogic("SurviveResource")
    local tampIndex = DataIndex.condition1 + index - 1
    local refreshValue = math.floor(surRes:getTotalDiamondAdd(y3.gameApp:getMyPlayerId()))
    if not self._recordMap[cfg.id .. "_" .. index] then
        self._recordMap[cfg.id .. "_" .. index] = saveData[tampIndex] or 0
    end
    self:refreshSaveAchievementTime(player, saveData, cfg, index)
    local tempValue = self._recordMap[cfg.id .. "_" .. index] + refreshValue
    self:updateSaveData(player, cfg, tampIndex, tempValue, true)
end

function SurviveGameAchievement:_update_condition_32(cfg, index, playerData) -- 魂石之路层级，param：暂无，value 层级
    if self:_checkNoInTimeLimit(cfg) then
        return
    end
    local params = string.split(cfg.param, "|")
    assert(params, "")
    local values = string.split(cfg.value, "|")
    assert(values, "")
    -- local goldId = tonumber(params[index]) or 0
    local floorValue = tonumber(values[index]) or 0
    local spawnEnemy = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy")
    local tempValue = spawnEnemy:getAbysChallenge():getChallengeFloor(playerData:getId()) --math.floor(surRes:getTotalDiamondAdd(y3.gameApp:getMyPlayerId()))
    if tempValue >= floorValue then
        local player = playerData:getPlayer()
        local saveData = self:_getAchieveSaveData(player, cfg) --self._achieveSave[cfg.id]
        local tampIndex = DataIndex.condition1 + index - 1
        self:refreshSaveAchievementTime(player, saveData, cfg, index)
        self:updateSaveData(player, cfg, tampIndex, tempValue, true)
    end
end

function SurviveGameAchievement:_update_condition_33(cfg, index, playerData) --击杀特定id怪物
    if self:_checkNoInTimeLimit(cfg) then
        return
    end
    local params = string.split(cfg.param, "|")
    assert(params, "")
    local values = string.split(cfg.value, "|")
    assert(values, "")
    local monsterId = tonumber(params[index]) or 0
    local condValue = tonumber(values[index]) or 0

    local player = playerData:getPlayer()
    local refreshValue = playerData:getKillNumId(monsterId)
    local saveData = self:_getAchieveSaveData(player, cfg) --self._achieveSave[cfg.id]
    local tampIndex = DataIndex.condition1 + index - 1
    if not self._recordMap[cfg.id .. "_" .. index] then
        self._recordMap[cfg.id .. "_" .. index] = saveData[tampIndex] or 0
    end
    self:refreshSaveAchievementTime(player, saveData, cfg, index)
    local tempValue = self._recordMap[cfg.id .. "_" .. index] + refreshValue
    self:updateSaveData(player, cfg, tampIndex, tempValue, true)
end

function SurviveGameAchievement:_update_condition_34(cfg, index, playerData) -- 关卡时长记录
    if self:_checkNoInTimeLimit(cfg) then
        return
    end
    local params = string.split(cfg.param, "|")
    assert(params, "")
    local values = string.split(cfg.value, "|")
    assert(values, "")
    local stageId = tonumber(params[index]) or 0
    if stageId == 0 then
        stageId = y3.userData:getCurStageId()
    end
    -- local condValue = tonumber(values[index]) or 0
    if stageId == y3.userData:getCurStageId() then
        local player = playerData:getPlayer()
        local saveData = self:_getAchieveSaveData(player, cfg) --self._achieveSave[cfg.id]
        local tampIndex = DataIndex.condition1 + index - 1
        local oldValue = saveData[tampIndex] or 0
        local readyEndTotalTime = math.floor(self._stagePassTime)
        if readyEndTotalTime >= oldValue then
            self:refreshSaveAchievementTime(player, saveData, cfg, index)
            local tempValue = readyEndTotalTime
            self:updateSaveData(player, cfg, tampIndex, tempValue, true)
        end
    end
end

----------------------------------检查成就--------------------------------
function SurviveGameAchievement:_check_condition_1(saveData, cfg, index) -- 通关关卡
    local params = string.split(cfg.param, "|")
    assert(params, "")
    local values = string.split(cfg.value, "|")
    assert(values, "")
    local conCount = tonumber(values[index]) or 0
    local saveCond = saveData[DataIndex.condition1 + index - 1] or 0
    -- if cfg.id == 1001 then
    --     print(type(saveCond))
    --     print(saveCond)
    -- end
    if saveCond <= 0 then
        return false
    end

    if cfg.if_daily == 1 then
        local timeRet          = y3.gameUtils.get_server_time(8)
        local year, month, day = GameUtils.getCurrentDate(timeRet.timestamp)
        -- if cfg.id == 1001 then
        --     print(year, month, day)
        --     print(saveData[DataIndex.year], saveData[DataIndex.month], saveData[DataIndex.day])
        -- end
        if saveData[DataIndex.year] == year and saveData[DataIndex.month] == month and saveData[DataIndex.day] == day then
            return saveCond and saveCond >= conCount
        else
            return false
        end
    else
        return saveCond and saveCond >= conCount
    end
end

function SurviveGameAchievement:_check_condition_2(saveData, cfg, index)
    return self:_check_condition_1(saveData, cfg, index)
end

function SurviveGameAchievement:_check_condition_3(saveData, cfg, index)
    return self:_check_condition_1(saveData, cfg, index)
end

function SurviveGameAchievement:_check_condition_4(saveData, cfg, index)
    return self:_check_condition_1(saveData, cfg, index)
end

function SurviveGameAchievement:_check_condition_5(saveData, cfg, index)
    return self:_check_condition_1(saveData, cfg, index)
end

function SurviveGameAchievement:_check_condition_6(saveData, cfg, index)
    return self:_check_condition_1(saveData, cfg, index)
end

function SurviveGameAchievement:_check_condition_7(saveData, cfg, index)
    return self:_check_condition_1(saveData, cfg, index)
end

function SurviveGameAchievement:_check_condition_8(saveData, cfg, index)
    return self:_check_condition_1(saveData, cfg, index)
end

function SurviveGameAchievement:_check_condition_9(saveData, cfg, index)
    return self:_check_condition_1(saveData, cfg, index)
end

function SurviveGameAchievement:_check_condition_10(saveData, cfg, index)
    return self:_check_condition_1(saveData, cfg, index)
end

function SurviveGameAchievement:_check_condition_11(saveData, cfg, index)
    return self:_check_condition_1(saveData, cfg, index)
end

function SurviveGameAchievement:_check_condition_12(saveData, cfg, index)
    return self:_check_condition_1(saveData, cfg, index)
end

function SurviveGameAchievement:_check_condition_13(saveData, cfg, index)
    return self:_check_condition_1(saveData, cfg, index)
end

function SurviveGameAchievement:_check_condition_14(saveData, cfg, index)
    return self:_check_condition_1(saveData, cfg, index)
end

function SurviveGameAchievement:_check_condition_15(saveData, cfg, index)
    return self:_check_condition_1(saveData, cfg, index)
end

function SurviveGameAchievement:_check_condition_16(saveData, cfg, index)
    return self:_check_condition_1(saveData, cfg, index)
end

function SurviveGameAchievement:_check_condition_17(saveData, cfg, index)
    return self:_check_condition_1(saveData, cfg, index)
end

function SurviveGameAchievement:_check_condition_18(saveData, cfg, index)
    return self:_check_condition_1(saveData, cfg, index)
end

function SurviveGameAchievement:_check_condition_19(saveData, cfg, index)
    return self:_check_condition_1(saveData, cfg, index)
end

function SurviveGameAchievement:_check_condition_20(saveData, cfg, index)
    local params = string.split(cfg.param, "|")
    assert(params, "")
    local values = string.split(cfg.value, "|")
    assert(values, "")
    local paramCon = tonumber(params[index]) or 0
    local conCount = tonumber(values[index]) or 0
    local tempIdex = DataIndex.condition1 + index - 1
    local saveCond = saveData[tempIdex] or 0
    if saveCond <= 0 then
        return false
    end
    if cfg.if_daily == 1 then
        local timeRet          = y3.gameUtils.get_server_time(8)
        local year, month, day = GameUtils.getCurrentDate(timeRet.timestamp)
        if saveData[DataIndex.year] == year and saveData[DataIndex.month] == month and saveData[DataIndex.day] == day then
            return saveCond and saveCond <= paramCon
        else
            return false
        end
    else
        return saveCond and saveCond <= paramCon
    end
end

function SurviveGameAchievement:_check_condition_21(saveData, cfg, index)
    return self:_check_condition_1(saveData, cfg, index)
end

function SurviveGameAchievement:_check_condition_22(saveData, cfg, index)
    return self:_check_condition_1(saveData, cfg, index)
end

function SurviveGameAchievement:_check_condition_23(saveData, cfg, index)
    return self:_check_condition_1(saveData, cfg, index)
end

---comment
---@param saveData any
---@param cfg any
---@param index any
---@param player Player
---@return boolean
function SurviveGameAchievement:_check_condition_24(saveData, cfg, index, player)
    local isRet = player.phandle:api_is_bookmark_current_map() or false
    return isRet
end

---comment
---@param saveData any
---@param cfg any
---@param index any
---@param player Player
---@return boolean
function SurviveGameAchievement:_check_condition_25(saveData, cfg, index, player)
    return player:get_map_level() >= 3
end

---comment
---@param saveData any
---@param cfg any
---@param index any
---@param player Player
---@return boolean
function SurviveGameAchievement:_check_condition_26(saveData, cfg, index, player)
    local params = string.split(cfg.param, "|")
    assert(params, "")
    local values = string.split(cfg.value, "|")
    assert(values, "")
    local paramCon = tonumber(params[index]) or 0
    local conCount = tonumber(values[index]) or 0
    return player:get_community_value("精华帖数量") >= conCount
end

---comment
---@param saveData any
---@param cfg any
---@param index any
---@param player Player
---@return boolean
function SurviveGameAchievement:_check_condition_27(saveData, cfg, index, player)
    local params = string.split(cfg.param, "|")
    assert(params, "")
    local values = string.split(cfg.value, "|")
    assert(values, "")
    local paramCon = tonumber(params[index]) or 0
    local conCount = tonumber(values[index]) or 0
    return player:get_community_value("帖子收到的欢乐数") >= conCount
end

function SurviveGameAchievement:_check_condition_28(saveData, cfg, index)
    return self:_check_condition_1(saveData, cfg, index)
end

function SurviveGameAchievement:_check_condition_29(saveData, cfg, index)
    return self:_check_condition_1(saveData, cfg, index)
end

function SurviveGameAchievement:_check_condition_30(saveData, cfg, index)
    return self:_check_condition_1(saveData, cfg, index)
end

function SurviveGameAchievement:_check_condition_31(saveData, cfg, index)
    return self:_check_condition_1(saveData, cfg, index)
end

function SurviveGameAchievement:_check_condition_32(saveData, cfg, index)
    return self:_check_condition_1(saveData, cfg, index)
end

function SurviveGameAchievement:_check_condition_33(saveData, cfg, index)
    return self:_check_condition_1(saveData, cfg, index)
end

function SurviveGameAchievement:_check_condition_34(saveData, cfg, index)
    return self:_check_condition_1(saveData, cfg, index)
end

return SurviveGameAchievement
