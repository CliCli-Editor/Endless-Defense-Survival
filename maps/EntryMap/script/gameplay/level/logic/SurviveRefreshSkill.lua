local GlobalConfigHelper = require "gameplay.level.logic.helper.GlobalConfigHelper"
local LogicBase = include("gameplay.level.logic.LogicBase")
local SurviveRefreshSkill = class("SurviveRefreshSkill", LogicBase)
local SurviveHelper = include("gameplay.level.logic.helper.SurviveHelper")
local stage_shop = include("gameplay.config.stage_shop")


local REFRESH_TIME = 5
local MAX_SLOT = 8
local SPLIT_NUM = 4
local LOCK_TIME = 0

function SurviveRefreshSkill:ctor(level)
    SurviveRefreshSkill.super.ctor(self, level)

    y3.gameApp:addTimerLoop(0.5, handler(self, self._refreshLogic))
    -- self._totalDt = 0
    -- self._skillCount = REFRESH_TIME
    self._staticsPool = {}
    self._refreshCount = 0
    self._refreshCountMap = {}
    self._guarantMaps = {}
    self._buySkillMap = {}
    self._buySkillCountMap = {}
    self._buySkillClassMap = {}
    self._refreshShopTotal = 0
    self._stopAutoRefresh = false
    self._recordAutoBuy = {}
    self:_initCfg()
    self:_initRefreshParam()
end

function SurviveRefreshSkill:setStopAutoRefresh(stop)
    self._stopAutoRefresh = stop
    local allPlayers = y3.userData:getAllInPlayers()
    for i, playerData in ipairs(allPlayers) do
        local param = self._refreshSkillParamMap[playerData:getId()]
        param.shop_duration = param.max_duration - 1
    end
end

function SurviveRefreshSkill:isStopAutoRefresh()
    return self._stopAutoRefresh
end

function SurviveRefreshSkill:onEventLeanrSkillSuccess(playerId, skillId, poolId, slot)
    -- print("SurviveRefreshSkill:_onEventLeanrSkillSuccess", playerId, skillId)
    local param = self._refreshSkillParamMap[playerId]
    local playerData = y3.userData:getPlayerData(playerId)
    if param.curStageIndex == playerData:getRandomPoolStageIndex() then
        local skillCfg = include("gameplay.config.config_skillData").get(skillId)
        assert(skillCfg, "")

        if not self._buySkillMap[playerId] then
            self._buySkillMap[playerId] = {}
        end
        if not self._buySkillMap[playerId][skillCfg.type] then
            self._buySkillMap[playerId][skillCfg.type] = 0
        end
        self._buySkillMap[playerId][skillCfg.type] = self._buySkillMap[playerId][skillCfg.type] + 1

        if not self._buySkillCountMap[playerId] then
            self._buySkillCountMap[playerId] = {}
        end
        if not self._buySkillCountMap[playerId][skillCfg.id] then
            self._buySkillCountMap[playerId][skillCfg.id] = 0
        end
        self._buySkillCountMap[playerId][skillCfg.id] = self._buySkillCountMap[playerId][skillCfg.id] + 1

        if skillCfg.type >= 1 and skillCfg.type <= 5 then
            if not self._buySkillClassMap[playerId] then
                self._buySkillClassMap[playerId] = {}
            end
            if not self._buySkillClassMap[playerId][skillCfg.class] then
                self._buySkillClassMap[playerId][skillCfg.class] = 0
            end
            self._buySkillClassMap[playerId][skillCfg.class] = self._buySkillClassMap[playerId][skillCfg.class] + 1
        end

        if param.curStageCfg.shop_type == 1 then
            param.freeCount = 0
        end
        self._refreshShopTotal = 0
        playerData:setRandomPoolState(slot, 1)
        y3.Sugar.achievement():updateAchievement(playerId, y3.SurviveConst.ACHIEVEMENT_REFRESH_TYPE_BUY_SKILL)
        y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SURVIVE_REFRESH_SKILl, playerId)
    end
end

function SurviveRefreshSkill:getRefreshShopTotal()
    return self._refreshShopTotal
end

