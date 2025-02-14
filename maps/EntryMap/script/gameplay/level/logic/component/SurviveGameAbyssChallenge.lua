local UserDataHelper = include "gameplay.level.logic.helper.UserDataHelper"
local SurviveHelper = include "gameplay.level.logic.helper.SurviveHelper"
local GlobalConfigHelper = include "gameplay.level.logic.helper.GlobalConfigHelper"
local SurviveGameAbyssChallenge = class("SurviveGameAbyssChallenge")

function SurviveGameAbyssChallenge:ctor(parent)
    self._parent = parent
    self:_initCfg()
end

function SurviveGameAbyssChallenge:_initCfg()
    self._curStageConfig = include("gameplay.config.stage_config").get(y3.userData:getCurStageId())
    self._curModeCfg = include("gameplay.config.stage_mode").get(self._curStageConfig.stage_type)
    local stage_wave_born_poins = string.split(self._curModeCfg.abyss_born_points, "|")
    assert(stage_wave_born_poins, "")
    self._modeBornType = tonumber(stage_wave_born_poins[1])
    local modeBornArgs = string.split(stage_wave_born_poins[2], "#")
    assert(modeBornArgs, "")
    self._modeBornArgs = {}
    for i = 1, #modeBornArgs do
        self._modeBornArgs[i] = tonumber(modeBornArgs[i])
    end

    self._spawnInterTime = GlobalConfigHelper.get(38)
    self._startReadyTime = GlobalConfigHelper.get(20)
    local stage_abyss = include("gameplay.config.stage_abyss")
    local len = stage_abyss.length()
    self._challengeList = {}
    for i = 1, len do
        local cfg = stage_abyss.indexOf(i)
        table.insert(self._challengeList, cfg)
    end
    local stage_abyss_spwan = include("gameplay.config.stage_abyss_spwan")
    self._challengeSpawnMap = {}
    local len = stage_abyss_spwan.length()
    for i = 1, len do
        local cfg = stage_abyss_spwan.indexOf(i)
        if not self._challengeSpawnMap[cfg.abyss_monster_id] then
            self._challengeSpawnMap[cfg.abyss_monster_id] = {}
        end
        table.insert(self._challengeSpawnMap[cfg.abyss_monster_id], cfg)
    end

    self._abyssChallengeData = {}
    self._abyssChallengeRecord = {}
    local allPlayers = y3.userData:getAllInPlayers()
    for _, playerData in ipairs(allPlayers) do
        local param = {}
        param.readyTime = 0 --self._startReadyTime
        param.maxReadyTime = self._startReadyTime
        param.curChallenge = 1
        param.challenging = false
        param.protecTime = 0
        param.spawnDoorMinTime = 0
        param.isOpened = false
        self._abyssChallengeData[playerData:getId()] = param
        self._abyssChallengeRecord[playerData:getId()] = {}
    end
    self._abyssShop = include("gameplay.level.logic.component.SurviveGameAbyssShop").new(self)
end

function SurviveGameAbyssChallenge:getShop()
    return self._abyssShop
end

function SurviveGameAbyssChallenge:getChallengeParam(playerId)
    local challengeParam = self._abyssChallengeData[playerId]
    local cfg = self._challengeList[challengeParam.curChallenge]
    local isEnd = true --cfg and false or true
    if cfg then
        isEnd = false
    end
    local curChallenge = challengeParam.curChallenge
    if not cfg then
        curChallenge = curChallenge - 1
    end
    return curChallenge, challengeParam.challenging, challengeParam.readyTime, challengeParam
        .maxReadyTime, challengeParam.challengingTime, challengeParam.maxChallengingTime, isEnd, challengeParam.close
end

