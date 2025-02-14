local GlobalConfigHelper = include "gameplay.level.logic.helper.GlobalConfigHelper"
local LevelBase = include("gameplay.level.LevelBase")
local SurviveTowerMap = class("SurviveTowerMap", LevelBase)

function SurviveTowerMap:ctor()
    SurviveTowerMap.super.ctor(self)
    self._gameStart = false
    self._gameReadyStart = false
    self._gameEnterStart = false
end

function SurviveTowerMap:isGameStart()
    return self._gameStart
end

function SurviveTowerMap:isGameReadyStart()
    return self._gameReadyStart
end

function SurviveTowerMap:isGameEnterStart()
    return self._gameEnterStart
end

function SurviveTowerMap:onInitData()
end

function SurviveTowerMap:onInitView()
    local viewList = {
        "gameplay.view.survive.main.SurviveGameHUD",
        "gameplay.view.tip.SurviveGameTip"
    }
    self:initView(viewList)
    -- include("gameplay.view.component.init")
end

function SurviveTowerMap:onInitLogic()
    self:addLogic("SurviveGameAchievement", true)
    self:addLogic("SurviveGameSaveItem", true)
    self:addLogic("SurviveGameStagePass", true)
    self:addLogic("SurviveGameTreasure", true)
    self:addLogic("SurviveGameTreasureDrop", true)
    self:addLogic("SurviveGameWeaponSave", true)
    self:addLogic("SurviveGameBattlePass", true)
    self:addLogic("SurviveGameCourse", true)
    self:addLogic("SurviveGameAchievementTitle", true)
    self:addLogic("SurviveGamePatch", true)
    self:addLogic("SurviveGamePlatformShop", true)
    self:addLogic("SurviveGameSevenDay", true)
    ------------------------------------------
    self:addLogic("SurviveGameStart")
    y3.userDataHelper.uploadTrackingDataInit(y3.gameApp:getMyPlayerId())
end

function SurviveTowerMap:onReadyStart()
    if not self._gameReadyStart then
        self._gameReadyStart = true
        pcall(function(...)
            self:getLogic("SurviveGameAchievementTitle"):syncTitle()
            self:getLogic("SurviveGameCourse"):syncTowerSkin()
            self:getLogic("SurviveGamePlatformShop"):initPlatformShopStart()
            self:getLogic("SurviveGameBattlePass"):autoUseExpItem()
        end)
        y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SURVIVE_GAME_READY_START)
    end
end

function SurviveTowerMap:startGame(stageId)
    if self._gameReadyStart and not self._gameEnterStart then
        self._gameEnterStart = true
        y3.userData:setCurStageId(stageId)
        self:getLogic("SurviveGameStart"):startTimeEnter()
        self:_onStart()
        y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SURVIVE_GAME_START)
    end
end

function SurviveTowerMap:onEnterStart()
    if self._gameEnterStart and not self._gameStart then
        self._gameStart = true
        self:getLogic("SurviveGameStart"):startTimeStart()
        y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SURVIVE_GAME_ENTER_START)
    end
end

function SurviveTowerMap:_onStart()
    self:_initPlayer()
    self:addLogic("SurviveGameStatus")
    self:addLogic("SurviveRefreshSkill")
    self:addLogic("SurviveSpawnerEnemy")
    self:addLogic("SurviveResource")
    self:addLogic("SurviveGameTaskSyetem")
    self:addLogic("SurviveGameTechnology")
    self:addLogic("SurviveGameHeroShop")
    self:addLogic("SurviveGameCheckFuncOpen")
    -------------------------------------
    self:_initSaveData()
end

function SurviveTowerMap:_initSaveData()
    pcall(function(...)
        self:getLogic("SurviveGameAchievement"):initAchievementReward()
        self:getLogic("SurviveGameTreasure"):initTreasureAttr()
        self:getLogic("SurviveGameWeaponSave"):initWeaponAttr()
        self:getLogic("SurviveGameBattlePass"):initBattlePassAttr()
        self:getLogic("SurviveGameAchievementTitle"):initTitleAttr()
        self:getLogic("SurviveGameCourse"):initTowerSkinAttr()
        self:getLogic("SurviveGamePlatformShop"):initPlatformShopGameStart()
        y3.userDataHelper.unloadMaxPower(y3.gameApp:getMyPlayerId())
    end)
    y3.SyncMgr:sync(y3.SyncConst.SYNC_SAVE_SYNC_END, {})