function SurviveRefreshSkill:buySkillIsSingal(playerId)
    local count = 0
    for skillType = 1, 5 do
        if self._buySkillMap[playerId] and self._buySkillMap[playerId][skillType] then
            count = count + 1
        end
    end
    return count == 1
end

function SurviveRefreshSkill:buySkillCount(playerId, skillId)
    local skillId = tostring(skillId)
    if self._buySkillCountMap[playerId] and self._buySkillCountMap[playerId][skillId] then
        return self._buySkillCountMap[playerId][skillId]
    end
    return 0
end

function SurviveRefreshSkill:buySkillClassCount(playerId, class)
    if self._buySkillClassMap[playerId] and self._buySkillClassMap[playerId][class] then
        return self._buySkillClassMap[playerId][class]
    end
    return 0
end

function SurviveRefreshSkill:getRefresfSkillTime(playerId)
    local param = self._refreshSkillParamMap[playerId]
    return param.shop_duration
end

function SurviveRefreshSkill:getRefresfMaxSkillTime(playerId)
    local param = self._refreshSkillParamMap[playerId]
    return param.max_duration
end

function SurviveRefreshSkill:getCostGoldRefreshShop(playerId)
    local param = self._refreshSkillParamMap[playerId]
    local baseCost = GlobalConfigHelper.get(2)
    local costAdd = GlobalConfigHelper.get(3)
    local costGold = baseCost + costAdd * param.totalRefreshCount
    local playerData = y3.userData:getPlayerData(playerId)
    local player = playerData:getPlayer()
    if y3.userDataHelper.has_store_item(player, y3.SurviveConst.PLATFORM_ITEM_MAP.JINSHOUZHI) then
        costGold = math.floor(costGold - costGold * 0.2)
    end
    return costGold
end

function SurviveRefreshSkill:getRefreshCount(playerId)
    local param = self._refreshSkillParamMap[playerId]
    local costGold = self:getCostGoldRefreshShop(playerId)
    local playerData = y3.userData:getPlayerData(playerId)
    local mainActor = playerData:getMainActor()
    local unitFreeCount = 0
    if mainActor then
        unitFreeCount = math.floor(mainActor:getUnit():get_attr("刷新免费次数"))
    end
    return param.freeCount + unitFreeCount, param.refreshCount, param.curStageCfg.shop_refresh_free_times,
        param.curStageCfg.shop_refresh_limit, costGold
end

function SurviveRefreshSkill:_initRefreshParam()
    self._refreshSkillParamMap = {}
    self._buySkillGoldMap = {}
    local players = y3.userData:getAllInPlayers()
    for i, playerData in ipairs(players) do
        local param = {}
        param.shop_duration = 0
        param.max_duration = 0
        param.curStageIndex = 0
        param.curStageCfg = self._stageList[1]
        param.buy = false
        param.refreshCount = 0
        param.freeCount = 0
        param.totalRefreshCount = 0
        param.shopLevel = 1
        param.shopExp = 0
        self._refreshSkillParamMap[playerData:getId()] = param
        self._buySkillGoldMap[playerData:getId()] = {}
        self._recordAutoBuy[playerData:getId()] = {}
    end
end

