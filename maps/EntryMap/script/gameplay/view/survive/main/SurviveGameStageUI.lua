local UserDataHelper = include "gameplay.level.logic.helper.UserDataHelper"
local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGameStageUI = class("SurviveGameStageUI", StaticUIBase)

local MODE_LIST = {
    [1] = y3.Lang.get("level_mode1"),
    [2] = y3.Lang.get("level_mode2"),
    [3] = y3.Lang.get("level_mode3"),
}


function SurviveGameStageUI:ctor(param, root)
    local ui = y3.UIHelper.getUI("ba79dc46-f238-4d69-bbd5-3a63f35ad8bf")
    SurviveGameStageUI.super.ctor(self, ui)
    self._root = root
    self._towerUI = include("gameplay.view.survive.main.SurviveGameStageTowerUI").new()
    self._stageMenuUi = include("gameplay.view.survive.main.SurviveGameStageMenuUI").new(self)
    self._gameSaveView = include("gameplay.view.survive.save.SurviveGameSaveView").new()

    self._featureMap = {}
    self._battlePass = include("gameplay.view.survive.save.SurviveGameBattlePassUI").new()
    self._featureMap[self._battlePass:indexOfMenuList()] = self._battlePass

    self._mode_select_LIST = y3.UIHelper.getUI("fe7bb4f1-e1b5-4e2b-afcf-fe74119c8965")
    self._modePreBtn = y3.UIHelper.getUI("893410b9-17ae-4006-8c61-e23299b0ad99")
    self._modeNextBtn = y3.UIHelper.getUI("3334b05f-99c7-474b-a1d6-a6ba6ad78653")

    self._level_select_list = y3.UIHelper.getUI("f85e20a4-65d8-4ce5-a3ad-2284f7dec609")
    self._levelPreBtn = y3.UIHelper.getUI("12c41b1c-7192-4f8a-8c02-3b502729eb8f")
    self._levelNextBtn = y3.UIHelper.getUI("9f7af86f-1638-465a-8bd3-b76425d64ed2")

    self._level_time_TEXT = y3.UIHelper.getUI("de398072-a49f-4872-9208-265e3325368a")
    self._level_goal_LIST = y3.UIHelper.getUI("9c9a61ca-836a-4a2a-93c1-cd8949e8fc5b")

    self._level_achievement_LIST = y3.UIHelper.getUI("855730b5-16a2-495d-832d-ea21403969dd")
    self._level_reward_GRID = y3.UIHelper.getUI("920e4745-6f07-416c-9e0b-22bfcb222786")

    self._game_start_BTN = y3.UIHelper.getUI("49c8aa71-7031-4c58-86d0-1ac87c50a792")
    self._game_start_title = y3.UIHelper.getUI("cb1f8e8f-ce17-4c50-ac94-de2328773fb5")

    self._playerList = y3.UIHelper.getUI("96165e66-f96b-47bf-821c-69647695bb5f")

    self._gameStartTimeTips = y3.UIHelper.getUI("307edc84-ab4f-4adc-b7c8-f44a95a6414c")
    self._gameStartTimeTips:set_visible(false)

    self._content = y3.UIHelper.getUI("41d05bd4-3c17-4276-b130-a25eb1f6c4aa")

    self._game_start_BTN:add_local_event("左键-点击", handler(self, self._onClickStartBtn))
    self._levelPreBtn:add_local_event("左键-点击", handler(self, self._onLevelPreBtn))
    self._levelNextBtn:add_local_event("左键-点击", handler(self, self._onLevelNextBtn))
    self._modePreBtn:add_local_event("左键-点击", handler(self, self._onModePreBtn))
    self._modeNextBtn:add_local_event("左键-点击", handler(self, self._onModeNextBtn))
    self._awardIcons = {}
    self._recordHover = {}
    self:_initCfg()
    self:_updatePlayerList()
    self:_handStarHover(1)
    self._curLevelPercent = 0
    y3.gameApp:registerEvent(y3.EventConst.EVENT_SURVIVE_GAME_START, handler(self, self._onEventStart))
    y3.gameApp:registerEvent(y3.EventConst.EVENT_UPDATE_ENTER_TIME, handler(self, self._onEventUpdateTime))
