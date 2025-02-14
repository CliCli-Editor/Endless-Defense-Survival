local GlobalConfigHelper = include "gameplay.level.logic.helper.GlobalConfigHelper"
local SurviveHelper = include "gameplay.level.logic.helper.SurviveHelper"
local SurviveGameHead = class("SurviveGameHead")

local HUJIA_IMG = 134233872
local GONGJI_IMG = 134247607
local HUIFU_IMG = 134242611

function SurviveGameHead:ctor(ui)
    self._ui                    = y3.UIHelper.getUI("603c59c5-7a7b-43d2-b897-336fcd7e8b53") --ui
    self._towerIcon             = y3.UIHelper.getUI("1d9ae030-f501-4e26-bef9-7095c4c490d3") --self._ui:get_child("head_info.avatar._tower_ICON")
    self._hpBar                 = y3.UIHelper.getUI("583d9556-d037-4650-9684-055795eeef01") --self._ui:get_child("head_info.info.bar._player_hp_BAR")
    self._hpText                = y3.UIHelper.getUI("29de8035-9f10-4417-8dc2-3a26985fa87c") --self._ui:get_child("head_info.info.bar._player_hp_BAR._player_hp_value_TEXT")
    self._mdBar                 = y3.UIHelper.getUI("85dc2096-911f-4da1-b268-d3bd16d19c02") --self._ui:get_child("head_info.info.bar._player_shield_BAR")
    self._mdText                = y3.UIHelper.getUI("e12c5641-1139-4347-8a4f-69cd3cdd96a2") --self._ui:get_child("head_info.info.bar._player_shield_BAR._player_hp_value_TEXT")
    self._defText               = y3.UIHelper.getUI("004bd6fe-2682-4846-8a6d-2b2d7a68ee6d") --self._ui:get_child("head_info.info.def.def._player_def_value_TEXT")
    self._recoverText           = y3.UIHelper.getUI("6a734adf-e937-4f0e-ab37-45e0bf3f3a74") --self._ui:get_child("head_info.info.def.recover._player_recover_value_TEXT")
    self._stageNameText         = y3.UIHelper.getUI("01e053b3-bfeb-409a-a7c4-883e8ede782c") --self._ui:get_child("timeline.stage_name_and_phase_text")
    self._stageEndCountdownText = y3.UIHelper.getUI("89942def-f279-496e-99cf-6a510783e8f0") --self._ui:get_child("timeline.stage_end_countdown_text")
    self._stageEndTipText       = y3.UIHelper.getUI("60c97097-7b5d-45d7-aa9b-22fa3c253534") --self._ui:get_child("timeline.stage_end_tip_text")
    self._buffList6             = y3.UIHelper.getUI("d7fc9f63-0395-4a42-8d67-6f9415924cb6") --self._ui:get_child("ec65e3d6-3b0b-4882-958b-7d9ea2e3441a")
    self._buffList7             = y3.UIHelper.getUI("c8f17737-456f-4229-954a-96ead1aebcc1")
    self._buffList8             = y3.UIHelper.getUI("36f761ae-beb4-43e3-8aa0-ac5a7557ccb6")
    self._headAttrIcon1         = y3.UIHelper.getUI("68823ece-d1e8-4648-b98c-4e71e9c993c7")
    self._headAttrIcon2         = y3.UIHelper.getUI("e8766906-da9c-4332-888b-55d0c7c2b7f1")

    self._buffList300           = y3.UIHelper.getUI("8e2d6a52-f7dc-4787-9347-8d83f56c7726")
    self._buffList400           = y3.UIHelper.getUI("2075178c-f6d8-40f8-b075-9ab74f5807f0")

    local selUnitInfo           = y3.UIHelper.getUI("3de2ff49-bb9d-49ee-aa15-e06c545a02d2") --self._ui:get_child("sel_unit_info")
    self._unit_BUFFLIST         = y3.UIHelper.getUI("2a11a72a-243d-4aa8-9549-e8b56a0fdeee")
    self._low_hp_alert          = y3.UIHelper.getUI("19b03cd2-88c7-48af-83f4-c55f2f87caef")
    self._selUnitInfo           = include("gameplay.view.survive.main.SurviveGameSelUnitInfoUI").new(selUnitInfo)

    self._hpBar2                = y3.UIHelper.getUI("ebcf23bf-f31e-4bbc-b948-f000a08b52e8")
    self._hpText2               = y3.UIHelper.getUI("7f68f453-3a51-4334-892e-50fcd057a681")
    self._mdBar2                = y3.UIHelper.getUI("50febe39-89a0-4d3a-acee-1c9a91796ab0")
    self._mdText2               = y3.UIHelper.getUI("a49438d9-eaa4-454b-b8cc-cbca8d06577e")

    self._totalStageBar         = y3.UIHelper.getUI("dcb0bb20-8cac-468e-93b2-c374e498a761")

    self._tower_BTN             = y3.UIHelper.getUI("65ee1c92-d142-4034-bec2-1c41909074b4")
    self._hero_BTN              = y3.UIHelper.getUI("fd200e59-4f09-4e88-90b8-ef6978c85c23")
    self._towerBuffRoot         = y3.UIHelper.getUI("fec0e114-3fae-4c77-a956-5e80e0a4df76")
    self._heroBuffRoot          = y3.UIHelper.getUI("f0d60f22-6e13-4f1a-aa46-63840409e62e")

    self._mode_monster          = y3.UIHelper.getUI("45c4d4e5-d05f-4155-9117-bd95d6edfaa1")

    local playerData            = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local mainActor             = playerData:getMainActor()
    -- self._mainBuffList          = include("gameplay.view.component.CommonBuffList").new(self._unit_BUFFLIST)
    -- self._mainBuffList:bindUnit(mainActor:getUnit())
    self._unit_BUFFLIST:set_buff_on_ui(mainActor:getUnit())
    self._unit_BUFFLIST:set_visible(true)

    self._redValue      = GlobalConfigHelper.get(33)

    self._timeline      = y3.UIHelper.getUI("a521eb48-4c03-4709-8651-646c9dadc5e1") --self._ui:get_child("timeline")
    self._timeline_BAR  = y3.UIHelper.getUI("be07beed-c9ef-47b1-966c-6ec8d4a8c6bc") --self._ui:get_child("timeline._timeline_BAR")

    self._buff_fold_BTN = y3.UIHelper.getUI("2a7bb693-823b-4d2d-b4b8-077383b794bf")
    self._buffMain      = y3.UIHelper.getUI("8628da5e-99f3-4888-a3af-5a204e66e1ed")
    self._mode_survival = y3.UIHelper.getUI("67d8f6f3-b5e1-45c9-8d99-d7ddd3a55a8f")
    local stageId       = y3.userData:getCurStageId()
    local stageCfg      = include("gameplay.config.stage_config").get(stageId)
    assert(stageCfg, "stageCfg is nil")
    self._mode_survival:set_visible(stageCfg.stage_type == y3.SurviveConst.STAGE_MODE_SURVIVE)

    self._buffUIMap   = {}
    self._isShowTower = true
    self:_initTimeline()
    y3.gameApp:registerEvent(y3.EventConst.EVENT_SURVIVE_STAGE_CHANGE, handler(self, self._onEventSurviveStageChange))
    y3.gameApp:registerEvent(y3.EventConst.EVENT_SURVIVE_SELECT_UNIT, handler(self, self._onEventSelectUnit))
    y3.gameApp:registerEvent(y3.EventConst.EVENT_SURVIVE_STAGE_EVENT_WAVE, handler(self, self._onEventSurviveStageWave))
    self:_initBuffList()
    self:updateBuffList()
    self._towerIcon:add_local_event("左键-按下", handler(self, self._onTowerIconClick))
    self._tower_BTN:add_local_event("左键-点击", handler(self, self._onTabTowerBuffClick))
    self._hero_BTN:add_local_event("左键-点击", handler(self, self._onTabHeroBuffClick))
    self._buff_fold_BTN:add_local_event("左键-点击", handler(self, self._onFoldBuffClick))
    self:_onFoldBuffClick()
    self:fadeLowHp()
    y3.ctimer.loop(0.1, handler(self, self._refreshHpUI))
    self:_updateModeMonster()
    y3.ctimer.loop(0.1, handler(self, self._updateModeMonster))
