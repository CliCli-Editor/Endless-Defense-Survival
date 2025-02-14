local UserDataHelper = include "gameplay.level.logic.helper.UserDataHelper"
local SurviveHelper = include "gameplay.level.logic.helper.SurviveHelper"
local GlobalConfigHelper = include "gameplay.level.logic.helper.GlobalConfigHelper"
local SurviveGameStageChallenge = class("SurviveGameStageChallenge")

function SurviveGameStageChallenge:ctor(parent, type)
    self._parent = parent
    self._type = type
    self._uniqueId = 1
    self:_initCfg()
end

function SurviveGameStageChallenge:_initCfg()
    self._curStageConfig = include("gameplay.config.stage_config").get(y3.userData:getCurStageId())
    self._curModeCfg = include("gameplay.config.stage_mode").get(self._curStageConfig.stage_type)
    local stage_wave_born_poins = string.split(self._curModeCfg.challenge_born_points, "|")
    assert(stage_wave_born_poins, "")
    self._modeBornType = tonumber(stage_wave_born_poins[1])
    local modeBornArgs = string.split(stage_wave_born_poins[2], "#")
    assert(modeBornArgs, "")
    self._modeBornArgs = {}
    for i = 1, #modeBornArgs do
        self._modeBornArgs[i] = tonumber(modeBornArgs[i])
    end

    local curStageId = y3.userData:getCurStageId()
    local stageCfg   = include("gameplay.config.stage_config").get(curStageId)
    assert(stageCfg, "stageCfg is nil")
    local stage_challenge_group = string.split(stageCfg.stage_challenge_group, "#")
    assert(stage_challenge_group, "stage_challenge_group is nil")
    -- print(self._type)
    self._challengeList   = {}
    local stage_challange = include("gameplay.config.stage_challange")
    local len             = stage_challange.length()
    for i = 1, len do
        local cfg = stage_challange.indexOf(i)
        local groupid = tonumber(stage_challenge_group[self._type]) or 0
        if cfg.stage_challenge_type == self._type and groupid == cfg.stage_challenge_group_id then
            table.insert(self._challengeList, cfg)
        end
    end
    self._challengeLimitCount = GlobalConfigHelper.get(18)
    self._challengeSpawnTime  = GlobalConfigHelper.get(19)
    self._challengeData       = {}
    self._challengeDoing      = {}
    self._challengeCheck      = {}
    local allPlayers          = y3.userData:getAllInPlayers()
    for i, playerData in ipairs(allPlayers) do
        local param                              = {}
        param.curChallengeIndex                  = 0
        param.list                               = {}
        param.totalDt                            = 0
        self._challengeData[playerData:getId()]  = param
        self._challengeDoing[playerData:getId()] = {}
        self._challengeCheck[playerData:getId()] = { checkList = {} }
    end
end

function SurviveGameStageChallenge:challengeHas()
    return #self._challengeList > 0
end

function SurviveGameStageChallenge:getChallengeIndex(playerId)
    local challengeParam = self._challengeData[playerId]
    return challengeParam.curChallengeIndex
end

function SurviveGameStageChallenge:getChallengeParam(playerId)
    local challengeParam = self._challengeData[playerId]
    local nextCfg = self._challengeList[challengeParam.curChallengeIndex + 1]
    if nextCfg then
        return #challengeParam.list, challengeParam.totalDt, nextCfg.stage_challenge_time_require
    else
        return #challengeParam.list, 0, 1
    end
end

function SurviveGameStageChallenge:doChallengeLogic(delay)
    -- local allPlayers = y3.userData:getAllInPlayers()
    -- for i, playerData in ipairs(allPlayers) do
    --     local challengeParam = self._challengeData[playerData:getId()]
    --     local nextCfg = self._challengeList[challengeParam.curChallengeIndex + 1]
    --     local curCount = #challengeParam.list
    --     if nextCfg and curCount < self._challengeLimitCount then
    --         challengeParam.totalDt = challengeParam.totalDt + delay
    --         if challengeParam.totalDt >= nextCfg.stage_challenge_time_require then
    --             challengeParam.totalDt = 0
    --             challengeParam.curChallengeIndex = challengeParam.curChallengeIndex + 1
    --             table.insert(challengeParam.list, nextCfg)
    --         end
    --     end
    -- end
    self:_checkStageChallengeDoing(delay)
