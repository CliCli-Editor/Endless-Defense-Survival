local UserDataHelper = require "gameplay.level.logic.helper.UserDataHelper"
local SyncConst = include "gameplay.const.SyncConst"
local SyncManager = class("SyncManager")

function SyncManager:ctor()
    y3.sync.onSync(SyncConst.SYNC_MESSAGE_DRAW, handler(self, self._syncMsgDraw))
    y3.sync.onSync(SyncConst.SYNC_MESSAGE_BUY_CARD, handler(self, self._syncBuyCard))
    y3.sync.onSync(SyncConst.SYNC_BUILD_TOWER, handler(self, self._syncBuildTower))
    y3.sync.onSync(SyncConst.SYNC_UPGRADE_QIUXIAN, handler(self, self._syncUpgradeQiuxian))
    y3.sync.onSync(SyncConst.SYNC_UPGRADE_LIANGCAO, handler(self, self._syncUpgradeLiangcao))
    y3.sync.onSync(SyncConst.SYNC_SELL_TOWER, handler(self, self._syncSellTower))
    y3.sync.onSync(SyncConst.SYNC_MESSAGE_SHENGXING, handler(self, self._syncShengxing))
    y3.sync.onSync(SyncConst.SYNC_MESSAGE_QIANSHAN, handler(self, self._syncQianshan))
    y3.sync.onSync(SyncConst.SYNC_BUILD_SHENGXING, handler(self, self._syncBuildShengxing))
    y3.sync.onSync(SyncConst.SYNC_UPGRADE_JUEWEI, handler(self, self._syncUpgradeJuewei))
    y3.sync.onSync(SyncConst.SYNC_CHALLENGE_JUEWEI, handler(self, self._syncChallengeJuewei))
    y3.sync.onSync(SyncConst.SYNC_SELECT_JUEWEI_BUFF, handler(self, self._syncSelectJueweiBuff))
    y3.sync.onSync(SyncConst.SYNC_UP_HERO_OFFICIAL, handler(self, self._syncUpHeroOfficial))
    y3.sync.onSync(SyncConst.SYNC_HE_CHENG_ITEM, handler(self, self._syncHeChengItem))
    y3.sync.onSync(SyncConst.SYNC_SELL_SELECT, handler(self, self._syncSellSelect))
    y3.sync.onSync(SyncConst.SYNC_SELL_ALL, handler(self, self._syncSellAll))
    y3.sync.onSync(SyncConst.SYNC_BACK_MODE, handler(self, self._syncBackMode))
    y3.sync.onSync(SyncConst.SYNC_SELECT_MODE, handler(self, self._syncSelectMode))
    y3.sync.onSync(SyncConst.SYNC_SELECT_LEVEL, handler(self, self._syncSelectLevel))
    y3.sync.onSync(SyncConst.SYNC_PLAYER_READY, handler(self, self._syncPlayerReady))

    ------
    y3.sync.onSync(SyncConst.SYNC_SURVIVE_LEARN_SKILL, handler(self, self._syncLearnSkill))
    y3.sync.onSync(SyncConst.SYNC_REFRESH_SKILL_POOL, handler(self, self._syncRefreshSkillPool))
    y3.sync.onSync(SyncConst.SYNC_SURVIVE_SELECT_STAGE, handler(self, self._syncStageSelect))
    y3.sync.onSync(SyncConst.SYNC_STAGE_CHALLENGE_START, handler(self, self._syncChallengeStart))
    y3.sync.onSync(SyncConst.SYNC_SURVIVE_PAUSE_GAME, handler(self, self._syncPauseGame))
    y3.sync.onSync(SyncConst.SYNC_SURVIVE_STAGE_ABYSS_CHALLENGE_START, handler(self, self._syncAbyssChallengeStart))
    y3.sync.onSync(SyncConst.SYNC_REWARD_SKILL_SELECT, handler(self, self._syncRewardSkillSelect))
    y3.sync.onSync(SyncConst.SYNC_STAGE_CHALLENGE_COMMON_START, handler(self, self._syncCommonChallengeStart))
    y3.sync.onSync(SyncConst.SYNC_SURVIVE_REFRESH_ABYSS_SHOP, handler(self, self._syncRefreshAbyssShop))
    y3.sync.onSync(SyncConst.SYNC_SURVIVE_ABYSS_SHOP_BUY, handler(self, self._syncAbyssShopBuy))
    y3.sync.onSync(SyncConst.SYNC_ATTR_PACK_LIST, handler(self, self._syncAttrPackList))
    y3.sync.onSync(SyncConst.SYNC_SURVIVE_ABYSS_CHALLENGE_BONUS_GET, handler(self, self._syncAbyssChallengeBounsGet))
    y3.sync.onSync(SyncConst.SYNC_TREASURE_UPGRADE, handler(self, self._syncTreasureUpgrade))
    y3.sync.onSync(SyncConst.SYNC_SAVE_SYNC_END, handler(self, self._syncSaveSyncEnd))
    y3.sync.onSync(SyncConst.SYNC_SELECTED_SKIN_TOWER, handler(self, self._syncSelectedSkinTower))
    y3.sync.onSync(SyncConst.SYNC_WEAPON_EFFECT, handler(self, self._syncWeaponEffect))
    y3.sync.onSync(SyncConst.SYNC_WEAPON_UPGRADE, handler(self, self._syncWeaponUpgrade))
    y3.sync.onSync(SyncConst.SYNC_SURVIVE_TECH_UPGRADE, handler(self, self._syncTechUpgrade))
    y3.sync.onSync(SyncConst.SYNC_END_BOSS_RESULT, handler(self, self._syncEndBossResult))
    y3.sync.onSync(SyncConst.SYNC_SELECT_SAVE_BOSS, handler(self, self._syncSelectSaveBoss))
    y3.sync.onSync(SyncConst.SYNC_BUY_HERO_SHOP_ITEM, handler(self, self._syncBuyHeroShopItem))
    y3.sync.onSync(SyncConst.SYNC_SHOP_UP_STAGE, handler(self, self._syncShopUpStage))
    y3.sync.onSync(SyncConst.SYNC_EQUIP_TITLE, handler(self, self._syncEquipTitle))
    y3.sync.onSync(SyncConst.SYNC_BUY_SHOP_EXP, handler(self, self._syncBuyShopExp))
    y3.sync.onSync(SyncConst.SYNC_RECEIVE_BP_REWARD, handler(self, self._syncReceiveBPReward))
    y3.sync.onSync(SyncConst.SYNC_ADD_BP_EXP, handler(self, self._syncAddBPExp))
    y3.sync.onSync(SyncConst.SYNC_HECHENG_PKG_ITEM, handler(self, self._syncHechengItem))
    y3.sync.onSync(SyncConst.SYNC_SELLITEM_PKG_ONEKEY, handler(self, self._syncSellPkgOneKey))
    y3.sync.onSync(SyncConst.SYNC_SELLITEM_PKG_ONE, handler(self, self._syncSellItemPkgOne))
    y3.sync.onSync(SyncConst.SYNC_REMOVE_REWARD_SELECT, handler(self, self._syncRemoveRewardSelect))
    y3.sync.onSync(SyncConst.SYNC_EQUIP_TOWER_SKIN, handler(self, self._syncEquipTowerSkin))
    y3.sync.onSync(SyncConst.SYNC_PLATFORM_ATTR_LIST, handler(self, self._syncPlatformAttrList))
    y3.sync.onSync(SyncConst.SYNC_PLATFORM_SKILL_LIST, handler(self, self._syncPlatformSkillList))
    y3.sync.onSync(SyncConst.SYNC_GET_SIGNDAY_REWARD, handler(self, self._syncGetSigndayReward))
    y3.sync.onSync(SyncConst.SYNC_UNEQUIP_TOWER_SKIN, handler(self, self._syncUnequipTowerSkin))
    y3.sync.onSync(SyncConst.SYNC_RANDOM_LOAD_TIPS_TEXT, handler(self, self._syncRandomLoadTipsText))
    y3.sync.onSync(SyncConst.SYNC_INSERT_LABEL_SORT, handler(self, self._syncInsertLabelSort))
    y3.sync.onSync(SyncConst.SYNC_REMOVE_LABEL_SORT, handler(self, self._syncRemoveLabelSort))
    y3.sync.onSync(SyncConst.SYNC_SHOP_HELPER_OPEN, handler(self, self._syncShopHelperOpen))
    y3.sync.onSync(SyncConst.SYNC_SHOP_AUTO_REFRESH, handler(self, self._syncShopAutoRefresh))