end

function SurviveGameHead:_updateModeMonster()
    local spawnEnemy = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy")
    self._mode_monster:set_visible(spawnEnemy:getExtraLoseType() == 1)
    if spawnEnemy:getExtraLoseType() == 1 then
        local monsterNum, limitNum = spawnEnemy:getAllMonsterNums()
        local colorList = GlobalConfigHelper.getMonsterNumColorMap()
        local per = monsterNum / limitNum * 100
        local colorStr = colorList[#colorList].color
        for i = 1, #colorList do
            if per <= colorList[i].percent then
                colorStr = colorList[i].color
                break
            end
        end
        local textStr = y3.Lang.getLang(y3.langCfg.get(74).str_content,
            { current = "#" .. colorStr .. " " .. monsterNum, total = limitNum })
        self._mode_monster:get_child("monster_count_TEXT"):set_text(textStr)
    end
end

function SurviveGameHead:_onTabTowerBuffClick()
    print("tower buff click")
    self._tower_BTN:set_image(134268071)
    self._hero_BTN:set_image(134270277)
    self._towerBuffRoot:set_visible(true)
    self._heroBuffRoot:set_visible(false)
end

function SurviveGameHead:_onTabHeroBuffClick()
    print("hero buff click")
    self._tower_BTN:set_image(134270277)
    self._hero_BTN:set_image(134268071)
    self._towerBuffRoot:set_visible(false)
    self._heroBuffRoot:set_visible(true)
end

function SurviveGameHead:_onFoldBuffClick()
    self._buffMain:set_visible(not self._buffMain:is_visible())
    if self._buffMain:is_visible() then
        self._buff_fold_BTN:set_widget_absolute_scale(1, 1)
    else
        self._buff_fold_BTN:set_widget_absolute_scale(-1, 1)
    end
end

function SurviveGameHead:fadeLowHp()
    if not self._playHud then
        self._playHud = true
        y3.ui.play_timeline_animation(y3.player(y3.gameApp:getMyPlayerId()), y3.const.UIAnimKey["hud"], 1, true)
    end
end

function SurviveGameHead:_onTowerIconClick(player)
    local playerData = y3.userData:getPlayerData(player:get_id())
    local mainActor = playerData:getMainActor()
    if mainActor then
        y3.gameApp:moveCameraToPoint(player, mainActor:getPosition())
    end
end

function SurviveGameHead:_initBuffList()
    local buffChilds = self._unit_BUFFLIST:get_childs()
    for i, child in ipairs(buffChilds) do
        child:add_local_event('鼠标-移入', function(local_player)
            local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
            local mainActor  = playerData:getMainActor()
            if not self._isShowTower then
                mainActor = mainActor:getSoulHeroActor()
            end
            local buffList = mainActor:getUnit():get_buffs()
            local data     = buffList[i]
            if data then
                y3.gameApp:getLevel():getView("SurviveGameTip"):showUniversalTip({
                    title = data:get_name(),
                    desc = data:get_description()
                })
            end
        end)
        child:add_local_event('鼠标-移出', function(local_player)
            y3.gameApp:getLevel():getView("SurviveGameTip"):hideUniversalTip()
        end)
    end
end

function SurviveGameHead:_initTimeline()
    local markContents = string.split(GlobalConfigHelper.get(26), "|")
    self._markMap = {}
    for _, content in ipairs(markContents) do
        local contents = string.split(content, "#")
        local markId = contents[1]
        local markText1 = contents[2]
        local markText2 = contents[3]
        self._markMap[markId] = { text1 = markText1, text2 = markText2 }
    end
    local curStageConfig = include("gameplay.config.stage_config").get(y3.userData:getCurStageId())
    self._curStageConfig = curStageConfig
    assert(curStageConfig, "curStageConfig is nil")
    self._modeName = ""
    local modeCfg = include("gameplay.config.stage_mode").get(curStageConfig.stage_type)
    if modeCfg then
        self._modeName = modeCfg.name
    end

    self._showOnBar = {}
    local waveList = SurviveHelper.getStageWaveCfg(y3.userData:getCurStageId())
    self._stagePhaseTime = {}
    self._stageShowMap = {}
    self._stageFirstStage = {}
    for i = 1, #waveList do
        local cfg = waveList[i]
        if not self._stagePhaseTime[cfg.stage_phase] then
            self._stagePhaseTime[cfg.stage_phase] = 0
        end
        self._stagePhaseTime[cfg.stage_phase] = cfg.event_time
        if not self._stageShowMap[cfg.stage_phase] then
            self._stageShowMap[cfg.stage_phase] = {}
        end
        if cfg.event_type == 1 or cfg.event_type == 3 then
            if not self._stageFirstStage[cfg.stage_phase] then
                self._stageFirstStage[cfg.stage_phase] = cfg
            end
        end
        if cfg.show_on_progressBar ~= "" then
            table.insert(self._stageShowMap[cfg.stage_phase], cfg)
        end
    end
end

function SurviveGameHead:_hoverTimelineTip(uiPre, showCfg)
    local ui = uiPre:get_child("")
    ui:add_local_event("鼠标-移入", function(local_player)
        if showCfg then
            y3.Sugar.tipRoot():showMiniTip({ desc = showCfg.timeline_mark_tips })
        end
    end)
    ui:add_local_event("鼠标-移出", function(local_player)
        y3.Sugar.tipRoot():hideMiniTip()
    end)
end

function SurviveGameHead:_onEventSurviveStageWave(trg, stage_wave_number)
    if stage_wave_number ~= "" then
        local spawnEnemy = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy")
        local curStagePhase = spawnEnemy:getCurStage_phase()
        local phaseMap, maxNum = GlobalConfigHelper.getStagePhaseMap()
        local appendText = y3.Lang.getLang(y3.langCfg.get(77).str_content,
            {
                wave = stage_wave_number
            })
        local stageDesc = y3.Lang.getLang(y3.langCfg.get(3).str_content,
            {
                stage_type = self._modeName,
                stage_name = self._curStageConfig.stage_name,
                current = phaseMap
                    [curStagePhase] or phaseMap[1],
                sum = maxNum
            })
        self._stageNameText:set_text(stageDesc .. appendText)
    end
end

function SurviveGameHead:_onEventSurviveStageChange()
    local spawnEnemy = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy")
    local curStagePhase = spawnEnemy:getCurStage_phase()
    if self._stagePhaseTime[curStagePhase] then
        for i = 1, #self._showOnBar do
            self._showOnBar[i].ui:remove()
        end
        self._showOnBar        = {}
        local localPlayer      = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId()):getPlayer() --y3.player(y3.gameApp:getMyPlayerId())
        local timeWidth        = self._timeline:get_width() - 50
        local timeHeight       = self._timeline:get_height()
        local totalTime        = self._stagePhaseTime[curStagePhase]
        local curTime          = spawnEnemy:getSpawnParamTotalDt()
        local phaseMap, maxNum = GlobalConfigHelper.getStagePhaseMap()
        self._stageNameText:set_text(y3.Lang.getLang(y3.langCfg.get(3).str_content,
            {
                stage_type = self._modeName,
                stage_name = self._curStageConfig.stage_name,
                current = phaseMap
                    [curStagePhase] or phaseMap[1],
                sum = maxNum
            }))

        self:_updateStageCountDown(curTime, totalTime, curStagePhase)
        for i = 1, #self._stageShowMap[curStagePhase] do
            local cfg = self._stageShowMap[curStagePhase][i]
            local posx = timeWidth * cfg.event_time / totalTime + 25
            local barParams = string.split(cfg.show_on_progressBar, "#")
            assert(barParams, "")
            local uiPre     = nil
            local showBarId = tonumber(barParams[1])
            local showCfg   = include("gameplay.config.stage_wave_ui").get(showBarId)
            assert(showCfg, "showCfg is nil")
            if showCfg.timeline_mark_name ~= "" then
                uiPre = y3.ui_prefab.create(localPlayer, showCfg.timeline_mark_name, self._timeline)
                uiPre:get_child(""):set_pos(posx, timeHeight * 0.5)
                self:_hoverTimelineTip(uiPre, showCfg)
                table.insert(self._showOnBar, { ui = uiPre, time = cfg.event_time, param = barParams, cfg = showCfg })
            end
            if uiPre then
                local markContents = string.split(showCfg.timeline_mark_content, "|")
                assert(markContents, "")
                if #markContents > 0 then
                    local markText = markContents[1]
                    local min = math.floor((cfg.event_time) / 60)
                    local sec = math.floor(cfg.event_time) % 60
                    local timeStr = string.format("%02d:%02d", min, sec)
                    uiPre:get_child("_label_TEXT"):set_text(y3.Lang.getLang(markText, { time = timeStr }))
                end
                local timeline_mark_icon = showCfg.timeline_mark_icon
                if timeline_mark_icon > 0 then
                    if uiPre:get_child("_icon_IMG") then
                        uiPre:get_child("_icon_IMG"):set_image(timeline_mark_icon)
                    else
                        uiPre:get_child("bg"):set_image(timeline_mark_icon)
                    end
                end
            end
        end
    end
