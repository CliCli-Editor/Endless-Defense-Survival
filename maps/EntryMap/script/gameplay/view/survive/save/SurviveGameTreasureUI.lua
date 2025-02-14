local GlobalConfigHelper = require "gameplay.level.logic.helper.GlobalConfigHelper"
local UserDataHelper = include "gameplay.level.logic.helper.UserDataHelper"
local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGameTreasureUI = class("SurviveGameTreasureUI", StaticUIBase)

local TAB_SHENLIN = 1
local TAB_WEIKAIFANG = 2

local TAB_COST = {
    [1] = 1001,
    [2] = 1014
}

local TAB_NAME = {
    [1] = GameAPI.get_text_config('#30000001#lua07'),
    [2] = GameAPI.get_text_config('#30000001#lua08')
}

local FILTER_TEXT_MAP = {
    [1] = "通关",
    [2] = "存档boss1",
    [3] = "存档boss2",
    [4] = "存档boss3",
    [5] = "存档boss4",
}

function SurviveGameTreasureUI:ctor()
    local ui = y3.UIHelper.getUI("1943f869-4a87-49cf-bff4-6946263bf55e")
    SurviveGameTreasureUI.super.ctor(self, ui)
    self._title_TEXT = y3.UIHelper.getUI("0e4c181f-e4f2-4b2f-870c-ae9675211e5d")
    self._content = y3.UIHelper.getUI("b0b7fbda-097e-4f69-896a-70afb63acb52")
    self._shenlinUi = y3.UIHelper.getUI("00e47e91-21f3-4b87-ba4e-abd0f535f080")
    self._filterUI = y3.UIHelper.getUI("28355ccf-5183-4d4e-a687-062474b2e643")
    self._treasureListView = self._shenlinUi:get_child("treasure_GRID")

    self._res_icon = y3.UIHelper.getUI("fa1e1c0b-8493-4688-afb9-ce705163261f")
    self._res_value_TEXT = y3.UIHelper.getUI("44389c73-ccfc-474f-b0be-e0caaf4b6574")
    self._res = y3.UIHelper.getUI("2ae6bf3d-e644-458b-9825-9301d77c0317")

    self._filterIndex = 1
    self._treasureCards = {}
    self._progressNover = {}
    self:_initTab()
    self:updateUI()
    self:_initFilterUI()
    self:_onClickFilterBtn(1)
    y3.gameApp:registerEvent(y3.EventConst.EVENT_SURVIVE_TRAESURE_LV_UP, handler(self, self._onEventTreasureLvUp))
    self._res:add_local_event("鼠标-移入", function(local_player)
        local cfg = include("gameplay.config.save_item").get(TAB_COST[self._tabIndex])
        y3.Sugar.tipRoot():showUniversalTip({ title = cfg.item_name, desc = cfg.item_desc })
    end)
    self._res:add_local_event("鼠标-移出", function(local_player)
        y3.Sugar.tipRoot():hideUniversalTip({})
    end)
end

function SurviveGameTreasureUI:_initFilterUI()
    local nameMap = GlobalConfigHelper.getSaveChallengeTypeNameMap()
    self._filterNameMap = nameMap
    local childs = self._filterUI:get_childs()
    self._filterBtns = {}
    for i, child in ipairs(childs) do
        local filterBtn = child:get_childs()[1]
        local filterText = child:get_childs()[2]
        local filterName = nameMap[i].name
        filterText:set_text(filterName)
        filterBtn:add_local_event("左键-按下", function(local_player)
            self:_onClickFilterBtn(i)
        end)
        table.insert(self._filterBtns, filterBtn)
    end
end

function SurviveGameTreasureUI:_updateTreasureFilterUI()
    local nameMap = {}
    if self._tabIndex == TAB_SHENLIN then
        nameMap = GlobalConfigHelper.getSaveChallengeTypeNameMap()
    elseif self._tabIndex == TAB_WEIKAIFANG then
        nameMap = GlobalConfigHelper.getSaveChallengeTypeNameMap2()
    end
    self._filterNameMap = nameMap
    local childs = self._filterUI:get_childs()
    for i, child in ipairs(childs) do
        local filterText = child:get_childs()[2]
        if nameMap[i] then
            child:set_visible(true)
            local filterName = nameMap[i].name
            filterText:set_text(filterName)
        else
            child:set_visible(false)
        end
    end
end

function SurviveGameTreasureUI:_onClickFilterBtn(index)
    self._filterIndex = self._filterNameMap[index].filtertype
    for i = 1, #self._filterBtns do
        self._filterBtns[i]:set_image(i == index and 134278900 or 134227385)
    end
    self:_updateTreasureShenlin()
    self._treasureListView:set_ui_gridview_bar_percent(1, 0)
end

function SurviveGameTreasureUI:_onEventTreasureLvUp()
    self:updateUI()
    self:_updateTreasureShenlin()
end

function SurviveGameTreasureUI:onUpdate()
    self:updateUI()
    self:_updateTreasureShenlin()
end