end

function SyncManager:sync(id, data)
    y3.player.with_local(function(local_player)
        data.player_id = local_player:get_id()
        y3.sync.send(id, data)
    end)
end

function SyncManager:dispatchLocalEvent(player_id, id, ...)
    local args = { ... }
    y3.player.with_local(function(local_player)
        if local_player:get_id() == player_id then
            y3.gameApp:dispatchEvent(id, table.unpack(args))
        end
    end)
end

function SyncManager:_syncMsgDraw(data, source)
    if not data then
        return
    end
    local index = data.darwIndex
    local playerData = y3.userData:getPlayerData(data.player_id)
    local qiuxianling = playerData:getQiuxianling()
    local costValue = y3.userData:getDrawCost(index)
    if qiuxianling >= costValue then
        local retValue = qiuxianling - costValue
        playerData:setQiuxianling(retValue)
        local drawHeroList = y3.userData:getRandomHeroList(5)
        self:dispatchLocalEvent(data.player_id, y3.EventConst.EVENT_UPDATE_DRAW, drawHeroList)
    else
        print("_syncMsgDraw")
    end
end

function SyncManager:_syncBuyCard(data, source)
    if not data then
        return
    end
    local card_id = data.card_id
    local player = y3.userData:getPlayerData(data.player_id)
    local cfg = include("gameplay.config.hero").get(card_id)
    local gold = player:getYinliang()
    if gold >= cfg.cost then
        gold = gold - cfg.cost
        player:setYinliang(gold)
        self:dispatchLocalEvent(data.player_id, y3.EventConst.EVENT_BUY_HERO_CARD, cfg)
    else
        print("_syncBuyCard")
    end
end