end

function SurviveGameHead:_updateSelectUnitStatus(isSelect, selUnit, local_player)
    if isSelect then
        local needInfo = true
        print(selUnit)
        if selUnit then
            print(selUnit:get_owner_player())
            if selUnit:get_owner_player() == local_player then
                if selUnit:has_tag(y3.SurviveConst.STATE_TAG_SOUL_ACTOR) then
                    self._isShowTower = false
                    self._unit_BUFFLIST:set_buff_on_ui(selUnit)
                    self._unit_BUFFLIST:set_visible(true)
                    self:updateUI()
                    needInfo = false
                elseif selUnit:has_tag(y3.SurviveConst.STATE_PLAYER_TAG) then
                    self._isShowTower = true
                    self._unit_BUFFLIST:set_buff_on_ui(selUnit)
                    self._unit_BUFFLIST:set_visible(true)
                    self:updateUI()
                    needInfo = false
                end
            end
        end
        if needInfo then
            self:showSelUnitInfo(local_player:get_selecting_unit())
        else
            self:showSelUnitInfo(nil)
        end
    else
        self:showSelUnitInfo(nil)
    end
end

function SurviveGameHead:_onEventSelectUnit(trg, player, isSelect)
    y3.player.with_local(function(local_player)
        if player:get_id() == local_player:get_id() then
            self:_updateSelectUnitStatus(isSelect, local_player:get_selecting_unit(), local_player)
        end
    end)
