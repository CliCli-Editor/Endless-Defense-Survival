local GlobalConfigHelper = require "gameplay.level.logic.helper.GlobalConfigHelper"
local UserDataHelper = include "gameplay.level.logic.helper.UserDataHelper"
local SurviveHelper = include "gameplay.level.logic.helper.SurviveHelper"
local LogicBase = include("gameplay.level.logic.LogicBase")
local SurviveGameTaskSyetem = class("SurviveGameTaskSyetem", LogicBase)
local stage_task = include("gameplay.config.stage_task")


local TASKCON_NONE = 1
local TASKCON_KILL_MONSTER_TYPE = 2
local TASKCON_KILL_MONSTER_ID = 3
local TASKCON_COST_COIN = 4
local TASKCON_ADD_COIN = 5
local TASKCON_ADD_SKILL_TYPE = 6
local TASKCON_ADD_SKILL_ID = 7
local TASKCON_ADD_ITEM_ID = 8
local TASKCON_GAME_TIME = 9
local TASKCON_PASS_STAGE = 10
local TASKCON_HEROSHOP_LV = 11

local TASK_COMPLETE_TYPE_ALL = 1
local TASK_COMPLETE_TYPE_NUM = 2

function SurviveGameTaskSyetem:ctor(level)
    SurviveGameTaskSyetem.super.ctor(self, level)
    y3.gameApp:addTimerLoop(0.5, handler(self, self._onTaskSystemUpdate))
    self:_initData()
end