function SurviveRefreshSkill:_initCfg()
    local maxUnlookStageId = y3.userData:getMaxUnLockStageId()
    local stage_shop       = include("gameplay.config.stage_shop")
    local len              = stage_shop.length()
    self._stageList        = {}
    for i = 1, len do
        local cfg = stage_shop.indexOf(i)
        table.insert(self._stageList, cfg)
    end
    local gift_pool = include("gameplay.config.gift_pool")
    local len = gift_pool.length()
    self._giftPoolMaps = {}
    for i = 1, len do
        local cfg = gift_pool.indexOf(i)
        if not self._giftPoolMaps[cfg.pool_id] then
            self._giftPoolMaps[cfg.pool_id] = {}
        end
        table.insert(self._giftPoolMaps[cfg.pool_id], cfg)
    end
    local random_pool = include("gameplay.config.random_pool")
    local len = random_pool.length()
    self._randomPoolMaps = {}
    self._randomPoolAllMaps = {}
    for i = 1, len do
        local cfg = random_pool.indexOf(i)
        assert(cfg, "random_pool is nil")
        if not self._randomPoolMaps[cfg.random_pool_id] then
            self._randomPoolMaps[cfg.random_pool_id] = {}
        end
        if not self._randomPoolAllMaps[cfg.random_pool_id] then
            self._randomPoolAllMaps[cfg.random_pool_id] = {}
        end
        table.insert(self._randomPoolAllMaps[cfg.random_pool_id], cfg)
        if cfg.item_type == 1 or cfg.item_type == 2 then
            local skillCfg = include("gameplay.config.config_skillData").get(tostring(cfg.random_pool_item))
            if skillCfg then
                if maxUnlookStageId >= skillCfg.unlock_stage_level then
                    table.insert(self._randomPoolMaps[cfg.random_pool_id], cfg)
                end
            end
        else
            table.insert(self._randomPoolMaps[cfg.random_pool_id], cfg)
        end
    end
    local random_pool_guarant = include("gameplay.config.random_pool_guarant")
    local len = random_pool_guarant.length()
    self._randomPoolGuarantMaps = {}
    for i = 1, len do
        local cfg = random_pool_guarant.indexOf(i)
        local random_pool_ids = string.split(cfg.random_pool_id, "|")
        for i = 1, #random_pool_ids do
            self._randomPoolGuarantMaps[random_pool_ids[i]] = cfg
        end
    end
    local stage_shop_level = include("gameplay.config.stage_shop_level")
    self._shopLevelCfgMap = {}
    self._maxShopLevel = 0
    local len = stage_shop_level.length()
    for i = 1, len do
        local cfg = stage_shop_level.indexOf(i)
        assert(cfg, "")
        self._shopLevelCfgMap[cfg.shop_level] = cfg
        if cfg.shop_level > self._maxShopLevel then
            self._maxShopLevel = cfg.shop_level
        end
    end
    self._expMap = GlobalConfigHelper.getShopBuyExpMap()
end

function SurviveRefreshSkill:_refreshLogic(delay)
    if not self._level:isGameStart() then
        return
    end
    self:_refreshSkills(delay:float())
end

function SurviveRefreshSkill:_refreshSkills(delay)
    if self._stopAutoRefresh == false then
        local allPlayers = y3.userData:getAllInPlayers()
        for i, playerData in ipairs(allPlayers) do
            local param         = self._refreshSkillParamMap[playerData:getId()]
            param.shop_duration = param.shop_duration - delay
            if param.shop_duration <= 0 then
                param.curStageIndex = param.curStageIndex + 1
                param.curStageCfg = self._stageList[param.curStageIndex] or self._stageList[#self._stageList]
                if param.curStageCfg then
                    param.refreshCount = param.curStageCfg.shop_refresh_limit
                    param.freeCount = math.max(param.curStageCfg.shop_refresh_free_times, 0)
                    if param.curStageCfg.shop_type == 1 then
                        local player = playerData:getPlayer()
                        if y3.userDataHelper.has_store_item(player, y3.SurviveConst.PLATFORM_ITEM_MAP.JINSHOUZHI) then
                            param.freeCount = param.freeCount + 2
                        end
                    end
                    param.shop_duration = param.curStageCfg.shop_duration + LOCK_TIME
                    param.max_duration = param.curStageCfg.shop_duration
                    param.buy = false
                    self:_refreshCards(param.curStageCfg.id, playerData:getId())
                else
                    param.shop_duration = 999
                end
            end
        end
    end
    y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SURVIVE_REFRESH_SKILl_UPDATE_TIME)
end

function SurviveRefreshSkill:isShopLock(playerId)
    local param = self._refreshSkillParamMap[playerId]
    if param.shop_duration >= param.max_duration then
        return true
    end
    return false
end