end

function SurviveGameHead:_refreshHpUI()
    local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local mainActor  = playerData:getMainActor()
    local mainUnit   = mainActor:getUnit()
    local isInShield = false
    if mainUnit:kv_has("skillon:19999") then
        isInShield = mainUnit:kv_load("skillon:19999", "boolean")
    end
    local hpMax = math.floor(mainUnit:get_attr(y3.const.UnitAttr['最大生命']))
    local hpCur = math.floor(mainUnit:get_attr(y3.const.UnitAttr['生命']))
    local mdMax = math.floor(mainUnit:get_attr(y3.const.UnitAttr['最大魔法']))
    local mdCur = math.floor(mainUnit:get_attr(y3.const.UnitAttr['魔法']))
    self._hpBar:set_current_progress_bar_value(hpCur / hpMax * 100)
    self._mdBar:set_current_progress_bar_value(mdCur / mdMax * 100)
    self._hpText:set_text(hpCur .. "/" .. hpMax)
    self._hpBar2:set_current_progress_bar_value(hpCur / hpMax * 100)
    self._mdBar2:set_current_progress_bar_value(mdCur / mdMax * 100)
    self._hpText2:set_text(hpCur .. "/" .. hpMax)
    if mdMax > 0 then
        self._mdText:set_text(mdCur .. "/" .. mdMax)
        self._mdText2:set_text(mdCur .. "/" .. mdMax)
    else
        self._mdText:set_text(GameAPI.get_text_config('#479410554#lua'))
        self._mdText2:set_text(GameAPI.get_text_config('#479410554#lua'))
    end
    if isInShield then
        self._mdBar2:get_child("progress_bar_img"):set_image(134232103)
    else
        self._mdBar2:get_child("progress_bar_img"):set_image(134242809)
    end
