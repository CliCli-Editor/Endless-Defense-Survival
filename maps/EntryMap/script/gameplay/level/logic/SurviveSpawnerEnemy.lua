local GameUtils           = include "gameplay.utils.GameUtils"
local GlobalConfigHelper  = include "gameplay.level.logic.helper.GlobalConfigHelper"
local LogicBase           = include("gameplay.level.logic.LogicBase")
local SurviveSpawnerEnemy = class("SurviveSpawnerEnemy", LogicBase)
local SurviveHelper       = include("gameplay.level.logic.helper.SurviveHelper")

local MAX_SPAWN           = 1000
local SPAWN_RANGE         = GlobalConfigHelper.get(4)

local RADIUS_300          = 500
local RADIUS_600          = 900
local RADIUS_900          = 1350
local RADIUS_1200         = 1800

local AREA_KEY_300        = 300
local AREA_KEY_600        = 600
local AREA_KEY_900        = 900
local AREA_KEY_1200       = 1200

function SurviveSpawnerEnemy:ctor(level)
    SurviveSpawnerEnemy.super.ctor(self, level)
    y3.gameApp:addTimerLoop(1 / y3.GameConst.GAME_FPS, handler(self, self._onSpawnEnemy))
    self._totalDt          = 0
    self._monsterGroup     = {}
    self._areaMonster      = {}
    self._areaPlayer       = {}
    self._waveList         = {}
    self._stop             = false
    self._isWin            = false
    self._spawnInter       = y3.SurviveConst.REFRESH_INTER
    self._spawnParam       = {}
    self._curStage_phase   = 0
    self._maxStage_phase   = 0
    self._bossList         = {}
    self._playerFirePoints = {}
    self._stageDropMap     = {}
    self._addBuffList      = {}
    self._stopDropCoin     = false

    self._clearFrameCount  = 0
    self._clearFrameCount2 = 0
    self._cacheAreaMap     = {}

    self._playerFightBoss  = {}

    self._damageList       = {}

    self._deltaSpeed       = 1
    self._extraLoseDt      = 0

    self._spawnQueueList   = y3.luaQueue.new()

    self._selecter         = y3.selector.create()
    self._selecter:count(30)
    self._wanfenyi = math.random(1, 10000)
    self:_initCfg()
    self:_initArea()
    self:_initData()
    self._abyssChallenge = include("gameplay.level.logic.component.SurviveGameAbyssChallenge").new(self)
    self._goldChallenge = include("gameplay.level.logic.component.SurviveGameStageChallenge").new(self,
        y3.SurviveConst.STAGE_CHALLENGE_GOLD)
    self._diamondChallenge = include("gameplay.level.logic.component.SurviveGameStageChallenge").new(self,
        y3.SurviveConst.STAGE_CHALLENGE_DIAMOND)
    self._itemChallenge = include("gameplay.level.logic.component.SurviveGameStageChallenge").new(self,
        y3.SurviveConst.STAGE_CHALLENGE_ITEM)
end

function SurviveSpawnerEnemy:getStopDropCoin()
    return self._stopDropCoin
end

function SurviveSpawnerEnemy:getWanfenyi()
    return self._wanfenyi
end

function SurviveSpawnerEnemy:getTotalDt()
    return self._totalDt
end

function SurviveSpawnerEnemy:isWin()
    return self._isWin
end

function SurviveSpawnerEnemy:setWin(isWin)
    self._isWin = isWin
end

function SurviveSpawnerEnemy:getAbysChallenge()
    return self._abyssChallenge
end

function SurviveSpawnerEnemy:getDiamondChallenge()
    return self._diamondChallenge
end

function SurviveSpawnerEnemy:getGoldChallenge()
    return self._goldChallenge
end

function SurviveSpawnerEnemy:getItemChallenge()
    return self._itemChallenge
end

function SurviveSpawnerEnemy:getMonsterGroup(playerId)
    return self._monsterGroup[playerId]
end