--- comment
function SurviveRefreshSkill:initiativeRefreshCards(params)
    local stageShopId = params[1]
    assert(stageShopId, "stageShopId is nil")
    local playerId = params[2]
    assert(playerId, "playerId is nil")
    local result = {}
    local resultSet = {}
    if self:isShopLock(playerId) then
        return
    end
    local limitTime = GlobalConfigHelper.get(37)
    local param = self._refreshSkillParamMap[playerId]
    if param.shop_duration <= limitTime then
        y3.Sugar.localTips(playerId, y3.langCfg.get(21).str_content)
        return
    end

    local playerData = y3.userData:getPlayerData(playerId)
    local mainActor = playerData:getMainActor()
    local unitFreeCount = 0
    -- print("---------------------------------------------------")
    if mainActor then
        unitFreeCount = mainActor:getUnit():get_attr("刷新免费次数")
        -- print("unitFreeCount", unitFreeCount)
    end
    stageShopId = param.curStageCfg.id
    if param.freeCount > 0 then
        param.freeCount = param.freeCount - 1
        result, resultSet = self:_refreshCards(stageShopId, playerId)
    elseif unitFreeCount > 0 then
        unitFreeCount = unitFreeCount - 1
        -- print("unitFreeCount", unitFreeCount)
        if mainActor then
            mainActor:getUnit():add_attr("刷新免费次数", -1)
            -- print(mainActor:getUnit():get_attr("刷新免费次数"))
        end
        result, resultSet = self:_refreshCards(stageShopId, playerId)
    else
        -- print(param.curStageCfg.shop_refresh_limit)
        if param.curStageCfg.shop_refresh_limit >= 0 and param.refreshCount <= 0 then
            y3.Sugar.localTips(playerId, GameAPI.get_text_config('#-969181188#lua'))
            return result
        end
        local costGold = self:getCostGoldRefreshShop(playerId) --baseCost + costAdd * param.totalRefreshCount
        local player = playerData:getPlayer()
        local gold = player:get_attr("gold")
        if gold >= costGold then
            player:set("gold", gold - costGold)
            param.refreshCount = param.refreshCount - 1
            param.totalRefreshCount = param.totalRefreshCount + 1
            result, resultSet = self:_refreshCards(stageShopId, playerId)
        else
            y3.Sugar.localTips(playerId, GameAPI.get_text_config('#-1604967454#lua'))
        end
    end
    if #resultSet > 0 then
        self._refreshShopTotal = self._refreshShopTotal + 1
        y3.Sugar.achievement():recordAchievementDataIncrement(playerId, y3.SurviveConst.ACHIEVEMENT_COND_SHOP_REFRESH, 1)
        y3.Sugar.achievement():recordAchievementDataIncrement(playerId, y3.SurviveConst.ACHIEVEMENT_COND_SHUAXIN_IN, 1)
        y3.Sugar.achievement():updateAchievement(playerId, y3.SurviveConst.ACHIEVEMENT_REFRESH_TYPE_REFRESH_SKILL)
    end
    return result
end

function SurviveRefreshSkill:forstinitiativeRefreshCards(params)
    local stageShopId = params[1]
    assert(stageShopId, "stageShopId is nil")
    local playerId = params[2]
    assert(playerId, "playerId is nil")
    local result = self:_refreshCards(stageShopId, playerId)
    return result
end

function SurviveRefreshSkill:_refreshCards(stageShopId, playerId)
    local stageCfg = stage_shop.get(stageShopId)
    assert(stageCfg, "can not find cfg in stage_shop by id=" .. stageShopId)
    local result = { [1] = {}, [2] = {} }
    local resultSet = {}
    local giftPoolIds = self:getCurShopGiftPoolIds(playerId)
    for i = 1, MAX_SLOT do
        local poolId       = giftPoolIds[i]
        local randItemData = self:_signalCardRefresh(poolId, playerId)
        if randItemData then
            local row = math.ceil(i / SPLIT_NUM)
            if not result[row] then
                result[row] = {}
            end
            table.insert(result[row], randItemData.id)
            table.insert(resultSet, { id = randItemData.id, mult = stageCfg.mult })
        end
    end
    local playerData = y3.userData:getPlayerData(playerId)
    local param = self._refreshSkillParamMap[playerId]
    playerData:setRandomPools(resultSet, param.curStageIndex)
    local player = playerData:getPlayer()
    if y3.userDataHelper.has_store_item(player, y3.SurviveConst.PLATFORM_ITEM_MAP.JINSHOUZHI) then
        local mainActor = playerData:getMainActor()
        if mainActor then
            mainActor:addBaseAttr(19, 0.2) -- 最终增伤
        end
    end
    y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SURVIVE_REFRESH_SKILl, playerId, true)
    return result, resultSet