function SurviveGameTaskSyetem:getTaskDesc(taskData)
    local result = {}
    local condData = taskData.conMap[TASKCON_KILL_MONSTER_ID]
    if condData then
        local condMonsterId = tonumber(condData.params[2])
        local maxProgress = tonumber(condData.params[3])
        local monsterCfg = include("gameplay.config.monster").get(condMonsterId)
        assert(monsterCfg)
        local taskDescCfg = include("gameplay.config.stage_task_desc").get(TASKCON_KILL_MONSTER_ID - 1)
        assert(taskDescCfg)
        table.insert(result,
            y3.Lang.getLang(taskDescCfg.stage_task_target_desc,
                {
                    monster_name = monsterCfg.monster_name,
                    target_number = maxProgress,
                    current = condData.progress,
                    target = maxProgress
                }))
    end
    condData = taskData.conMap[TASKCON_KILL_MONSTER_TYPE]
    if condData then
        local condMonsterType = tonumber(condData.params[2])
        local maxProgress = tonumber(condData.params[3])
        local taskDescCfg = include("gameplay.config.stage_task_desc").get(TASKCON_KILL_MONSTER_TYPE - 1)
        assert(taskDescCfg)
        local monsterTypeNameMap = GlobalConfigHelper.getMonsterTypeNameMap()
        table.insert(result,
            y3.Lang.getLang(taskDescCfg.stage_task_target_desc,
                {
                    monster_type = monsterTypeNameMap[condMonsterType],
                    target_number = maxProgress,
                    current = condData.progress,
                    target = maxProgress
                }))
    end
    condData = taskData.conMap[TASKCON_COST_COIN]
    if condData then
        local resId = tonumber(condData.params[2])
        local costCoin = tonumber(condData.params[3])
        local taskDescCfg = include("gameplay.config.stage_task_desc").get(TASKCON_COST_COIN - 1)
        assert(taskDescCfg)
        table.insert(result,
            y3.Lang.getLang(taskDescCfg.stage_task_target_desc,
                {
                    resource_name = y3.userDataHelper.getResName(resId),
                    target_number = costCoin,
                    current = condData.progress,
                    target = costCoin
                }))
    end
    condData = taskData.conMap[TASKCON_ADD_COIN]
    if condData then
        local resId = tonumber(condData.params[2])
        local addCoin = tonumber(condData.params[3])
        local taskDescCfg = include("gameplay.config.stage_task_desc").get(TASKCON_ADD_COIN - 1)
        assert(taskDescCfg)
        table.insert(result,
            y3.Lang.getLang(taskDescCfg.stage_task_target_desc,
                {
                    resource_name = y3.userDataHelper.getResName(resId),
                    target_number = addCoin,
                    current = condData.progress,
                    target = addCoin
                }))
    end
    condData = taskData.conMap[TASKCON_ADD_SKILL_TYPE]
    if condData then
        local skillType = tonumber(condData.params[2])
        local maxProgress = tonumber(condData.params[3])
        local taskDescCfg = include("gameplay.config.stage_task_desc").get(TASKCON_ADD_SKILL_TYPE - 1)
        assert(taskDescCfg)
        local skillTypeNameMap = GlobalConfigHelper.getSkillTypeNameMap()
        table.insert(result,
            y3.Lang.getLang(taskDescCfg.stage_task_target_desc,
                {
                    skill_type = skillTypeNameMap[skillType],
                    target_number = maxProgress,
                    current = condData.progress,
                    target = maxProgress
                }))
    end
    condData = taskData.conMap[TASKCON_ADD_SKILL_ID]
    if condData then
        local skillId = tonumber(condData.params[2])
        local maxProgress = tonumber(condData.params[3])
        local skillCfg = include("gameplay.config.skill").get(tostring(skillId))
        assert(skillCfg)
        local taskDescCfg = include("gameplay.config.stage_task_desc").get(TASKCON_ADD_SKILL_ID - 1)
        assert(taskDescCfg)
        table.insert(result,
            y3.Lang.getLang(taskDescCfg.stage_task_target_desc,
                {
                    skill_name = skillCfg.name,
                    target_number = maxProgress,
                    current = condData.progress,
                    target = maxProgress
                }))
    end
    condData = taskData.conMap[TASKCON_ADD_ITEM_ID]
    if condData then
        local itemId = tonumber(condData.params[2])
        local maxProgress = tonumber(condData.params[3])
        local itemCfg = include("gameplay.config.item").get(itemId)
        assert(itemCfg)
        local taskDescCfg = include("gameplay.config.stage_task_desc").get(TASKCON_ADD_ITEM_ID - 1)
        assert(taskDescCfg)
        table.insert(result,
            y3.Lang.getLang(taskDescCfg.stage_task_target_desc,
                {
                    item_name = itemCfg.item_name,
                    target_number = maxProgress,
                    current = condData.progress,
                    target = maxProgress
                }))
    end
    condData = taskData.conMap[TASKCON_GAME_TIME]
    if condData then
        local time = tonumber(condData.params[3])
        local taskDescCfg = include("gameplay.config.stage_task_desc").get(TASKCON_GAME_TIME - 1)
        assert(taskDescCfg)
        table.insert(result,
            y3.Lang.getLang(taskDescCfg.stage_task_target_desc,
                {
                    time = time,
                    current = condData.progress,
                    target = time
                }))
    end
    condData = taskData.conMap[TASKCON_PASS_STAGE]
    if condData then
        local stageId = tonumber(condData.params[2])
        local taskDescCfg = include("gameplay.config.stage_task_desc").get(TASKCON_PASS_STAGE - 1)
        assert(taskDescCfg)
        table.insert(result,
            y3.Lang.getLang(taskDescCfg.stage_task_target_desc, {}))
    end
    condData = taskData.conMap[TASKCON_HEROSHOP_LV]
    if condData then
        local condShopId = tonumber(condData.params[2])
        local lv = tonumber(condData.params[3])
        local shopCfg = include("gameplay.config.hero_shop").get(condShopId)
        assert(shopCfg)
        local taskDescCfg = include("gameplay.config.stage_task_desc").get(TASKCON_HEROSHOP_LV - 1)
        assert(taskDescCfg)
        table.insert(result,
            y3.Lang.getLang(taskDescCfg.stage_task_target_desc,
                {
                    tech_name = shopCfg.not_,
                    target_number = lv,
                    current = condData.progress,
                    target = lv
                }))
    end
    return result
end

