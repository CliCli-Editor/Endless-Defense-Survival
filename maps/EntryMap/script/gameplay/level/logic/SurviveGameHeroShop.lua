local GlobalConfigHelper = require "gameplay.level.logic.helper.GlobalConfigHelper"
local LogicBase = include("gameplay.level.logic.LogicBase")
local SurviveGameHeroShop = class("SurviveGameHeroShop", LogicBase)
local SurviveHelper = include("gameplay.level.logic.helper.SurviveHelper")

function SurviveGameHeroShop:ctor(level)
    SurviveGameHeroShop.super.ctor(self, level)

    self:_initData()
    y3.gameApp:addTimerLoop(1, handler(self, self._onShopTimer))
end

function SurviveGameHeroShop:_initData()
    self._curStageConfig = include("gameplay.config.stage_config").get(y3.userData:getCurStageId())
    self._curModeCfg = include("gameplay.config.stage_mode").get(self._curStageConfig.stage_type)
    local stage_wave_born_poins = string.split(self._curModeCfg.pass_ordeal_born_points, "|")
    assert(stage_wave_born_poins, "")
    self._modeBornType = tonumber(stage_wave_born_poins[1])
    local modeBornArgs = string.split(stage_wave_born_poins[2], "#")
    assert(modeBornArgs, "")
    self._modeBornArgs = {}
    for i = 1, #modeBornArgs do
        self._modeBornArgs[i] = tonumber(modeBornArgs[i])
    end

    local hero_shop = include("gameplay.config.hero_shop")
    self._roundMap = {}
    self._maxRound = 0
    self._allRounds = {}
    local len = hero_shop.length()
    for i = 1, len do
        local cfg = hero_shop.indexOf(i)
        assert(cfg, "")
        if not self._roundMap[cfg.round] then
            self._roundMap[cfg.round] = {}
            table.insert(self._allRounds, cfg.round)
        end
        if cfg.round > self._maxRound then
            self._maxRound = cfg.round
        end
        table.insert(self._roundMap[cfg.round], cfg)
    end
    self._curStageConfig = include("gameplay.config.stage_config").get(y3.userData:getCurStageId())
    local stage_pass_ordeal = include("gameplay.config.stage_pass_ordeal")
    local len = stage_pass_ordeal.length()
    self._curStagePrdealList = {}
    for i = 1, len do
        local cfg = stage_pass_ordeal.indexOf(i)
        assert(cfg, "")
        if cfg.stage_pass_ordeal_group == self._curStageConfig.stage_pass_ordeal then
            table.insert(self._curStagePrdealList, cfg)
        end
    end
    self._lvExpMap = GlobalConfigHelper.getHeroShopLvExpMap()
    self._heroShopExp = GlobalConfigHelper.get(48)

    self._playerRoundShop = {}
    local allInPlayers = y3.userData:getAllInPlayers()
    for _, playerData in ipairs(allInPlayers) do
        local param = {}
        param.round = 1
        param.shops = {}
        param.passDoom = {}
        param.shopMap = {}
        param.doomMap = {}
        param.shopLevel = 1
        param.shopExp = 0
        param.doomChallenge = { challenge = false, upStageId = 0, limitTime = 0, remainTime = 0, list = {} }
        self._playerRoundShop[playerData:getId()] = param
        for i = 1, #self._allRounds do
            self:initShopList(playerData:getId(), self._allRounds[i])
        end
    end
end

function SurviveGameHeroShop:_onShopTimer(dt)
    local delta = dt:float()
    local allInPlayers = y3.userData:getAllInPlayers()
    for _, playerData in ipairs(allInPlayers) do
        local param = self._playerRoundShop[playerData:getId()]
        local doomChallenge = param.doomChallenge
        if doomChallenge.challenge then
            doomChallenge.remainTime = doomChallenge.remainTime - delta
            if doomChallenge.remainTime <= 0 then
                doomChallenge.challenge = false
                local list = doomChallenge.list
                for i = 1, #list do
                    local monster = list[i]
                    if not monster:isDie() then
                        monster:getUnit():kill_by()
                    end
                end
                doomChallenge.list = {}
                y3.Sugar.localNotice(playerData:getId(), 45, { floor = doomChallenge.upStageId })
            else
                local list = doomChallenge.list
                local allDie = true
                for i = 1, #list do
                    if not list[i]:isDie() then
                        allDie = false
                    end
                end
                if allDie then
                    doomChallenge.challenge = false
                    doomChallenge.list = {}
                    local param = self._playerRoundShop[playerData:getId()]
                    local upExp = self._lvExpMap[param.shopLevel] or 0
                    param.shopLevel = param.shopLevel + 1
                    param.shopExp = math.max(0, param.shopExp - upExp)
                    param.passDoom[doomChallenge.upStageId] = 1
                    local curCfg = doomChallenge.curCfg
                    self:_upStageAward(playerData, curCfg.reward_args, curCfg.reward_type)
                    self:_upStageAward(playerData, curCfg.reward_args_2, curCfg.reward_type_2)
                    y3.Sugar.localNotice(playerData:getId(), 44, {})
                    y3.gameApp:dispatchEvent(y3.EventConst.EVENT_REFRESH_HERO_SHOP, playerData:getId())
                end
            end
        end
    end
