local GlobalConfigHelper = require "gameplay.level.logic.helper.GlobalConfigHelper"
local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGameAchievementUI = class("SurviveGameAchievementUI", StaticUIBase)

function SurviveGameAchievementUI:ctor()
    local ui = y3.UIHelper.getUI("c3144e48-f6f1-4e07-9479-00d2e9ff59bb")
    SurviveGameAchievementUI.super.ctor(self, ui)

    self._tabContent = y3.UIHelper.getUI("95d20a24-f9ad-40e9-9dbb-9ad34e348c21")
    self._res = y3.UIHelper.getUI("6d9eea13-2922-4d40-b554-474b82dcbab9")
    self._res_icon_IMG = y3.UIHelper.getUI("2e6b277c-a6cf-44ec-a1e4-2d8f93762df5")
    self._res_value_TEXT = y3.UIHelper.getUI("efc50989-8289-4ef0-b8ed-0de2ca370b3a")

    self._passGrids = y3.UIHelper.getUI("f490d7ca-0a46-440b-b435-fb36dc9a38bb")
    self._commonGrids = y3.UIHelper.getUI("fa042b6c-3c4f-424f-9f5d-c18836c54d44")

    self._content = y3.UIHelper.getUI("27d8af07-6998-44cc-9e82-309210c82f7f")
    self._filterPassAchi = y3.UIHelper.getUI("9e076597-15e9-48e3-a8e5-e8c8ec0a02d8")
    self._filterCommonAchi = y3.UIHelper.getUI("985dc0a9-d599-4c49-be8e-e2875e647a37")
    -- self._filterPassAchi:set_visible(false)
    -- self._filterCommonAchi:set_visible(false)

    self._passCards = {}
    self._passIndex = 1
    self._commonCards = {}
    self._commonIndex = 1

    self._passAchiRightUI = include("gameplay.view.survive.save.SurviveGameAchievementRightUI").new()
    self._passAchiProgressUI = include("gameplay.view.survive.save.SurviveGameAchievementProgressUI").new()

    self._passAchiRightUI2 = include("gameplay.view.survive.save.SurviveGameAchievementRightUI2").new()
    self._passAchiProgressUI2 = include("gameplay.view.survive.save.SurviveGameAchievementProgressUI2").new()

    self:_initTab()
    self:_initUI()
    self:_onTabClick(1)
    self:_initFilter()
    self._res:add_local_event("鼠标-移入", function(local_player)
        y3.Sugar.tipRoot():showUniversalTip({ type = y3.SurviveConst.TIP_TYPE_ACHI_DESC })
    end)
    self._res:add_local_event("鼠标-移出", function(local_player)
        y3.Sugar.tipRoot():hideUniversalTip()
    end)
    self:_onClickPassAchiFilter(1)
    self:_onClickCommonAchiFilter(1)
end

function SurviveGameAchievementUI:_initFilter()
    local filterChilds = self._filterPassAchi:get_childs()
    self._passFilterBtns = {}
    local filnetNames = GlobalConfigHelper.getAchievementPassFilterText()
    for i = 1, #filterChilds do
        filterChilds[i]:set_visible(true)
        local btn = filterChilds[i]:get_childs()[1]
        local labeltext = filterChilds[i]:get_childs()[2]
        table.insert(self._passFilterBtns, btn)
        labeltext:set_text(filnetNames[i].name)
        btn:add_local_event("左键-点击", function(local_player)
            self:_onClickPassAchiFilter(i)
        end)
    end
    local filterChilds2 = self._filterCommonAchi:get_childs()
    self._commonFilterBtns = {}
    local MAP_TEXT = {
        [1] = GameAPI.get_text_config('#30000001#lua73'),
        [2] = GameAPI.get_text_config('#30000001#lua74'),
        [3] = GameAPI.get_text_config('#30000001#lua75'),
        [4] = GameAPI.get_text_config('#30000001#lua76'),
    }
    for i = 1, #filterChilds2 do
        local btn = filterChilds2[i]:get_childs()[1]
        local labeltext = filterChilds2[i]:get_childs()[2]
        labeltext:set_text(MAP_TEXT[i])
        table.insert(self._commonFilterBtns, btn)
        btn:add_local_event("左键-点击", function(local_player)
            self:_onClickCommonAchiFilter(i)
        end)
    end
end