end

function SurviveRefreshSkill:_signalCardRefresh(poolId, playerId)
    local giftList = self._giftPoolMaps[poolId]
    assert(giftList, "giftList is nil by id=" .. poolId)
    if giftList[1] then
        local giftCfg = giftList[1]
        local random_pool_ids = string.split(giftCfg.random_pool_id, "|")
        local randomList = self:checkGuaranteed(playerId, random_pool_ids)
        local randomData = SurviveHelper.getRandomDataByWeightList(randomList)
        if not self._staticsPool[randomData.random_poolId] then
            self._staticsPool[randomData.random_poolId] = 0
        end
        self._staticsPool[randomData.random_poolId] = self._staticsPool[randomData.random_poolId] + 1
        local randPoolList = self._randomPoolMaps[randomData.random_poolId]
        assert(randPoolList, "randPoolList is nil by id=" .. randomData.random_poolId)
        local guaranteedCfg = self._randomPoolGuarantMaps[randomData.random_poolId]
        if guaranteedCfg then
            local guarantData = self._guarantMaps[playerId][guaranteedCfg.random_pool_min_content]
            guarantData.count = 0
        end
        local randItemData = SurviveHelper.getRandomItemByWeightList(randPoolList)
        return randItemData
    end
end

function SurviveRefreshSkill:getRandomItemByPoolId(poolId)
    local randPoolList = self._randomPoolAllMaps[tostring(poolId)]
    assert(randPoolList, "random_PoolList is nil by id=" .. poolId)
    local randItemData = SurviveHelper.getRandomItemByWeightList(randPoolList)
    return randItemData
end

function SurviveRefreshSkill:getRandomItemByPoolIdMini(poolId)
    local randPoolList = self._randomPoolMaps[tostring(poolId)]
    if not randPoolList then
        return
    end
    local randItemData = SurviveHelper.getRandomItemByWeightList(randPoolList)
    return randItemData
end

function SurviveRefreshSkill:checkGuaranteed(playerId, random_pool_ids)
    local weigthMap = {}
    local guaranteed = {}
    local randomList = {}
    for i = 1, #random_pool_ids do
        local randPoolIds = string.split(random_pool_ids[i], "#")
        assert(randPoolIds, "")
        local randPoolId = randPoolIds[1]
        local weight = tonumber(randPoolIds[2])
        weigthMap[randPoolId] = weight

        local randData = {}
        randData.random_poolId = randPoolId
        randData.weight = weight
        table.insert(randomList, randData)

        local guaranteedCfg = self._randomPoolGuarantMaps[randPoolId]
        if guaranteedCfg then
            if not self:isInGuaranteedList(guaranteed, guaranteedCfg) then
                table.insert(guaranteed, guaranteedCfg)
            end
        end
    end
    local hitGuaranteedCfg = nil
    for i, guaranteedCfg in ipairs(guaranteed) do
        if not self._guarantMaps[playerId] then
            self._guarantMaps[playerId] = {}
        end
        if not self._guarantMaps[playerId][guaranteedCfg.random_pool_min_content] then
            self._guarantMaps[playerId][guaranteedCfg.random_pool_min_content] = { count = 0 }
        end
        local guarantData = self._guarantMaps[playerId][guaranteedCfg.random_pool_min_content]
        if hitGuaranteedCfg then
            guarantData.count = math.min(guarantData.count + 1, guaranteedCfg.random_pool_guarant)
        else
            local randoHitCount = math.random(guarantData.count, guaranteedCfg.random_pool_guarant)
            if randoHitCount >= guaranteedCfg.random_pool_guarant then
                guarantData.count = 0
                hitGuaranteedCfg = guaranteedCfg
                -- PrintLog("命中保底卡池：" .. hitGuaranteedCfg.random_pool_min_content)
            else
                guarantData.count = math.min(guarantData.count + 1, guaranteedCfg.random_pool_guarant)
            end
        end
    end
    if hitGuaranteedCfg then
        randomList = {}
        local guaranteedPoolIds = string.split(hitGuaranteedCfg.random_pool_id, "|")
        for i = 1, #guaranteedPoolIds do
            local randomId = guaranteedPoolIds[i]
            if weigthMap[randomId] then
                local randData = {}
                randData.random_poolId = randomId
                randData.weight = weigthMap[randomId]
                table.insert(randomList, randData)
            end
        end
    end
    return randomList