function SyncManager:_syncBuildTower(data, source)
    if not data then
        return
    end
    local build_id = data.build_id
    local cfg = include("gameplay.config.hero").get(build_id)
    local player = y3.player(data.player_id)
    local playerData = y3.userData:getPlayerData(data.player_id)
    local liangcao = playerData:getLiangcao()
    local max_liangcao = playerData:getMax_liangcao()
    if liangcao + cfg.liangcao <= max_liangcao then
        local pos = data.pos
        local pureBuild = function()
            liangcao = liangcao + cfg.liangcao
            playerData:setLiangcao(liangcao)
            y3.gameApp:getGameLogic():addTower(data.player_id, cfg, pos)
        end
        if data.autoShengxing then
            local towerEx = y3.gameApp:getGameLogic():checkCanAutoShengxing(player, cfg.id)
            if towerEx then
                towerEx:levelup()
            else
                pureBuild()
            end
        else
            pureBuild()
        end

        self:dispatchLocalEvent(data.player_id, y3.EventConst.EVENT_BUILDTOWER_SUCCESS, build_id)
    end
end

function SyncManager:_syncUpgradeQiuxian(data, source)
    if not data then
        return
    end
    local qiuxian_lv = data.qiuxian_lv
    local player = y3.player(data.player_id)
    local playerData = y3.userData:getPlayerData(data.player_id)
    local cur_qiuxianLv = playerData:getQiuxian_lv()
    local qiuxianCfg = include("gameplay.config.yanjiu").get(1)
    local costValue = qiuxianCfg.cost_gold + qiuxian_lv * qiuxianCfg.up_gold
    local gold = playerData:getYinliang()
    local qiuxian_speed = playerData:getRecoverSpeed()
    if gold >= costValue then
        local gold = gold - costValue
        local cur_qiuxianLv = cur_qiuxianLv + 1
        qiuxian_speed = qiuxian_speed + qiuxianCfg.up_point
        playerData:setYinliang(gold)
        playerData:setQiuxian_lv(cur_qiuxianLv)
        playerData:setRecoverSpeed(qiuxian_speed)
        self:dispatchLocalEvent(data.player_id, y3.EventConst.EVENT_UPGRADE_QIUXIAN_SUCCESS, cur_qiuxianLv)
    end
end

function SyncManager:_syncUpgradeLiangcao(data, source)
    if not data then
        return
    end
    local liangcao_lv = data.liangcao_lv
    local player = y3.player(data.player_id)
    local playerData = y3.userData:getPlayerData(data.player_id)
    local cur_liangcaoLv = playerData:getLiangcao_lv()
    local liangcaoCfg = include("gameplay.config.yanjiu").get(2)
    local costValue = liangcaoCfg.cost_gold + liangcao_lv * liangcaoCfg.up_gold
    local costValue1 = liangcaoCfg.cost_qiuxian + liangcao_lv * liangcaoCfg.up_qiuxian
    local qiuxianling = playerData:getQiuxianling()
    local max_liangcao = playerData:getMax_liangcao()
    local gold = playerData:getYinliang()
    if gold >= costValue and qiuxianling >= costValue1 then
        gold = gold - costValue
        qiuxianling = qiuxianling - costValue1
        cur_liangcaoLv = cur_liangcaoLv + 1
        max_liangcao = max_liangcao + liangcaoCfg.up_point
        playerData:setYinliang(gold)
        playerData:setQiuxianling(qiuxianling)
        playerData:setLiangcao_lv(cur_liangcaoLv)
        playerData:setMax_liangcao(max_liangcao)
        self:dispatchLocalEvent(data.player_id, y3.EventConst.EVENT_UPGRADE_LIANGCAO_SUCCESS, cur_liangcaoLv)
    end
end

function SyncManager:_syncSellTower(data, source)
    if not data then
        return
    end
    local player = y3.player(data.player_id)
    local playerData = y3.userData:getPlayerData(data.player_id)
    local price = data.price
    local costliangcao = data.liangcao
    local gold = playerData:getYinliang()
    local liangcao = playerData:getLiangcao()
    gold = gold + price
    liangcao = liangcao - costliangcao
    playerData:setYinliang(gold)
    playerData:setLiangcao(liangcao)
    y3.gameApp:getGameLogic():removeTower(data.key)
    self:dispatchLocalEvent(data.player_id, y3.EventConst.EVENT_SELL_TOWER_SUCCESS, data.tower_id)
end

function SyncManager:_syncShengxing(data, source)
    if not data then
        return
    end
    local player = y3.player(data.player_id)
    y3.gameApp:getGameLogic():towerShengxing(player, data.unitId)
    self:dispatchLocalEvent(data.player_id, y3.EventConst.EVENT_SHENGXING_SUCCESS, data.unitId)
end

function SyncManager:_syncQianshan(data, source)
    if not data then
        return
    end
    local player     = y3.player(data.player_id)
    local playerData = y3.userData:getPlayerData(data.player_id)
    local buildId    = data.buildId
    local cfg        = include("gameplay.config.hero").get(buildId)
    local gold       = playerData:getYinliang()
    gold             = gold + cfg.cost
    playerData:setYinliang(gold)
    self:dispatchLocalEvent(data.player_id, y3.EventConst.EVENT_QIANSHAN_SUCCESS, buildId)
end

function SyncManager:_syncBuildShengxing(data, source)
    if not data then
        return
    end
    local player = y3.player(data.player_id)
    local buildId = data.buildId
    local tower = y3.gameApp:getGameLogic():checkCanAutoShengxing(player, buildId)
    if tower then
        tower:levelup()
    end
    self:dispatchLocalEvent(data.player_id, y3.EventConst.EVENT_BUILDTOWER_SUCCESS, buildId)
end

