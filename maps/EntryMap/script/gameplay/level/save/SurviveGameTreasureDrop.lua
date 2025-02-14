local GameUtils = require "gameplay.utils.GameUtils"
local LogicBase = include("gameplay.level.logic.LogicBase")
local SurviveGameTreasureDrop = class("SurviveGameTreasureDrop", LogicBase)

local MAX_PASS = 2

function SurviveGameTreasureDrop:ctor(level)
    SurviveGameTreasureDrop.super.ctor(self, level)
    self:_initCfg()
end

function SurviveGameTreasureDrop:_initCfg()
    local treasureSaveData = y3.userData:loadTable("Treasure")
    self._treasureSaveData = treasureSaveData

    self._maxRandomNum = 10000
    local random_num = math.random(1, self._maxRandomNum + 1) - 1
    self._random_num = random_num

    self._recordDrops = {}

    local treasure_loot = include("gameplay.config.treasure_loot")
    local len = treasure_loot.length()
    self._stagePassTreaseDropMap = {}
    self._stageChallengeTreasureDropMap = {}
    self._surelyMap = {}
    for i = 1, len do
        local cfg = treasure_loot.indexOf(i)
        assert(cfg, "")
        if cfg.reward_type == 1 then
            if not self._stagePassTreaseDropMap[cfg.stage_id] then
                self._stagePassTreaseDropMap[cfg.stage_id] = {}
            end
            table.insert(self._stagePassTreaseDropMap[cfg.stage_id], cfg)
        else
            if not self._stageChallengeTreasureDropMap[cfg.reward_type] then
                self._stageChallengeTreasureDropMap[cfg.reward_type] = {}
            end
            if not self._stageChallengeTreasureDropMap[cfg.reward_type][cfg.stage_id] then
                self._stageChallengeTreasureDropMap[cfg.reward_type][cfg.stage_id] = {}
            end
            table.insert(self._stageChallengeTreasureDropMap[cfg.reward_type][cfg.stage_id], cfg)
        end
    end
end

function SurviveGameTreasureDrop:randomNum()
    local random_num = math.random(1, self._maxRandomNum + 1) - 1
    self._random_num = random_num
end

function SurviveGameTreasureDrop:_getChallengeData(challengeType)
    local challengeStr = y3.userDataHelper.getSaveDataDecryptConcat(self._treasureSaveData["challenge" .. challengeType])
    local saveData = {}
    saveData.year = tonumber(challengeStr[1]) or 0
    saveData.month = tonumber(challengeStr[2]) or 0
    saveData.day = tonumber(challengeStr[3]) or 0
    saveData.count = tonumber(challengeStr[4]) or 0
    print("---------------------------------------")
    print(saveData.year, saveData.month, saveData.day, saveData.count)
    return saveData
end

function SurviveGameTreasureDrop:_saveChallengeData(challengeType, saveData)
    local serverData = y3.gameUtils.get_server_time(8)
    local year, month, day = GameUtils.getCurrentDate(serverData.timestamp)
    saveData.year = year
    saveData.month = month
    saveData.day = day
    local enctryStr = y3.userDataHelper.getSaveDataEncryptConcat(saveData.year, saveData.month, saveData.day,
        saveData.count)
    self._treasureSaveData["challenge" .. challengeType] = enctryStr
end

function SurviveGameTreasureDrop:_getChallengeTypeTodayCount(challengeType)
    local saveData = self:_getChallengeData(challengeType)
    local serverData = y3.gameUtils.get_server_time(8)
    local year, month, day = GameUtils.getCurrentDate(serverData.timestamp)
    if year == saveData.year and month == saveData.month and day == saveData.day then
        return saveData.count
    else
        return 0
    end
end