function SurviveSpawnerEnemy:getAllMonsterNums()
    -- log.info("///////////////////////////////////")
    local totalMonsterNum = 0
    local allPlayers = y3.userData:getAllInPlayers()
    local playerNum = y3.userData:getPlayerCount()
    for _, playerData in ipairs(allPlayers) do
        local list = self._monsterGroup[playerData:getId()]
        -- log.info(#list)
        totalMonsterNum = totalMonsterNum + #list
    end
    totalMonsterNum = totalMonsterNum + #self._bossList
    -- log.info(#self._bossList)
    local limitNums = 0
    if self._extraLoseType and self._extraLoseType == 1 then
        limitNums = self._extraLoseArgs[playerNum]
    end
    return totalMonsterNum, limitNums
end

function SurviveSpawnerEnemy:getExtraLoseType()
    return self._extraLoseType or 0
end

function SurviveSpawnerEnemy:getTotalStageTime()
    return self._totalStageTime
end

function SurviveSpawnerEnemy:getCurStageTime()
    return self._curStageTime
end

function SurviveSpawnerEnemy:_initLoseExtraCondition()
    local lose_extra_condition = string.split(self._curModeCfg.lose_extra_condition, "|")
    assert(lose_extra_condition, "")
    self._extraLoseType = tonumber(lose_extra_condition[1])
    if lose_extra_condition[2] then
        local extraLoseArgs = string.split(lose_extra_condition[2], "#")
        assert(extraLoseArgs, "")
        self._extraLoseArgs = {}
        for i = 1, #extraLoseArgs do
            self._extraLoseArgs[i] = tonumber(extraLoseArgs[i])
        end
    end
end

function SurviveSpawnerEnemy:_initCfg()
    self._mutiNums = string.split(GlobalConfigHelper.get(12), "|")
    self._mutiHps = string.split(GlobalConfigHelper.get(13), "|")
    self._mutiAtks = string.split(GlobalConfigHelper.get(14), "|")
    SurviveHelper.initStageCfg()
    SurviveHelper.initMonsterTypePool()
    SurviveHelper.initWaveMonsterNumberPool()
    SurviveHelper.initMonsterModelPool()
    --------------------------------------------------------------------------
    self._curStageConfig = include("gameplay.config.stage_config").get(y3.userData:getCurStageId())
    self._curModeCfg = include("gameplay.config.stage_mode").get(self._curStageConfig.stage_type)
    local stage_wave_born_poins = string.split(self._curModeCfg.stage_wave_born_poins, "|")
    assert(stage_wave_born_poins, "")
    self._modeBornType = tonumber(stage_wave_born_poins[1])
    local modeBornArgs = string.split(stage_wave_born_poins[2], "#")
    assert(modeBornArgs, "")
    self._modeBornArgs = {}
    for i = 1, #modeBornArgs do
        self._modeBornArgs[i] = tonumber(modeBornArgs[i])
    end
    self:_initLoseExtraCondition()
    -------------------------------------------------------------------------------------------------
    local stage_phase_limit_times = string.split(self._curStageConfig.stage_phase_limit_time, "|")
    assert(stage_phase_limit_times, "")
    self._stagePhaseLimitTimes = {}
    for i = 1, #stage_phase_limit_times do
        local limitTime = tonumber(stage_phase_limit_times[i])
        if limitTime then
            self._stagePhaseLimitTimes[#self._stagePhaseLimitTimes + 1] = limitTime
        end
    end
    local stage_pass_extra_conditions = string.split(self._curStageConfig.stage_pass_extra_condition, "|")
    assert(stage_pass_extra_conditions, "")
    self._stagePassExtraConditions = {}
    for i = 1, #stage_pass_extra_conditions do
        local condition = tonumber(stage_pass_extra_conditions[i])
        if condition then
            self._stagePassExtraConditions[#self._stagePassExtraConditions + 1] = condition
        end
    end
    ---------------------------------------------------------------------
    self._noticeList        = {}
    self._stageWaveList     = {}
    self._fixStageWavelist  = {}
    self._dropStageWaveList = {}
    local waveList          = SurviveHelper.getStageWaveCfg(y3.userData:getCurStageId())
    local lastStagePhase    = 0
    self._stagePhaseTime    = {}
    self._totalStageTime    = 0
    self._curStageTime      = 0
    for i = 1, #waveList do
        local cfg = waveList[i]
        assert(cfg, "")
        local data = {}
        data.use = false
        data.cfg = waveList[i]

        if not self._stagePhaseTime[cfg.stage_phase] then
            self._stagePhaseTime[cfg.stage_phase] = cfg.event_time
        else
            if cfg.event_time > self._stagePhaseTime[cfg.stage_phase] then
                self._stagePhaseTime[cfg.stage_phase] = cfg.event_time
            end
        end
        if cfg.stage_phase > self._maxStage_phase then
            self._maxStage_phase = cfg.stage_phase
        end
        if lastStagePhase ~= cfg.stage_phase then
            local waveUIId = 100
            if cfg.stage_phase > 1 then
                waveUIId = 200
            end
            local waveUICfg = include("gameplay.config.stage_wave_ui").get(waveUIId)
            assert(waveUICfg, "")
            table.insert(self._noticeList,
                { stage_phase = cfg.stage_phase, cfg = waveUICfg, time = waveUICfg.time_offset, use = false })
        end
        lastStagePhase = cfg.stage_phase
        if cfg.show_on_progressBar ~= "" then
            local showParam = string.split(cfg.show_on_progressBar, "#")
            assert(showParam, "")
            local showId = tonumber(showParam[1])
            local waveUICfg = include("gameplay.config.stage_wave_ui").get(showId)
            assert(waveUICfg, "")
            table.insert(self._noticeList,
                { stage_phase = cfg.stage_phase, cfg = waveUICfg, time = cfg.event_time + waveUICfg.time_offset, use = false })
        end
        table.insert(self._stageWaveList, data)
        table.insert(self._fixStageWavelist, data)
        if cfg.weapon_exp ~= "" or cfg.item_reward ~= "" or cfg.enter_stage_phase_reward ~= "" or cfg.item_reward_fixed ~= "" then
            table.insert(self._dropStageWaveList, cfg)
        end
    end
    for i = 1, #self._stagePhaseTime do
        if i < self._curStageConfig.stage_challenge_stage_phase_id then
            self._totalStageTime = self._totalStageTime + self._stagePhaseTime[i]
        end
    end
    for i = 1, #self._stagePhaseTime do
        self._stagePhaseTime[i] = self._stagePhaseTime[i] + (self._stagePhaseTime[i - 1] or 0)
    end
    --------------------------------------------
    self._challengeList   = {}
    local stage_challange = include("gameplay.config.stage_challange")
    local len             = stage_challange.length()
    for i = 1, len do
        local cfg = stage_challange.indexOf(i)
        if cfg.stage_challenge_type == 1 then
            table.insert(self._challengeList, cfg)
        end
    end
    self._challengeLimitCount = GlobalConfigHelper.get(18)
    self._challengeSpawnTime  = GlobalConfigHelper.get(19)
    self._challengeData       = {}
    self._challengeDoing      = {}
    local allPlayers          = y3.userData:getAllInPlayers()
    for i, playerData in ipairs(allPlayers) do
        local param                              = {}
        param.curChallengeIndex                  = 0
        param.list                               = {}
        param.totalDt                            = 0
        self._challengeData[playerData:getId()]  = param
        self._challengeDoing[playerData:getId()] = {}
        self._stageDropMap[playerData:getId()]   = {}
    end
end

function SurviveSpawnerEnemy:_initData()
    local param = {}
    param.lastDt = 0
    param.totalDt = 0
    param.inter = 0
    self._spawnParam = param
    local allPlayers = y3.userData:getAllInPlayers()
    for i, playerData in ipairs(allPlayers) do
        if not self._monsterGroup[playerData:getId()] then
            self._monsterGroup[playerData:getId()] = {}
        end
    end
end

function SurviveSpawnerEnemy:clearPlayerEnemy(playerData)
    if self._monsterGroup[playerData:getId()] then
        for i, monster in ipairs(self._monsterGroup[playerData:getId()]) do
            monster:cleanup()
            monster:getUnit():remove()
        end
        self._monsterGroup[playerData:getId()] = {}
    end
end

function SurviveSpawnerEnemy:_initSignalArea(playerData)
    if not self._areaMonster[playerData:getId()] then
        self._areaMonster[playerData:getId()] = {}
    end
    if not self._areaPlayer[playerData:getId()] then
        self._areaPlayer[playerData:getId()] = {}
    end

    if self._areaPlayer[playerData:getId()][AREA_KEY_300] then
        self._areaPlayer[playerData:getId()][AREA_KEY_300]:remove()
    end
    if self._areaPlayer[playerData:getId()][AREA_KEY_600] then
        self._areaPlayer[playerData:getId()][AREA_KEY_600]:remove()
    end
    if self._areaPlayer[playerData:getId()][AREA_KEY_900] then
        self._areaPlayer[playerData:getId()][AREA_KEY_900]:remove()
    end
    if self._areaPlayer[playerData:getId()][AREA_KEY_1200] then
        self._areaPlayer[playerData:getId()][AREA_KEY_1200]:remove()
    end

    local mainActor = playerData:getMainActor()
    local point = mainActor:getUnit():get_point()
    local area300 = y3.area.create_circle_area(point, RADIUS_300)
    local area600 = y3.area.create_circle_area(point, RADIUS_600)
    local area900 = y3.area.create_circle_area(point, RADIUS_900)
    local area1200 = y3.area.create_circle_area(point, RADIUS_1200)

    self._areaMonster[playerData:getId()][AREA_KEY_300] = {}
    self._areaMonster[playerData:getId()][AREA_KEY_600] = {}
    self._areaMonster[playerData:getId()][AREA_KEY_900] = {}
    self._areaMonster[playerData:getId()][AREA_KEY_1200] = {}

    self._areaPlayer[playerData:getId()][AREA_KEY_300] = area300
    self._areaPlayer[playerData:getId()][AREA_KEY_600] = area600
    self._areaPlayer[playerData:getId()][AREA_KEY_900] = area900
    self._areaPlayer[playerData:getId()][AREA_KEY_1200] = area1200

    area300:event("区域-进入", function(trg, data)
        if data.unit:has_tag(y3.SurviveConst.STATE_ENEMY_TAG) then
            data.unit:add_tag(y3.SurviveConst.TAG_AREA_300)
        end
    end)
    area300:event("区域-离开", function(trg, data)
        data.unit:remove_tag(y3.SurviveConst.TAG_AREA_300)
    end)
    area600:event("区域-进入", function(trg, data)
        if data.unit:has_tag(y3.SurviveConst.STATE_ENEMY_TAG) then
            data.unit:add_tag(y3.SurviveConst.TAG_AREA_600)
        end
    end)
    area600:event("区域-离开", function(trg, data)
        data.unit:remove_tag(y3.SurviveConst.TAG_AREA_600)
    end)
    area900:event("区域-进入", function(trg, data)
        if data.unit:has_tag(y3.SurviveConst.STATE_ENEMY_TAG) then
            data.unit:add_tag(y3.SurviveConst.TAG_AREA_900)
        end
    end)
    area900:event("区域-离开", function(trg, data)
        data.unit:remove_tag(y3.SurviveConst.TAG_AREA_900)
    end)
    area1200:event("区域-进入", function(trg, data)
        if data.unit:has_tag(y3.SurviveConst.STATE_ENEMY_TAG) then
            data.unit:add_tag(y3.SurviveConst.TAG_AREA_1200)
        end
    end)
    area1200:event("区域-离开", function(trg, data)
        -- data.unit:remove_tag(y3.SurviveConst.TAG_AREA_1200)
    end)
end

function SurviveSpawnerEnemy:_initArea()
    local allPlayers = y3.userData:getAllInPlayers()
    for i, playerData in ipairs(allPlayers) do
        self:_initSignalArea(playerData)
    end
end

---comment
---@param unit Unit
---@param area Area
---@param player Player
---@return boolean
function SurviveSpawnerEnemy:unitIsInArea(unit, area, player)
    local unitGroup = area:get_unit_group_in_area(player)
    local list = unitGroup:pick()
    for i, sameAreaUnit in ipairs(list) do
        if sameAreaUnit:get_id() == unit:get_id() then
            return true
        end
    end
    return false
end

function SurviveSpawnerEnemy:_onAreanEnter(playerId, area, unit)
    if unit:has_tag(y3.SurviveConst.STATE_ENEMY_TAG) then
        -- log.info("SurviveSpawnerEnemy:_onAreanEnter", area, unit)
        -- local sameAreaList = self._areaMonster[playerId][area]
        -- sameAreaList[#sameAreaList + 1] = unit
    end
end

function SurviveSpawnerEnemy:_onAreanExit(playerId, area, unit)
    if unit:has_tag(y3.SurviveConst.STATE_ENEMY_TAG) then
        -- log.info("SurviveSpawnerEnemy:_onAreanExit", area, unit)
        -- local sameAreaList = self._areaMonster[playerId][area]
        -- for i, sameAreaUnit in ipairs(sameAreaList) do
        --     if sameAreaUnit:get_id() == unit:get_id() then
        --         table.remove(sameAreaList, i)
        --         break
        --     end
        -- end
    end
end

function SurviveSpawnerEnemy:doDamageList()
    -- for i = 1, 10 do
    --     if self._damageList and #self._damageList > 0 then
    --         local params = table.remove(self._damageList, #self._damageList)
    --         y3.surviveHelper.calculateDamageReal(params)
    --     else
    --         break
    --     end
    -- end
end

function SurviveSpawnerEnemy:insertDamageList(params)
    -- self._damageList = self._damageList or {}
    -- table.insert(self._damageList, params)
end

function SurviveSpawnerEnemy:setSpawnerStop(stop)
    self._stop = stop
end

function SurviveSpawnerEnemy:_onSpawnEnemy(delay)
    if not self._level:isGameStart() then
        return
    end
    self:doDamageList()
    local delta = delay:float() * self._deltaSpeed
    self._totalDt = self._totalDt + delta
    self:_onCacheArean()
    if self._stop then
        return
    end
    if self._curStage_phase == 0 then
        self:_goNextStagePhase()
    end
    if self._totalDt >= 2 then
        if self._noticeList[1].use == false then
            self._noticeList[1].use = true
            y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SURVIVE_NOTICE_SHOW, self._noticeList[1].cfg.id)
        end
    end
    local gameStatus = self._level:getLogic("SurviveGameStatus")
    if not gameStatus:isInBattle() then
        return
    end
    self:_checkStageFailed(delta)
    self:_onRealSpawnEnemy(delta)
    self:_onStageTime(delta)
    self:_checkStageWin(delta)
end

function SurviveSpawnerEnemy:setSpawnDeltaSpeed(speed)
    self._deltaSpeed = speed
end

function SurviveSpawnerEnemy:_onCacheArean()
    self._clearFrameCount = self._clearFrameCount + 1
    if self._clearFrameCount >= 2 then
        self._clearFrameCount = 0
        self._cacheAreaMap = {}
    end
    -- self._clearFrameCount2 = self._clearFrameCount2 + 1
    -- if self._clearFrameCount2 >= 5 then
    --     self._clearFrameCount2 = 0
    --     self._unitRecordDamageMap = {}
    -- end
end

function SurviveSpawnerEnemy:_onStageTime(delta)
    local limitTime = self._stagePhaseTime[self._curStage_phase] or self._stagePhaseTime[self._maxStage_phase]
    self._curStageTime = math.min(limitTime, self._curStageTime + delta)
end

function SurviveSpawnerEnemy:gameResult(playerId)
    y3.Sugar.achievement():updateAchievement(playerId, y3.SurviveConst.ACHIEVEMENT_REFRESH_TYPE_PLAYED)
    y3.gameApp:addTimer(0.5, function()
        y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SURVEVE_RESULT_WIN, playerId)
        y3.game.end_player_game(y3.player(playerId), y3.GameConst.VICTORY, true)
    end)
    local playerData = y3.userData:getPlayerData(playerId)
    playerData:setEndFlag(true)
end

function SurviveSpawnerEnemy:_checkStageWin(delta)
    local isWin = true
    if self._curStage_phase == 0 then
        isWin = false
    end
    if self._curStage_phase <= self._maxStage_phase then
        isWin = false
    end
    if isWin then
        self._stop = true
        y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SURVIVE_REFRESH_DPS)
        local allInPlayers = y3.userData:getAllInPlayers()
        for _, playerData in ipairs(allInPlayers) do
            y3.Sugar.achievement():updateAchievement(playerData:getId(),
                y3.SurviveConst.ACHIEVEMENT_REFRESH_TYPE_PLAYED)
            y3.Sugar.localNotice(playerData:getId(), 28, {})
        end
        local endDelayTime = GlobalConfigHelper.get(59)
        y3.gameApp:addTimer(endDelayTime, function()
            y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SURVEVE_RESULT_WIN, y3.gameApp:getMyPlayerId())
            y3.game.end_player_game(y3.player(y3.gameApp:getMyPlayerId()), y3.GameConst.VICTORY, true)
        end)
    end
end

function SurviveSpawnerEnemy:_checkExtraFailedCondition(delta)
    if not self._extraLoseType then
        return false
    end
    local isRet = false
    if self._extraLoseType == 1 then
        local playerNum = y3.userData:getPlayerCount()
        local limitTime = self._extraLoseArgs[5]
        local limitNums = self._extraLoseArgs[playerNum]
        local allPlayers = y3.userData:getAllInPlayers()
        local totalMonsterNum = 0
        for _, playerData in ipairs(allPlayers) do
            local list = self._monsterGroup[playerData:getId()]
            totalMonsterNum = totalMonsterNum + #list
        end
        totalMonsterNum = totalMonsterNum + #self._bossList
        if totalMonsterNum >= limitNums then
            if self._extraLoseDt == 0 then
                y3.Sugar.NoticeAll(54, { sec = limitTime })
            end
            local lastDt = self._extraLoseDt
            self._extraLoseDt = self._extraLoseDt + delta
            if lastDt < math.floor(self._extraLoseDt) and self._extraLoseDt >= math.floor(self._extraLoseDt) then
                y3.Sugar.NoticeAll(54, { sec = limitTime - math.floor(self._extraLoseDt) })
            end
            if self._extraLoseDt >= limitTime then
                isRet = true
            end
        else
            self._extraLoseDt = 0
        end
    end
    return isRet
end

function SurviveSpawnerEnemy:_checkStageFailed(delta)
    local isFailed = true
    local allPlayers = y3.userData:getAllInPlayers()
    for i, playerData in ipairs(allPlayers) do
        if not playerData:getIsFailed() then
            isFailed = false
        end
    end
    if self:_checkExtraFailedCondition(delta) then
        isFailed = true
    end
    if isFailed then
        self._stop = true
        y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SURVIVE_REFRESH_DPS)
        local allInPlayers = y3.userData:getAllInPlayers()
        for _, playerData in ipairs(allInPlayers) do
            if not self._isWin then
                y3.Sugar.localNotice(playerData:getId(), 27, {})
            end
            y3.Sugar.achievement():updateAchievement(playerData:getId(),
                y3.SurviveConst.ACHIEVEMENT_REFRESH_TYPE_PLAYED)
        end
        local endDelayTime = GlobalConfigHelper.get(59)
        y3.gameApp:addTimer(endDelayTime, function()
            y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SURVEVE_RESULT_FAIL, y3.gameApp:getMyPlayerId())
            y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SURVEVE_RESULT_WIN, y3.gameApp:getMyPlayerId())
            y3.game.end_player_game(y3.player(y3.gameApp:getMyPlayerId()),
                self._isWin and y3.GameConst.VICTORY or y3.GameConst.DEFEAT, true)
            if not self._isWin then
                y3.userDataHelper.uploadTrackingDataLose(y3.gameApp:getMyPlayerId())
            end
        end)
    end
