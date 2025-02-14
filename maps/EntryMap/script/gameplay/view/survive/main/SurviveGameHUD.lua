local GameUtils                     = require "gameplay.utils.GameUtils"
local SurviveGameSettingUI          = include "gameplay.view.survive.main.SurviveGameSettingUI"
local SurviveGameBasicControlUI     = include "gameplay.view.survive.main.SurviveGameBasicControlUI"
local SurviveGamePlayerStatisticsUI = include "gameplay.view.survive.main.SurviveGamePlayerStatisticsUI"
local SurviveGamePlayerAllayUI      = include "gameplay.view.survive.main.SurviveGamePlayerAllayUI"
local SurviveGameBarItemListUI      = include "gameplay.view.survive.main.SurviveGameBarItemListUI"
local SurviveGameAbyssChallengeUI   = include "gameplay.view.survive.main.SurviveGameAbyssChallengeUI"
local SurviveGameStageChallengeUI   = include "gameplay.view.survive.main.SurviveGameStageChallengeUI"
local ViewBase                      = include("gameplay.base.ViewBase")
local SurviveSkillPoolUI            = include("gameplay.view.survive.main.SurviveSkillPoolUI")
local SurviveGameSkillTotal         = include("gameplay.view.survive.main.SurviveGameSkillTotal")
local SurviveGameSkillStatistics    = include("gameplay.view.survive.main.SurviveGameSkillStatistics")
local SurviveGameHead               = include("gameplay.view.survive.main.SurviveGameHead")
local SurviveGameStageUI            = include("gameplay.view.survive.main.SurviveGameStageUI")
local SurviveGameAbyssShopUI        = include("gameplay.view.survive.main.SurviveGameAbyssShopUI")
local SurviveGameHUD                = class("SurviveGameHUD", ViewBase)

function SurviveGameHUD:ctor()
    SurviveGameHUD.super.ctor(self, "hud")
end

function SurviveGameHUD:_initUIMap()
    self._uiMap = {}
end

function SurviveGameHUD:onInit()
    self:_initUIMap()
    --------------------------------------------
    self._chatUI = y3.UIHelper.getUI("51a02598-1e34-4ecb-8c64-f079b2562997")
    self._chatUI:set_visible(y3.game.is_debug_mode())
    self._btnSetting = y3.UIHelper.getUI("021d2952-7d04-42c9-a24c-da2a5937538e")
    self._btnMenu    = y3.UIHelper.getUI("e8c1e779-ac2f-4491-89e6-97ca38e559ed")
    self._btnMenu:set_button_enable(false)
    self._mask             = y3.UIHelper.getUI("287f624e-4c71-4fbf-8b19-b0bb477eca23")
    self._commonSkill      = y3.UIHelper.getUI("74faee8b-a1c4-40c5-ab54-ae4620717f26")
    self._versionText      = y3.UIHelper.getUI("28309931-cfa9-472d-914a-519543d7e4c6")
    self._menu             = include("gameplay.view.menu.SurviveMenuView").new()          --y3.UIHelper.getUI("ed0d6420-e5c0-4308-80cd-1b5fb3956cdd")
    self._menuMaintitle    = include("gameplay.view.menu.SurviveMenuMaintitleView").new() --  y3.UIHelper.getUI("f762ecbe-f23b-4a4a-bf8e-9b399200278f")
    self._menuLoading      = include("gameplay.view.menu.SurviveMenuLoadingView").new()
    self._needInterception = include("gameplay.view.survive.main.common.NeedInterceptionHoverBottom").new()
    self._menuMaintitle:setVisible(true)
    self._menu:setVisible(false)
    self._commonSkill:set_visible(false)
    ----------------------------------------------------
    self._stage = SurviveGameStageUI.new(nil, self)
    self._settingUi = SurviveGameSettingUI.new(self)

    self:addTrigger(y3.gameApp:registerEvent(y3.EventConst.EVENT_SURVIVE_GAME_START, handler(self, self._onStart)))
    self:addTrigger(y3.gameApp:registerEvent(y3.EventConst.EVENT_SURVIVE_GAME_READY_START,
        handler(self, self._onReadyStart)))
    self:addTrigger(y3.gameApp:registerEvent(y3.EventConst.EVENT_SURVIVE_GAME_ENTER_START,
        handler(self, self._onEnterStart)))
    self:addTrigger(y3.gameApp:registerEvent(y3.EventConst.EVENT_SHOW_HUD,
        handler(self, self._onEventShowHud)))
    self:addTrigger(y3.gameApp:registerEvent(y3.EventConst.EVENT_SURVIVE_REFRESH_SKILl,
        handler(self, self._onEventRefreshSkill)))
    self:addTrigger(y3.gameApp:registerEvent(y3.EventConst.EVENT_SURVIVE_SKILL_INFO_UPDATE,
        handler(self, self._onEventSkillInfoUpdate)))
    self:addTrigger(y3.gameApp:registerEvent(y3.EventConst.EVENT_SURVIVE_REFRESH_DPS,
        handler(self, self._onEventSurviveRefreshDps)))
    self:addTrigger(y3.gameApp:registerEvent(y3.EventConst.EVENT_SURVIVE_NOTICE_SHOW,
        handler(self, self._onEventNoticeShow)))
    self:addTrigger(y3.gameApp:registerEvent(y3.EventConst.EVENT_SURVIVE_GAME_PAUSE, handler(self, self._onEventPause)))
    self:addTrigger(y3.gameApp:registerEvent(y3.EventConst.EVENT_SURVIVE_SELECT_REWARD,
        handler(self, self._onEventSelectReward)))
    self:addTrigger(y3.gameApp:registerEvent(y3.EventConst.EVENT_SURVIVE_SELECT_UNIT,
        handler(self, self._onEventSelectUnit)))
    self:addTrigger(y3.gameApp:registerEvent(y3.EventConst.EVENT_SURVIVE_SHOW_NPC_INFO,
        handler(self, self._onEventShowNpcInfo)))
    self._btnSetting:add_local_event("左键-按下", handler(self, self._onBtnSettingClick))
    self._versionText:add_local_event("左键-点击", function(local_player)
        GameUtils.gotoWebUrl()
    end)