end

function SurviveGameStageChallenge:_checkStageChallengeDoing(delay)
    local allPlayers = y3.userData:getAllInPlayers()
    for i, playerData in ipairs(allPlayers) do
        local doList = self._challengeDoing[playerData:getId()]
        for i, data in ipairs(doList) do
            data.totalDt = data.totalDt + delay
            if data.totalDt >= self._challengeSpawnTime and data.count > 0 then
                data.totalDt = 0
                data.count = data.count - 1
                local monsterCfg = include("gameplay.config.monster").get(data.monster_id)
                local points = data.points
                local monster = self:_spawnChallengeEnemy(monsterCfg, points, playerData, data.cfg)
                local checkData = self._challengeCheck[playerData:getId()]
                if monster then
                    if not checkData[data.uniqueId] then
                        checkData[data.uniqueId] = { start = false, list = {}, cfg = data.cfg }
                        table.insert(checkData.checkList, data.uniqueId)
                    end
                    table.insert(checkData[data.uniqueId].list, monster)
                end
                if data.count <= 0 then
                    if checkData[data.uniqueId] then
                        checkData[data.uniqueId].start = true
                    end
                end
            end
        end
        for i, data in ipairs(doList) do
            if data.count <= 0 then
                table.remove(doList, i)
                break
            end
        end
    end
    self:_checkChallengeResult()
end

function SurviveGameStageChallenge:_checkChallengeResult()
    local allPlayers = y3.userData:getAllInPlayers()
    for _, playerData in ipairs(allPlayers) do
        local checkData = self._challengeCheck[playerData:getId()]
        local checkList = checkData.checkList
        for _, uniqueId in ipairs(checkList) do
            local data = checkData[uniqueId]
            if data and data.start then
                local list = data.list
                local allDie = true
                for i = 1, #list do
                    local monster = list[i]
                    if not monster:isDie() then
                        allDie = false
                    end
                end
                if allDie then
                    checkData[uniqueId] = nil
                    self:_doReward(data.cfg, playerData)
                end
            end
        end
    end
end

function SurviveGameStageChallenge:_doReward(cfg, playerData)
    -- print("doReward", cfg.stage_challenge_drop_type, cfg.stage_challenge_drop_args)
    if cfg.stage_challenge_drop_type == y3.SurviveConst.REWARD_TYPE_RES then
        local reward_args = string.split(cfg.stage_challenge_drop_args, "#")
        assert(reward_args, "reward_args error")
        local resId   = tonumber(reward_args[1])
        local resNum  = tonumber(reward_args[2])
        local resName = y3.userDataHelper.getResName(resId)
        if resId == y3.SurviveConst.RESOURCE_TYPE_GOLD then
            local player = playerData:getPlayer()
            local gold = player:get_attr("gold")
            player:set("gold", gold + resNum)
            -- y3.Sugar.localNotice(playerData:getId(), 2, { floor = cfg.stage_abyss_floor, reward = resName, num = resNum })
        elseif resId == y3.SurviveConst.RESOURCE_TYPE_DIAMOND then
            local player = playerData:getPlayer()
            local gold = player:get_attr("diamond")
            player:set("diamond", gold + resNum)
            -- y3.Sugar.localNotice(playerData:getId(), 2, { floor = cfg.stage_abyss_floor, reward = resName, num = resNum })
        end
    elseif cfg.stage_challenge_drop_type == y3.SurviveConst.REWARD_TYPE_SELECT then
        local abyssChallenge = self._parent:getAbysChallenge()
        if not abyssChallenge then
            return
        end
        abyssChallenge:insertChallengeRecord(cfg.stage_challenge_drop_args, playerData)
    elseif cfg.stage_challenge_drop_type == y3.SurviveConst.RRWARD_TYPE_RANDOM then
        local reward_args = string.split(cfg.stage_challenge_drop_args, "|")
        assert(reward_args, "reward_args error")
        local randList = {}
        for _, reward_arg in ipairs(reward_args) do
            local params = string.split(reward_arg, "#")
            assert(params, "params error")
            local poolId = tonumber(params[1])
            local weight = tonumber(params[2])
            local data = {}
            data.poolId = poolId
            data.weight = weight
            table.insert(randList, data)
        end
        local refreshSkill = y3.gameApp:getLevel():getLogic("SurviveRefreshSkill")
        local randData = SurviveHelper.getRandomDataByWeightList(randList)
        local randomItem = refreshSkill:getRandomItemByPoolId(randData.poolId)
        local itemCfg = include("gameplay.config.random_pool").get(randomItem.id)
        assert(itemCfg, "can not find cfg in random_pool by id=" .. randomItem.id)
        UserDataHelper.dropRandomItem(playerData:getId(), itemCfg)
    end