end

function SurviveSpawnerEnemy:_checkAddBuffList()
    if self._addBuffList and #self._addBuffList > 0 then
        local count = 0
        for i = #self._addBuffList, 1, -1 do
            local monster = self._addBuffList[i].monster
            local buffId = self._addBuffList[i].buffId
            if monster then
                monster:addBuff(buffId)
            end
            table.remove(self._addBuffList, i)
            count = count + 1
            if count > 5 then
                break
            end
        end
    end
end

function SurviveSpawnerEnemy:_checkSpawnQueueList()
    if not y3.luaQueue.isEmpty(self._spawnQueueList) then
        -- log.info("SurviveSpawnerEnemy:_checkSpawnQueueList")
        local param = y3.luaQueue.popFront(self._spawnQueueList)
        local monster = self:_spawnSingleEnemy(param.monsterCfg, param.points, param.playerData, param.stageCfg,
            param.isBoss)
        if param.isBoss then
            local allPlayers = y3.userData:getAllInPlayers()
            self:_monsterDrop(param.waveData, { monster }, allPlayers[1]:getId())
            for _, playerData in ipairs(allPlayers) do
                self:_addPlayerStageDropMonsters(playerData, param.stageCfg, { monster })
            end
        else
            self:_dropMonsterList(param.waveData, { monster }, param.playerData, param.stageCfg)
        end
    end
end

function SurviveSpawnerEnemy:_onRealSpawnEnemy(delay)
    self:_checkSpawnQueueList()
    self:_checkNextStageWave(delay)
    self:_doWaveLogic(delay)
    self:_checkAddBuffList()
    self._goldChallenge:doChallengeLogic(delay)
    self._abyssChallenge:doChallenge(delay)
    self._diamondChallenge:doChallengeLogic(delay)
    self._itemChallenge:doChallengeLogic(delay)
    self:_doFirePoints(delay)
    self:_checkEnterNextStage()
    self:_checkPlayerStageDrop()
end

function SurviveSpawnerEnemy:_doFirePoints(delay)
    local allPlayers = y3.userData:getAllInPlayers()
    for i, playerData in ipairs(allPlayers) do
        local fireParam = self._playerFirePoints[playerData:getId()]
        if fireParam then
            fireParam.time = fireParam.time - delay
            if fireParam.time <= 0 then
                y3.eca.call("结束集火", playerData:getPlayer())
                self._playerFirePoints[playerData:getId()] = nil
            end
            local list = fireParam.list or {}
            local allDie = true
            for i, fireUnit in ipairs(list) do
                if y3.class.isValid(fireUnit) and fireUnit:is_alive() then
                    allDie = false
                    break
                end
            end
            if allDie then
                y3.eca.call("结束集火", playerData:getPlayer())
                self._playerFirePoints[playerData:getId()] = nil
            end
        end
    end
end