end

function SurviveGameHeroShop:_upStageAward(playerData, reward_args, reward_type)
    if reward_args ~= "" then
        local reward_args = string.split(reward_args, "|")
        assert(reward_args, "reward_args error")
        if reward_type == 4 then
            local skillTo = tonumber(reward_args[1])
            local skillId = tonumber(reward_args[2])
            local mainActor = playerData:getMainActor()
            -- print("_upStageAward")
            -- print(skillId, skillTo)
            if skillTo == 1 then
                SurviveHelper.leanSkill({ playerData:getId(), skillId })
            elseif skillTo == 2 then
                local soulActor = mainActor:getSoulHeroActor()
                soulActor:learnSkill(skillId)
            end
            local skillCfg = include("gameplay.config.config_skillData").get(tostring(skillId))
            assert(skillCfg, "can not find skillCfg by id=" .. skillId)
            local skillDesc = y3.userDataHelper.getSkillDesc(skillCfg)
            y3.Sugar.localNotice(playerData:getId(), 49, { skill_desc = skillDesc })
        else
            local refreshSkill = y3.gameApp:getLevel():getLogic("SurviveRefreshSkill")
            local randItem1 = refreshSkill:getRandomItemByPoolId(tonumber(reward_args[1]))
            local randItem2 = refreshSkill:getRandomItemByPoolId(tonumber(reward_args[2]))
            local randItem3 = refreshSkill:getRandomItemByPoolId(tonumber(reward_args[3]))
            local spawnEnemy = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy")
            local abyssChallenge = spawnEnemy:getAbysChallenge()
            abyssChallenge:insertChallengeRecordData(playerData:getId(), { randItem1, randItem2, randItem3 }, reward_type,
                true)
        end
    end
end

function SurviveGameHeroShop:getIsUpStageChallenging(playerId)
    local param = self._playerRoundShop[playerId]
    local doomChallenge = param.doomChallenge
    if doomChallenge.challenge then
        return true
    end
    return false
end

function SurviveGameHeroShop:upStage(playerId)
    local param = self._playerRoundShop[playerId]
    local doomChallenge = param.doomChallenge
    if doomChallenge.challenge then
        y3.Sugar.localTips(playerId, y3.langCfg.get(38).str_content)
        return
    end
    local curStage = self:getCurUpStage(playerId)
    if curStage > 0 then
        if param.passDoom[curStage] then
            -- print("已经通过了渡劫 " .. curStage)
            return
        end
        doomChallenge.challenge = true
        local cfg = self._curStagePrdealList[curStage] --include("gameplay.config.stage_pass_ordeal").get(curStage)
        if not cfg then
            -- print("缺少渡劫配置 " .. curStage)
            return
        end
        doomChallenge.upStageId = curStage
        doomChallenge.limitTime = cfg.stage_pass_ordeal_challenge_time_require
        doomChallenge.remainTime = doomChallenge.limitTime
        doomChallenge.curCfg = cfg

        local list = {}
        local monsterIds = string.split(cfg.stage_pass_ordeal_monster_id, "|")
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
        local randData   = SurviveHelper.getRandomDataByWeightList(randList)
        local playerData = y3.userData:getPlayerData(playerId)
        local mainActor  = playerData:getMainActor()


        local points = {}
        if self._modeBornType == 2 then
            local pointStart = y3.point.get_point_by_res_id(self._modeBornArgs[playerId])
            points = SurviveHelper.getRandomSpawnPoints(pointStart, 20, math.random(0, 360), randData.count)
        elseif self._modeBornType == 1 then
            points = SurviveHelper.getRandomSpawnPoints(mainActor:getPosition(),
                cfg.stage_pass_order_monster_born_place, math.random(0, 360),
                randData.count)
        end
        for i = 1, randData.count do
            local monsterCfg = include("gameplay.config.monster").get(randData.monster_id)
            assert(monsterCfg, "monsterCfg error by id=" .. randData.monster_id)
            local monster = self:_spawnChallengeEnemy(monsterCfg, points, playerData, i, cfg)
            table.insert(list, monster)
        end
        doomChallenge.list = list
        y3.gameApp:dispatchEvent(y3.EventConst.EVENT_REFRESH_HERO_SHOP, playerData:getId())
    end