end

function SurviveRefreshSkill:isInGuaranteedList(guaranteed, guaranteedCfg)
    for i = 1, #guaranteed do
        if guaranteedCfg.id == guaranteed[i].id then
            return true
        end
    end
    return false
end

function SurviveRefreshSkill:getSkillBuyAllGold(playerId, skillId)
    local buySkillGold = self._buySkillGoldMap[playerId]
    return buySkillGold[skillId] or 0
end

function SurviveRefreshSkill:buySkill(data)
    local player = y3.player(data.player_id)
    local playerData = y3.userData:getPlayerData(data.player_id)
    local state = playerData:getRandomPoolState(data.slot)
    if state == 1 then
        return
    end
    if self:isShopLock(data.player_id) then
        return
    end
    local poolData = playerData:getRandomPoolData(data.slot)
    if not poolData then
        return
    end
    local mainActor = playerData:getMainActor()
    if mainActor:isDieFianl() then
        y3.Sugar.localTips(playerData:getId(), y3.langCfg.get(68).str_content)
        return
    end
    if data.autoBuy then
        local param = self._refreshSkillParamMap[data.player_id]
        local curStageCfg = param.curStageCfg
        if curStageCfg.shop_help_auto == 0 then
            return
        end
    end
    local mult = poolData.mult
    local gold = player:get_attr("gold")
    local allPrice = mult * data.price
    if gold >= allPrice then
        for i = 1, mult do
            self:_signalBuySkill(data, player, playerData)
            if data.autoBuy then
                if self._recordAutoBuy[playerData:getId()] then
                    local gameTotalTime = self._level:getLogic("SurviveSpawnerEnemy"):getTotalDt()
                    local recordData = { skillId = data.skillId, time = gameTotalTime }
                    table.insert(self._recordAutoBuy[playerData:getId()], 1, recordData)
                    y3.Sugar.localSkillBuyNotice(playerData:getId(), recordData)
                    if #self._recordAutoBuy[playerData:getId()] > 20 then
                        table.remove(self._recordAutoBuy[playerData:getId()])
                    end
                end
            end
        end
    else
        if not data.autoBuy then
            y3.Sugar.localTips(data.player_id, y3.Lang.get("jinbibuzu"))
        end
    end
end

function SurviveRefreshSkill:getAutoBuyList(playerId)
    return self._recordAutoBuy[playerId] or {}
end

function SurviveRefreshSkill:_signalBuySkill(data, player, playerData)
    local gold = player:get_attr("gold")
    if gold >= data.price then
        local buySkillGold = self._buySkillGoldMap[data.player_id]
        if not buySkillGold[data.skillId] then
            buySkillGold[data.skillId] = data.price
        else
            buySkillGold[data.skillId] = buySkillGold[data.skillId] + data.price
        end
        local skillCfg = include("gameplay.config.config_skillData").get(tostring(data.skillId))
        assert(skillCfg, "skillCfg is nil")
        self:addShopExp(data.player_id, self._expMap[skillCfg.class] or self._expMap[1])
        player:set("gold", gold - data.price)
        local SurviveHelper = include("gameplay.level.logic.helper.SurviveHelper")
        local mainActor = playerData:getMainActor()
        if self:_specBuySkillLogic(mainActor, playerData, data, skillCfg) then
        else
            SurviveHelper.leanSkill({ playerData:getId(), data.skillId })
        end
        self:onEventLeanrSkillSuccess(data.player_id, data.skillId, data.poolId, data.slot)
    else
        y3.Sugar.localTips(data.player_id, y3.Lang.get("jinbibuzu"))
    end
end