end

function SurviveTowerMap:onSyncSaveEnd(playerId)
    local playerData = y3.userData:getPlayerData(playerId)
    local player = playerData:getPlayer()
    local hero = playerData:getMainActor()
    local initGold = hero:getUnit():get_attr(y3.const.UnitAttr["初始金币"])
    local initDiamond = hero:getUnit():get_attr(y3.const.UnitAttr["初始魂石数量"])
    player:set("gold", initGold)
    player:set("diamond", initDiamond)
end

function SurviveTowerMap:_initPlayer()
    local stageCfg = include("gameplay.config.stage_config").get(y3.userData:getCurStageId())
    assert(stageCfg, "stageCfg is nil by id=" .. y3.userData:getCurStageId())
    y3.eca.call('游戏模式选择确认', { stageCfg.stage_type })
    local playerDataList = y3.userData:getAllInPlayers()
    for i = 1, #playerDataList do
        self:_initPlayerUnit(playerDataList[i])
        self:getLogic("SurviveGameCourse"):recordFirstTime(playerDataList[i]:getId())
        self:getLogic("SurviveGameSevenDay"):recordSignDay(playerDataList[i]:getId())
    end
    y3.userDataHelper.uploadTrackingDataStart(y3.gameApp:getMyPlayerId())
    self:_initPlayerSetting()
end

function SurviveTowerMap:_initPlayerSetting()
    xpcall(function(...)
        local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
        local player = playerData:getPlayer()
        local hero = playerData:getMainActor()
        if y3.Sugar.gameCourse():isShowEffect() then
            y3.game.sfx_switch(player, true)
        else
            y3.game.sfx_switch(player, false)
        end
        if y3.Sugar.gameCourse():isShowCallSoul() then
            hero:getUnit():kv_save("callsoul", true)
        else
            hero:getUnit():kv_save("callsoul", false)
        end
    end, __G__TRACKBACK__)
end

function SurviveTowerMap:_initPlayerUnit(playerData)
    local player = playerData:getPlayer()
    y3.camera.set_moving_with_mouse(player, false)
    y3.ui.change_mini_map_img(player, 134266760)
    player:set_name(playerData:getTitleText())
    local pointStart = y3.point.get_point_by_res_id(y3.userDataHelper.getPlayerSpawnPointId(player:get_id()))
    player:set_mouse_drag_selection(false)
    local hero = include("gameplay.scene.actor.HeroActor").new(player:get_id())
    player:select_unit(hero:getUnit())
    hero:setPosition(pointStart)

    ---------------------------------------------
    y3.ltimer.wait(0.1, function(timer, count)
        local skinTower = playerData:getSkinTower()
        -- print("xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
        -- print(skinTower)
        local scfg = include("gameplay.config.stage_tower").get(skinTower)
        if scfg then
            if scfg.tower_config_skill_id > 0 then
                hero:learnSkill(scfg.tower_config_skill_id, y3.const.AbilityType.HERO)
                hero:setHeroIcon(scfg.tower_icon)
            end
        end
        local towerSkinId = playerData:getTowerSkinId()
        local skinCfg = include("gameplay.config.stage_tower_skin").get(towerSkinId)
        if skinCfg then
            hero:replaceModelId(skinCfg.tower_skin_model_id)
            hero:addAttrPack(skinCfg.tower_skin_equip_attr_pack, y3.const.UnitAttrType["基础"])
            hero:getUnit():set_scale(skinCfg.tower_skin_scale)
        end
        if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.SSR3) > 0 then -- 辉金buff
            hero:addBuff(1900001)
        end
        -- local curStageId = y3.userData:getCurStageId()
        -- local stageCfg = include("gameplay.config.stage_config").get(curStageId)
        -- if stageCfg then
        --     if stageCfg.default_skill ~= "" then
        --         local skillList = string.split(stageCfg.default_skill, "|")
        --         assert(skillList, "default_skill is empty")
        --         for i = 1, #skillList do
        --             -- y3.surviveHelper.leanSkill({ playerData:getId(), tonumber(skillList[i]) })
        --         end
        --     end
        -- end
    end)
    -----------------------------------------------
    y3.userData:getPlayerData(player:get_id()):setMainActor(hero)
end

return SurviveTowerMap