function SurviveGameAbyssChallenge:getChallengeFloor(playerId)
    local challengeParam = self._abyssChallengeData[playerId]
    local cfg = self._challengeList[challengeParam.curChallenge] or self._challengeList[#self._challengeList]
    return cfg.stage_abyss_floor
end

function SurviveGameAbyssChallenge:doChallenge(delay)
    local allPlayers = y3.userData:getAllInPlayers()
    for _, playerData in ipairs(allPlayers) do
        self:_doPlayerChallenge(playerData, delay)
    end
end

function SurviveGameAbyssChallenge:_doPlayerChallenge(playerData, delay)
    local challengeParam = self._abyssChallengeData[playerData:getId()]
    if not challengeParam.isOpened then
        challengeParam.isOpened = y3.FuncCheck.checkFuncIsOpen(playerData:getId(), y3.FuncConst.FUNC_ABYSS)
        return
    end
    if challengeParam.readyTime > 0 then
        challengeParam.readyTime = challengeParam.readyTime - delay
    end
    if challengeParam.protecTime > 0 then
        challengeParam.protecTime = challengeParam.protecTime - delay
        if challengeParam.protecTime <= 0 then
            if challengeParam.autoNext then
                self:startChallenge(playerData:getId())
            end
        end
    end
    if challengeParam.spawnDoorMinTime > 0 then
        challengeParam.spawnDoorMinTime = challengeParam.spawnDoorMinTime - delay
        if challengeParam.spawnDoorMinTime <= 0 then
            if challengeParam.door then
                challengeParam.door:remove()
                challengeParam.door = nil
            end
        end
    end
    if challengeParam.challenging then
        challengeParam.challengingTime = challengeParam.challengingTime - delay
        challengeParam.spawnDt = challengeParam.spawnDt + delay
        if challengeParam.spawnDt >= self._spawnInterTime and challengeParam.count > 0 then
            challengeParam.count = challengeParam.count - 1
            challengeParam.spawnDt = 0
            local pointIndex = challengeParam.maxCount - challengeParam.count
            local monsterCfg = include("gameplay.config.monster").get(challengeParam.monster_id)
            local cfg = self._challengeList[challengeParam.curChallenge]
            local monster = self:_spawnChallengeEnemy(monsterCfg, challengeParam.spawnPoints, playerData, cfg,
                pointIndex)
            if monster and monsterCfg then
                monster:replaceMonsterName(y3.Lang.getLang(y3.langCfg.get(39).str_content,
                    { monster_name = monsterCfg.monster_name, floor = cfg.stage_abyss_floor }))
            end
            table.insert(challengeParam.monsterList, monster)
        end
        if challengeParam.challengingTime <= 0 then
            local killList = {}
            for i, monster in ipairs(challengeParam.monsterList) do
                if not monster:isDie() then
                    monster:getUnit():kill_by()
                    table.insert(killList, monster:getUnit():get_id())
                end
            end
            y3.eca.call("击杀特效", { [1] = killList, [2] = "深渊", [3] = playerData:getId() })
            local cfg = self._challengeList[challengeParam.curChallenge]
            y3.Sugar.localNotice(playerData:getId(), 3, { floor = cfg.stage_abyss_floor })
            challengeParam.challenging = false
            self:addAbyssChallengeFlag(playerData:getId(), false)
            challengeParam.readyTime = cfg.count_down
            challengeParam.maxReadyTime = cfg.count_down
        else
            local killCount = 0
            for i, monster in ipairs(challengeParam.monsterList) do
                if monster:isDie() then
                    killCount = killCount + 1
                end
            end
            if killCount >= challengeParam.maxCount then
                local cfg = self._challengeList[challengeParam.curChallenge]
                challengeParam.curChallenge = challengeParam.curChallenge + 1
                challengeParam.challenging = false
                self:addAbyssChallengeFlag(playerData:getId(), false)
                self:_doReward(cfg.fixed_reward_type, cfg.fixed_reward_args, playerData, cfg)
                self:_doReward(cfg.reward_type, cfg.reward_args, playerData, cfg)

                if challengeParam.protecTime <= 0 then
                    self:startChallenge(playerData:getId())
                else
                    challengeParam.autoNext = true
                end
            end
        end
    end
end

function SurviveGameAbyssChallenge:getChallengeRemainMonsterNum(playerId)
    local challengeParam = self._abyssChallengeData[playerId]
    if challengeParam.challenging then
        local maxCount = challengeParam.maxCount or 0
        local monsterList = challengeParam.monsterList or {}
        local dieCount = 0
        for i = 1, #monsterList do
            if monsterList[i]:isDie() then
                dieCount = dieCount + 1
            end
        end
        return maxCount - dieCount
    end
    return 0
end

function SurviveGameAbyssChallenge:_doReward(reward_type, reward_args, playerData, cfg)
    -- print("doReward", cfg.reward_type, cfg.reward_args)
    if reward_type == y3.SurviveConst.REWARD_TYPE_RES then
        local reward_args = string.split(reward_args, "#")
        assert(reward_args, "reward_args error")
        local resId   = tonumber(reward_args[1])
        local resNum  = tonumber(reward_args[2])
        local resName = y3.userDataHelper.getResName(resId)
        if resId == y3.SurviveConst.RESOURCE_TYPE_GOLD then
            local player = playerData:getPlayer()
            local gold = player:get_attr("gold")
            player:set("gold", gold + resNum)
            y3.Sugar.localNotice(playerData:getId(), 2, { floor = cfg.stage_abyss_floor, reward = resName, num = resNum })
        elseif resId == y3.SurviveConst.RESOURCE_TYPE_DIAMOND then
            local player = playerData:getPlayer()
            local gold = player:get_attr("diamond")
            player:set("diamond", gold + resNum)
            y3.Sugar.localNotice(playerData:getId(), 2, { floor = cfg.stage_abyss_floor, reward = resName, num = resNum })
        end
    elseif reward_type == y3.SurviveConst.REWARD_TYPE_SELECT then
        self:insertChallengeRecord(reward_args, playerData)
    elseif reward_type == y3.SurviveConst.RRWARD_TYPE_RANDOM then
        local reward_args = string.split(reward_args, "|")
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

function SurviveGameAbyssChallenge:insertChallengeRecord(reward_args, playerData)
    local reward_args = string.split(reward_args, "|")
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
    local result = {}
    local recordList = self._abyssChallengeRecord[playerData:getId()]
    table.insert(recordList, { type = 1, list = result })

    local refreshSkill = y3.gameApp:getLevel():getLogic("SurviveRefreshSkill")
    for i = 1, 3 do
        local randData = SurviveHelper.getRandomDataByWeightList(randList)
        local randomItem = refreshSkill:getRandomItemByPoolId(randData.poolId)
        table.insert(result, { id = randomItem.id, random_pool_item = randomItem.random_pool_item })
    end
    y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SURVIVE_SELECT_REWARD_ADD, playerData:getId())