end

function SurviveGameStageUI:menuClick(index)
    local childs = self._content:get_childs()
    local haveVisible = false
    for i, child in ipairs(childs) do
        local name = tonumber(child:get_name()) or 0
        if name == index then
            child:set_visible(true)
            haveVisible = child:is_visible()
            if self._featureMap[index] then
                self._featureMap[index]:onShow()
            end
            if index == 1 then
                self._towerUI:updateUI()
            end
            local tabView = self._gameSaveView:getTabView(index)
            if tabView and tabView.onUpdate then
                tabView:onUpdate()
            end
        else
            child:set_visible(false)
        end
    end
    -- if not haveVisible then
    --     childs[1]:set_visible(true)
    -- end
end

function SurviveGameStageUI:_onEventStart()
    local gameStart = y3.gameApp:getLevel():getLogic("SurviveGameStart")
    local entime = gameStart:getEnterTime()
    self._gameStartTimeTips:set_visible(entime > 0)
    self._gameStartTimeTips:set_text(GameAPI.get_text_config('#30000001#lua26') .. math.floor(gameStart:getEnterTime()) .. "s")
    self:updateState()
end

function SurviveGameStageUI:_onEventUpdateTime()
    local gameStart = y3.gameApp:getLevel():getLogic("SurviveGameStart")
    local entime = gameStart:getEnterTime()
    if entime <= 3 then
        self._gameStartTimeTips:set_text_color_hex("ff3434", 255)
    end
    self._gameStartTimeTips:set_visible(entime > 0)
    self._gameStartTimeTips:set_text(GameAPI.get_text_config('#30000001#lua26') .. math.floor(gameStart:getEnterTime()) .. "s")
end

function SurviveGameStageUI:_onLevelPreBtn(local_player)
    local childs = self._level_select_list:get_childs()
    local maxPro = #childs - 5
    local index = self._curLevelPercent
    self._curLevelPercent = math.max(0, index - 1)
    local pro = math.max(0, (index - 1) / maxPro * 100)
    self._level_select_list:set_list_view_percent(pro)
end

function SurviveGameStageUI:_onLevelNextBtn(local_player)
    local childs = self._level_select_list:get_childs()
    local maxPro = #childs - 5
    local index = self._curLevelPercent
    self._curLevelPercent = math.min(maxPro, index + 1)
    local pro = math.min((index + 1) / maxPro * 100, 100)
    self._level_select_list:set_list_view_percent(pro)
end

function SurviveGameStageUI:_onModePreBtn(local_player)

end

function SurviveGameStageUI:_onModeNextBtn(local_player)

end

function SurviveGameStageUI:_updatePlayerList()
    local allInPlayers = y3.userData:getAllInPlayers()
    local childs = self._playerList:get_childs()
    for i, child in ipairs(childs) do
        if i > 1 then
            local index = i - 1
            local playerData = allInPlayers[index]
            child:set_visible(index == 1)
            if playerData then
                local player = playerData:getPlayer()
                child:get_child("title_TEXT"):set_text(playerData:getPlayerName())
                child:get_child("avatar.mask._player_plat_avatar_IMG"):set_image(player:get_platform_icon())
            else
                child:get_child("title_TEXT"):set_text(GameAPI.get_text_config('#384979971#lua'))
            end
        end
    end
end

function SurviveGameStageUI:_initCfg()
    local modeCfg = include("gameplay.config.stage_mode").get(1)

    local stage_mode = include("gameplay.config.stage_mode")
    local modeLen = stage_mode.length()
    self._modeList = {}
    for i = 1, modeLen do
        local cfg = stage_mode.indexOf(i)
        table.insert(self._modeList, cfg)
    end

    local stage_config = include("gameplay.config.stage_config")
    local collect = include("gameplay.config.collect")
    local len = collect.length()
    self._stageCollect = {}
    for i = 1, len do
        local cfg = collect.indexOf(i)
        assert(cfg, "")
        if cfg.collect_type == 2 then
            if cfg.stage_id > 0 then
                self._stageCollect[cfg.stage_id] = cfg
            end
        end
    end
    local len = stage_config.length()
    self._stageList = {}
    self._modeStageList = {}
    for i = 1, len do
        local cfg = stage_config.indexOf(i)
        assert(cfg, "")
        if cfg.stage_type == modeCfg.id then
            if #self._stageList < modeCfg.released_level then
                table.insert(self._stageList, cfg)
            end
        end
        local curModeCfg = include("gameplay.config.stage_mode").get(cfg.stage_type)
        if curModeCfg then
            if not self._modeStageList[cfg.stage_type] then
                self._modeStageList[cfg.stage_type] = {}
            end
            local curStageList = self._modeStageList[cfg.stage_type]
            if #curStageList < curModeCfg.released_level then
                table.insert(curStageList, cfg)
            end
        end
    end

    self._stageCards = {}
    self._selectStageIndex = 1
    self:updateState()
    self:updateUI()
    self:_updateMode()
    self:_onUpdateStageSelect()