end

function SurviveGameStageChallenge:_spawnChallengeEnemy(monsterCfg, points, playerData, challengeCfg)
    if #points == 0 then
        return
    end
    local monster = include("gameplay.scene.actor.MonsterActor").new(y3.GameConst.PLAYER_ID_ENEMY, monsterCfg,
        nil, nil, nil, challengeCfg)
    local randomIndex = math.random(1, #points)
    monster:setPosition(points[randomIndex])
    if challengeCfg.stage_challenge_type == 1 then
        monster:replaceMonsterName(y3.Lang.getLang(y3.langCfg.get(46).str_content,
            { floor = challengeCfg.stage_challenge_count, monster_name = monsterCfg.monster_name }))
    elseif challengeCfg.stage_challenge_type == 2 then
        monster:replaceMonsterName(y3.Lang.getLang(y3.langCfg.get(47).str_content,
            { floor = challengeCfg.stage_challenge_count, monster_name = monsterCfg.monster_name }))
    end
    local monsterGroup = self._parent:getMonsterGroup(playerData:getId())
    monster:addToGroup(monsterGroup)
    monster:setOwnPlayerId(playerData:getId())
    monster:getUnit():attack_move(playerData:getMainActor():getUnit():get_point(), 500)
    return monster
end

function SurviveGameStageChallenge:startStageChallenge(playerId)
    -- print("startStageChallenge")
    -- if self._parent:getCurStage_phase() ~= 1 then
    --     return
    -- end
    -- print("startStageChallenge2")
    local challengeParam = self._challengeData[playerId]
    challengeParam.curChallengeIndex = challengeParam.curChallengeIndex + 1
    local cfg = self._challengeList[challengeParam.curChallengeIndex]
    if not cfg then
        return
    end
    local monsterIds = string.split(cfg.stage_challenge_monster_id, "|")
    assert(monsterIds, "monsterIds is nil")
    local randList = {}
    local playerData = y3.userData:getPlayerData(playerId)
    local mainActor = playerData:getMainActor()
    local points = {}
    if self._modeBornType == 2 then
        local pointStart = y3.point.get_point_by_res_id(self._modeBornArgs[playerId])
        points = SurviveHelper.getRandomSpawnPoints(pointStart, 20,
            math.random(0, 360), 1)
    elseif self._modeBornType == 1 then
        points = SurviveHelper.getRandomSpawnPoints(mainActor:getPosition(), cfg.stage_challenge_range,
            math.random(0, 360), 1)
    end

    for _, monsterId in ipairs(monsterIds) do
        local param = string.split(monsterId, "#")
        assert(param, "param is nil")
        local data = {}
        data.monster_id = tonumber(param[1])
        data.count = tonumber(param[2])
        data.weight = tonumber(param[3])
        data.cfg = cfg
        data.uniqueId = self:getUniqueId()
        data.totalDt = 0
        data.points = points
        table.insert(randList, data)
    end
    local randData = SurviveHelper.getRandomDataByWeightList(randList)
    table.insert(self._challengeDoing[playerId], randData)
    y3.Sugar.localNotice(playerId, 4,
        { challenge_type = cfg.stage_challenge_type, round = cfg.stage_challenge_count })
end

function SurviveGameStageChallenge:getUniqueId()
    local id = self._uniqueId
    self._uniqueId = self._uniqueId + 1
    return id
end

return SurviveGameStageChallenge