function SurviveSpawnerEnemy:_goNextStagePhase()
    if self._curStage_phase == self._curStageConfig.stage_clear_stage_phase_id then
        self._isWin        = true
        local allInPlayers = y3.userData:getAllInPlayers()
        for _, playerData in ipairs(allInPlayers) do
            y3.Sugar.stagePass(playerData:getId(), y3.userData:getCurStageId())
            y3.Sugar.achievement():updateAchievement(playerData:getId(),
                y3.SurviveConst.ACHIEVEMENT_REFRESH_TYPE_PASS)
        end
        y3.userDataHelper.uploadTrackingDataWin(y3.gameApp:getMyPlayerId())
    end
    self._curStageTime = self._stagePhaseTime[self._curStage_phase] or 0
    self._curStage_phase = self._curStage_phase + 1
    self._spawnParam.totalDt = 0
    self._spawnParam.lastDt = 0
    y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SURVIVE_STAGE_CHANGE)
end

function SurviveSpawnerEnemy:getSpawnParamTotalDt()
    return self._spawnParam.totalDt
end

function SurviveSpawnerEnemy:getCurStage_phase()
    return self._curStage_phase
end

function SurviveSpawnerEnemy:_checkEnterNextStage()
    if self._curStage_phase == 0 then
        self:_goNextStagePhase()
        return
    end
    ------------------------阶段结束-------------------------------
    local isStageEnd = true
    for i = 1, #self._stageWaveList do
        if self._stageWaveList[i].cfg.stage_phase == self._curStage_phase then
            local cfg = self._stageWaveList[i].cfg
            if cfg.event_type == 4 then
            else
                if not self._stageWaveList[i].use then
                    isStageEnd = false
                    break
                end
            end
        end
    end
    if isStageEnd then
        for i = 1, #self._stageWaveList do
            if self._stageWaveList[i].cfg.stage_phase == self._curStage_phase then
                self._stageWaveList[i].use = true
            end
        end
    end
    --------------------------波次结束---------------------------
    local isWaveEnd = true
    for i = 1, #self._waveList do
        if not self._waveList[i].use then
            isWaveEnd = false
            break
        end
    end
    ---------------------------怪物死亡---------------------------------
    local isNoMonster = true
    local anyNoMonster = false
    local allPlayers = y3.userData:getAllInPlayers()
    local isAllFailed = true
    local allAlive = true
    local monsterCount = 0
    for i, playerData in ipairs(allPlayers) do
        if not playerData:getIsFailed() then
            isAllFailed = false
            local list = self._monsterGroup[playerData:getId()]
            if #list > 0 then
                monsterCount = monsterCount + #list
                isNoMonster = false
            else
                anyNoMonster = true
            end
        else
            allAlive = false
        end
    end
    if #self._bossList > 0 then
        monsterCount = monsterCount + #self._bossList
        isNoMonster = false
        anyNoMonster = false
    end
    -------------------------------时间限制-------------------------------
    if self._stagePhaseLimitTimes[self._curStage_phase] then
        local limitTime = self._stagePhaseLimitTimes[self._curStage_phase]
        if self._spawnParam.totalDt >= limitTime then
            local condition = self._stagePassExtraConditions[self._curStage_phase] or 0
            if condition == y3.SurviveConst.STAGE_CONDITION_ANY_ONE then
                if isStageEnd and isWaveEnd and anyNoMonster then
                    isNoMonster = true
                    for i, playerData in ipairs(allPlayers) do
                        self:clearPlayerEnemy(playerData)
                    end
                else
                    isAllFailed = true
                    for i, playerData in ipairs(allPlayers) do
                        playerData:setIsFailed(true)
                    end
                end
            elseif condition == y3.SurviveConst.STAGE_CONDITION_ALL then
                if isStageEnd and isWaveEnd and isNoMonster and allAlive then
                    isNoMonster = true
                else
                    isAllFailed = true
                    for i, playerData in ipairs(allPlayers) do
                        playerData:setIsFailed(true)
                    end
                end
            end
        end
    end
    -- log.info("怪物数量", monsterCount)
    -------------------------------------最终判断--------------------------------------------
    -- print("isStageEnd", isStageEnd, "isWaveEnd", isWaveEnd, "isNoMonster", isNoMonster, "isAllFailed", isAllFailed)
    if isStageEnd and isWaveEnd and isNoMonster and (not isAllFailed) then
        self:_goNextStagePhase()
    end
end

function SurviveSpawnerEnemy:getRandomTypePoolGroups(stageCfg)
    local randList = {}
    local random_type_monster_pool_groups = string.split(stageCfg.random_type_monster_pool_group, "|")
    assert(random_type_monster_pool_groups, "random_type_monster_pool_groups is error")
    for i = 1, #random_type_monster_pool_groups do
        local pools = string.split(random_type_monster_pool_groups[i], "#")
        if #pools == 2 then
            local poolId = tonumber(pools[1])
            local weight = tonumber(pools[2])
            local randData = {}
            randData.poolId = poolId
            randData.weight = weight
            table.insert(randList, randData)
        end
    end
    local randData = nil
    if #randList > 0 then
        randData = SurviveHelper.getRandomDataByWeightList(randList)
    end
    return randData
end

function SurviveSpawnerEnemy:_checkFirstWave()

end

function SurviveSpawnerEnemy:_checkNextStageWave(delay)
    local waveList = self._waveList
    local param = self._spawnParam
    param.totalDt = param.totalDt + delay
    for i = 1, #self._stageWaveList do
        local stageData = self._stageWaveList[i]
        if not stageData.use then
            if self._curStage_phase ~= stageData.cfg.stage_phase then
                break
            end
            -- self._curStage_phase = stageData.cfg.stage_phase
            local stageCfg = stageData.cfg
            if param.totalDt >= stageCfg.event_time and param.lastDt < stageCfg.event_time then
                if i == 1 then
                    self:_checkFirstWave()
                end
                if stageCfg.event_type == 1 then
                    y3.eca.call('波次刷怪')
                end
                y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SURVIVE_STAGE_EVENT_WAVE, stageCfg.stage_wave_number)

                stageData.use = true
                local randData = self:getRandomTypePoolGroups(stageCfg)
                local limitNum, itemRandList = y3.userDataHelper.getStageWaveMonsterDrop(stageCfg)
                local ranData = SurviveHelper.getRandomDataByWeightList(itemRandList)
                table.insert(waveList, {
                    stageCfg = stageCfg,
                    curCount = 0,
                    poolId = randData and randData.poolId or 0,
                    curEventDt = stageCfg
                        .generate_interval,
                    use = false,
                    monsterDropNum = limitNum,
                    monsterDropItem = ranData,
                    monsterDropFlag = {}
                })
                local allPlayers = y3.userData:getAllInPlayers()
                for i, playerData in ipairs(allPlayers) do
                    if stageCfg.stage_notice_id > 0 then
                        y3.Sugar.localNotice(playerData:getId(), stageCfg.stage_notice_id, { sec = -1 })
                    end
                    if not playerData:getIsFailed() then
                        self:_spawnRegularWaveMonster(playerData, stageCfg)
                    end
                end
            end
        end
    end
    for i = 1, #self._stageWaveList do
        if self._stageWaveList[i].use then
            table.remove(self._stageWaveList, i)
            break
        end
    end
    for i = 1, #self._noticeList do
        local noticeData = self._noticeList[i]
        if not noticeData.use then
            -- print(noticeData.time)
            if param.totalDt >= noticeData.time and noticeData.stage_phase == self._curStage_phase then
                -- log.info("noticeData.time", noticeData.time, "param.totalDt", param.totalDt)
                noticeData.use = true
                y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SURVIVE_NOTICE_SHOW, noticeData.cfg.id)
            end
        end
    end
    param.lastDt = param.totalDt
end

function SurviveSpawnerEnemy:_stageWaveDrop(playerData, cfg, allPlayerKill)
    if cfg.enter_stage_phase_reward ~= "" then
        if allPlayerKill then
            self:_stageDropSelectReward(playerData, cfg)
        end
    end
    if cfg.item_reward_fixed ~= "" then
        self:_stageDropItemRewardFixed(playerData, cfg.item_reward_fixed)
    end
    if cfg.weapon_exp ~= "" or cfg.item_reward ~= "" then
        local weaponSave = y3.gameApp:getLevel():getLogic("SurviveGameWeaponSave")
        local weapon_exp = string.split(cfg.weapon_exp, "|")
        assert(weapon_exp, "")
        local item_rewards = string.split(cfg.item_reward, "|")
        assert(item_rewards, "")
        local ranList = {}
        for _, itemReward in ipairs(item_rewards) do
            local param = string.split(itemReward, "#")
            assert(param, "")
            local data = {}
            data.rewardStr = itemReward
            data.weight = tonumber(param[4])
            table.insert(ranList, data)
        end
        -- for _, playerData in ipairs(allPlayers) do
        local mainActor = playerData:getMainActor()
        local list = mainActor:getAbilityCanUp()
        GameUtils.shuffleArray(list)
        if cfg.weapon_exp ~= "" then
            for i = 1, 3 do
                local params = string.split(weapon_exp[i], "#")
                assert(params, "")
                local min = tonumber(params[1])
                local max = tonumber(params[2])
                local skillKey = list[i]
                if skillKey then
                    local exp = math.random(min, max)
                    local player = playerData:getPlayer()
                    if y3.userDataHelper.has_store_item(player, y3.SurviveConst.PLATFORM_ITEM_MAP.BAIYINTEQUAN) then
                        exp = math.floor(exp + exp * 0.5)
                    end
                    weaponSave:dropWeaponExp(playerData:getId(), skillKey, exp)
                end
            end
        end
        if cfg.item_reward ~= "" then
            local randData = SurviveHelper.getRandomDataByWeightList(ranList)
            local player = playerData:getPlayer()
            if y3.userDataHelper.has_store_item(player, y3.SurviveConst.PLATFORM_ITEM_MAP.BAIYINTEQUAN) then
                y3.userDataHelper.dropSaveItem(playerData:getId(), randData.rewardStr, 0.5)
            else
                y3.userDataHelper.dropSaveItem(playerData:getId(), randData.rewardStr)
            end
        end
    end