function SurviveGameTaskSyetem:_initData()
    self._taskData = {}
    local allInPlayers = y3.userData:getAllInPlayers()
    for _, playerData in ipairs(allInPlayers) do
        local param = {}
        param.taskList = {}
        param.canGetTaskList = {}
        param.taskGetLimit = {}
        param.taskFinishCount = {}
        param.afkRewards = {}
        self._taskData[playerData:getId()] = param
    end
    local len = stage_task.length()
    for i = 1, len do
        local cfg = stage_task.indexOf(i)
        assert(cfg, "")
        for _, playerData in ipairs(allInPlayers) do
            local param = self._taskData[playerData:getId()]
            param.taskGetLimit[cfg.id] = cfg.task_complete_num_limit
            param.taskFinishCount[cfg.id] = 0
            if cfg.task_give_type == 2 then -- 开局接取的任务
                self:receiveTask(playerData:getId(), cfg.id)
            end
        end
    end
    local curStageCfg = include("gameplay.config.stage_config").get(y3.userData:getCurStageId())
    if curStageCfg then
        for _, playerData in ipairs(allInPlayers) do
            if curStageCfg.stage_task_id ~= "" then
                local taskParams = string.split(curStageCfg.stage_task_id, "|")
                assert(taskParams, "")
                for _, taskId in ipairs(taskParams) do
                    local taskIdex = tonumber(taskId) or 0
                    if taskIdex > 0 then
                        self:receiveTask(playerData:getId(), taskIdex)
                    end
                end
            end
        end
    end

    y3.SignalMgr:beginCache(self.__cname)
    y3.SignalMgr:add(y3.SignalConst.SIGNAL_MONSTER_DIE, handler(self, self._signalMonsterDie))
    y3.SignalMgr:add(y3.SignalConst.SIGNAL_PLAYER_UPDATE_COIN, handler(self, self._signalUpdateCoin))
    y3.SignalMgr:add(y3.SignalConst.SIGNAL_UPDATE_SKILL, handler(self, self._signalUpdateSkill))
    y3.SignalMgr:add(y3.SignalConst.SIGNAL_UPDATE_ITEM, handler(self, self._signalUpdateItem))
    y3.SignalMgr:add(y3.SignalConst.SIGNAL_STAGE_PASS, handler(self, self._signalStagePass))
    y3.SignalMgr:add(y3.SignalConst.SIGNAL_GAME_TIME_REFRESH, handler(self, self._signalGameTimeRefresh))
    y3.SignalMgr:add(y3.SignalConst.SIGNAL_HEROSHOP_LV_UP, handler(self, self._signalHeroShopLvUp))
    y3.SignalMgr:endCache()
end

function SurviveGameTaskSyetem:getTaskDataByType(playerId, taskType)
    local param = self._taskData[playerId]
    local taskList = param.taskList
    for i = 1, #taskList do
        local taskData = taskList[i]
        if not taskData.remove and taskData.taskType == taskType then
            return taskData
        end
    end
end

function SurviveGameTaskSyetem:clear()
    y3.SignalMgr:removeCache(self.__cname)
    SurviveGameTaskSyetem.super.clear(self)
end

function SurviveGameTaskSyetem:_createTaskData(taskId)
    local cfg = stage_task.get(taskId)
    assert(cfg, "task config not found by id=" .. taskId)
    local task_complete_conditions = string.split(cfg.task_complete_condition, "|")
    assert(task_complete_conditions, "")
    local conMap = {}
    local condList = {}
    for _, condition in ipairs(task_complete_conditions) do
        local params = string.split(condition, "#")
        assert(params, "")
        local data = {}
        data.cond = tonumber(params[1])
        data.params = params
        data.progress = 0
        conMap[data.cond] = data
        table.insert(condList, data.cond)
    end
    local task_complete_condition_args = string.split(cfg.task_complete_condition_args, "#")
    assert(task_complete_condition_args, "")
    local data = {}
    data.taskId = taskId
    data.taskType = cfg.task_type
    data.taskTime = cfg.task_require_time
    data.conMap = conMap
    data.condList = condList
    data.completeCond = tonumber(task_complete_condition_args[1])
    data.completeArgs = task_complete_condition_args
    return data
end