function SyncManager:_syncUpgradeJuewei(data, source)
    if not data then
        return
    end
    if y3.gameApp:getLevel():isInUpgradeChallange() then
        return
    end
    local player = y3.player(data.player_id)
    local chadata = y3.gameApp:getLevel():getPlayerChallengeData(data.player_id)
    local cfg = include("gameplay.config.king_title").get(chadata.level)
    local tasks = string.split(cfg.task_group_id, "|")
    local index = math.random(1, #tasks)
    local taskId = tonumber(tasks[index])
    y3.gameApp:getLevel():startUpgradeChallenge(data.player_id, taskId)
    self:dispatchLocalEvent(data.player_id, y3.EventConst.EVENT_UPGRADE_JUEWEI_TASK)
end

function SyncManager:_syncChallengeJuewei(data, source)
    if not data then
        return
    end
    if not y3.gameApp:getLevel():canStartChallenge(data.player_id) then
        return
    end
    local player = y3.player(data.player_id)
    local cnt = data.cnt
    local costCfg = include("gameplay.config.challange").get(1)
    local cfg = include("gameplay.config.honor_challange_wave").get(cnt)
    local qiuxian = player:get_attr(y3.const.PlayerAttr["求贤令"])
    local costNum = costCfg.cost_coin_number + costCfg.challenge_cost_add * (cnt - 1)
    qiuxian = qiuxian - costCfg.cost_coin_number
    player:set(y3.const.PlayerAttr["求贤令"], qiuxian)
    y3.gameApp:getLevel():startChallenge(cfg, player:get_id())
    self:dispatchLocalEvent(y3.EventConst.EVENT_ZHANXUN_TIAOZHAN_START)
end

function SyncManager:_syncSelectJueweiBuff(data, source)
    if not data then
        return
    end
    local player = y3.player(data.player_id)
    y3.gameApp:getLevel():selectJueweiBuff(player:get_id(), data.buffId)
    self:dispatchLocalEvent(data.player_id, y3.EventConst.EVENT_SELECT_JUEWEI_BUFF, data.buffId)
end

function SyncManager:_syncUpHeroOfficial(data, source)
    if not data then
        return
    end
    local player = y3.player(data.player_id)
    y3.gameApp:getLevel():setHeroOfficial(player:get_id(), data.officialId, data.unitId)
end

function SyncManager:_syncHeChengItem(data, source)
    if not data then
        return
    end
end

function SyncManager:_syncSellSelect(data, source)
    if not data then
        return
    end
end

function SyncManager:_syncSellAll(data, source)
    if not data then
        return
    end
end

function SyncManager:_syncBackMode(data, source)
    if not data then
        return
    end
    y3.userData:setGameMode(0)
    y3.userData:setGameLevelId(0)
    y3.gameApp:dispatchEvent(y3.EventConst.EVENT_GAME_STATUS_UPDATE)
end

function SyncManager:_syncSelectMode(data, source)
    if not data then
        return
    end
    local modeId = data.modeId
    print("select mode", modeId)
    y3.userData:setGameMode(modeId)
    y3.gameApp:dispatchEvent(y3.EventConst.EVENT_GAME_STATUS_UPDATE)
end

function SyncManager:_syncSelectLevel(data, source)
    if not data then
        return
    end
    local levelId = data.levelId
    local mode = y3.userData:getGameMode()
    if mode == 0 then
        return
    end
    y3.userData:setGameLevelId(levelId)
    y3.gameApp:dispatchEvent(y3.EventConst.EVENT_GAME_STATUS_UPDATE)
    y3.SyncMgr:sync(y3.SyncConst.SYNC_PLAYER_READY, { ready = true })
end

function SyncManager:_syncPlayerReady(data, source)
    if not data then
        return
    end
    local playerData = y3.userData:getPlayerData(data.player_id)
    playerData:setReady(data.ready)
    y3.gameApp:dispatchEvent(y3.EventConst.EVENT_GAME_STATUS_UPDATE)
end

function SyncManager:localPrint(playerId, ...)
    local args = { ... }
    y3.player.with_local(function(local_player)
        xpcall(function(...)
            if local_player:get_id() == playerId then
                PrintGame(table.unpack(args))
            end
        end, __G__TRACKBACK__)
    end)
end

------------------------
function SyncManager:_syncLearnSkill(data, source)
    if not data then
        return
    end
    local refreshSkill = y3.gameApp:getLevel():getLogic("SurviveRefreshSkill")
    refreshSkill:buySkill(data)
end

function SyncManager:_syncRefreshSkillPool(data, source)
    if not data then
        return
    end
    local playerId = data.player_id
    y3.gameApp:getLevel():getLogic("SurviveRefreshSkill"):initiativeRefreshCards({ 1, playerId })
end

function SyncManager:_syncStageSelect(data, source)
    if not data then
        return
    end
    local playerId = data.player_id
    local playerData = y3.userData:getPlayerData(playerId)
    if playerData:isRoomMaster() then
        local stageId = data.stageId
        local maxUnlockStageId = y3.gameApp:getLevel():getLogic("SurviveGameStagePass"):getMaxPassStageId(playerId)
        y3.userData:setMaxUnLockStageId(maxUnlockStageId)
        y3.gameApp:getLevel():startGame(stageId)
        local player = playerData:getPlayer()
        local cfg = include("gameplay.config.stage_config").get(stageId)
        assert(cfg, "")
        y3.G_PromptMgr:showNotice(12, { player_name = player:get_name(), stage_name = cfg.stage_name })
    else
        y3.Sugar.localTips(playerId, GameAPI.get_text_config('#215305308#lua'))
    end
end

function SyncManager:_syncChallengeStart(data, source)
    if not data then
        return
    end
    local playerId = data.player_id
    y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy"):getGoldChallenge():startStageChallenge(playerId)
end

function SyncManager:_syncPauseGame(data, source)
    if not data then
        return
    end
    local playerData = y3.userData:getPlayerData(data.player_id)
    local player = y3.player(data.player_id)
    if data.pause then
        local pauseCount = playerData:getPauseCount()
        if pauseCount <= 0 then
            return
        end
        y3.gameApp:setPause(data.pause)
        local playerNum = y3.userData:getPlayerCount()
        if playerNum > 1 then
            playerData:setPauseCount(pauseCount - 1)
        end
        y3.G_PromptMgr:showNotice(11, { player_name = player:get_name() })
    else
        y3.gameApp:setPause(data.pause)
        y3.G_PromptMgr:showNotice(10, { player_name = player:get_name() })
    end
    y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SURVIVE_GAME_PAUSE, data.player_id)