end

function SurviveGameHUD:_onBtnSettingClick(local_player)
    self._settingUi:show(not self._settingUi:isVisible())
end

function SurviveGameHUD:_onBtnMenuClick(local_player)
    if y3.gameApp:getLevel():isGameStart() then
        self._menu:setVisible(not self._menu:isVisible())
        self._stage:updateState()
    end
end

function SurviveGameHUD:_onReadyStart(trg)
    self._menu:setVisible(true)
    y3.ltimer.wait(0.1, function(timer, count)
        self._menuMaintitle:setVisible(false)
    end)
end

function SurviveGameHUD:_onStart()
    self._shopSkill          = SurviveSkillPoolUI.new(y3.UIHelper.getUI("1870e693-45b7-4edc-9e05-acdf4f1f40ea"), self)
    self._skillTotal         = SurviveGameSkillTotal.new(y3.UIHelper.getUI("71adb592-0e67-4acf-afdb-ba0151d70d55"), self)
    self._skillStatistics    = SurviveGameSkillStatistics.new(y3.UIHelper.getUI("07ba816c-019c-474d-bddd-383d55a6ed14"),
        self)
    self._head               = SurviveGameHead.new(self._main:get_child("head"), self)
    self._challengeUI        = SurviveGameStageChallengeUI.new(self)
    self._abyssChallengeUi   = SurviveGameAbyssChallengeUI.new(self)
    self._abyssShopUI        = SurviveGameAbyssShopUI.new(self)
    self._itemBar            = SurviveGameBarItemListUI.new(self)
    self._playerAllyUI       = SurviveGamePlayerAllayUI.new(self)
    self._playerStatisticsUI = SurviveGamePlayerStatisticsUI.new(self)
    self._basicControl       = SurviveGameBasicControlUI.new(self)
    self._bossShowUI         = include("gameplay.view.survive.main.SurviveGameBossShowUI").new(self)
    self._settWin            = include("gameplay.view.settlement.SettlementUIWin").new()
    self._settFailed         = include("gameplay.view.settlement.SettlementUIFailed").new()
    self._resourceUI         = include("gameplay.view.survive.main.SurviveGameResUI").new()
    self._attrUI             = include("gameplay.view.survive.main.SurviveGameAllAttrUI").new(self)
    self._heroShopUI         = include("gameplay.view.survive.main.SurviveGameHeroShopUI").new(self)
    self._technologyUI       = include("gameplay.view.survive.main.SurviveGameTechnologyUI").new(self)
    self._wikiUI             = include("gameplay.view.survive.main.SurviveGameWikiUI").new(self)

    self._commonSkill:set_visible(true)
    self._skillTotal:updateUI()
    self._head:updateUI()
    self._challengeUI:updateUI()
    y3.ctimer.loop(1, function(timer, count, local_player)
        y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SURVIVE_REFRESH_DPS)
    end)