end

function SurviveSpawnerEnemy:_stageDropItemRewardFixed(playerData, item_reward_fixed)
    local itemrewards = string.split(item_reward_fixed, "|")
    assert(itemrewards, "")
    for _, itemreward in ipairs(itemrewards) do
        if itemreward ~= "" then
            y3.userDataHelper.dropSaveItem(playerData:getId(), itemreward)
        end
    end
end

function SurviveSpawnerEnemy:_stageDropSelectReward(playerData, stageCfg)
    if stageCfg.enter_stage_phase_reward == "" then
        return
    end
    log.info("SurviveSpawnerEnemy:_stageDropSelectReward", stageCfg.enter_stage_phase_reward)
    local enter_stage_phase_reward = string.split(stageCfg.enter_stage_phase_reward, "|")
    assert(enter_stage_phase_reward, "")
    local recordType = tonumber(enter_stage_phase_reward[1])
    if recordType == y3.SurviveConst.SELECT_REWARD_TASK then
        local recordList = {}
        for i = 2, #enter_stage_phase_reward do
            local poolId = tonumber(enter_stage_phase_reward[i])
            local refreshSkill = y3.gameApp:getLevel():getLogic("SurviveRefreshSkill")
            local randItem = refreshSkill:getRandomItemByPoolId(poolId)
            table.insert(recordList, randItem)
        end
        self._abyssChallenge:insertChallengeRecordData(playerData:getId(), recordList,
            recordType, true)
    else
        local randList = {}
        for i = 2, #enter_stage_phase_reward do
            local params = string.split(enter_stage_phase_reward[i], "#")
            assert(params, "")
            local data = {}
            data.random_poolId = tonumber(params[1])
            data.weight = tonumber(params[2])
            table.insert(randList, data)
        end
        local ranData1 = SurviveHelper.getRandomDataByWeightList(randList)
        for i = 1, #randList do
            if randList[i].random_poolId == ranData1.random_poolId then
                table.remove(randList, i)
                break
            end
        end
        local ranData2 = SurviveHelper.getRandomDataByWeightList(randList)
        for i = 1, #randList do
            if randList[i].random_poolId == ranData2.random_poolId then
                table.remove(randList, i)
                break
            end
        end
        local ranData3 = SurviveHelper.getRandomDataByWeightList(randList)
        local refreshSkill = y3.gameApp:getLevel():getLogic("SurviveRefreshSkill")
        local randItem1 = refreshSkill:getRandomItemByPoolId(ranData1.random_poolId)
        local randItem2 = refreshSkill:getRandomItemByPoolId(ranData2.random_poolId)
        local randItem3 = refreshSkill:getRandomItemByPoolId(ranData3.random_poolId)
        self._abyssChallenge:insertChallengeRecordData(playerData:getId(), { randItem1, randItem2, randItem3 },
            recordType)
    end
end

function SurviveSpawnerEnemy:_addPlayerStageDropMonsters(playerData, stageCfg, monsterList)
    if stageCfg.weapon_exp ~= "" or
        stageCfg.item_reward ~= "" or
        stageCfg.enter_stage_phase_reward ~= "" or
        stageCfg.item_reward_fixed ~= "" then
        local dropMap = self._stageDropMap[playerData:getId()]
        if not dropMap[stageCfg.id] then
            dropMap[stageCfg.id] = {
                start = false,
                monsterList = monsterList,
            }
        else
            for i = 1, #monsterList do
                table.insert(dropMap[stageCfg.id].monsterList, monsterList[i])
            end
        end
    end
end

function SurviveSpawnerEnemy:_startPlayerStageDropCheck(stageCfg)
    local allPlayers = y3.userData:getAllInPlayers()
    for i, playerData in ipairs(allPlayers) do
        local dropMap = self._stageDropMap[playerData:getId()]
        if dropMap[stageCfg.id] then
            dropMap[stageCfg.id].start = true
        end
    end
end

function SurviveSpawnerEnemy:_checkPlayerStageDrop()
    local allPlayers = y3.userData:getAllInPlayers()
    for i, playerData in ipairs(allPlayers) do
        local dropMap = self._stageDropMap[playerData:getId()]
        for i = 1, #self._dropStageWaveList do
            local cfg = self._dropStageWaveList[i]
            local dropData = dropMap[cfg.id]
            if dropData and dropData.start == true then
                if dropData.monsterList and #dropData.monsterList > 0 then
                    local allDie = true
                    local allPlayerKill = true
                    for i, monster in ipairs(dropData.monsterList) do
                        if not monster:isDie() then
                            allDie = false
                        end
                        if not monster:IsPlayerKill() then
                            allPlayerKill = false
                        end
                    end
                    if allDie then
                        self:_stageWaveDrop(playerData, cfg, allPlayerKill)
                        dropMap[cfg.id] = nil
                    end
                end
            end
        end
    end
end

function SurviveSpawnerEnemy:_doWaveLogic(delay)
    local waveList = self._waveList
    for i = 1, #waveList do
        local waveData = waveList[i]
        if not waveData.use then
            local stageCfg = waveData.stageCfg
            if stageCfg then
                if stageCfg.event_type == y3.SurviveConst.STAGE_WAVE_EVENT_NORMAL then
                    self:_doStageNormalWaveLogic(waveData, stageCfg, delay)
                elseif stageCfg.event_type == y3.SurviveConst.STAGE_WAVE_EVENT_COMMOND then
                    self:_doCommondWaveLogic(waveData, stageCfg.event_args)
                elseif stageCfg.event_type == y3.SurviveConst.STAGE_WAVE_EVENT_BOSS then
                    self:_doStageCenterWaveLogic(waveData, stageCfg, delay)
                else
                    waveData.use = true
                end
            end
        end
    end
    for i = 1, #self._waveList do
        if self._waveList[i].use then
            table.remove(self._waveList, i)
            break
        end
    end
end

function SurviveSpawnerEnemy:_dropMonsterList(waveData, monsterList, playerData, stageCfg)
    self:_monsterDrop(waveData, monsterList, playerData:getId())
    self:_addPlayerStageDropMonsters(playerData, stageCfg, monsterList)
end

function SurviveSpawnerEnemy:_doStageNormalWaveLogic(waveData, stageCfg, delay)
    waveData.curEventDt = waveData.curEventDt + delay
    if waveData.curCount >= stageCfg.generate_times then
        waveData.use = true
    end
    if waveData.curEventDt >= stageCfg.generate_interval and waveData.curCount < stageCfg.generate_times then
        waveData.curEventDt = 0
        waveData.curCount = waveData.curCount + 1

        local allPlayers = y3.userData:getAllInPlayers()
        for i, playerData in ipairs(allPlayers) do
            if not playerData:getIsFailed() then
                local monsterList = self:_spawnRealEenmy(playerData, stageCfg, waveData)
                self:_dropMonsterList(waveData, monsterList, playerData, stageCfg)
            end
        end
        if waveData.curCount >= stageCfg.generate_times then
            self:_startPlayerStageDropCheck(stageCfg)
            waveData.use = true
        end
    end
end

function SurviveSpawnerEnemy:_doStageCenterWaveLogic(waveData, stageCfg, delay)
    waveData.curEventDt = waveData.curEventDt + delay
    if waveData.curCount >= stageCfg.generate_times then
        waveData.use = true
    end
    if waveData.curEventDt >= stageCfg.generate_interval and waveData.curCount < stageCfg.generate_times then
        waveData.curEventDt = 0
        waveData.curCount = waveData.curCount + 1
        local args = string.split(stageCfg.event_args, "|")
        assert(args, "can not found args")
        local bossPointId = tonumber(args[1])
        local bossPoint = y3.point.get_point_by_res_id(bossPointId)
        assert(bossPoint, "bossPoint is nil by id=" .. bossPointId)
        local points = SurviveHelper.getRandomSpawnPoints(bossPoint, tonumber(args[2]),
            math.random(0, 360), 1)
        local allPlayers = y3.userData:getAllInPlayers()

        local monsterList = self:_spawnRealEenmy(allPlayers[1], stageCfg, waveData, points[1])
        self:_monsterDrop(waveData, monsterList, allPlayers[1]:getId())
        for i, playerData in ipairs(allPlayers) do
            self:_addPlayerStageDropMonsters(playerData, stageCfg, monsterList)
        end

        if waveData.curCount >= stageCfg.generate_times then
            self:_startPlayerStageDropCheck(stageCfg)
            waveData.use = true
        end
    end