function SurviveGameTreasureDrop:updateStagePass(playerId, stageId, isChallenge, challengeType)
    if playerId ~= y3.gameApp:getMyPlayerId() then
        return
    end
    log.info("SurviveGameTreasureDrop:updateStagePass", playerId, stageId, isChallenge)
    xpcall(function(...)
        challengeType = challengeType or 1
        local playerData = y3.userData:getPlayerData(playerId)
        local player = playerData:getPlayer()
        local passCount = self:_getChallengeTypeTodayCount(challengeType)
        print("passCount", challengeType, passCount)
        if isChallenge then
            -- if passCount >= MAX_PASS and not y3.userDataHelper.has_store_item(player, y3.SurviveConst.PLATFORM_ITEM_MAP.CANGPINGUANJIA) then
            --     self:_challengeOutDrop(stageId)
            --     return
            -- else
            local saveData = self:_getChallengeData(challengeType)
            local serverData = y3.gameUtils.get_server_time()
            local year, month, day = GameUtils.getCurrentDate(serverData.timestamp)
            if year == saveData.year and month == saveData.month and day == saveData.day then
                saveData.count = saveData.count + 1
            else
                saveData.count = 1
            end
            self:_saveChallengeData(challengeType, saveData)
            -- end
        end
        local stageCfg = include("gameplay.config.stage_config").get(stageId)
        assert(stageCfg, "not found stage cfg by id=" .. stageId)
        if stageCfg.stage_type == 1 then
            if isChallenge and passCount == 0 then
                if y3.userDataHelper.has_store_item(player, y3.SurviveConst.PLATFORM_ITEM_MAP.CANGPINGUANJIA) then
                    self:_dropTreasure(stageId, isChallenge, challengeType)
                    self._random_num = math.floor(self._random_num - self._random_num / 2) + 1
                    self:_dropTreasure(stageId, isChallenge, challengeType)
                    return
                end
            end
        end
        print("stage pass drop", stageId, isChallenge, challengeType)
        self:_dropTreasure(stageId, isChallenge, challengeType)
    end, __G__TRACKBACK__)
end

function SurviveGameTreasureDrop:_challengeOutDrop(stageId)
    local stageCfg = include("gameplay.config.stage_config").get(stageId)
    if stageCfg then
        local rewards = string.split(stageCfg.challenge_repeat_reward, "#")
        if rewards and tonumber(rewards[1]) then
            local saveItemLogic = y3.gameApp:getLevel():getLogic("SurviveGameSaveItem")
            print("challenge out drop", stageId, rewards[1], rewards[2])
            local rewardSize = tonumber(rewards[2])
            local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
            local player = playerData:getPlayer()
            if y3.userDataHelper.has_store_item(player, y3.SurviveConst.PLATFORM_ITEM_MAP.CANGPINGUANJIA) then
                rewardSize = math.ceil(rewardSize + rewardSize * 0.5)
            end
            saveItemLogic:dropSaveItem(y3.gameApp:getMyPlayerId(), tonumber(rewards[1]), rewardSize)
            -- y3.Sugar.recordPlayerDrop(y3.gameApp:getMyPlayerId(), {
            --     type = y3.SurviveConst.DROP_TYPE_SAVE_ITEM,
            --     value = tonumber(rewards[1]),
            --     size = rewardSize
            -- })
        end
    end
end

function SurviveGameTreasureDrop:_getDropData(randDataList, maxWeight)
    for i = 1, #randDataList do
        local data = randDataList[i]
        data.weight = math.floor(data.weight / maxWeight * self._maxRandomNum)
    end
    local pro = self._random_num
    local lastPro = 0
    for i = 1, #randDataList do
        if pro > lastPro and pro <= lastPro + randDataList[i].weight then
            return randDataList[i]
        end
        lastPro = lastPro + randDataList[i].weight
    end
    return randDataList[1]
end

function SurviveGameTreasureDrop:_dropTreasure(stageId, isChallenge, challengeType)
    local list = self._stagePassTreaseDropMap[stageId] or {}
    if isChallenge then
        list = self._stageChallengeTreasureDropMap[challengeType][stageId] or {}
    end
    if #list == 0 then
        return
    end
    local surlyMap = {}
    local surlyList = {}
    local stagePass = y3.gameApp:getLevel():getLogic("SurviveGameStagePass")
    local passCount = stagePass:getPassCount(y3.gameApp:getMyPlayerId(), stageId)
    local randDataList = {}
    local maxWeight = 0
    for _, cfg in ipairs(list) do
        if cfg.surely_id > 0 then
            if not surlyMap[cfg.surely_id] then
                surlyMap[cfg.surely_id] = {}
                table.insert(surlyList, cfg.surely_id)
            end
            table.insert(surlyMap[cfg.surely_id], cfg)
        end
        if passCount >= cfg.limit then
            local data = {}
            data.cfg = cfg
            data.weight = cfg.rate
            maxWeight = maxWeight + data.weight
            table.insert(randDataList, data)
        end
    end
    local hitSurlyList = {}
    local hitSurlyId = 0
    for i = 1, #surlyList do
        local surlyId = surlyList[i]
        local baodiCount = self._treasureSaveData["surly_" .. surlyId] or 0
        local cfg = surlyMap[surlyId][1]
        if baodiCount >= cfg.surely_num then
            hitSurlyList = surlyMap[surlyId]
            hitSurlyId = surlyId
            self._treasureSaveData["surly_" .. surlyId] = 0
            break
        end
    end
    if #hitSurlyList > 0 then
        randDataList = {}
        maxWeight = 0
        for i, cfg in ipairs(hitSurlyList) do
            local data = {}
            data.cfg = cfg
            data.weight = cfg.rate
            maxWeight = maxWeight + data.weight
            table.insert(randDataList, data)
        end
    end
    for i = 1, #surlyList do
        local surlyId = surlyList[i]
        if hitSurlyId ~= surlyId then
            if not self._treasureSaveData["surly_" .. surlyId] then
                self._treasureSaveData["surly_" .. surlyId] = 1
            else
                self._treasureSaveData["surly_" .. surlyId] = self._treasureSaveData["surly_" .. surlyId] + 1
            end
        end
    end
    local data = self:_getDropData(randDataList, maxWeight)
    if data then
        self:_recordTreasure(data)
    end