end

function SyncManager:_syncAbyssChallengeStart(data, source)
    if not data then
        return
    end
    y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy"):getAbysChallenge():startChallenge(data.player_id)
end

function SyncManager:_syncRewardSkillSelect(data, source)
    if not data then
        return
    end
    local playerData = y3.userData:getPlayerData(data.player_id)
    local SurviveHelper = include("gameplay.level.logic.helper.SurviveHelper")
    local randomItem = include("gameplay.config.random_pool").get(data.itemId)
    assert(randomItem, "randomItem is nil")
    local abyssChallenge = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy"):getAbysChallenge()
    if randomItem.item_type == 1 or randomItem.item_type == 2 then -- 技能
        SurviveHelper.leanSkill({ playerData:getId(), randomItem.random_pool_item })
    elseif randomItem.item_type == 3 then                          -- 道具
        SurviveHelper.dropItem(playerData:getId(), randomItem.random_pool_item)
    elseif randomItem.item_type == 4 then                          -- 塔魂
        local heroCfg = include("gameplay.config.hero").get(randomItem.random_pool_item)
        if heroCfg then
            local mainActor = playerData:getMainActor()
            local soulActor = nil
            if mainActor then
                soulActor = mainActor:getSoulHeroActor()
            end
            if soulActor then
                local skills = string.split(heroCfg.hero_talent_skill_group, "|")
                for i = 1, #skills do
                    soulActor:learnSkill(tonumber(skills[i]))
                end
                soulActor:setSoulCfg(heroCfg)
            end
        end
    elseif randomItem.item_type == 5 then -- 任务
        log.info("receive task", randomItem.random_pool_item)
        local taskSystem = y3.gameApp:getLevel():getLogic("SurviveGameTaskSyetem")
        taskSystem:receiveTask(playerData:getId(), randomItem.random_pool_item)
    end
    abyssChallenge:removeRecordList(data.player_id, data.recordIndex)
end

function SyncManager:_syncCommonChallengeStart(data, source)
    if not data then
        return
    end
    local playerId = data.player_id
    local challenge_type = data.challenge_type
    if challenge_type == 2 then
        y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy"):getDiamondChallenge():startStageChallenge(playerId)
    end
end

function SyncManager:_syncRefreshAbyssShop(data, source)
    if not data then
        return
    end
    local abyssChallenge = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy"):getAbysChallenge()
    local abyssShop = abyssChallenge:getShop()
    abyssShop:initiativeRefreshCards(data.player_id)
end

function SyncManager:_syncAbyssShopBuy(data, source)
    if not data then
        return
    end
    local abyssChallenge = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy"):getAbysChallenge()
    local abyssShop = abyssChallenge:getShop()
    abyssShop:buyAbyssShop(data.player_id, data.slot, data.buyTimes)
end

function SyncManager:_syncAttrPackList(data, source)
    if not data then
        return
    end
    local playerId = data.player_id
    local playerData = y3.userData:getPlayerData(playerId)
    local attrPackList = data.attrPackList
    for i = 1, #attrPackList do
        local mainActor = playerData:getMainActor()
        mainActor:addAttrPack(attrPackList[i], y3.const.UnitAttrType["基础"])
    end
end

function SyncManager:_syncAbyssChallengeBounsGet(data, source)
    if not data then
        return
    end
    local abyssChallenge = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy"):getAbysChallenge()
    abyssChallenge:refreshRecordRewardList(data.player_id, data.recordType)
end

function SyncManager:_syncTreasureUpgrade(data, source)
    if not data then
        return
    end
    local treasureLogic = y3.gameApp:getLevel():getLogic("SurviveGameTreasure")
    treasureLogic:upgradeTreasure(data.player_id, data.treasureId)
end

function SyncManager:_syncSaveSyncEnd(data, source)
    if not data then
        return
    end
    y3.gameApp:getLevel():onSyncSaveEnd(data.player_id)
end