function SurviveRefreshSkill:_specBuySkillLogic(mainActor, playerData, data, skillCfg)
    local isSpec = false
    if mainActor:getUnit():kv_has("20030_value_2") then
        local NO_SKILL = {
            [20008] = 1,
            [20009] = 1
        }
        local skillAddCount = math.floor(mainActor:getUnit():kv_load("20030_value_2", "number"))
        if skillAddCount > 0 then
            if skillCfg.class == 1 and not NO_SKILL[data.skillId] then -- 绿色
                for i = 1, skillAddCount + 1 do
                    SurviveHelper.leanSkill({ playerData:getId(), data.skillId })
                end
                mainActor:getUnit():kv_remove("20030_value_2")
                isSpec = true
            end
        end
    end
    if mainActor:getUnit():kv_has("20057_value_1") then
        local buySpec = mainActor:getUnit():kv_load("20057_value_1", "number")
        if buySpec > 0 then
            if skillCfg.class == 2 then --蓝色
                for i = 1, 2 do
                    SurviveHelper.leanSkill({ playerData:getId(), data.skillId })
                end
                mainActor:getUnit():kv_remove("20057_value_1")
                isSpec = true
            end
        end
    end
    return isSpec
end

-----------------------------商店升级------------------------------
function SurviveRefreshSkill:addShopExp(playerId, exp)
    local param = self._refreshSkillParamMap[playerId]
    local shopLevel = param.shopLevel
    local shopExp = param.shopExp
    local shopLevelCfg = self._shopLevelCfgMap[shopLevel]
    if not shopLevelCfg then
        return
    end
    shopExp = shopExp + exp
    if shopExp >= shopLevelCfg.shop_next_level_exp then
        shopLevel = math.min(self._maxShopLevel, shopLevel + 1)
        shopExp = shopExp - shopLevelCfg.shop_next_level_exp
        param.shopLevel = shopLevel
        param.shopExp = shopExp
    else
        param.shopExp = shopExp
    end
    y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SHOP_EXP_ADD, playerId)
end

function SurviveRefreshSkill:getNextLevelShopExp(playerId)
    local param = self._refreshSkillParamMap[playerId]
    local shopLevel = param.shopLevel
    local shopExp = param.shopExp
    local shopLevelCfg = self._shopLevelCfgMap[shopLevel]
    if not shopLevelCfg then
        return 0
    end
    return math.max(0, shopLevelCfg.shop_next_level_exp - shopExp)
end

function SurviveRefreshSkill:getCurShopUpPrice(playerId)
    local needExp = self:getNextLevelShopExp(playerId)
    if needExp <= 0 then
        return 0
    end
    local expPrice = GlobalConfigHelper.get(45)
    local needPrice = expPrice * needExp
    return needPrice
end

function SurviveRefreshSkill:buyShopExp(playerId)
    local needExp = self:getNextLevelShopExp(playerId)
    if needExp <= 0 then
        y3.Sugar.localTips(playerId, GameAPI.get_text_config('#-1385594544#lua'))
        return
    end
    local expPrice = GlobalConfigHelper.get(45)
    local needPrice = expPrice * needExp
    if SurviveHelper.checkShopPrice(playerId, y3.SurviveConst.RESOURCE_TYPE_DIAMOND, needPrice) then
        self:addShopExp(playerId, needExp)
        y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SHOP_EXP_ADD, playerId)
    else
        y3.Sugar.localTips(playerId, GameAPI.get_text_config('#-599375980#lua'))
    end
end

function SurviveRefreshSkill:getCurShopGiftPoolIds(playerId)
    local param = self._refreshSkillParamMap[playerId]
    local shopLevel = param.shopLevel
    local shopLevelCfg = self._shopLevelCfgMap[shopLevel] or self._shopLevelCfgMap[self._maxShopLevel]
    local list = {}
    for i = 1, MAX_SLOT do
        local poolId = tonumber(shopLevelCfg["shop_block" .. i .. "_pool_id"])
        if poolId then
            table.insert(list, poolId)
        end
    end
    return list
end

function SurviveRefreshSkill:getShopLevelParam(playerId)
    local param = self._refreshSkillParamMap[playerId]
    local shopLevel = param.shopLevel
    local shopExp = param.shopExp
    local shopLevelCfg = self._shopLevelCfgMap[shopLevel] or self._shopLevelCfgMap[self._maxShopLevel]
    return shopLevel, shopExp, shopLevelCfg.shop_next_level_exp, shopLevelCfg
end

return SurviveRefreshSkill