function SurviveGameTreasureUI:_initTab()
    self._tabIndex = TAB_SHENLIN
    self._tabs = y3.UIHelper.getUI("d2b5374a-7e82-49b7-859a-764e3830aaa3")
    local childs = self._tabs:get_childs()
    self._tabBtns = {}
    for _, tabBtn in ipairs(childs) do
        local i = tonumber(tabBtn:get_name())
        if i then
            tabBtn:set_visible(i <= 2)
            if TAB_NAME[i] then
                tabBtn:get_child("_title_TEXT"):set_text(TAB_NAME[i])
            end
            tabBtn:add_local_event("左键-按下", function(local_player)
                self:_onTabClick(i)
            end)
            table.insert(self._tabBtns, tabBtn)
        end
    end
end

function SurviveGameTreasureUI:_onTabClick(index)
    self._tabIndex = index
    for i = 1, #self._tabBtns do
        self._tabBtns[i]:set_image(i == index and 134237413 or 134274921)
    end
    self:_updateTreasureFilterUI()
    self:updateUI()
    self:_onClickFilterBtn(1)
end

function SurviveGameTreasureUI:updateUI()
    local cfg = include("gameplay.config.save_item").get(TAB_COST[self._tabIndex])
    local saveItemLogic = y3.gameApp:getLevel():getLogic("SurviveGameSaveItem")
    local costNum = saveItemLogic:getSaveItemNum(y3.gameApp:getMyPlayerId(), TAB_COST[self._tabIndex])
    self._res_icon:set_image(tonumber(cfg.item_icon))
    self._res_value_TEXT:set_text(costNum)
end

function SurviveGameTreasureUI:_getCurFilterTreasureList()
    local result = {}
    local treasure = include("gameplay.config.treasure")
    local len = treasure.length()
    for i = 1, len do
        local cfg = treasure.indexOf(i)
        if cfg.treasure_type == self._filterIndex then
            table.insert(result, cfg)
        end
    end
    return result
end

function SurviveGameTreasureUI:_updateTreasureShenlin()
    local curList = self:_getCurFilterTreasureList()
    local len = #curList

    local unlockNum = 0
    local treasureLogic = y3.gameApp:getLevel():getLogic("SurviveGameTreasure")
    for i = 1, len do
        local cfg = curList[i]
        assert(cfg, "")
        local card = self._treasureCards[i]
        if not card then
            card = include("gameplay.view.survive.save.SurviveGameTreasureCard").new(self._treasureListView)
            self._treasureCards[i] = card
        end
        card:setVisible(true)
        if card:updateUI(cfg, treasureLogic) then
            unlockNum = unlockNum + 1
        end
    end
    for i = len + 1, #self._treasureCards do
        self._treasureCards[i]:setVisible(false)
    end
    self:_updateProgressUI(unlockNum)
end

function SurviveGameTreasureUI:_getCurProgressList()
    local treasure_progress = include("gameplay.config.treasure_progress")
    local len = treasure_progress.length()
    local result = {}
    for i = 1, len do
        local proCfg = treasure_progress.indexOf(i)
        assert(proCfg, "")
        if proCfg.progress_type == self._filterIndex then
            table.insert(result, proCfg)
        end
    end
    return result
end

function SurviveGameTreasureUI:_updateProgressUI(unlockNum)
    local progressText = self._shenlinUi:get_child("progress.info._title_TEXT")
    local progressBar = self._shenlinUi:get_child("progress.bar.collection_BAR")
    local PRO_MAP = {
        [1] = "milestone_1",
        [2] = "milestone_2",
        [3] = "milestone_end"
    }
    local curProgressList = self:_getCurProgressList()
    local len = #curProgressList
    local maxPro = 0
    for i = 1, len do
        local proCfg = curProgressList[i]
        assert(proCfg, "")
        maxPro = proCfg.progress_max
        if PRO_MAP[i] then
            local bg = self._shenlinUi:get_child("progress.bar." .. PRO_MAP[i] .. ".bg")
            assert(bg, "")
            if not self._progressNover[bg] then
                self._progressNover[bg] = 1
                bg:add_local_event("鼠标-移入", function(local_player)
                    self:_onProgressBgEnter(i)
                end)
                bg:add_local_event("鼠标-移出", function(local_player)
                    self:_onProgressBgExit(i)
                end)
            end
            local value_text = self._shenlinUi:get_child("progress.bar." .. PRO_MAP[i] .. ".value_TEXT")
            assert(value_text, "")
            value_text:set_text(proCfg.progress)
        end
    end
    assert(progressBar, "")
    assert(progressText, "")
    progressText:set_text(GameAPI.get_text_config('#30000001#lua15') .. unlockNum .. "/" .. maxPro)
    progressBar:set_current_progress_bar_value(unlockNum / maxPro * 100)
end

function SurviveGameTreasureUI:_onProgressBgEnter(index)
    local curProgressList = self:_getCurProgressList()
    local proCfg = curProgressList[index]
    if proCfg then
        local desc = UserDataHelper.getAttrConcatStr(proCfg.attr_pack)
        y3.Sugar.tipRoot():showUniversalTip({ title = proCfg.name, desc = desc })
    end
end

function SurviveGameTreasureUI:_onProgressBgExit(proCfg)
    y3.Sugar.tipRoot():hideUniversalTip({})
end

return SurviveGameTreasureUI