end

function SurviveGameHead:isShowTower()
    return self._isShowTower
end

function SurviveGameHead:updateUI()
    local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local mainActor  = nil
    if self._isShowTower then
        mainActor = playerData:getMainActor()
    else
        mainActor = playerData:getMainActor():getSoulHeroActor()
    end
    local mainUnit = playerData:getMainActor():getUnit()
    local hpMax = math.floor(mainUnit:get_attr(y3.const.UnitAttr['最大生命']))
    local hpCur = math.floor(mainUnit:get_attr(y3.const.UnitAttr['生命']))
    local hpPro = hpCur / hpMax * 100
    self:_refreshHpUI()
    self._towerIcon:set_image(mainActor:getHeroIcon())
    self._low_hp_alert:set_visible(hpPro < self._redValue)

    local def = math.floor(mainUnit:get_attr(y3.const.UnitAttr['物理防御']))
    local recover = math.floor(mainUnit:get_attr(y3.const.UnitAttr['生命恢复']))
    if self._isShowTower then
        self._headAttrIcon1:set_image(HUJIA_IMG)
        self._headAttrIcon2:set_image(HUIFU_IMG)
    else
        self._headAttrIcon1:set_image(GONGJI_IMG)
        self._headAttrIcon2:set_image(HUJIA_IMG)
        local soulUnit = mainActor:getUnit()
        def = math.floor(soulUnit:get_attr(y3.const.UnitAttr['物理攻击']))
        recover = math.floor(soulUnit:get_attr(y3.const.UnitAttr['物理防御']))
    end

    self._defText:set_text(def .. "")
    self._recoverText:set_text(recover .. "")