function SurviveGameTaskSyetem:_onTaskSystemUpdate(delay)
    if not self._level:isGameStart() then
        return
    end
    local dt = delay:float()
    local allInPlayers = y3.userData:getAllInPlayers()
    for _, playerData in ipairs(allInPlayers) do
        local param = self._taskData[playerData:getId()]
        local taskList = param.taskList
        for i = 1, #taskList do
            local taskData = taskList[i]
            self:_checkPlayerTaskComplete(playerData, taskData)
            if not taskData.remove then
                if taskData.taskTime > 0 then
                    taskData.taskTime = taskData.taskTime - dt
                    if taskData.taskTime <= 0 then
                        self:_onTaskFinishFailed(playerData, taskData)
                    end
                end
            end
        end
        for s = #taskList, 1, -1 do
            if taskList[s].remove then
                table.remove(taskList, s)
            end
        end
        y3.SignalMgr:dispatch(y3.SignalConst.SIGNAL_GAME_TIME_REFRESH, playerData:getPlayer(), dt)
    end
end

function SurviveGameTaskSyetem:_checkPlayerTaskComplete(playerData, taskData)
    local condList = taskData.condList
    local completeNum = 0
    for i = 1, #condList do
        local cond = condList[i]
        if cond == TASKCON_NONE then
            completeNum = completeNum + 1
        else
            local condData = taskData.conMap[cond]
            local paramValue = tonumber(condData.params[3])
            if condData.progress >= paramValue then
                completeNum = completeNum + 1
            end
        end
    end
    if taskData.completeCond == TASK_COMPLETE_TYPE_ALL then
        if completeNum >= #condList then
            self:_onTaskFinishSuccess(playerData, taskData)
        end
    elseif taskData.completeCond == TASK_COMPLETE_TYPE_NUM then
        local completeArg = tonumber(taskData.completeArgs[2]) or 0
        if completeNum >= completeArg then
            self:_onTaskFinishSuccess(playerData, taskData)
        end
    end
end

function SurviveGameTaskSyetem:_onTaskFinishSuccess(playerData, taskData)
    taskData.remove = true
    local cfg = include("gameplay.config.stage_task").get(taskData.taskId)
    assert(cfg, "task config not found by id=" .. taskData.taskId)
    local param = self._taskData[playerData:getId()]
    if cfg.task_reward_auto == 1 then
        self:_getTaskReward(cfg, playerData)
    else
        table.insert(param.canGetTaskList, taskData.taskId)
    end
    if not param.taskFinishCount[taskData.taskId] then
        param.taskFinishCount[taskData.taskId] = 0
    end
    param.taskFinishCount[taskData.taskId] = param.taskFinishCount[taskData.taskId] + 1
    y3.Sugar.localNotice(playerData:getId(), 24, { task_title = cfg.task_title })
    self:_taskFinishHandle(playerData, cfg)
    y3.gameApp:dispatchLocalEvent(playerData:getId(), y3.EventConst.EVENT_TASK_FINISH_SUCCESS,
        { task_id = taskData.taskId })
end

function SurviveGameTaskSyetem:_taskFinishHandle(playerData, cfg)
    local task_complete_handle = string.split(cfg.task_complete_handle, "#")
    assert(task_complete_handle, "")
    local handleType = tonumber(task_complete_handle[1])
    if handleType == 1 then -- 触发事件
    elseif handleType == 2 then
        self:receiveTask(playerData:getId(), tonumber(task_complete_handle[2]))
    end
end

function SurviveGameTaskSyetem:_onTaskFinishFailed(playerData, taskData)
    taskData.remove = true
    local cfg = include("gameplay.config.stage_task").get(taskData.taskId)
    assert(cfg, "task config not found by id=" .. taskData.taskId)
    y3.Sugar.localNotice(playerData:getId(), 23, { task_title = cfg.task_title })
    y3.gameApp:dispatchLocalEvent(playerData:getId(), y3.EventConst.EVENT_TASK_FINISH_FAILED,
        { task_id = taskData.taskId })
end

function SurviveGameTaskSyetem:_getTaskReward(cfg, playerData)
    if cfg.task_reward ~= "" then
        local task_rewards = string.split(cfg.task_reward, "|")
        assert(task_rewards, "")
        for i = 1, #task_rewards do
            self:_taskAward(cfg, playerData, task_rewards[i])
        end
    end