end

function SurviveGameAbyssChallenge:insertChallengeRecordData(playerId, list, recordType, needShow)
    -- print("insertChallengeRecordData", playerId, list, recordType, needShow)
    local result = {}
    local recordList = self._abyssChallengeRecord[playerId] or {}
    table.insert(recordList, { type = recordType or 1, list = result })
    for i = 1, #list do
        table.insert(result, { id = list[i].id, random_pool_item = list[i].random_pool_item })
    end
    y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SURVIVE_SELECT_REWARD_ADD, playerId)
    if needShow then
        y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SURVIVE_SELECT_REWARD, #recordList, playerId)
    end
end

function SurviveGameAbyssChallenge:getAbyssChallengeRecordList(playerId, index)
    local recordList = self._abyssChallengeRecord[playerId]
    return recordList[index]
end

function SurviveGameAbyssChallenge:getAbyssChallengeRecordNum(playerId)
    local recordList = self._abyssChallengeRecord[playerId] or {}
    return #recordList
end

function SurviveGameAbyssChallenge:getAbyssChallengeRecordNumByType(playerId, recordType)
    local recordList = self._abyssChallengeRecord[playerId] or {}
    local count = 0
    for i = 1, #recordList do
        if recordList[i].type == recordType then
            count = count + 1
        end
    end
    return count
end

function SurviveGameAbyssChallenge:removeRecordList(playerId, index)
    local recordList = self._abyssChallengeRecord[playerId] or {}
    if #recordList > 0 then
        table.remove(recordList, index)
        y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SURVIVE_SELECT_REWARD_ADD, playerId)
    end
end