end

function SurviveSpawnerEnemy:_monsterDrop(waveData, monsterList, playerId)
    if waveData.monsterDropItem then
        for i = 1, #monsterList do
            local count = waveData.monsterDropFlag[playerId] or 0
            if count >= waveData.monsterDropNum then
                return
            end
            if waveData.monsterDropItem.itemId > 0 then
                monsterList[i]:dieDropItem(waveData.monsterDropItem.itemId, waveData.monsterDropItem.size)
                if not waveData.monsterDropFlag[playerId] then
                    waveData.monsterDropFlag[playerId] = 0
                end
                waveData.monsterDropFlag[playerId] = waveData.monsterDropFlag[playerId] + 1
            end
        end
    end
end

function SurviveSpawnerEnemy:_doCommondWaveLogic(waveData, eventArgs)
    waveData.use = true
    if eventArgs == "" then
        return
    end
    local eventComds = string.split(eventArgs, "#")
    assert(eventComds, "eventArgs is error")
    local cmdName = eventComds[1]
    local args = string.split(eventComds[2], "|")
    assert(args, "args is error")
    if cmdName == "heal_tower_hp" then
        local rate = tonumber(args[1])
        local allPlayers = y3.userData:getAllInPlayers()
        for i = 1, #allPlayers do
            local playerData = allPlayers[i]
            local mainActor = playerData:getMainActor()
            playerData:setIsFailed(false)
            if mainActor and mainActor:getUnit() then
                local maxHp = mainActor:getUnit():get_attr(y3.const.UnitAttr['最大生命'])
                local value = maxHp * (rate / 100)
                if not mainActor:getUnit():is_alive() then
                    mainActor:getUnit():reborn()
                end
                mainActor:getUnit():heals(value, nil, nil, "heal")
            end
        end
    elseif cmdName == "move_tower" then
        local point1 = tonumber(args[1])
        local point2 = tonumber(args[2])
        local point3 = tonumber(args[3])
        local point4 = tonumber(args[4])
        local playerMap = {
            [1] = y3.point.get_point_by_res_id(point1),
            [2] = y3.point.get_point_by_res_id(point2),
            [3] = y3.point.get_point_by_res_id(point3),
            [4] = y3.point.get_point_by_res_id(point4),
        }
        local allPlayers = y3.userData:getAllInPlayers()
        for i = 1, #allPlayers do
            local playerData = allPlayers[i]
            y3.eca.call("刷新镜头", playerData:getPlayer())
            self._monsterGroup[playerData:getId()] = {}
        end
        self._bossList = {}

        local allPlayers = y3.userData:getAllInPlayers()
        for i = 1, #allPlayers do
            local playerData = allPlayers[i]
            local mainActor = allPlayers[i]:getMainActor()
            if mainActor and mainActor:getUnit() then
                local spawnPoint = playerMap[playerData:getId()]
                mainActor:setPosition(spawnPoint, false)
                y3.player.with_local(function(local_player)
                    if local_player:get_id() == playerData:getId() then
                        y3.gameApp:moveCameraToPoint(local_player, spawnPoint, 0)
                    end
                end)
            end
        end
        y3.gameApp:addTimer(0.2, function()
            local allPlayers = y3.userData:getAllInPlayers()
            for i = 1, #allPlayers do
                local playerData = allPlayers[i]
                self._monsterGroup[playerData:getId()] = {}
            end
            self._bossList = {}
        end)
        self:_initArea()
    elseif cmdName == "coin_income" then
        local state = tonumber(args[1])
        local surviveResource = y3.gameApp:getLevel():getLogic("SurviveResource")
        surviveResource:closeAutoAddGold(state == 0)
    elseif cmdName == "abyss_state" then
        local state = tonumber(args[1])
        local allPlayers = y3.userData:getAllInPlayers()
        local abyssChallenge = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy"):getAbysChallenge()
        for i = 1, #allPlayers do
            local playerData = allPlayers[i]
            abyssChallenge:forcecloseChallenge(playerData:getId(), state == 0)
        end
    elseif cmdName == "monster_drop_coin" then
        local state = tonumber(args[1])
        self._stopDropCoin = state == 0
        local allPlayers = y3.userData:getAllInPlayers()
        for i = 1, #allPlayers do
            local playerData = allPlayers[i]
            y3.Sugar.localNotice(playerData:getId(), 29, { state = self._stopDropCoin and "关闭" or "开启" })
        end
    elseif cmdName == "shop_auto_refresh" then
        local state = tonumber(args[1])
        local refreshSkill = y3.gameApp:getLevel():getLogic("SurviveRefreshSkill")
        refreshSkill:setStopAutoRefresh(state == 0)
        local allPlayers = y3.userData:getAllInPlayers()
        for i = 1, #allPlayers do
            local playerData = allPlayers[i]
            y3.Sugar.localNotice(playerData:getId(), 30, { state = self._stopDropCoin and "关闭" or "开启" })
        end
    elseif cmdName == "create_npc" then
        local npcId = tonumber(args[1])
        local npcPointId = tonumber(args[2])

        local npcPoint = y3.point.get_point_by_res_id(npcPointId)
        local unit = y3.unit.create_unit(y3.player(y3.GameConst.PLAYER_ID_FRIEND), npcId, npcPoint, 0)
        unit:add_tag(y3.SurviveConst.STATE_TAG_BOSS_NPC)

        if self._archiveBossCfgList then
            for i = 1, #self._archiveBossCfgList do
                local cfg = self._archiveBossCfgList[i]
                local point = y3.point.get_point_by_res_id(cfg.stage_born_area)
                local npcPoint = point:move(400, 400, 0)
                local unit = y3.unit.create_unit(y3.player(y3.GameConst.PLAYER_ID_FRIEND), npcId, npcPoint, 0)
                unit:add_tag(y3.SurviveConst.STATE_TAG_BOSS_NPC)
                -- unit:set_scale(0.001)
                unit:add_state(y3.const.UnitEnumState["隐藏"])
                local boss = self._archiveBossList[cfg.id]
                if boss then
                    boss:setArchieveNpc(unit)
                end
            end
        end
    elseif cmdName == "init_archive_phase" then
        local curStageId = y3.userData:getCurStageId()
        local bossList   = y3.userDataHelper.getStageBoss(curStageId)
        for i = 1, #bossList do
            self:_createArchiveBoss(bossList[i])
        end
        local allInPlayers = y3.userData:getAllInPlayers()
        for i, playerData in ipairs(allInPlayers) do
            local mainActor = playerData:getMainActor()
            if mainActor then
                mainActor:getUnit():kv_save("is_archive_boss", true)
            end
        end
    elseif cmdName == "give_buff_to_monster" then
        local buffId       = tonumber(args[1])
        local allInPlayers = y3.userData:getAllInPlayers()
        for i, playerData in ipairs(allInPlayers) do
            local monsterList = self._monsterGroup[playerData:getId()]
            for j, monster in ipairs(monsterList) do
                if not monster:isDie() then
                    table.insert(self._addBuffList, { monster = monster, buffId = buffId })
                end
            end
        end
        for i = 1, #self._bossList do
            if not self._bossList[i]:isDie() then
                table.insert(self._addBuffList, { monster = self._bossList[i], buffId = buffId })
            end
        end
    elseif cmdName == "black_market_charge" then
        local state = tonumber(args[1])
        local chargeClose = state == 0
        local allPlayers = y3.userData:getAllInPlayers()
        for i = 1, #allPlayers do
            local playerData = allPlayers[i]
            self._abyssChallenge:getShop():closeShopCharge(playerData:getId(), chargeClose)
            -- y3.Sugar.localNotice(playerData:getId(), 29, { state = self._stopDropCoin and "关闭" or "开启" })
        end
    elseif cmdName == "skill_growth" then
        local state = tonumber(args[1])
        y3.eca.call("设置成长允许", { state })
    end
end

function SurviveSpawnerEnemy:_createArchiveBoss(bossCfg)
    if not self._archiveBossList then
        self._archiveBossList = {}
    end
    if not self._archiveBossCfgList then
        self._archiveBossCfgList = {}
    end
    local cfg = bossCfg
    table.insert(self._archiveBossCfgList, cfg)
    local point = y3.point.get_point_by_res_id(cfg.stage_born_area)
    local monsterCfg = include("gameplay.config.monster").get(cfg.stage_archive_boss_id)
    local boss = include("gameplay.scene.actor.MonsterActor").new(y3.GameConst.PLAYER_ID_ENEMY, monsterCfg, nil, nil, nil,
        nil, nil, cfg)
    boss:setPosition(point)
    self._archiveBossList[bossCfg.id] = boss
    -- print("create_archive_boss", bossCfg.id, point, boss)
    -- table.insert(self._archiveBossList, boss)