end

function SurviveGameStageUI:updateState()
    local gamestart = y3.gameApp:getLevel():isGameEnterStart()
    if gamestart then
        self._game_start_BTN:set_button_enable(false)
        self._game_start_title:set_text(y3.Lang.get("level_start_title"))
    else
        local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
        local roomMasterPlayerData = y3.userData:getRoomMasterPlayerData()
        self._game_start_BTN:set_button_enable(playerData:isRoomMaster())
        if not playerData:isRoomMaster() then
            self._game_start_title:set_text(y3.Lang.get("level_start_title_master",
                { name = roomMasterPlayerData:getPlayerName() }))
        end
    end
end

function SurviveGameStageUI:_updateMode()
    local modeChilds = self._mode_select_LIST:get_childs()
    for i, mode in ipairs(modeChilds) do
        local modeCfg = self._modeList[i]
        if modeCfg then
            mode:set_visible(true)
            local btn = mode:get_child("bg_BTN")
            btn:set_button_enable(modeCfg.mode_released == 1)
            mode:get_child("_mode_name_TEXT"):set_text(modeCfg.name)
            btn:add_local_event("左键-点击", function()
                self:_onModeBtnClick(i)
            end)
        else
            mode:set_visible(false)
        end
    end
end

function SurviveGameStageUI:_onModeBtnClick(modeIndex)
    self._stageList = self._modeStageList[modeIndex] or {}
    self:updateUI()
    self:onStageSelectIndex(1)
end

function SurviveGameStageUI:updateUI()
    local levelCells = self._level_select_list:get_childs()
    for i, cellUI in ipairs(levelCells) do
        local cfg = self._stageList[i]
        if cfg then
            cellUI:set_visible(true)
            local card = self._stageCards[i]
            if not card then
                card = include("gameplay.view.survive.main.SurviveGameStageUICell").new(cellUI, self)
                self._stageCards[i] = card
            end
            local collect = self._stageCollect[cfg.id]
            card:updateUI(cfg, i, collect)
            card:updateSelect(self._selectStageIndex)
        else
            cellUI:set_visible(false)
        end
    end
end

function SurviveGameStageUI:onStageSelectIndex(index)
    self._selectStageIndex = index
    self:_onUpdateStageSelect()
end

function SurviveGameStageUI:_onUpdateStageSelect()
    for i, card in ipairs(self._stageCards) do
        card:updateSelect(self._selectStageIndex)
    end
    self:_updateStageGoal()
    self:_updateStageAchiement()
    self:_updateStageAward()
    local cfg = self._stageList[self._selectStageIndex]
    if cfg then
        local min = math.floor(cfg.show_time / 60)
        local sec = math.floor(cfg.show_time % 60)
        self._level_time_TEXT:set_text(string.format("%02d:%02d", min, sec))
    end
end