end

function SurviveGameTreasureDrop:_recordTreasure(data)
    local cfg = data.cfg
    if cfg.surely_id > 0 then
        self._treasureSaveData["surly_" .. cfg.surely_id] = 0
    end
    if not self._treasureSaveData[cfg.treasure_id] then
        local treasureLogic = y3.gameApp:getLevel():getLogic("SurviveGameTreasure")
        treasureLogic:dropTreasure(y3.gameApp:getMyPlayerId(), cfg.treasure_id)
        y3.Sugar.recordPlayerDrop(y3.gameApp:getMyPlayerId(),
            { type = y3.SurviveConst.DROP_TYPE_TREASURE, value = cfg.treasure_id, size = 1 })
        print("drop treasure", cfg.treasure_id)
    else
        local treasureCfg = include("gameplay.config.treasure").get(cfg.treasure_id)
        assert(treasureCfg, "not found treasure cfg by id=" .. cfg.treasure_id)
        local saveItemLogic = y3.gameApp:getLevel():getLogic("SurviveGameSaveItem")
        local sells = string.split(treasureCfg.sell, "#")
        assert(sells, "")
        local sellNums = tonumber(sells[2])
        local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
        local player = playerData:getPlayer()
        if y3.userDataHelper.has_store_item(player, y3.SurviveConst.PLATFORM_ITEM_MAP.CANGPINGUANJIA) then
            sellNums = math.ceil(sellNums + sellNums * 0.5)
        end
        saveItemLogic:dropSaveItem(y3.gameApp:getMyPlayerId(), tonumber(sells[1]), sellNums)
        print("drop save item", sells[1], sells[2])
    end
end

function SurviveGameTreasureDrop:dropPureTreasureType(playerId, stageId, challengeType)
    y3.player.with_local(function(local_player)
        xpcall(function(...)
            if local_player:get_id() == playerId then
                self:_dropTreasure(stageId, true, challengeType)
            end
        end, __G__TRACKBACK__)
    end)
end

function SurviveGameTreasureDrop:dropPureTreasure(playerId, treasureId)
    if playerId ~= y3.gameApp:getMyPlayerId() then
        return
    end
    log.info("SurviveGameTreasureDrop:dropPureTreasure", playerId, treasureId)
    xpcall(function(...)
        local treasureCfg = include("gameplay.config.treasure").get(treasureId)
        assert(treasureCfg, "not found treasure cfg by id=" .. treasureId)
        if not self._treasureSaveData[treasureCfg.id] then
            local treasureLogic = y3.gameApp:getLevel():getLogic("SurviveGameTreasure")
            treasureLogic:dropTreasure(playerId, treasureCfg.id)
            y3.Sugar.recordPlayerDrop(playerId,
                { type = y3.SurviveConst.DROP_TYPE_TREASURE, value = treasureCfg.id, size = 1 })
            print("drop treasure", treasureCfg.id)
        else
            local saveItemLogic = y3.gameApp:getLevel():getLogic("SurviveGameSaveItem")
            local sells = string.split(treasureCfg.sell, "#")
            assert(sells, "")
            saveItemLogic:dropSaveItem(playerId, tonumber(sells[1]), tonumber(sells[2]))
            -- y3.Sugar.recordPlayerDrop(playerId,
            --     { type = y3.SurviveConst.DROP_TYPE_SAVE_ITEM, value = tonumber(sells[1]), size = tonumber(sells[2]) })
            -- print("drop save item", sells[1], sells[2])
        end
    end, __G__TRACKBACK__)
end

return SurviveGameTreasureDrop