end

function SurviveGameTaskSyetem:_taskAward(cfg, playerData, task_reward_str)
    local task_reward = string.split(task_reward_str, "#")
    assert(task_reward, "")
    local modifyRate = 1
    local rewardType = tonumber(task_reward[1]) or 0
    if cfg.task_reward_modify ~= "" and rewardType == 4 then
        local task_reward_modify = string.split(cfg.task_reward_modify, "#")
        assert(task_reward_modify, "")
        local modifyType = tonumber(task_reward_modify[1])
        local modifyItem = tonumber(task_reward_modify[2])
        if modifyType == 1 then
            local gameSaveItem = y3.gameApp:getLevel():getLogic("SurviveGameSaveItem")
            if gameSaveItem:getSaveItemNum(playerData:getId(), modifyItem) > 0 then
                modifyRate = math.floor(tonumber(task_reward_modify[3]) or 1)
            end
        elseif modifyType == 2 then
            -- print("增加系数了吗")
            local player = playerData:getPlayer()
            if player:get_store_item_number(modifyItem) > 0 then
                modifyRate = math.floor(tonumber(task_reward_modify[3]) or 1)
            end
        end
    end
    -- print("task_reward_coin", task_reward)
    if rewardType == 1 then -- 货币
        local resId = tonumber(task_reward[2])
        local resNum = tonumber(task_reward[3])
        UserDataHelper.dropRes(playerData:getId(), resId, resNum)
    elseif rewardType == 2 then -- 技能
        local skillId = tonumber(task_reward[2])
        local skillNum = tonumber(task_reward[3])
        for i = 1, skillNum do
            SurviveHelper.leanSkill({ playerData:getId(), skillId })
        end
    elseif rewardType == 3 then
    elseif rewardType == 4 then -- 存档道具
        local saveItemId = tonumber(task_reward[2])
        local saveItemNum = tonumber(task_reward[3]) * modifyRate
        -- log.info("saveItemId", saveItemId, "saveItemNum", saveItemNum)
        local rewardStr = y3.SurviveConst.DROP_TYPE_SAVE_ITEM .. "#" .. saveItemId .. "#" .. saveItemNum
        y3.userDataHelper.dropSaveItem(playerData:getId(), rewardStr)
        if cfg.id == y3.SurviveConst.AFK_TASK_ID then
            self:addAfkReward(playerData:getId(),
                { type = y3.SurviveConst.DROP_TYPE_SAVE_ITEM, value = saveItemId, size = saveItemNum })
            y3.gameApp:dispatchLocalEvent(playerData:getId(), y3.EventConst.EVENT_RECEIVE_AFK_REWARD)
        end
    end
end

function SurviveGameTaskSyetem:addAfkReward(playerId, reward)
    local playerData = y3.userData:getPlayerData(playerId)
    local afkRewards = self._taskData[playerData:getId()].afkRewards
    for i = 1, #afkRewards do
        if afkRewards[i].type == reward.type and afkRewards[i].value == reward.value then
            afkRewards[i].size = afkRewards[i].size + reward.size
            return
        end
    end
    table.insert(self._taskData[playerData:getId()].afkRewards, reward)
end

function SurviveGameTaskSyetem:getAfkRewards(playerId)
    local param = self._taskData[playerId]
    if not param then
        return {}
    end
    return param.afkRewards
end

function SurviveGameTaskSyetem:getTaskDataByTaskId(playerId, taskId)
    local param = self._taskData[playerId]
    if not param then
        return
    end
    local taskList = param.taskList
    for i = 1, #taskList do
        local taskData = taskList[i]
        if taskData.taskId == taskId then
            return taskData
        end
    end
end

function SurviveGameTaskSyetem:getAfkTaskRewardTime(playerId)
    local param = self._taskData[playerId]
    if not param then
        return 0
    end
    local afkTask = self:getTaskDataByTaskId(playerId, y3.SurviveConst.AFK_TASK_ID)
    if not afkTask then
        return 0
    end
    local condData = afkTask.conMap[TASKCON_GAME_TIME]
    if condData then
        local limitTime = tonumber(condData.params[3]) or 0
        return limitTime - condData.progress
    end
    return 0