end

function SurviveGameHeroShop:_spawnChallengeEnemy(monsterCfg, points, playerData, index, upStageCfg)
    if #points == 0 then
        return
    end
    local monster = include("gameplay.scene.actor.MonsterActor").new(y3.GameConst.PLAYER_ID_ENEMY, monsterCfg,
        nil, nil, nil, nil, nil)
    monster:setAttrOrdealChangeCfg(upStageCfg)
    monster:setPosition(points[index])
    local spawnEnemy = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy")
    monster:setOwnPlayerId(playerData:getId())
    monster:addToGroup(spawnEnemy:getMonsterGroup(playerData:getId()))
    monster:getUnit():attack_move(playerData:getMainActor():getUnit():get_point(), 500)
    return monster
end

function SurviveGameHeroShop:getCurUpStage(playerId)
    local param = self._playerRoundShop[playerId]
    local shopLv = param.shopLevel
    return shopLv
end

function SurviveGameHeroShop:isUnlockShop(playerId, round)
    return true
end

function SurviveGameHeroShop:initShopList(playerId, round)
    local param    = self._playerRoundShop[playerId]
    local shopList = self._roundMap[round]
    local shops    = {}
    for i = 1, #shopList do
        local cfg = shopList[i]
        local data = {}
        data.level = 0
        data.cfg = shopList[i]
        data.buyCount = 0
        table.insert(shops, data)
        if cfg.up_stage > 0 then
            param.doomMap[round] = data
        end
    end
    param.shopMap[round] = shops
end

function SurviveGameHeroShop:_nextShop(playerId)
    local param = self._playerRoundShop[playerId]
    param.round = math.min(self._maxRound, param.round + 1)
    y3.gameApp:dispatchEvent(y3.EventConst.EVENT_REFRESH_HERO_SHOP, playerId)
end

function SurviveGameHeroShop:_checkShopCanNext(playerId)
    local param = self._playerRoundShop[playerId]
    local round = param.round
    if round >= self._maxRound then
        return false
    end
    local shops = param.shopMap[round]
    local ret = true
    for i = 1, #shops do
        local level = shops[i].level
        local cfg = shops[i].cfg
        if cfg.max_level < 0 then
            ret = false
            break
        end
        if level < cfg.max_level then
            ret = false
            break
        end
    end
    return ret
end

function SurviveGameHeroShop:getShopPrice(shopData)
    local cfg    = shopData.cfg
    local prices = string.split(cfg.price, "#")
    assert(prices, "")
    local level     = shopData.level
    local priceType = tonumber(prices[1])
    local priceSize = tonumber(prices[2])
    local priceAdd  = tonumber(prices[3])
    return priceType, priceSize + priceAdd * level
end

function SurviveGameHeroShop:shopSlotIsUnlock(playerId, slotIndex)
    local param    = self._playerRoundShop[playerId]
    local round    = param.round
    local shops    = param.shopMap[round] or {}
    local shopData = shops[slotIndex]
    local cfg      = shopData.cfg
    if cfg.unlock_slot < 0 then
        return true
    end
    local shopLv = param.shopLevel
    if shopLv >= cfg.unlock_slot then
        return true
    end
    return false
end

function SurviveGameHeroShop:getShopDataSkillId(playerId, shopData)
    local playeData = y3.userData:getPlayerData(playerId)
    local mainActor = playeData:getMainActor()
    local soulActor = nil
    if mainActor then
        soulActor = mainActor:getSoulHeroActor()
    end
    if shopData.cfg.unique_skill == 1 then
        if soulActor then
            return soulActor:getUniqueSkill()
        else
            return shopData.cfg.skill_id
        end
    else
        return shopData.cfg.skill_id
    end
end