function SyncManager:_syncSelectedSkinTower(data, source)
    if not data then
        return
    end
    if y3.gameApp:getLevel():isGameStart() then
        return
    end
    local playerData = y3.userData:getPlayerData(data.player_id)
    local towerId = data.towerId
    playerData:setSkinTower(towerId)
    local gameCourse = y3.gameApp:getLevel():getLogic("SurviveGameCourse")
    gameCourse:recordStageTower(data.player_id, towerId)
end

function SyncManager:_syncWeaponEffect(data, source)
    if not data then
        return
    end
    local playerData = y3.userData:getPlayerData(data.player_id)
    local weaponEffectList = data.weaponEffectList
    local weaponEffectMap = playerData:getWeaponEffectMap()
    for i = 1, #weaponEffectList do
        local effectData = weaponEffectList[i]
        local weaponId = effectData.weaponId
        if not weaponEffectMap[weaponId] then
            weaponEffectMap[weaponId] = {}
        end
        local effects = string.split(effectData.effect, "#")
        assert(effects)
        local effectId = tonumber(effects[1]) or 0
        local effectValue = tonumber(effects[2]) or 0
        if not weaponEffectMap[weaponId][effectId] then
            weaponEffectMap[weaponId][effectId] = effectValue
        else
            weaponEffectMap[weaponId][effectId] = weaponEffectMap[weaponId][effectId] + effectValue
        end
    end
    print("weaponEffectListadasda")
end

function SyncManager:_syncWeaponUpgrade(data, source)
    if not data then
        return
    end
    local playerData = y3.userData:getPlayerData(data.player_id)
    local weanponSave = y3.gameApp:getLevel():getLogic("SurviveGameWeaponSave")
    weanponSave:upgradeWeapon(data.player_id, data.weaponId, data.addLv)
end

function SyncManager:_syncTechUpgrade(data, source)
    if not data then
        return
    end
    local technology = y3.gameApp:getLevel():getLogic("SurviveGameTechnology")
    technology:upgradeTechnology(data.player_id, data.techType)
end

function SyncManager:_syncEndBossResult(data, source)
    if not data then
        return
    end
    local spawnEnemy = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy")
    spawnEnemy:gameResult(data.player_id)
end

function SyncManager:_syncSelectSaveBoss(data, source)
    if not data then
        return
    end
    local spawnEnemy = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy")
    spawnEnemy:selectSaveBoss(data.player_id, data.bossId)
end

function SyncManager:_syncBuyHeroShopItem(data, source)
    if not data then
        return
    end
    local heroShop = y3.gameApp:getLevel():getLogic("SurviveGameHeroShop")
    heroShop:buyShop(data.player_id, data.round, data.slot)
end

function SyncManager:_syncShopUpStage(data, source)
    if not data then
        return
    end
    local heroShop = y3.gameApp:getLevel():getLogic("SurviveGameHeroShop")
    heroShop:upStage(data.player_id)
end

function SyncManager:_syncEquipTitle(data, source)
    if not data then
        return
    end
    local playerData = y3.userData:getPlayerData(data.player_id)
    local titleId = data.titleId
    local cfg = include("gameplay.config.title").get(titleId)
    if cfg then
        if cfg.type == 1 then
            playerData:setPreTitleId(titleId)
        elseif cfg.type == 2 then
            playerData:setConnectTitleId(titleId)
        elseif cfg.type == 3 then
            playerData:setSuffixTtileId(titleId)
        end
        local achievementTitle = y3.gameApp:getLevel():getLogic("SurviveGameAchievementTitle")
        achievementTitle:equipTitile(data.player_id, titleId)
    end
    y3.gameApp:dispatchEvent(y3.EventConst.EVENT_EQUIP_TITLE_SUCCESS, playerData:getId(), titleId)
end

function SyncManager:_syncBuyShopExp(data, source)
    if not data then
        return
    end
    local refreshSkill = y3.gameApp:getLevel():getLogic("SurviveRefreshSkill")
    refreshSkill:buyShopExp(data.player_id)
end

function SyncManager:_syncReceiveBPReward(data, source)
    if not data then
        return
    end

    local playerId = data.playerId
    local player = y3.player(playerId)
    local seasonIndex = data.seasonIndex
    local paramDic = data.param
    local basttlePassData = y3.gameApp:getLevel():getLogic("SurviveGameBattlePass")
    basttlePassData:recordRewardReceiveInfo(player, seasonIndex, paramDic)

    local battlepassActivityCfg = include("gameplay.config.game_acitivity")
    if not battlepassActivityCfg then
        log.error("battlepass activity cfg error")
        return
    end
    local battlepassCfg = include("gameplay.config.game_battlepass")
    if not battlepassActivityCfg then
        log.error("bp cfg error")
        return
    end

    local detailInfo = basttlePassData:getSaveData(seasonIndex)
    if not detailInfo then
        log.error("bp archiveData error")
        return
    end

    local length = battlepassCfg.length()
    for index = 1, length, 1 do
        while true do
            local cfgInfo = battlepassCfg.indexOf(index)
            if not cfgInfo then
                break
            end

            if cfgInfo.game_season ~= seasonIndex then
                break
            end

            for dataType, detailParam in pairs(paramDic) do
                if dataType == basttlePassData.SeasonDataIndex.SpecialReward and detailParam and #detailParam > 0 then
                    for key, rewardInfo in pairs(detailParam) do
                        local rewardParams = string.split(rewardInfo, "#")
                        if rewardParams and #rewardParams > 0 then
                            local rewardType = tonumber(rewardParams[1])
                            if rewardType == y3.SurviveConst.DROP_TYPE_ATTR_PACK then
                                break
                            end
                            y3.userDataHelper.dropSaveItem(playerId, rewardInfo)
                        end
                    end
                    paramDic[dataType] = nil
                else
                    for index, level in pairs(detailParam) do
                        if cfgInfo.game_battlepass_level == level then
                            local rewardInfo

                            if dataType == basttlePassData.SeasonDataIndex.FreeReward then
                                rewardInfo = cfgInfo.game_battlepass_basic_reward
                            elseif dataType == basttlePassData.SeasonDataIndex.AdvancedReward then
                                rewardInfo = cfgInfo.game_battlepass_privilege_reward
                            elseif dataType == basttlePassData.SeasonDataIndex.UltimateReward then
                                rewardInfo = cfgInfo.game_battlepass_gold_reward
                            end

                            if rewardInfo then
                                local rewardParams = string.split(rewardInfo, "#")
                                if rewardParams and #rewardParams == 3 then
                                    local rewardType = tonumber(rewardParams[1])
                                    if rewardType == y3.SurviveConst.DROP_TYPE_ATTR_PACK then
                                        break
                                    end
                                    y3.userDataHelper.dropSaveItem(playerId, rewardInfo)
                                end
                            end
                        end
                    end
                end
            end
            break
        end
    end