function SurviveGameAbyssChallenge:refreshRecordRewardList(playerId, recordType)
    local recordList = self._abyssChallengeRecord[playerId]
    if #recordList > 0 then
        local index = 0
        for i = 1, #recordList do
            if recordList[i].type == recordType then
                index = i
            end
        end
        if index == 0 then
            if recordType == 1 then
                for i = 1, #recordList do
                    if recordList[i].type == 3 then
                        index = i
                    end
                end
            end
        end
        if index == 0 then
            if recordType == 1 then
                for i = 1, #recordList do
                    if recordList[i].type == 4 then
                        index = i
                    end
                end
            end
        end
        if index > 0 then
            y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SURVIVE_SELECT_REWARD, index, playerId)
        end
    end
end

function SurviveGameAbyssChallenge:_spawnChallengeEnemy(monsterCfg, points, playerData, challengeCfg, index)
    if #points == 0 then
        return
    end
    local monster = include("gameplay.scene.actor.MonsterActor").new(y3.GameConst.PLAYER_ID_ENEMY, monsterCfg,
        nil, nil, nil, nil, challengeCfg)
    monster:setPosition(points[index])
    monster:addToGroup(self._parent:getMonsterGroup(playerData:getId()))
    monster:setOwnPlayerId(playerData:getId())
    monster:getUnit():attack_move(playerData:getMainActor():getUnit():get_point(), 500)
    return monster
end

function SurviveGameAbyssChallenge:forcecloseChallenge(playerId, close)
    local challengeParam = self._abyssChallengeData[playerId]
    challengeParam.close = close
    self:closeChallenge(playerId)
end

function SurviveGameAbyssChallenge:closeChallenge(playerId)
    local challengeParam = self._abyssChallengeData[playerId]
    challengeParam.challenging = false
    self:addAbyssChallengeFlag(playerId, false)
    challengeParam.readyTime = challengeParam.maxReadyTime
    challengeParam.autoNext = false
    -- print("closeChallenge", playerId)
    if challengeParam.monsterList then
        local killList = {}
        for i, monster in ipairs(challengeParam.monsterList) do
            if not monster:isDie() then
                monster:getUnit():kill_by()
                table.insert(killList, monster:getUnit():get_id())
            end
        end
        y3.eca.call("击杀特效", { [1] = killList, [2] = "深渊", [3] = playerId })
    end
    if challengeParam.door then
        challengeParam.door:remove()
        challengeParam.door = nil
    end
end

function SurviveGameAbyssChallenge:addAbyssChallengeFlag(playerId, bFlag)
    local playerData = y3.userData:getPlayerData(playerId)
    local mainActor = playerData:getMainActor()
    if mainActor then
        mainActor:getUnit():kv_save("abyssFlag", bFlag)
    end
end