end

function SurviveGameHUD:showResultUI(win)
    y3.game.pause_game()
    if win then
        self._settWin:setVisible(true)
        self._settFailed:setVisible(false)
    else
        self._settFailed:setVisible(true)
        self._settWin:setVisible(false)
    end
end

function SurviveGameHUD:getHeadUI()
    return self._head
end

function SurviveGameHUD:_onEnterStart()
    print("SurviveGameHUD:_onEnterStart")
    self._menuLoading:setVisible(true)
    self:setVisible(true)
    self._inventoryUI = include("gameplay.view.survive.main.SurviveGameInventoryUI").new(self)
    y3.ltimer.wait(0.1, function(timer, count)
        self._menu:setVisible(false)
    end)
end

function SurviveGameHUD:_onEventShowHud()
    self._btnMenu:add_local_event("左键-点击", handler(self, self._onBtnMenuClick))
    self._btnMenu:set_button_enable(true)
    self._menuLoading:setVisible(false)
    self._taskUi       = include("gameplay.view.survive.main.SurviveGameTaskUI").new(self)
    self._signDayUI    = include("gameplay.view.survive.main.SurviveGameSevenDayUI").new(self)
    self._shopHelperUI = include("gameplay.view.survive.main.autoBuy.ShopHerperBuyUI").new()
    self._afkReceiveUi = include("gameplay.view.survive.main.afk.AFKModeReceiveUI").new()
    self._taskMainUI   = include("gameplay.view.survive.main.task.TaskMainUI").new()
    self._stageSpeedUI = include("gameplay.view.survive.main.button.StageSpeedUI").new(self)
end

function SurviveGameHUD:showAbyssShop()
    if self._abyssShopUI:isVisible() then
        self._abyssShopUI:show(false)
    else
        self._abyssShopUI:show(true)
    end
end

function SurviveGameHUD:_onEventRefreshSkill(trg, playerId, isAnim)
    y3.ctimer.wait_frame(2, function(timer, count, local_player)
        self:refreshSkillPool(playerId, isAnim)
    end)
end

function SurviveGameHUD:refreshSkillPool(playerId, isAnim)
    y3.player.with_local(function(local_player)
        if local_player:get_id() == playerId then
            local playerData = y3.userData:getPlayerData(playerId)
            self._shopSkill:updateUI(playerData, isAnim)
        end
    end)
end

function SurviveGameHUD:_onEventSkillInfoUpdate(trg, playerId)
    if playerId == y3.gameApp:getMyPlayerId() then
        if self._skillTotal then
            self._skillTotal:updateUI()
        end
    end
    -- self._skillStatistics:updateUI()
end

function SurviveGameHUD:_onEventSurviveRefreshDps(trg)
    self._skillTotal:updateUI()
    self._skillStatistics:updateUI()
    self._head:updateUI()
    self._head:updateTimeline()
    self._challengeUI:updateUI()
    self._abyssChallengeUi:updateUI()
    self._playerStatisticsUI:updateUI()
    self._playerAllyUI:updateUI()
    self:refreshSkillPool(y3.gameApp:getMyPlayerId())
end

function SurviveGameHUD:showSkillStatistics(skillType)
    self._skillStatistics:show(skillType)
end