end

function SurviveGameHead:updateTimeline()
    local spawnEnemy = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy")
    local curStagePhase = spawnEnemy:getCurStage_phase()
    if self._stagePhaseTime[curStagePhase] then
        local totalTime = self._stagePhaseTime[curStagePhase]
        local curTime   = spawnEnemy:getSpawnParamTotalDt()
        self:_updateStageCountDown(curTime, totalTime, curStagePhase)

        local cur = spawnEnemy:getCurStageTime()
        local max = spawnEnemy:getTotalStageTime()
        self._totalStageBar:set_current_progress_bar_value(cur / max * 100)
    end
    local achievement = y3.gameApp:getLevel():getLogic("SurviveGameAchievement")
    local gameStatus = y3.gameApp:getLevel():getLogic("SurviveGameStatus")
    local readyEndTotalTime = 0
    if achievement:getPlayedEndTime() > 0 then
        readyEndTotalTime = math.floor(achievement:getPlayedEndTime())
    else
        readyEndTotalTime = math.floor(gameStatus:getReadyEndTotalTime())
    end
    if self._mode_survival then
        self._mode_survival:get_child("survival_time_txt"):set_text(GameAPI.get_text_config('#30000001#lua19') .. readyEndTotalTime .. GameAPI.get_text_config('#30000001#lua20'))
    end
    self:_updateSelectUnit()
    self:updateBuffList()
end

function SurviveGameHead:_initBuffMapDataList()
    local playerData   = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local mainActor    = playerData:getMainActor()
    local list         = mainActor:getBuffList()
    self._buffDataList = {}
    local typeMap1     = {
        [6] = 1,
        [7] = 2,
        [8] = 3,
    }
    for i = 1, #list do
        local cfg = list[i]
        if typeMap1[cfg.type] then
            if not self._buffDataList[cfg.type] then
                self._buffDataList[cfg.type] = {}
            end
            table.insert(self._buffDataList[cfg.type], cfg)
        end
    end
    local soulActor = mainActor:getSoulHeroActor()
    local list2 = soulActor:getSkikList()
    local typeMap2 = {
        [300] = 1,
        [400] = 2,
    }
    for i = 1, #list2 do
        local cfg = list2[i]
        if typeMap2[cfg.type] then
            if not self._buffDataList[cfg.type] then
                self._buffDataList[cfg.type] = {}
            end
            table.insert(self._buffDataList[cfg.type], cfg)
        end
    end
end

function SurviveGameHead:updateBuffList()
    self:_initBuffMapDataList()
    self:_updateBuffListSignal2(self._buffList6, 6)
    self:_updateBuffListSignal2(self._buffList7, 7)
    self:_updateBuffListSignal2(self._buffList8, 8)
    self:_updateBuffListSignal2(self._buffList300, 300, true)
    self:_updateBuffListSignal2(self._buffList400, 400, true)