end

function SurviveGameTaskSyetem:receiveTask(playerId, taskId)
    local taskData = self:_createTaskData(taskId)
    local param = self._taskData[playerId]
    local taskLimit = param.taskGetLimit[taskId] or -1
    local taskCount = param.taskFinishCount[taskId] or 0
    if taskLimit > 0 then
        if taskCount >= taskLimit then
            -- print("任务完成次数达到上限")
            return
        end
    end
    local cfg = include("gameplay.config.stage_task").get(taskId)
    if not cfg then
        return
    end
    -- print("receiveTask " .. taskId)
    local taskList = param.taskList
    table.insert(taskList, taskData)
    self:_onPlayerReceiveTask(playerId, taskData)
    if cfg.task_require_time > 0 then
        y3.Sugar.localNotice(playerId, 22, { task_title = cfg.task_title, time = math.floor(cfg.task_require_time) })
    else
        y3.Sugar.localNotice(playerId, 22, { task_title = cfg.task_title, time = y3.langCfg.get(38).str_content })
    end
    y3.gameApp:dispatchLocalEvent(playerId, y3.EventConst.EVENT_TASK_RECEIVE, { task_id = taskId })
end

function SurviveGameTaskSyetem:_onPlayerReceiveTask(playerId, taskData)
    local cfg = include("gameplay.config.stage_task").get(taskData.taskId)
    assert(cfg, "task config not found by id=" .. taskData.taskId)
    local triggerEvents = string.split(cfg.task_get_trigger_event, "#")
    assert(triggerEvents, "")
    if #triggerEvents == 0 then
        return
    end
    local eventType = tonumber(triggerEvents[1])
    if eventType == 1 then
        self:_spawnTriggerMonster(playerId, triggerEvents)
    end
end

-- 1#1800#10001#20
function SurviveGameTaskSyetem:_spawnTriggerMonster(playerId, triggerEvents)
    local range = tonumber(triggerEvents[2])
    local monsterId = tonumber(triggerEvents[3])
    local num = tonumber(triggerEvents[4])
    local monsterCfg = include("gameplay.config.monster").get(monsterId)
    assert(monsterCfg, "monster config not found by id=" .. monsterId)
    local playerData = y3.userData:getPlayerData(playerId)
    local mainActor = playerData:getMainActor()
    local points = SurviveHelper.getRandomSpawnPoints(mainActor:getPosition(), range, math.random(0, 360), num)

    for pointIndex = 1, #points do
        local spawnEnemy = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy")
        local monster = include("gameplay.scene.actor.MonsterActor").new(y3.GameConst.PLAYER_ID_ENEMY, monsterCfg,
            nil, nil, nil, nil)
        monster:setPosition(points[pointIndex])
        local monsterGroup = spawnEnemy:getMonsterGroup(playerData:getId())
        monster:addToGroup(monsterGroup)
        monster:getUnit():attack_move(playerData:getMainActor():getUnit():get_point(), 500)
    end
end

---comment
---@param id any
---@param player Player
---@param monsterId any
function SurviveGameTaskSyetem:_signalMonsterDie(id, player, monsterId)
    local param = self._taskData[player:get_id()]
    if not param then
        return
    end
    local taskList = param.taskList
    local monsterCfg = include("gameplay.config.monster").get(monsterId)
    assert(monsterCfg, "monster config not found by id=" .. monsterId)
    for i = 1, #taskList do
        local taskData = taskList[i]
        if taskData.conMap[TASKCON_KILL_MONSTER_TYPE] then
            local condData = taskData.conMap[TASKCON_KILL_MONSTER_TYPE]
            local monsterType = tonumber(condData.params[2])
            if monsterType == monsterCfg.monster_type then
                condData.progress = condData.progress + 1
            end
        end
        if taskData.conMap[TASKCON_KILL_MONSTER_ID] then
            local condData = taskData.conMap[TASKCON_KILL_MONSTER_ID]
            local condMonsterId = tonumber(condData.params[2])
            if condMonsterId == monsterId then
                condData.progress = condData.progress + 1
            end
        end
    end