function SurviveGameAchievementUI:_onClickPassAchiFilter(index)
    for i = 1, #self._passFilterBtns do
        self._passFilterBtns[i]:set_image(i == index and 134278900 or 134227385)
    end
    local list = {}
    for i = 1, #self._passCollectsRaw do
        local cfg = self._passCollectsRaw[i]
        if cfg.filter == index then
            table.insert(list, cfg)
        end
    end
    self._passCollects = list
    for i = 1, #self._passCards do
        local cfg = self._passCollects[i]
        if cfg then
            self._passCards[i]:setVisible(true)
            self._passCards[i]:updateUI(cfg, i)
        else
            self._passCards[i]:setVisible(false)
        end
    end
    -- local rowCount = math.ceil(#list / 5)
    -- self._passCards:set_ui_gridview_count(rowCount, 5)
    self:onSelectAchievement(1)
end

function SurviveGameAchievementUI:_onClickCommonAchiFilter(index)
    for i = 1, #self._commonFilterBtns do
        self._commonFilterBtns[i]:set_image(i == index and 134278900 or 134227385)
    end
    local list = {}
    for i = 1, #self._commonCollectsRaw do
        local cfg = self._commonCollectsRaw[i]
        if cfg.filter == index then
            table.insert(list, cfg)
        end
    end
    self._commonCollects = list
    for i = 1, #self._commonCards do
        local cfg = self._commonCollects[i]
        if cfg then
            self._commonCards[i]:setVisible(true)
            self._commonCards[i]:updateUI(cfg, i)
        else
            self._commonCards[i]:setVisible(false)
        end
    end
    local rowCount = math.ceil(#list / 5)
    self._commonGrids:set_ui_gridview_bar_percent(1, 0)
    -- self._passCards:set_ui_gridview_count(rowCount, 5)
    self:onSelectAchievementCom(1)
end

function SurviveGameAchievementUI:_initUI()
    local collect = include("gameplay.config.collect")
    self._passCollects = {}
    self._commonCollects = {}
    self._firstCollects = {}

    self._passCollectsRaw = {}
    self._commonCollectsRaw = {}
    self._firstCollectsRaw = {}

    local len = collect.length()
    for i = 1, len do
        local cfg = collect.indexOf(i)
        if cfg.collect_type == 2 then --
            table.insert(self._passCollects, cfg)
            table.insert(self._passCollectsRaw, cfg)
        elseif cfg.collect_type == 3 then
            table.insert(self._commonCollects, cfg)
            table.insert(self._commonCollectsRaw, cfg)
        elseif cfg.collect_type == 1 then
            table.insert(self._firstCollects, cfg)
            table.insert(self._firstCollectsRaw, cfg)
        end
    end
    table.sort(self._passCollects, function(a, b)
        return a.slot < b.slot
    end)
    table.sort(self._passCollectsRaw, function(a, b)
        return a.slot < b.slot
    end)
    table.sort(self._commonCollects, function(a, b)
        return a.slot < b.slot
    end)
    table.sort(self._commonCollectsRaw, function(a, b)
        return a.slot < b.slot
    end)
    table.sort(self._firstCollects, function(a, b)
        return a.slot < b.slot
    end)
    table.sort(self._firstCollectsRaw, function(a, b)
        return a.slot < b.slot
    end)
    self:_initPassAchievemtnUI()
    self:_initCommonAchievementUI()

    local achievement = y3.gameApp:getLevel():getLogic("SurviveGameAchievement")
    self._res_value_TEXT:set_text(achievement:getTotalAchievementPoint(y3.gameApp:getMyPlayerId()))
end

function SurviveGameAchievementUI:_initPassAchievemtnUI()
    for i = 1, #self._passCollects do
        local card = self._passCards[i]
        if not card then
            card = include("gameplay.view.survive.save.SurviveGameAchievementCard").new(self._passGrids, self)
            self._passCards[i] = card
        end
        card:updateUI(self._passCollects[i], i)
    end
    self:onSelectAchievement(1)
    self._passAchiProgressUI:updateUI(self._passCollectsRaw, self._firstCollectsRaw)
end

function SurviveGameAchievementUI:onSelectAchievement(index)
    for i = 1, #self._passCards do
        local card = self._passCards[i]
        card:updateCardSelect(index)
    end
    local cfg = self._passCollects[index]
    if cfg then
        self._passAchiRightUI:updateUI(cfg)
    end
end

function SurviveGameAchievementUI:_initCommonAchievementUI()
    for i = 1, #self._commonCollects do
        local card = self._commonCards[i]
        if not card then
            card = include("gameplay.view.survive.save.SurviveGameAchievementCard2").new(self._commonGrids, self)
            self._commonCards[i] = card
        end
        card:updateUI(self._commonCollects[i], i)
    end
    self:onSelectAchievementCom(1)
    self._passAchiProgressUI2:updateUI(self._commonCollectsRaw)
end

function SurviveGameAchievementUI:onSelectAchievementCom(index)
    for i = 1, #self._commonCards do
        local card = self._commonCards[i]
        card:updateCardSelect(index)
    end
    local cfg = self._commonCollects[index]
    if cfg then
        self._passAchiRightUI2:updateUI(cfg)
    end
end

function SurviveGameAchievementUI:_initTab()
    local childs = self._tabContent:get_childs()
    self._tabBtns = {}
    for i, child in ipairs(childs) do
        local index = tonumber(child:get_name())
        if index then
            self._tabBtns[index] = child
            child:add_local_event("左键-点击", function(local_player)
                self:_onTabClick(index)
            end)
        end
    end
end

local TAB_SELECT_IMG = 134237413
local TAB_NORMAL_IMG = 134274921
function SurviveGameAchievementUI:_onTabClick(index)
    local childs = self._content:get_childs()
    for i, child in ipairs(childs) do
        local name = tonumber(child:get_name())
        child:set_visible(name == index)
    end
    for i = 1, #self._tabBtns do
        self._tabBtns[i]:set_image(index == i and TAB_SELECT_IMG or TAB_NORMAL_IMG)
    end
end

return SurviveGameAchievementUI