function SurviveGameHUD:_onEventNoticeShow(trg, id)
    local waveUICfg = include("gameplay.config.stage_wave_ui").get(id)
    assert(waveUICfg, "can not found cfg in stage_wave_ui by id=" .. id)
    if waveUICfg.active == 1 and waveUICfg.ui_name ~= "" then
        local ui = y3.UIHelper.getUI(waveUICfg.ui_name)
        ui:set_visible(true)
        ui:set_alpha(255)
        ui:get_child("show_ANIM"):play_ui_sequence(false, 0.03)
        ui:get_child("_highlight_tip_TEXT"):set_text("")
        y3.ctimer.wait(0.3, function(timer, count)
            local text = ui:get_child("_highlight_tip_TEXT")
            assert(text, "")
            text:set_text(waveUICfg.ui_content)
            local fade = include("gameplay.utils.uiAction.FadeTo").new(text, 0, 255, 0.2)
            fade:runAction(2)
        end)
        y3.ctimer.wait(waveUICfg.ui_show_time, function(timer, count)
            local fade = include("gameplay.utils.uiAction.FadeTo").new(ui, 255, 0, 0.4, function()
                ui:set_visible(false)
            end)
            fade:runAction(2)
        end)
    end
end

function SurviveGameHUD:_onEventPause(trg, player_id)
    local isPause = y3.gameApp:isPause()
    if isPause then
        local player        = y3.player(player_id)
        local data          = {}
        data.title          = "提示"
        data.desc           = GameAPI.get_text_config('#1096957119#lua') .. player:get_name() .. "暂停了游戏"
        data.okCallback     = function(local_player)
            self:_alperExitGame()
            return true
        end
        data.cancelCallback = function(local_player)
            self._alertPop1 = nil
            y3.SyncMgr:sync(y3.SyncConst.SYNC_SURVIVE_PAUSE_GAME, { pause = false })
        end
        local popAlert      = include("gameplay.view.tip.PopupSystemAlert").new(data)
        popAlert:setConfirmBtnText("退出游戏")
        popAlert:setCancelBtnText("恢复游戏")
        self._alertPop1 = popAlert
    else
        if self._alertPop1 then
            self._alertPop1:close()
        end
        if self._alertPop2 then
            self._alertPop2:close()
        end
    end
end

function SurviveGameHUD:_alperExitGame()
    print("exit game")
    local data          = {}
    data.title          = "提示"
    data.desc           = GameAPI.get_text_config('#-1156116345#lua')
    data.okCallback     = function(local_player)
        self._alertPop1 = nil
        local_player:exit_game()
    end
    data.cancelCallback = function(local_player)
        self._alertPop2 = nil
    end
    local popAlert      = include("gameplay.view.tip.PopupSystemAlert").new(data)
    popAlert:setConfirmBtnText("确认")
    popAlert:setCancelBtnText("取消")
    self._alertPop2 = popAlert
end

function SurviveGameHUD:_onEventSelectReward(trg, recordIndex, playerId)
    print("SurviveGameHUD:_onEventSelectReward", recordIndex, playerId)
    y3.player.with_local(function(local_player)
        if local_player:get_id() == playerId then
            if not self._selectUI then
                self._selectUI = include("gameplay.view.survive.main.SurviveGameRewardSkillSelectUI").new(function()
                end)
            end
            if self._selectUI:isVisible() then
                print("ccccccccccccccccccccccccc")
                return
            end
            self._selectUI:show(recordIndex)
        end
    end)
end

function SurviveGameHUD:_onEventSelectUnit(trg, player)
    y3.player.with_local(function(local_player)
        local playerData = y3.userData:getPlayerData(local_player:get_id())
        local mainActor = playerData:getMainActor()
        if mainActor then
            -- local abis = playerData:getMainActor():getUnit():get_abilities_by_type(y3.const.AbilityType.COMMON)
            -- self._commonSkill:bind_ability(abis[1]) --mainActor:getUnit())
        end
    end)
end

function SurviveGameHUD:_onEventShowNpcInfo(trg, playerId, npcId)
    if playerId == y3.gameApp:getMyPlayerId() then
        local spawnEnemy = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy")
        local bossList = spawnEnemy:getArchieveCfgList()
        self._bossShowUI:show(bossList)
    end
end

function SurviveGameHUD:hideSkillStatistics()
    self._skillStatistics:hide()
end

function SurviveGameHUD:toggleStatics()
    self._skillStatistics:toggleShow()
end

function SurviveGameHUD:toggleGameSaveView()
    -- self._gameSaveView:toggleView()
end

function SurviveGameHUD:toggleStat()
    self._attrUI:toggleShow()
end

function SurviveGameHUD:toggleWiki()
    self._wikiUI:toggleShow()
end

function SurviveGameHUD:toggleInventory()
    self._inventoryUI:toggleShow()
end

return SurviveGameHUD