end

function SurviveGameTaskSyetem:_signalUpdateCoin(id, player, coinId, coinNum)
    local param = self._taskData[player:get_id()]
    local taskList = param.taskList
    for i = 1, #taskList do
        local taskData = taskList[i]
        if taskData.conMap[TASKCON_ADD_COIN] then
            local condData = taskData.conMap[TASKCON_ADD_COIN]
            local conCoinId = tonumber(condData.params[2])
            if conCoinId == coinId and coinNum > 0 then
                condData.progress = condData.progress + coinNum
            end
        end
        if taskData.conMap[TASKCON_COST_COIN] then
            local condData = taskData.conMap[TASKCON_COST_COIN]
            local conCoinId = tonumber(condData.params[2])
            if conCoinId == coinId and coinNum < 0 then
                condData.progress = condData.progress + math.abs(coinNum)
            end
        end
    end
end

function SurviveGameTaskSyetem:_signalUpdateSkill(id, player, skillId)
    local param = self._taskData[player:get_id()]
    local taskList = param.taskList
    local skillCfg = include("gameplay.config.config_skillData").get(tostring(skillId))
    assert(skillCfg, "skill config not found by id=" .. skillId)
    for i = 1, #taskList do
        local taskData = taskList[i]
        if taskData.conMap[TASKCON_ADD_SKILL_TYPE] then
            local condData = taskData.conMap[TASKCON_ADD_SKILL_TYPE]
            local skillType = tonumber(condData.params[2])
            if skillType == skillCfg.type or skillType == -1 then
                condData.progress = condData.progress + 1
            end
        end
        if taskData.conMap[TASKCON_ADD_SKILL_ID] then
            local condData = taskData.conMap[TASKCON_ADD_SKILL_ID]
            local condSkillId = tonumber(condData.params[2])
            if condSkillId == skillId then
                condData.progress = condData.progress + 1
            end
        end
    end
end

function SurviveGameTaskSyetem:_signalUpdateItem(id, player, itemId, num)
    local param = self._taskData[player:get_id()]
    local taskList = param.taskList
    for i = 1, #taskList do
        local taskData = taskList[i]
        if taskData.conMap[TASKCON_ADD_ITEM_ID] then
            local condData   = taskData.conMap[TASKCON_ADD_ITEM_ID]
            local condItemId = tonumber(condData.params[2])
            if condItemId == itemId then
                condData.progress = condData.progress + num
            end
        end
    end
end

function SurviveGameTaskSyetem:_signalStagePass(id, player)
    local param = self._taskData[player:get_id()]
    local taskList = param.taskList
    for i = 1, #taskList do
        local taskData = taskList[i]
        if taskData.conMap[TASKCON_PASS_STAGE] then
            local condData    = taskData.conMap[TASKCON_PASS_STAGE]
            condData.progress = condData.progress + 1
        end
    end
end

function SurviveGameTaskSyetem:_signalGameTimeRefresh(id, player, addTime)
    local param = self._taskData[player:get_id()]
    local taskList = param.taskList
    for i = 1, #taskList do
        local taskData = taskList[i]
        if taskData.conMap[TASKCON_GAME_TIME] then
            local condData    = taskData.conMap[TASKCON_GAME_TIME]
            condData.progress = condData.progress + addTime
        end
    end
end

function SurviveGameTaskSyetem:_signalHeroShopLvUp(id, player, shopItemId, level)
    -- print("hero shop lv up", player, shopItemId, level)
    local param = self._taskData[player:get_id()]
    local taskList = param.taskList
    for i = 1, #taskList do
        local taskData = taskList[i]
        if taskData.conMap[TASKCON_HEROSHOP_LV] then
            local condData   = taskData.conMap[TASKCON_HEROSHOP_LV]
            local condShopId = tonumber(condData.params[2])
            -- local condLevel  = tonumber(condData.params[3])
            if condShopId == shopItemId then
                condData.progress = level
            end
        end
    end
end

return SurviveGameTaskSyetem