end

function SyncManager:_syncAddBPExp(data, source)
    if not data then
        return
    end

    local playerId = data.playerId
    local player = y3.player(playerId)
    local exp = data.exp
    local seasonIndex = data.seasonIndex
    local basttlePassData = y3.gameApp:getLevel():getLogic("SurviveGameBattlePass")
    basttlePassData:addExp(player, seasonIndex, exp)
end

function SyncManager:_syncHechengItem(data, source)
    if not data then
        return
    end
    local playerData = y3.userData:getPlayerData(data.player_id)
end

function SyncManager:_syncSellPkgOneKey(data, source)
    if not data then
        return
    end
    local playerData = y3.userData:getPlayerData(data.player_id)
end

function SyncManager:_syncSellItemPkgOne(data, source)
    if not data then
        return
    end
    local playerData = y3.userData:getPlayerData(data.player_id)
end

function SyncManager:_syncRemoveRewardSelect(data, source)
    if not data then
        return
    end
    local abyssChallenge = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy"):getAbysChallenge()
    if data.recordIndex and data.recordIndex > 0 then
        abyssChallenge:removeRecordList(data.player_id, data.recordIndex)
    end
end

function SyncManager:_syncEquipTowerSkin(data, source)
    if not data then
        return
    end
    local playerData = y3.userData:getPlayerData(data.player_id)
    local towerSkinId = data.towerSkinId
    print(type(towerSkinId))
    playerData:setTowerSkinId(towerSkinId)
    local gameCourse = y3.gameApp:getLevel():getLogic("SurviveGameCourse")
    gameCourse:equipTowerSkin(data.player_id, towerSkinId)
    y3.gameApp:dispatchEvent(y3.EventConst.EVENT_EQUIP_TOWER_SKIN_SUCCESS, playerData:getId(), towerSkinId)
end

function SyncManager:_syncUnequipTowerSkin(data, source)
    if not data then
        return
    end
    local playerData = y3.userData:getPlayerData(data.player_id)
    local towerSkinId = 0
    playerData:setTowerSkinId(0)
    local gameCourse = y3.gameApp:getLevel():getLogic("SurviveGameCourse")
    gameCourse:equipTowerSkin(data.player_id, towerSkinId)
    y3.gameApp:dispatchEvent(y3.EventConst.EVENT_EQUIP_TOWER_SKIN_SUCCESS, playerData:getId(), towerSkinId)
end

function SyncManager:_syncPlatformAttrList(data, source)
    if not data then
        return
    end
    local playerData = y3.userData:getPlayerData(data.player_id)
    local mainActor = playerData:getMainActor()
    if mainActor then
        local attrList = data.attrList
        for i = 1, #attrList do
            mainActor:addBaseAttr(attrList[i].id, attrList[i].value, y3.const.UnitAttrType["基础"])
        end
    end
end

function SyncManager:_syncPlatformSkillList(data, source)
    if not data then
        return
    end
    local playerData = y3.userData:getPlayerData(data.player_id)
    local mainActor = playerData:getMainActor()
    if mainActor then
        local skillList = data.skillList
        for i = 1, #skillList do
            y3.surviveHelper.leanSkill({ playerData:getId(), skillList[i].id })
        end
    end
end

function SyncManager:_syncGetSigndayReward(data, source)
    if not data then
        return
    end
    local playerData = y3.userData:getPlayerData(data.player_id)
    local sevenDay = y3.gameApp:getLevel():getLogic("SurviveGameSevenDay")
    sevenDay:signDay(playerData:getId())
    y3.gameApp:dispatchEvent(y3.EventConst.EVENT_GET_SEVEN_DAY_REWARD_SUCCESS, playerData:getId())
end

function SyncManager:_syncRandomLoadTipsText(data, source)
    if not data then
        return
    end
    local playerData = y3.userData:getPlayerData(data.player_id)
    local game_loading_tips = include("gameplay.config.game_loading_tips")
    local len = game_loading_tips.length()
    local index = math.random(1, len)
    local cfg = game_loading_tips.indexOf(index)
    if cfg then
        y3.gameApp:dispatchEvent(y3.EventConst.EVENT_RANDOM_LOAD_TIPS_TEXT, playerData:getId(), cfg.id)
    end