function SurviveGameAbyssChallenge:startChallenge(playerId)
    local challengeParam = self._abyssChallengeData[playerId]
    local cfg = self._challengeList[challengeParam.curChallenge]
    if not cfg then
        y3.Sugar.localTips(playerId, y3.Lang.getLang(y3.langCfg.get(12).str_content))
        return
    end
    if challengeParam.close then
        y3.Sugar.localTips(playerId, y3.Lang.getLang(y3.langCfg.get(11).str_content))
        return
    end
    if challengeParam.readyTime > 0 then
        return
    end
    if challengeParam.challenging then
        self:closeChallenge(playerId)
        return
    end
    if challengeParam.protecTime > 0 then
        return
    end
    local playerData = y3.userData:getPlayerData(playerId)
    local mainActor = playerData:getMainActor()
    if mainActor:isDieFianl() then
        y3.Sugar.localTips(playerId, y3.langCfg.get(68).str_content)
        return
    end
    challengeParam.challenging = true
    challengeParam.autoNext = false
    self:addAbyssChallengeFlag(playerId, true)
    local monsterIds = string.split(cfg.stage_challenge_monster_id, "|")
    assert(monsterIds, "monsterIds error")
    local randList = {}
    for _, monsterId in ipairs(monsterIds) do
        local params = string.split(monsterId, "#")
        assert(params, "params error")
        local monster_id = tonumber(params[1])
        local count = tonumber(params[2])
        local weight = tonumber(params[3])
        local data = {}
        data.monster_id = monster_id
        data.count = count
        data.weight = weight
        table.insert(randList, data)
    end
    local randData                   = SurviveHelper.getRandomDataByWeightList(randList)
    local spawnCfg                   = self:_getStageAbyssSpawnCfg(randData.monster_id, cfg)
    local playerData                 = y3.userData:getPlayerData(playerId)
    local mainActor                  = playerData:getMainActor()
    local abyss_monster_spawn_ranges = string.split(spawnCfg.abyss_monster_spawn_range, "|")
    assert(abyss_monster_spawn_ranges, "abyss_monster_spawn_ranges error")
    local randList2 = {}
    for _, abyss_monster_spawn_range in ipairs(abyss_monster_spawn_ranges) do
        local params = string.split(abyss_monster_spawn_range, "#")
        local range = tonumber(params[1])
        local weight = tonumber(params[2])
        local data = {}
        data.range = range
        data.weight = weight
        table.insert(randList2, data)
    end
    local randData2 = SurviveHelper.getRandomDataByWeightList(randList2)

    local points = {}
    if self._modeBornType == 2 then
        local pointStart = y3.point.get_point_by_res_id(self._modeBornArgs[playerId])
        points = SurviveHelper.getRandomSpawnPoints(pointStart, 20, math.random(0, 360),
            randData.count)
    elseif self._modeBornType == 1 then
        points = SurviveHelper.getRandomSpawnPoints(mainActor:getPosition(), randData2.range, math.random(0, 360),
            randData.count)
    end

    if spawnCfg.abyss_monster_spawn_door > 0 then
        local door = y3.particle.create({ type = spawnCfg.abyss_monster_spawn_door, target = points[1], time = -1 })
        challengeParam.door = door
    end
    local pointToEcas = {}
    for i = 1, #points do
        table.insert(pointToEcas, { x = points[i]:get_x(), y = points[i]:get_y(), z = points[i]:get_z() })
    end
    -- dump_all(pointToEcas)
    local playerData = y3.userData:getPlayerData(playerId)
    local mainActor = playerData:getMainActor()
    if mainActor then
        local unit = mainActor:getUnit()
        y3.eca.call('刷怪特效',
            {
                [1] = pointToEcas,
                [2] = self._spawnInterTime,
                [3] = { x = unit:get_point():get_x(), y = unit:get_point():get_y() },
                [4] = playerId
            })
    end
    challengeParam.spawnPoints = points
    challengeParam.monster_id = randData.monster_id
    challengeParam.count = randData.count
    challengeParam.spawnDt = 0
    challengeParam.challengingTime = cfg.stage_abyss_challenge_time_require
    challengeParam.maxChallengingTime = cfg.stage_abyss_challenge_time_require
    challengeParam.monsterList = {}
    challengeParam.maxCount = randData.count
    challengeParam.maxReadyTime = cfg.count_down
    challengeParam.protecTime = cfg.stage_abyss_protect_time
    challengeParam.spawnDoorMinTime = spawnCfg.abyss_monster_spawn_door_min_time
    y3.Sugar.localNotice(playerId, 20, {
        floor = cfg.stage_abyss_floor,
        require_time = math.floor(cfg
            .stage_abyss_challenge_time_require)
    })
    y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SURVIVE_ABYSS_START_CHALLENGE, playerId)
end

function SurviveGameAbyssChallenge:_getStageAbyssSpawnCfg(monsterId, challengeCfg)
    local list = self._challengeSpawnMap[monsterId] or {}
    if #list == 0 then
        local range = GlobalConfigHelper.get(4)
        return { stage_abyss_floor = 0, abyss_monster_spawn_range = range .. "#100", abyss_monster_spawn_door = 0, abyss_monster_spawn_door_min_time = 1 }
    end
    local retCfg = list[#list]
    for i = 1, #list do
        if challengeCfg.stage_abyss_floor <= list[i].abyss_max_floor then
            retCfg = list[i]
            break
        end
    end
    return retCfg
end

return SurviveGameAbyssChallenge