function SurviveGameHeroShop:getBuySuccess(playerId, slot)
    local param    = self._playerRoundShop[playerId]
    local round    = param.round
    local shops    = param.shopMap[round]
    local shopData = shops[slot]
    local shopCfg  = shopData.cfg
    local buyCount = shopData.buyCount
    if shopCfg.rate == "" then
        return true
    end
    local rates = string.split(shopCfg.rate, "|")
    assert(rates, "")
    local rate    = rates[buyCount] or rates[#rates]
    rate          = tonumber(rate)
    local randNum = math.random(1, 100)
    -- print(rate)
    -- print(randNum)
    return randNum <= rate
end

function SurviveGameHeroShop:buyShop(playerId, roundx, slot)
    local param = self._playerRoundShop[playerId]
    local round = param.round
    local shops = param.shopMap[round] or param.shopMap[self._maxRound]
    local shopData = shops[slot]
    if shopData then
        if self:shopSlotIsUnlock(playerId, slot) == false then
            y3.Sugar.localTips(playerId, GameAPI.get_text_config('#-1846672274#lua'))
            return
        end
        if shopData.cfg.max_level > 0 and shopData.level >= shopData.cfg.max_level then
            y3.Sugar.localTips(playerId, GameAPI.get_text_config('#-526674530#lua'))
            return
        end
        local priceType, priceSize = self:getShopPrice(shopData)
        if SurviveHelper.checkShopPrice(playerId, priceType, priceSize) then
            if priceType == y3.SurviveConst.RESOURCE_TYPE_DIAMOND then
                self:addHeroShopExp(playerId, priceSize / self._heroShopExp)
            end
            shopData.buyCount = shopData.buyCount + 1
            local isSuccess = self:getBuySuccess(playerId, slot)
            if not isSuccess then
                y3.Sugar.localTips(playerId, GameAPI.get_text_config('#866623899#lua'))
                return
            end
            y3.Sugar.localTips(playerId, GameAPI.get_text_config('#-1417518221#lua'))
            shopData.level = shopData.level + 1
            local playeData = y3.userData:getPlayerData(playerId)
            local mainActor = playeData:getMainActor()
            local soulActor = nil
            if mainActor then
                soulActor = mainActor:getSoulHeroActor()
            end
            local learnskillId = 0
            if shopData.cfg.unique_skill == 1 then
                if soulActor then
                    learnskillId = soulActor:getUniqueSkill() or 0
                end
            else
                learnskillId = shopData.cfg.skill_id
            end
            if learnskillId > 0 then
                local skillTos = string.split(shopData.cfg.skill_to, "|")
                assert(skillTos, "")
                for i = 1, #skillTos do
                    local skillTo = tonumber(skillTos[i])
                    if skillTo == 1 then
                        if soulActor then
                            soulActor:learnSkill(learnskillId)
                        end
                    elseif skillTo == 2 then
                        SurviveHelper.leanSkill({ playerId, learnskillId })
                    end
                end
            end
            if self:_checkShopCanNext(playerId) then
                self:_nextShop(playerId)
            end
            local playerData = y3.userData:getPlayerData(playerId)
            y3.SignalMgr:dispatch(y3.SignalConst.SIGNAL_HEROSHOP_LV_UP, playerData:getPlayer(), shopData.cfg.id,
                shopData.level)
            y3.gameApp:dispatchEvent(y3.EventConst.EVENT_REFRESH_HERO_SHOP, playerId)
        else
            y3.Sugar.localTips(playerId, GameAPI.get_text_config('#-1442066866#lua'))
        end
    else
        y3.Sugar.localTips(playerId, GameAPI.get_text_config('#254583467#lua'))
    end
end

function SurviveGameHeroShop:getShopList(playerId)
    local param = self._playerRoundShop[playerId]
    local curRound = param.round
    return param.shopMap[curRound] or param.shopMap[self._maxRound]
end

-------------------------------------------------
function SurviveGameHeroShop:addHeroShopExp(playerId, exp)
    local param = self._playerRoundShop[playerId]
    local curLv = param.shopLevel
    local curExp = param.shopExp
    local upExp = self._lvExpMap[curLv]
    if not upExp then
        return
    end
    curExp = curExp + exp
    if curExp >= upExp then
        curExp = upExp
    end
    param.shopLevel = curLv
    param.shopExp = curExp
end

function SurviveGameHeroShop:getCurShopExp(playerId)
    local param = self._playerRoundShop[playerId]
    return math.floor(param.shopExp)
end

function SurviveGameHeroShop:getCurShopUpMaxExp(playerId)
    local param = self._playerRoundShop[playerId]
    local curLv = param.shopLevel
    local upExp = self._lvExpMap[curLv] or 0
    return upExp
end

function SurviveGameHeroShop:isShopExpMax(playerId)
    local param = self._playerRoundShop[playerId]
    local curLv = param.shopLevel
    local curExp = param.shopExp
    local upExp = self._lvExpMap[curLv]
    if not upExp then
        return false
    end
    return curExp >= upExp
end

return SurviveGameHeroShop
