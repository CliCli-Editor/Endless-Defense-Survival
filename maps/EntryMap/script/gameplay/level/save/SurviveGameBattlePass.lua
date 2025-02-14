local LogicBase = include("gameplay.level.logic.LogicBase")
local M = class("SurviveGameBattlePass", LogicBase)
local GameUtils = include("gameplay.utils.GameUtils")

--[[
    战令存档结构

    每一等级奖励状态分三种：不可领-0、可领-1、已领-2    

    [s1]={经验值=总经验值#今天经验值#上次获得经验时间
          [免费档 领奖情况]=2#1#0#0..#n（N代表赛季战令等级）,
          [付费一档 领奖情况]=2#1#0#0..#n（N代表赛季战令等级）,
          [付费二档 领奖情况]=2#1#0#0..#n（N代表赛季战令等级）},
    [s2]={经验值=总经验值#今天经验值,
          [免费档 领奖情况]=2#1#0#0..#n（N代表赛季战令等级）,
          [付费一档 领奖情况]=2#1#0#0..#n（N代表赛季战令等级）,
          [付费二档 领奖情况]=2#1#0#0..#n（N代表赛季战令等级）},
    ……
]]


M.SeasonDataIndex = {
    Exp = 1,
    FreeReward = 2, --按等级组织的奖励信息列表
    AdvancedReward = 3, --按等级组织的奖励信息列表
    UltimateReward = 4, --按等级组织的奖励信息列表
    SpecialReward = 5, --1/2 RewardReceiveStatus
}
M.ExpDataIndex = {
    today = 1,
    lastGetTime = 2,
}
M.RewardReceiveStatus = {
    Havent = 1,
    Received = 2,
}

function M:ctor(level)
    M.super.ctor(self, level)
    self:_initData()
end

function M:_initData()
    local archiveData = y3.userData:loadTable("BattlePass")
    self._archiveData = archiveData
    if not archiveData then
        log.error("BattlePass error")
        return
    end

    local battlepassCfg = include("gameplay.config.game_battlepass")
    if not battlepassCfg then
        log.error("battlePass cfg error")
        return
    end

    local cfgLen = battlepassCfg.length()
    local seasonDic = {}
    for i = 1, cfgLen do
        local cfgInfo = battlepassCfg.indexOf(i)
        if not seasonDic[cfgInfo.game_season] then
            seasonDic[cfgInfo.game_season] = 1
        end
    end

    for seasonIndex,_ in pairs(seasonDic) do
        if nil == archiveData[seasonIndex] then
            self:addDefaultSeasonData(archiveData, seasonIndex, battlepassCfg)
        end
    end

    self:updateTodayExpLimit()
end

function M:autoUseExpItem()
    local expItemIdList = {}
    table.insert(expItemIdList, y3.SurviveConst.PLATFORM_ITEM_MAP.S1_BP_EXP_ITEM)
    local player = y3.player(y3.gameApp:getMyPlayerId())
    for _, itemId in ipairs(expItemIdList) do
        local itemCount = player:get_store_item_number(itemId)
        if itemCount > 0 then
            player:use_store_item(itemCount, itemId)
        end
    end
end

function M:updateTodayExpLimit()

    local battlepassCfg = include("gameplay.config.game_battlepass")
    if not battlepassCfg then
        return
    end

    local archiveData = self._archiveData
    if not archiveData then
        return
    end

    local curServerTime = y3.gameUtils.get_server_time(8)
    local curYear, curMonth, curDay = GameUtils.getCurrentDate(curServerTime.timestamp)

    local checkedSeason = {}
    local length = battlepassCfg.length()
    for index = 1, length, 1 do
        while true do
            local cfgInfo = battlepassCfg.indexOf(index)
            if not cfgInfo then
                break
            end

            local seasonIndex = cfgInfo.game_season
            if not archiveData[seasonIndex] then
                break
            end

            if checkedSeason[seasonIndex] then
               break
            end

            checkedSeason[seasonIndex] = 1

            local encryptedExpInfo = archiveData[seasonIndex][M.SeasonDataIndex.Exp]
            local decryptedExpInfo = y3.gameApp:decryptString(encryptedExpInfo)
            local params = string.split(decryptedExpInfo, "#")
            if not params or #params ~= 2 then
                break
            end
        

            local lastGetTime = tonumber(params[M.ExpDataIndex.lastGetTime])
            local eventYear, eventMonth, eventDay = GameUtils.getCurrentDate(lastGetTime)
            local lastChangeIsToday = curYear == eventYear and curMonth == eventMonth and curDay == eventDay
            if lastChangeIsToday then
                break
            end

            params[M.ExpDataIndex.today] = 0
            params[M.ExpDataIndex.lastGetTime] = curServerTime.timestamp

            local tempString = table.concat(params, "#")
            encryptedExpInfo = y3.gameApp:encryptString(tempString)
            archiveData[seasonIndex][M.SeasonDataIndex.Exp] = encryptedExpInfo

            break
        end
    end
end

function M:addDefaultSeasonData(archiveData, seasonIndex, battlepassCfg)
    if not archiveData or not seasonIndex or 0 == seasonIndex or not battlepassCfg then
        return
    end

    archiveData[seasonIndex] = {}

    local expInfo = {}
    expInfo[M.ExpDataIndex.today] = 0
    expInfo[M.ExpDataIndex.lastGetTime] = 0
    local tempExp = table.concat(expInfo, "#")
    local encryptedExp = y3.gameApp:encryptString(tempExp)
    archiveData[seasonIndex][M.SeasonDataIndex.Exp] = encryptedExp

    local rewardDefauldInfo = {}
    local len = battlepassCfg.length()
    for i = 1, len do
        local cfgInfo = battlepassCfg.indexOf(i)
        assert(cfgInfo, "")

        table.insert(rewardDefauldInfo, M.RewardReceiveStatus.Havent)
    end

    local tempRewardInfo = table.concat(rewardDefauldInfo, "#")
    local encryptedRewardInfo = y3.gameApp:encryptString(tempRewardInfo)
    archiveData[seasonIndex][M.SeasonDataIndex.FreeReward] = encryptedRewardInfo
    archiveData[seasonIndex][M.SeasonDataIndex.AdvancedReward] = encryptedRewardInfo
    archiveData[seasonIndex][M.SeasonDataIndex.UltimateReward] = encryptedRewardInfo
    archiveData[seasonIndex][M.SeasonDataIndex.SpecialReward] = y3.gameApp:encryptString(tostring(M.RewardReceiveStatus.Havent))
end

function M:addExp(player, seasonIndex, exp, ignorLimit)

    if not player or not exp or not seasonIndex or exp <= 0 or seasonIndex <= 0 then
        return
    end

    local playerId = player:get_id()
    local myPlayerId = y3.gameApp:getMyPlayerId()
    if playerId ~= myPlayerId then
        return
    end

    local archiveData = self._archiveData
    if not archiveData then
        return
    end

    if not archiveData[seasonIndex] then
        return
    end

    local encryptedExpInfo = archiveData[seasonIndex][M.SeasonDataIndex.Exp]
    local decryptedExpInfo = y3.gameApp:decryptString(encryptedExpInfo)
    local params = string.split(decryptedExpInfo, "#")
    if not params or #params ~= 2 then
        return
    end

    params[M.ExpDataIndex.today] = tonumber(params[M.ExpDataIndex.today])

    local battlepassActivityCfg = include("gameplay.config.game_acitivity")
    assert(battlepassActivityCfg, "battlepass activity cfg error")

    local activityInfo = battlepassActivityCfg.get(seasonIndex)
    assert(activityInfo, "battlepass activity info error")

    local expItemInfo = string.split(activityInfo.game_activity_args, "#")
    assert(expItemInfo and #expItemInfo == 3, "exp item info error")

    local expItemId = tonumber(expItemInfo[2])
    local perDayMaxGetableExp = tonumber(expItemInfo[3])
    assert(expItemId and perDayMaxGetableExp, "exp item info not number")

    local saveItemLogic = y3.gameApp:getLevel():getLogic("SurviveGameSaveItem")

    local curServerTime = y3.gameUtils.get_server_time(8)
    local curYear, curMonth, curDay = GameUtils.getCurrentDate(curServerTime.timestamp)

    local lastGetTime = tonumber(params[M.ExpDataIndex.lastGetTime])
    local eventYear, eventMonth, eventDay = GameUtils.getCurrentDate(lastGetTime)

    local lastChangeIsToday = curYear == eventYear and curMonth == eventMonth and curDay == eventDay
    if not lastChangeIsToday then
        params[M.ExpDataIndex.today] = 0
    end

    if params[M.ExpDataIndex.today] >= perDayMaxGetableExp and lastChangeIsToday and not ignorLimit then
        log.debug("添加赛季经验失败，已达当日经验上限")
        return
    end

    if params[M.ExpDataIndex.today] + exp > perDayMaxGetableExp and lastChangeIsToday and not ignorLimit then
        exp = perDayMaxGetableExp - params[M.ExpDataIndex.today]
    end
    if not ignorLimit then
        params[M.ExpDataIndex.today] = params[M.ExpDataIndex.today] + exp
    end

    saveItemLogic:dropSaveItem(playerId, expItemId, exp)
    params[M.ExpDataIndex.lastGetTime] = curServerTime.timestamp

    local tempString = table.concat(params, "#")
    local encryptedExpInfo = y3.gameApp:encryptString(tempString)
    archiveData[seasonIndex][M.SeasonDataIndex.Exp] = encryptedExpInfo

    y3.ltimer.wait(0.2, function (timer, count)
        y3.gameApp:dispatchEvent(y3.EventConst.EVENT_BP_DB_Changed, playerId)
    end)
end

---记录奖励领取情况
---@param player any
---@param seasonIndex any
---@param paramDic table {{免费奖励档位下标={等级1,等级2,..},{一档付费奖励档位下标={等级1,等级2,..}},...}}
function M:recordRewardReceiveInfo(player, seasonIndex, paramDic)

    if not player or not seasonIndex or seasonIndex <= 0 or getTableLength(paramDic) == 0 then
        return
    end

    local playerId = player:get_id()
    local getMyPlayerId = y3.gameApp:getMyPlayerId()
    if playerId ~= getMyPlayerId then
        return
    end

    local archiveData = self._archiveData
    assert(archiveData and archiveData[seasonIndex], "战令存档数据为空")

    for rewardType, levelList in pairs(paramDic) do
        while true do
            if not archiveData[seasonIndex][rewardType] then
                if rewardType == M.SeasonDataIndex.SpecialReward then
                    archiveData[seasonIndex][rewardType] = y3.gameApp:encryptString(tostring(M.RewardReceiveStatus.Received))
                else
                    log.warn("更新战令奖励信息失败，rewardType=%s, seasonIndex=%s", tostring(rewardType), tostring(seasonIndex))
                end
                break
            end

            if rewardType == M.SeasonDataIndex.SpecialReward then
                archiveData[seasonIndex][rewardType] = y3.gameApp:encryptString(tostring(M.RewardReceiveStatus.Received))
                break
            end
            local encryptedRewardInfo = archiveData[seasonIndex][rewardType]
            local decryptedRewardInfo = y3.gameApp:decryptString(encryptedRewardInfo)
            local params = string.split(decryptedRewardInfo, "#")
            if not params or #params == 0 then
                log.warn("更新战令奖励信息失败，存档信息异常！", tostring(seasonIndex))
                return
            end

            for _,lv in ipairs(levelList) do
                while true do
                    if not params[lv] then
                        break
                    end
                    params[lv] = M.RewardReceiveStatus.Received
                    break
                end
            end

            local tempString = table.concat(params, "#")
            local rewardsReceiveInfo = y3.gameApp:encryptString(tempString)
            archiveData[seasonIndex][rewardType] = rewardsReceiveInfo
            break
        end
    end

    y3.ltimer.wait(0.2, function (timer, count)
        y3.gameApp:dispatchEvent(y3.EventConst.EVENT_BP_DB_Changed, playerId)
    end)
end

function M:getSaveData(seasonIndex)
    local result = {}

    local player = y3.player(y3.gameApp:getMyPlayerId())
    local achieveSave = y3.userData:loadTableByPlayer(player, "BattlePass")
    if not achieveSave or not achieveSave[seasonIndex] then
        return result
    end

    local expInfo = {}
    local encryptedExpInfo = achieveSave[seasonIndex][M.SeasonDataIndex.Exp]
    local decryptedExpData = y3.gameApp:decryptString(encryptedExpInfo)
    local expParams = string.split(decryptedExpData, "#")
    assert(expParams and #expParams == 2, "exp info error")
    
    expInfo[M.ExpDataIndex.today] = tonumber(expParams[M.ExpDataIndex.today])
    expInfo[M.ExpDataIndex.lastGetTime] = tonumber(expParams[M.ExpDataIndex.lastGetTime])
    result[M.SeasonDataIndex.Exp] = expInfo

    local encryptedFreeRewardInfo = achieveSave[seasonIndex][M.SeasonDataIndex.FreeReward]
    local decryptedFreeRewardInfo = y3.gameApp:decryptString(encryptedFreeRewardInfo)
    local freeRewardParams = string.split(decryptedFreeRewardInfo, "#")
    assert(freeRewardParams and #freeRewardParams > 0, "free reward info error")
    result[M.SeasonDataIndex.FreeReward] = {}
    for index, value in ipairs(freeRewardParams) do
        result[M.SeasonDataIndex.FreeReward][index] = tonumber(value)
    end

    local encryptedAdvancedRewardInfo = achieveSave[seasonIndex][M.SeasonDataIndex.AdvancedReward]
    local decryptedAdvancedRewardInfo = y3.gameApp:decryptString(encryptedAdvancedRewardInfo)
    local advancedRewardParams = string.split(decryptedAdvancedRewardInfo, "#")
    assert(advancedRewardParams and #advancedRewardParams > 0, "first charge reward info error")
    result[M.SeasonDataIndex.AdvancedReward] = {}
    for index, value in ipairs(advancedRewardParams) do
        result[M.SeasonDataIndex.AdvancedReward][index] = tonumber(value)
    end

    local encryptedUltimateRewardInfo = achieveSave[seasonIndex][M.SeasonDataIndex.UltimateReward]
    local decryptedUltimateRewardInfo = y3.gameApp:decryptString(encryptedUltimateRewardInfo)
    local ultimateRewardParams = string.split(decryptedUltimateRewardInfo, "#")
    assert(ultimateRewardParams and #ultimateRewardParams > 0, "second charge reward info error")
    result[M.SeasonDataIndex.UltimateReward] = {}
    for index, value in ipairs(ultimateRewardParams) do
        result[M.SeasonDataIndex.UltimateReward][index] = tonumber(value)
    end

    local specialRewardStr = achieveSave[seasonIndex][M.SeasonDataIndex.SpecialReward]
    local specialRewardSign = specialRewardStr and y3.gameApp:decryptString(specialRewardStr) or M.RewardReceiveStatus.Havent
    result[M.SeasonDataIndex.SpecialReward] = tonumber(specialRewardSign)

    return result
end

function M:getCurLvAndExp(seasonIndex, curTotalExp)
    local battlepassCfg = include("gameplay.config.game_battlepass")
    assert(battlepassCfg, "battlePass cfg error")

    local lv = 0
    local nextLv = 0
    local curExp = curTotalExp
    local length = battlepassCfg.length()
    local seasonMaxLv = 0
    local curLvMaxExp = 0
    for index = 1, length, 1 do
        local cfgInfo = battlepassCfg.indexOf(index)
        assert(cfgInfo, "")

        if cfgInfo.game_season == seasonIndex then
            if curExp >= cfgInfo.game_battlepass_exp then
                lv = cfgInfo.game_battlepass_level
                nextLv = lv + 1
                curExp = curExp - cfgInfo.game_battlepass_exp
            elseif lv == 0 then
                curLvMaxExp = cfgInfo.game_battlepass_exp
                break
            elseif cfgInfo.game_battlepass_level == nextLv then
                curLvMaxExp = cfgInfo.game_battlepass_exp
            end
            seasonMaxLv = cfgInfo.game_battlepass_level
        end
    end
    lv = lv > seasonMaxLv and seasonMaxLv or lv

    return lv, curExp, curLvMaxExp
end

GM_IsUnlockAdvanceReward = false
function M:isUnlockAdvanceReward(playerId, seasonIndex)
    if GM_IsUnlockAdvanceReward then
        return true
    end

    local playerData = y3.userData:getPlayerData(playerId)
    local player = playerData:getPlayer()
    local itemId = 0
    if 1 == seasonIndex then
        itemId = y3.SurviveConst.PLATFORM_ITEM_MAP.S1_BP_ADVANCED
    end
    local isUnlockAdvanceReward = player:get_store_item_number(itemId) > 0
    --log.debug("isUnlockAdvanceReward  " .. tostring(player) .. " result " .. tostring(isUnlockAdvanceReward))
    return isUnlockAdvanceReward
end

GM_IsUnlockUltimateReward = false
function M:isUnlockUltimateReward(seasonIndex)
    if GM_IsUnlockUltimateReward then
        return true
    end

    local playerId = y3.gameApp:getMyPlayerId()
    local player = y3.player(playerId)
    local itemId = 0
    if 1 == seasonIndex then
        itemId = y3.SurviveConst.PLATFORM_ITEM_MAP.S1_BP_ULTIMATE
    end
    local isUnlockUltimateReward = player:get_store_item_number(itemId) > 0
    return isUnlockUltimateReward
end

function M:initBattlePassAttr()
    local attrPackList = self:getActivedAttrList()
    y3.SyncMgr:sync(y3.SyncConst.SYNC_ATTR_PACK_LIST, { attrPackList = attrPackList })
end

function M:getActivedAttrList()
    local attrPackList = {}

    local battlepassActivityCfg = include("gameplay.config.game_acitivity")
    assert(battlepassActivityCfg, "battlepass activity cfg error")
    local battlepassCfg = include("gameplay.config.game_battlepass")
    assert(battlepassCfg, "bp cfg error")

    local saveItemLogic = y3.gameApp:getLevel():getLogic("SurviveGameSaveItem")
    local playerId = y3.gameApp:getMyPlayerId()

    local seasonArchiveData = {}
    local bpActivityType = 1
    local seasonInfo = {}    
    local activityCfgLength = battlepassActivityCfg.length()
    for i = 1, activityCfgLength, 1 do
        while true do
            local activityCfgInfo = battlepassActivityCfg.indexOf(i)
            if not activityCfgInfo then
                break
            end
            if activityCfgInfo.game_activity_type ~= bpActivityType then
                break
            end

            local seasonIndex 
            local paramsList = string.split(activityCfgInfo.game_activity_args, "#")
            if paramsList and #paramsList >= 2 then
                seasonIndex = tonumber(paramsList[1])
            end

            if not seasonIndex then
                break
            end

            seasonInfo[seasonIndex] = {}
            seasonInfo[seasonIndex].expItemId = tonumber(paramsList[2])
            local isUnlockUltimateReward = self:isUnlockUltimateReward(seasonIndex)
            if not isUnlockUltimateReward then
                break
            end

            if not seasonArchiveData[seasonIndex] then
                seasonArchiveData[seasonIndex] = self:getSaveData(seasonIndex)
            end
            local archiveDetailInfo = seasonArchiveData[seasonIndex]
            if not archiveDetailInfo then
                break
            end

            if not archiveDetailInfo[M.SeasonDataIndex.SpecialReward] or 
                archiveDetailInfo[M.SeasonDataIndex.SpecialReward] == M.RewardReceiveStatus.Havent then
                break
            end

            local rewardParams = string.split(activityCfgInfo.game_activity_reward, "|")
            assert(rewardParams and #rewardParams >= 1, "special rewardParams error")

            for _, value in pairs(rewardParams) do
                local detailParams = string.split(value, "#")
                assert(detailParams and #detailParams > 0, "rewardParams error")

                local rewardType = tonumber(detailParams[1])
                assert(rewardParams and #rewardParams == 3, "rewardParams error")

                if rewardType == y3.SurviveConst.DROP_TYPE_ATTR_PACK then
                    table.insert(attrPackList, detailParams[2])
                end
            end
            break
        end
    end

    local bpCfgLength = battlepassCfg.length()
    for index = 1, bpCfgLength, 1 do
        while true do
            local cfgInfo = battlepassCfg.indexOf(index)
            if not cfgInfo then
                break
            end

            local seasonIndex = cfgInfo.game_season
            local expItemId = seasonInfo[seasonIndex].expItemId
            local totalExp = saveItemLogic:getSaveItemNum(playerId, expItemId)
            local curLv = self:getCurLvAndExp(seasonIndex, totalExp)
            if curLv < cfgInfo.game_battlepass_level then
                break
            end

            if not seasonArchiveData[seasonIndex] then
                seasonArchiveData[seasonIndex] = self:getSaveData(seasonIndex)
            end
            local archiveDetailInfo = seasonArchiveData[seasonIndex]
            if not archiveDetailInfo then
                break
            end

            local level = cfgInfo.game_battlepass_level
            local rewardParamsList = {}
            if seasonArchiveData[seasonIndex][M.SeasonDataIndex.FreeReward][level] == M.RewardReceiveStatus.Received then
                table.insert(rewardParamsList, cfgInfo.game_battlepass_basic_reward)
            end

            local isUnlockAdvanceReward = self:isUnlockAdvanceReward(playerId, seasonIndex)
            if isUnlockAdvanceReward and archiveDetailInfo[M.SeasonDataIndex.AdvancedReward][level] == M.RewardReceiveStatus.Received then                
                table.insert(rewardParamsList, cfgInfo.game_battlepass_privilege_reward)
            end
            local isUnlockUltimateReward = self:isUnlockUltimateReward(seasonIndex)
            if isUnlockUltimateReward and archiveDetailInfo[M.SeasonDataIndex.UltimateReward][level] == M.RewardReceiveStatus.Received then
                table.insert(rewardParamsList, cfgInfo.game_battlepass_gold_reward)
            end

            for _, rewardParams in pairs(rewardParamsList) do
                local detailParams = string.split(rewardParams, "#")
                assert(detailParams and #detailParams == 3, "invalid rewardParams params")

                local rewardType = tonumber(detailParams[1])
                if rewardType == y3.SurviveConst.DROP_TYPE_ATTR_PACK then
                    table.insert(attrPackList, detailParams[2])
                end
            end
            break
        end
    end

    return attrPackList
end

function M:existReciveableReward(seasonIndex)
    
    local battlepassActivityCfg = include("gameplay.config.game_acitivity")
    if not battlepassActivityCfg then
        return false
    end

    local activityInfo = battlepassActivityCfg.get(seasonIndex)
    if not activityInfo then
        return false
    end

    local expItemInfo = string.split(activityInfo.game_activity_args, "#")
    if not expItemInfo or #expItemInfo ~= 3 then
        return false
    end

    local perDayMaxGetableExp = tonumber(expItemInfo[3])
    if not perDayMaxGetableExp then
        return false
    end

    local archiveData = self._archiveData
    if not archiveData or not archiveData[seasonIndex] then
        return false
    end

    local encryptedExpInfo = archiveData[seasonIndex][M.SeasonDataIndex.Exp]
    local decryptedExpInfo = y3.gameApp:decryptString(encryptedExpInfo)
    local expParams = string.split(decryptedExpInfo, "#")
    if not expParams or #expParams ~= 2 then
        return false
    end
    
    local detailInfo = self:getSaveData(seasonIndex)
    if not detailInfo then
        return false
    end

    local saveItemLogic = y3.gameApp:getLevel():getLogic("SurviveGameSaveItem")
    local playerId = y3.gameApp:getMyPlayerId()
    local expItemId = tonumber(expItemInfo[2])
    local totalExp = saveItemLogic:getSaveItemNum(playerId, expItemId)
    local curLv = self:getCurLvAndExp(seasonIndex, totalExp)

    local battlepassCfg = include("gameplay.config.game_battlepass")
    if not battlepassCfg then
        return false
    end
    
    local isUnlockAdvanceReward = self:isUnlockAdvanceReward(playerId, seasonIndex)
    local isUnlockUltimateReward = self:isUnlockUltimateReward(seasonIndex)
    local length = battlepassCfg.length()
    for index = 1, length, 1 do
        while true do
            local cfgInfo = battlepassCfg.indexOf(index)
            if not cfgInfo or cfgInfo.game_season ~= seasonIndex then
                break
            end

            if curLv < cfgInfo.game_battlepass_level then
                break
            end

            local level = cfgInfo.game_battlepass_level
            if detailInfo[M.SeasonDataIndex.FreeReward][level] == M.RewardReceiveStatus.Havent then
                return true
            end
                
            if isUnlockAdvanceReward and detailInfo[M.SeasonDataIndex.AdvancedReward][level] == M.RewardReceiveStatus.Havent then
                return true
            end

            if isUnlockUltimateReward and detailInfo[M.SeasonDataIndex.UltimateReward][level] == M.RewardReceiveStatus.Havent then
                break
            end

            break
        end
    end

    if isUnlockUltimateReward then
        local specialRewardStr = archiveData[seasonIndex][M.SeasonDataIndex.SpecialReward]
        local specialRewardSign = specialRewardStr and y3.gameApp:decryptString(specialRewardStr) or M.RewardReceiveStatus.Havent
        specialRewardSign = tonumber(specialRewardSign)
        if specialRewardSign and specialRewardSign == M.RewardReceiveStatus.Havent then
            return true
        end
    end

    return false
end

return M