end

function SurviveSpawnerEnemy:getArchieveBossActor(bossCfgId)
    return self._archiveBossList[bossCfgId]
end

function SurviveSpawnerEnemy:selectSaveBoss(playerId, bossId)
    if self:playerIsInFightBoss(playerId) then
        return
    end
    local bossCfg = nil
    for i = 1, #self._archiveBossCfgList do
        if bossId == self._archiveBossCfgList[i].id then
            bossCfg = self._archiveBossCfgList[i]
        end
    end
    local posMap = {
        [1] = { -500, 100, 0 },
        [2] = { -200, 100, 0 },
        [3] = { 200, 100, 0 },
        [4] = { 500, 100, 0 },
    }
    local bossActor = self._archiveBossList[bossId]
    if bossActor and bossCfg then
        self._playerFightBoss[playerId] = bossActor
        local playerData = y3.userData:getPlayerData(playerId)
        local mainActor = playerData:getMainActor()
        local bossPoint = y3.point.get_point_by_res_id(bossCfg.stage_born_area) -- bossActor:getPosition()
        local mainActorPoint = bossPoint:move(posMap[playerId][1], posMap[playerId][2], posMap[playerId][3])
        mainActor:setPosition(mainActorPoint)
        self:_initSignalArea(playerData)
        y3.eca.call("刷新镜头", playerData:getPlayer())
        y3.gameApp:moveCameraToPoint(playerData:getPlayer(), mainActorPoint, 0)
    end
end

function SurviveSpawnerEnemy:getArchieveCfgList()
    return self._archiveBossCfgList
end

function SurviveSpawnerEnemy:getArchieveCfgListAll()
    local stage_archive_boss = include("gameplay.config.stage_archive_boss")
    local len = stage_archive_boss.length()
    local result = {}
    for i = 1, len do
        local cfg = stage_archive_boss.indexOf(i)
        table.insert(result, cfg)
    end
    return result
end

function SurviveSpawnerEnemy:playerIsInFightBoss(playerId)
    local boss = self._playerFightBoss[playerId]
    if boss and (not boss:isDie()) then
        return true
    end
    return false
end

function SurviveSpawnerEnemy:_spawnRegularWaveMonster(playerData, stageCfg)
    if stageCfg.regular_wave_monster ~= "" then
        local pointStart = y3.point.get_point_by_res_id(y3.userDataHelper.getPlayerSpawnPointId(playerData:getId()))
        local points = SurviveHelper.getRandomSpawnPoints(pointStart, SPAWN_RANGE, math.random(0, 360), 30)
        local regulars = string.split(stageCfg.regular_wave_monster, "|")
        for i = 1, #regulars do
            local params = string.split(regulars[i], ";")
            local cfg = SurviveHelper.getMonsterCfgById(tonumber(params[1]))
            for j = 1, tonumber(params[2]) do
                self:_spawnSingleEnemy(cfg, points, playerData, stageCfg)
            end
        end
    end
end

function SurviveSpawnerEnemy:_spawnRealEenmy(playerData, stageCfg, waveData, bossPoint)
    local poolId = waveData.poolId
    if poolId <= 0 then
        return {}
    end
    local points = {}
    local isBoss = false
    if bossPoint then
        isBoss = true
        points[1] = bossPoint
    else
        if self._modeBornType == 2 then
            local pointStart = y3.point.get_point_by_res_id(self._modeBornArgs[playerData:getId()])
            points = SurviveHelper.getRandomSpawnPoints(pointStart, 20, math.random(0, 360), 30)
        elseif self._modeBornType == 1 then
            local pointStart = playerData:getMainActor():getPosition()
            points = SurviveHelper.getRandomSpawnPoints(pointStart, self._modeBornArgs[1], math.random(0, 360), 30)
        end
    end
    local random_type_monster_pool = poolId --stageCfg.random_type_monster_pool
    local random_number_monster_pool = stageCfg.random_number_monster_pool
    local monsterType = SurviveHelper.getMonsterTypeByPoolId(random_type_monster_pool)
    local monsterNum = SurviveHelper.getMonsterNumByPoolId(random_number_monster_pool)
    local monsterCfg = SurviveHelper.getMonsterCfgById(monsterType)
    assert(monsterCfg, "monsterCfg is nil by id=" .. monsterType)
    if monsterCfg.monster_type == 1 and stageCfg.event_type == 3 then
        local playerNum = y3.userData:getPlayerCount()
        monsterNum = math.floor(tonumber(self._mutiNums[playerNum]) * monsterNum)
    end
    local monsterList = {}
    for i = 1, monsterNum do
        if i == 1 then
            local monster = self:_spawnSingleEnemy(monsterCfg, points, playerData, stageCfg, isBoss)
            table.insert(monsterList, monster)
        else
            y3.luaQueue.pushBack(self._spawnQueueList,
                {
                    monsterCfg = monsterCfg,
                    points = points,
                    playerData = playerData,
                    stageCfg = stageCfg,
                    isBoss = isBoss,
                    waveData = waveData
                })
        end
    end
    return monsterList
end

