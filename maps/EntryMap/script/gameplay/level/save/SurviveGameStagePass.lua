local GameUtils = require "gameplay.utils.GameUtils"
local LogicBase = include("gameplay.level.logic.LogicBase")
local SurviveGameStagePass = class("SurviveGameStagePass", LogicBase)

function SurviveGameStagePass:ctor(level)
    SurviveGameStagePass.super.ctor(self, level)
    self:_initData()
end

function SurviveGameStagePass:_initData()
    self._stagePass = y3.userData:loadTable("StagePass")
    local stage_config = include("gameplay.config.stage_config")
    local len = stage_config.length()
    self._stageMap = {}
    self._stageList = {}
    for i = 1, len do
        local cfg = stage_config.indexOf(i)
        assert(cfg, "")
        if not self._stageMap[cfg.stage_type] then
            self._stageMap[cfg.stage_type] = {}
        end
        if cfg.stage_type > 0 then
            table.insert(self._stageList, cfg)
        end
        table.insert(self._stageMap[cfg.stage_type], cfg)
    end
end

function SurviveGameStagePass:updateStagePass(playerId, stageId)
    if playerId ~= y3.gameApp:getMyPlayerId() then
        return
    end
    xpcall(function()
        local year, month, day = GameUtils.getCurrentDate()
        if not self._stagePass[stageId] then
            self._stagePass[stageId] = {}
        end
        if not self._stagePass[stageId].year then
            self._stagePass[stageId].year = year
        end
        if not self._stagePass[stageId].month then
            self._stagePass[stageId].month = month
        end
        if not self._stagePass[stageId].day then
            self._stagePass[stageId].day = day
        end
        if not self._stagePass[stageId].passCount then
            self._stagePass[stageId].passCount = 0
        end
        self._stagePass[stageId].passCount = self._stagePass[stageId].passCount + 1
        self:_refreshTodayPassCount(stageId)
    end, __G__TRACKBACK__)
end

function SurviveGameStagePass:_refreshTodayPassCount(stageId)
    local saveData = self._stagePass[stageId]
    local year, month, day = GameUtils.getCurrentDate()
    if saveData and saveData.year == year and saveData.month == month and saveData.day == day then
        if not saveData.todayPassCount then
            saveData.todayPassCount = 0
        end
        saveData.todayPassCount = saveData.todayPassCount + 1
    else
        saveData.year = year
        saveData.month = month
        saveData.day = day
        saveData.todayPassCount = 1
    end
end

function SurviveGameStagePass:getPassCount(playerId, stageId)
    local playerData = y3.userData:getPlayerData(playerId)
    local player = playerData:getPlayer()
    local stagePass = y3.userData:loadTableByPlayer(player, "StagePass")
    local saveData = stagePass[stageId] or {}
    return saveData.passCount or 0
end

function SurviveGameStagePass:getTodayPassCount(playerId, stageId)
    local playerData = y3.userData:getPlayerData(playerId)
    local player = playerData:getPlayer()
    local stagePass = y3.userData:loadTableByPlayer(player, "StagePass")
    local saveData = stagePass[stageId]
    local year, month, day = GameUtils.getCurrentDate()
    if saveData and saveData.year == year and saveData.month == month and saveData.day == day then
        return saveData.todayPassCount or 0
    else
        return 0
    end
end

function SurviveGameStagePass:getTodayPassCountAll(playerId)
    local playerData = y3.userData:getPlayerData(playerId)
    local player = playerData:getPlayer()
    local stagePass = y3.userData:loadTableByPlayer(player, "StagePass")
    local allCount = 0
    local year, month, day = GameUtils.getCurrentDate()
    for i = 1, #self._stageList do
        local stageId = self._stageList[i].id
        local saveData = stagePass[stageId]
        if saveData and saveData.year == year and saveData.month == month and saveData.day == day then
            allCount = allCount + (saveData.todayPassCount or 0)
        end
    end
    return allCount
end

function SurviveGameStagePass:getPassCountAll(playerId)
    local playerData = y3.userData:getPlayerData(playerId)
    local player = playerData:getPlayer()
    local stagePass = y3.userData:loadTableByPlayer(player, "StagePass")
    local allCount = 0
    for i = 1, #self._stageList do
        local stageId = self._stageList[i].id
        local saveData = stagePass[stageId] or {}
        allCount = allCount + (saveData.passCount or 0)
    end
    return allCount
end

function SurviveGameStagePass:stageIsUnLock(playerId, stageId)
    local stageCfg = include("gameplay.config.stage_config").get(stageId)
    if stageCfg then
        if stageCfg.stage_unlock_require <= 0 then
            return true
        end
        local passCount = self:getPassCount(playerId, stageCfg.stage_unlock_require)
        if passCount > 0 then
            return true
        end
    end
    return false
end

function SurviveGameStagePass:getStageIsUnLock(stageId)
    local allPlayers = y3.userData:getAllInPlayers()
    for i, playerData in ipairs(allPlayers) do
        local unLock = self:stageIsUnLock(playerData:getId(), stageId)
        if unLock then
            return true
        end
    end
    return false
end

function SurviveGameStagePass:getAllPlayerMaxUnlockStageId()
    local allPlayers = y3.userData:getAllInPlayers()
    local list = self._stageMap[1]
    local maxUnlockStageId = list[1].id
    for i, playerData in ipairs(allPlayers) do
        local unlockStageId = self:getMaxUnlockStageId(playerData:getId())
        if unlockStageId > maxUnlockStageId then
            return maxUnlockStageId
        end
    end
    return maxUnlockStageId
end

function SurviveGameStagePass:getMaxUnlockStageId(playerId)
    local list = self._stageMap[1]
    local maxUnlockStageId = list[1].id
    for i = 1, #list do
        if self:stageIsUnLock(playerId, list[i].id) then
            maxUnlockStageId = list[i].id
        else
            break
        end
    end
    return maxUnlockStageId
end

function SurviveGameStagePass:getMaxPassStageId(playerId)
    local list = self._stageMap[1]
    local maxPassStageId = list[1].id
    for i = 1, #list do
        if self:getPassCount(playerId, list[i].id) > 0 or list[i].stage_unlock_require <= 0 then
            maxPassStageId = list[i].id
        else
            break
        end
    end
    return maxPassStageId
end

return SurviveGameStagePass