end

function SyncManager:_syncInsertLabelSort(data, source)
    if not data then
        return
    end
    local playerData = y3.userData:getPlayerData(data.player_id)
    local labelType = data.labelType
    local label = data.label
    if label <= 0 then
        return
    end
    local gameCourse = y3.gameApp:getLevel():getLogic("SurviveGameCourse")
    log.info("SyncManager:_syncInsertLabelSort ", labelType, label)
    local removeSortLabel = function(recordSorts, label)
        for i = #recordSorts, 1, -1 do
            if recordSorts[i] == label or recordSorts[i] == 0 then
                table.remove(recordSorts, i)
            end
        end
    end
    if labelType == 1 then
        local recordSorts, isSave = gameCourse:getShopHelperWeanponSort(data.player_id)
        if isSave then
            removeSortLabel(recordSorts, label)
            table.insert(recordSorts, label)
        else
            recordSorts = {}
            table.insert(recordSorts, label)
        end
        gameCourse:recordShopHelperWeanponSort(playerData:getId(), recordSorts)
    elseif labelType == 2 then
        local recordSorts, isSave = gameCourse:getShopHelperWeanponAddSort(data.player_id)
        if isSave then
            removeSortLabel(recordSorts, label)
            table.insert(recordSorts, label)
        else
            recordSorts = {}
            table.insert(recordSorts, label)
        end
        gameCourse:recordShopHelperWeanponAddSort(playerData:getId(), recordSorts)
    elseif labelType == 3 then
        local recordSorts, isSave = gameCourse:getShopHelperWeaponOtherAddSort(data.player_id)
        if isSave then
            removeSortLabel(recordSorts, label)
            table.insert(recordSorts, label)
        else
            recordSorts = {}
            table.insert(recordSorts, label)
        end
        gameCourse:recordShopHelperWeanponOtherAddSort(playerData:getId(), recordSorts)
    elseif labelType == 4 then
        local recordSorts, isSave = gameCourse:getShopHelperWeaponQualitySort(data.player_id)
        if isSave then
            removeSortLabel(recordSorts, label)
            table.insert(recordSorts, label)
        else
            recordSorts = {}
            table.insert(recordSorts, label)
        end
        gameCourse:recordShopHelperWeanponQualitySort(playerData:getId(), recordSorts)
    end
    y3.gameApp:dispatchEvent(y3.EventConst.EVENT_INSERT_LABEL_SORT_SUCCESS, playerData:getId(), labelType, label)
end

function SyncManager:_syncRemoveLabelSort(data, source)
    if not data then
        return
    end
    local playerData = y3.userData:getPlayerData(data.player_id)
    local labelType = data.labelType
    local label = data.label
    if label <= 0 then
        return
    end
    local gameCourse = y3.gameApp:getLevel():getLogic("SurviveGameCourse")
    local removeSortLabel = function(recordSorts, label)
        for i = #recordSorts, 1, -1 do
            if recordSorts[i] == label or recordSorts[i] == 0 then
                table.remove(recordSorts, i)
            end
        end
    end
    log.info("SyncManager:_syncRemoveLabelSort ", labelType, label)
    if labelType == 1 then
        local recordSorts = gameCourse:getShopHelperWeanponSort(data.player_id)
        removeSortLabel(recordSorts, label)
        gameCourse:recordShopHelperWeanponSort(playerData:getId(), recordSorts)
    elseif labelType == 2 then
        local recordSorts = gameCourse:getShopHelperWeanponAddSort(data.player_id)
        removeSortLabel(recordSorts, label)
        gameCourse:recordShopHelperWeanponAddSort(playerData:getId(), recordSorts)
    elseif labelType == 3 then
        local recordSorts = gameCourse:getShopHelperWeaponOtherAddSort(data.player_id)
        removeSortLabel(recordSorts, label)
        gameCourse:recordShopHelperWeanponOtherAddSort(playerData:getId(), recordSorts)
    elseif labelType == 4 then
        local recordSorts = gameCourse:getShopHelperWeaponQualitySort(data.player_id)
        removeSortLabel(recordSorts, label)
        gameCourse:recordShopHelperWeanponQualitySort(playerData:getId(), recordSorts)
    end
    y3.gameApp:dispatchEvent(y3.EventConst.EVENT_REMOVE_LABEL_SORT_SUCCESS, playerData:getId(), labelType, label)
end

function SyncManager:_syncShopHelperOpen(data, source)
    if not data then
        return
    end
    local gameCourse = y3.gameApp:getLevel():getLogic("SurviveGameCourse")
    local isOpen = data.isOpen
    gameCourse:setShopHelperOpen(data.player_id, isOpen)
    y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SHOP_HELPER_OPEN_SUCCESS, data.player_id, isOpen)
end

function SyncManager:_syncShopAutoRefresh(data, source)
    if not data then
        return
    end
    local gameCourse = y3.gameApp:getLevel():getLogic("SurviveGameCourse")
    local isAuto = data.isAuto
    gameCourse:setShopHelperAutoRefresh(data.player_id, isAuto)
    y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SHOP_HELPER_AUTO_SUCCESS, data.player_id, isAuto)
end

return SyncManager