function SurviveGameStageUI:_updateStageGoal()
    local cfg = self._stageList[self._selectStageIndex]
    if cfg then
        local goals = string.split(cfg.content, "|")
        assert(goals, "")
        local goal_list = self._level_goal_LIST:get_childs()
        for i, goal in ipairs(goal_list) do
            goal:set_visible(i <= #goals)
            if i <= #goals then
                goal:get_child("_level_name_TEXT"):set_text(goals[i])
            else
                goal:get_child("_level_name_TEXT"):set_text("")
            end
        end
    end
end

function SurviveGameStageUI:_updateStageAchiement()
    local cfg = self._stageList[self._selectStageIndex]
    if cfg then
        local collect = self._stageCollect[cfg.id]
        if collect then
            self._level_achievement_LIST:set_visible(true)
            local achievePacks = string.split(collect.reward_attr_pack, "|")
            assert(achievePacks, "")
            local achiCells = self._level_achievement_LIST:get_childs()
            local achievemnt = y3.gameApp:getLevel():getLogic("SurviveGameAchievement")
            local starNum = achievemnt:getAchievementConditionValue(y3.gameApp:getMyPlayerId(), collect.id, 1)
            for i, achiCell in ipairs(achiCells) do
                if i <= #achievePacks then
                    achiCell:set_visible(true)
                    local attrList = UserDataHelper.getAttrListByPack(achievePacks[i])
                    for texti = 1, 2 do
                        local text = achiCell:get_child("_reward_" .. texti .. "_TEXT")
                        local attrData = attrList[texti]
                        if attrData then
                            text:set_visible(true)
                            if attrData.showType == 1 then
                                text:set_text(attrData.name .. " +" .. attrData.value)
                            else
                                text:set_text(attrData.name .. " +" .. attrData.value .. "%")
                            end
                        else
                            text:set_visible(false)
                        end
                    end
                    local starList = achiCell:get_child("stars.stars_LIST")
                    local starChilds = starList:get_childs()
                    for j, star in ipairs(starChilds) do
                        star:set_visible(j <= i)
                        star:set_image(i <= starNum and 134228477 or 134257174)
                    end
                else
                    achiCell:set_visible(false)
                end
            end
        else
            self._level_achievement_LIST:set_visible(false)
        end
    end
end

function SurviveGameStageUI:_handStarHover(starUI)
    if not self._recordHover[starUI] then
        self._recordHover[starUI] = true
        self._level_achievement_LIST:add_local_event("鼠标-移入", function()
            local cfg = self._stageList[self._selectStageIndex]
            if cfg then
                local collect = self._stageCollect[cfg.id]
                if collect then
                    local desc = UserDataHelper.getCollectStarDesc(collect)
                    y3.Sugar.tipRoot():showUniversalTip({ title = GameAPI.get_text_config('#30000001#lua05'), desc = desc })
                end
            end
        end)
        self._level_achievement_LIST:add_local_event("鼠标-移出", function()
            y3.Sugar.tipRoot():hideUniversalTip()
        end)
    end
end

function SurviveGameStageUI:_updateStageAward()
    local cfg = self._stageList[self._selectStageIndex]
    if not cfg then
        return
    end
    for i = 1, #self._awardIcons do
        self._awardIcons[i]:setVisible(false)
    end
    local awardList = UserDataHelper.getStageReward(cfg)
    local specList = UserDataHelper.getStageSpecDrop(y3.gameApp:getMyPlayerId(), cfg)
    local lastIndex = 0
    for i = 1, #awardList do
        local commonIcon = self._awardIcons[i]
        if not commonIcon then
            commonIcon = include("gameplay.view.component.CommonItemIcon").new(self._level_reward_GRID)
            self._awardIcons[i] = commonIcon
        end
        commonIcon:setVisible(true)
        commonIcon:updateUI(awardList[i])
        lastIndex = i
    end
    for i = 1, #specList do
        local commonIcon = self._awardIcons[lastIndex + i]
        if not commonIcon then
            commonIcon = include("gameplay.view.component.CommonItemIcon").new(self._level_reward_GRID)
            self._awardIcons[lastIndex + i] = commonIcon
        end
        commonIcon:setVisible(true)
        commonIcon:updateUI(specList[i])
    end
end

function SurviveGameStageUI:_onClickStartBtn()
    local cfg = self._stageList[self._selectStageIndex]
    if cfg then
        local stagePass = y3.gameApp:getLevel():getLogic("SurviveGameStagePass")
        local isUnLock = stagePass:getStageIsUnLock(cfg.id)
        if cfg.stage_open_state == 1 and isUnLock then
            y3.SyncMgr:sync(y3.SyncConst.SYNC_SURVIVE_SELECT_STAGE, { stageId = cfg.id })
        end
    end
end

return SurviveGameStageUI