end

function SurviveGameHead:_updateBuffListSignal2(buffList, index, isSoul)
    local list   = self._buffDataList[index] or {}
    local listUI = self._buffUIMap[index] or {}
    if #list > 0 then
        local ph = buffList:get_child("ph")
        if ph and not ph:is_removed() then
            ph:remove()
        end
    end
    for i, data in ipairs(list) do
        local ui = listUI[i]
        if not ui then
            ui = include("gameplay.view.survive.main.SurviveGameBuffIcon").new(buffList, true)
            listUI[i] = ui
        end
        ui:setVisible(true)
        ui:updateUI(data, isSoul)
    end
    local startIndex = #list
    local cells      = buffList:get_childs()
    for i = startIndex + 1, #cells do
        cells[i]:set_visible(false)
    end
    self._buffUIMap[index] = listUI
end

function SurviveGameHead:_updateStageCountDown(curTime, totalTime, curStagePhase)
    self._timeline_BAR:set_current_progress_bar_value(curTime / totalTime * 100)
    local totalTimeShow = totalTime

    local firstStage = self._stageFirstStage[curStagePhase]
    local text = ""
    for i = 1, #self._showOnBar do
        local showData = self._showOnBar[i]
        local showCfg = showData.cfg
        if showCfg.timeline_phase_text ~= "" then
            local phaseParams = string.split(showCfg.timeline_phase_text, "|")
            assert(phaseParams, "")
            text = phaseParams[2] and phaseParams[2] or phaseParams[1]
            if curTime < showData.time then
                text = phaseParams[1]
                break
            end
        end
    end

    if totalTimeShow >= curTime then
        self._stageEndTipText:set_visible(true)
        local min = math.floor((totalTimeShow - curTime) / 60)
        local sec = math.floor(totalTimeShow - curTime) % 60
        self._stageEndTipText:set_text(y3.Lang.getLang(text, { time = string.format("%02d:%02d", min, sec) }))
    else
        self._stageEndTipText:set_visible(false)
        self._stageEndCountdownText:set_text("")
    end
    for i = 1, #self._showOnBar do
        local showData = self._showOnBar[i]
        local labelText = showData.ui:get_child("_label_TEXT")
        local bg = showData.ui:get_child("bg")
        local uiPre = showData.ui
        if curTime > showData.time then
            local showCfg = showData.cfg
            local markContents = string.split(showCfg.timeline_mark_content, "|")
            assert(markContents, "")
            if #markContents > 1 then
                local markText = markContents[2]
                labelText:set_text(y3.Lang.getLang(markText, {}))
            end
            local timeline_mark_icon = showCfg.timeline_mark_icon_passed
            if timeline_mark_icon > 0 then
                if uiPre:get_child("_icon_IMG") then
                    uiPre:get_child("_icon_IMG"):set_image(timeline_mark_icon)
                else
                    bg:set_image(timeline_mark_icon)
                end
            end
        end
    end
end

function SurviveGameHead:showSelUnitInfo(unit)
    local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local mainActor = playerData:getMainActor()
    local mainUnit = mainActor:getUnit()
    if unit and unit ~= mainUnit then
        self._selectUnit = unit
        self:_updateSelectUnit()
    else
        self._selectUnit = nil
        self._selUnitInfo:setVisible(false)
    end
end

function SurviveGameHead:_showBuffTip()

end

function SurviveGameHead:_updateSelectUnit()
    if not self._selectUnit then
        self:showSelUnitInfo(nil)
        return
    end
    if not y3.class.isValid(self._selectUnit) then
        self:showSelUnitInfo(nil)
        return
    end
    if not self._selectUnit:is_alive() then
        self:showSelUnitInfo(nil)
        return
    end
    if self._selectUnit:has_tag(y3.SurviveConst.STATE_TAG_BOSS_NPC) then
        self:showSelUnitInfo(nil)
        return
    end
    self._selUnitInfo:setVisible(true)
    local unit = self._selectUnit
    unit:event("单位-死亡", function()
        self:showSelUnitInfo(self._selectUnit)
    end)
    self._selUnitInfo:updateUI(unit)
end

return SurviveGameHead