function SurviveSpawnerEnemy:_spawnSingleEnemy(monsterCfg, points, playerData, stageCfg, isBoss)
    if #points == 0 then
        return
    end
    local monster = include("gameplay.scene.actor.MonsterActor").new(y3.GameConst.PLAYER_ID_ENEMY, monsterCfg,
        stageCfg, self._mutiHps, self._mutiAtks)
    local randomIndex = math.random(1, #points)
    monster:setPosition(points[randomIndex])
    if stageCfg and stageCfg.event_type == 1 then
        monster:setOwnPlayerId(playerData:getId())
    end
    if not isBoss then
        monster:addToGroup(self._monsterGroup[playerData:getId()])
        if monsterCfg.initial_command <= 0 then
            monster:getUnit():attack_move(playerData:getMainActor():getUnit():get_point(), 2000)
        end
        local actorPoint = playerData:getMainActor():getUnit():get_point()
        local myPoint = monster:getPosition()
        monster:getUnit():set_facing(myPoint:get_angle_with(actorPoint), 1 / 30)
    else
        monster:addToGroup(self._bossList)
    end
    return monster
end

function SurviveSpawnerEnemy:findMonsterActorByUnitId(unitId)
    local allPlayers = y3.userData:getAllInPlayers()
    for i, playerData in ipairs(allPlayers) do
        local list = self._monsterGroup[playerData:getId()]
        for j, monster in ipairs(list) do
            if monster:getUnit():get_id() == unitId then
                return monster
            end
        end
    end
    for i, boss in ipairs(self._bossList) do
        if boss:getUnit():get_id() == unitId then
            return boss
        end
    end
    return nil
end

function SurviveSpawnerEnemy:spawnEnemyFast(monsterId, whoUnitId, point)
    if monsterId <= 0 then
        return
    end
    local monsterActor = self:findMonsterActorByUnitId(whoUnitId)
    local group = nil
    if monsterActor then
        group = monsterActor:getGroup()
    end
    local monsterCfg = include("gameplay.config.monster").get(monsterId)
    local pointLua = y3.point.get_by_handle(point)
    local monster = include("gameplay.scene.actor.MonsterActor").new(y3.GameConst.PLAYER_ID_ENEMY, monsterCfg)
    if group then
        -- monster:addToGroup(group)
    end
    monster:setPosition(pointLua)
    return monster:getUnit()
end

function SurviveSpawnerEnemy:_spawnEnemy(playerData)
    local count = #self._monsterGroup[playerData:getId()]
    if count < MAX_SPAWN then
        playerData:setWave_refresh_count(playerData:getWave_refresh_count() + 1)
        local round = playerData:getRound_count()
        local pointStart = y3.point.get_point_by_res_id(y3.userDataHelper.getPlayerSpawnPointId(playerData:getId()))
        if y3.SurviveConst.REFRESH_GOLD_MONSTER_COUNT[round] then
            local monsterCfg = SurviveHelper.getGoldMonsterCfg()
            local monster = include("gameplay.scene.actor.MonsterActor").new(y3.GameConst.PLAYER_ID_ENEMY, monsterCfg)
            local points = SurviveHelper.getRandomSpawnPoints(pointStart, SPAWN_RANGE, math.random(0, 360), 1)
            monster:setPosition(points[1])
            monster:addToGroup(self._monsterGroup[playerData:getId()])
            monster:getUnit():attack_move(playerData:getMainActor():getUnit():get_point(), 100)
        else
            local spanNums = SurviveHelper.getSpawnMonsterNums()
            local points = SurviveHelper.getRandomSpawnPoints(pointStart, SPAWN_RANGE, math.random(0, 360), spanNums)
            for i, point in ipairs(points) do
                local monsterCfg = SurviveHelper.getSpawnMonsterId()
                local monster = include("gameplay.scene.actor.MonsterActor").new(y3.GameConst.PLAYER_ID_ENEMY, monsterCfg)
                monster:setPosition(point)
                monster:addToGroup(self._monsterGroup[playerData:getId()])
                monster:getUnit():attack_move(playerData:getMainActor():getUnit():get_point(), 100)
            end
            if playerData:getWave_refresh_count() >= y3.SurviveConst.WAVE_MAX_COUNT then
                playerData:setWave_refresh_count(0)
                playerData:setRound_count(playerData:getRound_count() + 1)
            end
        end
    end
end

function SurviveSpawnerEnemy:findEnemy(playerId, notList)
    local list = self._monsterGroup[playerId]
    if not list then
        return
    end
    local aliveList = {}
    for i, monster in ipairs(list) do
        if monster:isAlive() and not notList[monster:getUnit():get_id()] then
            aliveList[#aliveList + 1] = monster
        end
    end
    if #aliveList == 0 then
        return
    end
    local index = math.random(1, #aliveList)
    return list[index]
end

function SurviveSpawnerEnemy:findAllEnemyUnit(playerId, notList)
    local list = self._monsterGroup[playerId]
    if not list then
        return {}
    end
    local aliveList = {}
    for i, monster in ipairs(list) do
        if monster:isAlive() and not notList[monster:getUnit():get_id()] then
            aliveList[#aliveList + 1] = monster:getUnit()
        end
    end
    if #aliveList == 0 then
        return {}
    end
    return aliveList
end

function SurviveSpawnerEnemy:getAliveList(list)
    local result = {}
    for i = 1, #list do
        if list[i]:is_alive() then
            table.insert(result, list[i])
        end
    end
    return result
end

function SurviveSpawnerEnemy:findArea300Enemy(playerId)
    local list = self._cacheAreaMap[playerId .. "_300"]
    if list then
        return list
    end
    local playerData = y3.userData:getPlayerData(playerId)
    local mainActor  = playerData:getMainActor()
    if mainActor then
        local point = mainActor:getPosition()
        self._selecter:with_tag(y3.SurviveConst.TAG_AREA_300)
        self._selecter:without_tag("")
        self._selecter:in_range(point, RADIUS_300)
        local unitGroup = self._selecter:get()
        self._cacheAreaMap[playerId .. "_300"] = unitGroup:pick()
        return self._cacheAreaMap[playerId .. "_300"]
    end
    return {}
end

function SurviveSpawnerEnemy:findArea300_to_600Enemy(playerId)
    local list = self._cacheAreaMap[playerId .. "_300_600"]
    if list then
        return list
    end
    local playerData = y3.userData:getPlayerData(playerId)
    local mainActor  = playerData:getMainActor()
    if mainActor then
        local point = mainActor:getPosition()
        self._selecter:with_tag(y3.SurviveConst.TAG_AREA_600)
        self._selecter:without_tag(y3.SurviveConst.TAG_AREA_300)
        self._selecter:in_range(point, RADIUS_600)
        local unitGroup = self._selecter:get()
        self._cacheAreaMap[playerId .. "_300_600"] = unitGroup:pick()
        return self._cacheAreaMap[playerId .. "_300_600"]
    end
    return {}
end

function SurviveSpawnerEnemy:findArea600Enemy(playerId)
    local list = self._cacheAreaMap[playerId .. "_600"]
    if list then
        return list
    end
    local playerData = y3.userData:getPlayerData(playerId)
    local mainActor  = playerData:getMainActor()
    if mainActor then
        local point = mainActor:getPosition()
        self._selecter:with_tag(y3.SurviveConst.TAG_AREA_600)
        self._selecter:in_range(point, RADIUS_600)
        local unitGroup = self._selecter:get()
        self._cacheAreaMap[playerId .. "_600"] = unitGroup:pick()
        return self._cacheAreaMap[playerId .. "_600"]
    end
    return {}
end

function SurviveSpawnerEnemy:findArea600_to_900Enemy(playerId)
    local list = self._cacheAreaMap[playerId .. "_600_900"]
    if list then
        return list
    end
    local playerData = y3.userData:getPlayerData(playerId)
    local mainActor  = playerData:getMainActor()
    if mainActor then
        local point = mainActor:getPosition()
        self._selecter:with_tag(y3.SurviveConst.TAG_AREA_900)
        self._selecter:without_tag(y3.SurviveConst.TAG_AREA_600)
        self._selecter:in_range(point, RADIUS_900)
        local unitGroup = self._selecter:get()
        self._cacheAreaMap[playerId .. "_600_900"] = unitGroup:pick()
        return self._cacheAreaMap[playerId .. "_600_900"]
    end
    return {}
end

function SurviveSpawnerEnemy:findArea900Enemy(playerId)
    local list = self._cacheAreaMap[playerId .. "_900"]
    if list then
        return list
    end
    local playerData = y3.userData:getPlayerData(playerId)
    local mainActor  = playerData:getMainActor()
    if mainActor then
        local point = mainActor:getPosition()
        self._selecter:with_tag(y3.SurviveConst.TAG_AREA_900)
        self._selecter:in_range(point, RADIUS_900)
        local unitGroup = self._selecter:get()
        self._cacheAreaMap[playerId .. "_900"] = unitGroup:pick()
        return self._cacheAreaMap[playerId .. "_900"]
    end
    return {}
end

function SurviveSpawnerEnemy:findArea900_to_1200Enemy(playerId)
    local list = self._cacheAreaMap[playerId .. "_900_1200"]
    if list then
        return list
    end
    local playerData = y3.userData:getPlayerData(playerId)
    local mainActor  = playerData:getMainActor()
    if mainActor then
        local point = mainActor:getPosition()
        self._selecter:with_tag(y3.SurviveConst.TAG_AREA_1200)
        self._selecter:without_tag(y3.SurviveConst.TAG_AREA_900)
        self._selecter:in_range(point, RADIUS_1200)
        local unitGroup = self._selecter:get()
        self._cacheAreaMap[playerId .. "_900_1200"] = unitGroup:pick()
        return self._cacheAreaMap[playerId .. "_900_1200"]
    end
    return {}
end

function SurviveSpawnerEnemy:findArea1200Enemy(playerId)
    local list = self._cacheAreaMap[playerId .. "_1200"]
    if list then
        return list
    end
    local playerData = y3.userData:getPlayerData(playerId)
    local mainActor  = playerData:getMainActor()
    if mainActor then
        local point = mainActor:getPosition()
        self._selecter:with_tag(y3.SurviveConst.TAG_AREA_1200)
        self._selecter:in_range(point, RADIUS_1200)
        local unitGroup = self._selecter:get()
        self._cacheAreaMap[playerId .. "_1200"] = unitGroup:pick()
        return self._cacheAreaMap[playerId .. "_1200"]
    end
    return {}
end

function SurviveSpawnerEnemy:getFirePointList(playerId)
    local fireParam = self._playerFirePoints[playerId]
    if not fireParam then
        return {}
    end
    local time = fireParam.time
    if time <= 0 then
        return {}
    end
    local list = fireParam.list
    if not list then
        return {}
    end
    local result = {}
    for i = 1, #list do
        if y3.class.isValid(list[i]) and list[i]:is_alive() then
            table.insert(result, list[i])
        end
    end
    return result
end

function SurviveSpawnerEnemy:firePoint(params)
    local py_point   = params[1]
    local range      = params[2]
    local playerId   = params[3]
    local time       = params[4]
    local playerData = y3.userData:getPlayerData(playerId)
    local mainActor  = playerData:getMainActor()
    if mainActor then
        local point = y3.point.get_by_handle(py_point)
        self._selecter:with_tag(nil)
        self._selecter:without_tag(nil)
        self._selecter:is_enemy(playerData:getPlayer())
        self._selecter:in_range(point, range)
        local unitGroup = self._selecter:get()
        if not self._playerFirePoints[playerId] then
            self._playerFirePoints[playerId] = { time = 0, list = {} }
        end
        local fireParam = self._playerFirePoints[playerId]
        local list = unitGroup:pick()
        self._selecter:of_player(nil)
        fireParam.list = list
        fireParam.time = time
    end
end

function SurviveSpawnerEnemy:recordSkillDamage(unitId, damageType, attackType, abilityKey, targetUnitId, damageValue,
                                               jumpWord)
    -- if not self._unitRecordDamageMap then
    --     self._unitRecordDamageMap = {}
    -- end
    -- self._unitRecordDamageMap[unitId .. "_" .. damageType .. "_" .. attackType .. "_" .. abilityKey .. "_" .. targetUnitId] =
    -- {
    --     damageValue = damageValue,
    --     jumpWord = jumpWord
    -- }
end

function SurviveSpawnerEnemy:getRecordSkillDamage(unitId, damageType, attackType, abilityKey, targetUnitId)
    -- if not self._unitRecordDamageMap then
    --     self._unitRecordDamageMap = {}
    -- end
    -- return self._unitRecordDamageMap
    --     [unitId .. "_" .. damageType .. "_" .. attackType .. "_" .. abilityKey .. "_" .. targetUnitId]
end

return SurviveSpawnerEnemy
