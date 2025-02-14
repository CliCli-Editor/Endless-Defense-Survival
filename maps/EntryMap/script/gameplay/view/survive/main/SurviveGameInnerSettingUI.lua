local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGameInnerSettingUI = class("SurviveGameInnerSettingUI", StaticUIBase)

local SETTING_MAP = {
    [1] = "effect",
    [2] = "damageText",
    [3] = "callSoul"
}

local INDEX_EFFECT = 1
local INDEX_DAMAGETEXT = 2
local INDEX_CALLSOUL = 3

function SurviveGameInnerSettingUI:ctor()
    local ui = y3.UIHelper.getUI("e3c6f53b-a28b-4fc7-bc7a-052506f0128b")
    SurviveGameInnerSettingUI.super.ctor(self, ui)

    self._exitBtn = y3.UIHelper.getUI("b1b98944-fb91-4614-8fa0-b747a951625f")
    self._backBtn = y3.UIHelper.getUI("12ac87d8-4771-4cf6-b3ef-e558e55248d8")
    self._settingList = y3.UIHelper.getUI("5c4f380f-c255-4fa2-a220-4b87edc6abef")

    self._exitBtn:add_local_event("左键-点击", handler(self, self._onExitBtnClick))
    self._backBtn:add_local_event("左键-点击", handler(self, self._onExitBtnClick))
    self:_initUI()
end

function SurviveGameInnerSettingUI:_initUI()
    local childs = self._settingList:get_childs()
    for index, child in ipairs(childs) do
        child:get_child("use"):add_local_event("左键-点击", function()
            self:_onClickSetting(index)
        end)
    end
end

function SurviveGameInnerSettingUI:updateUI()
    local childs = self._settingList:get_childs()
    for index, child in ipairs(childs) do
        self:_showSettingStatus(index, child)
    end
end

function SurviveGameInnerSettingUI:_showSettingStatus(index, ui)
    if index == INDEX_EFFECT then
        local isShow = y3.Sugar.gameCourse():isShowEffect()
        ui:get_child("use.icon"):set_visible(not isShow)
    elseif index == INDEX_DAMAGETEXT then
        local isShow = y3.Sugar.gameCourse():isShowDamageText()
        ui:get_child("use.icon"):set_visible(not isShow)
    elseif index == INDEX_CALLSOUL then
        local isShow = y3.Sugar.gameCourse():isShowCallSoul()
        ui:get_child("use.icon"):set_visible(isShow)
    end
end

function SurviveGameInnerSettingUI:_onClickSetting(index)
    if index == INDEX_EFFECT then
        local isShow = y3.Sugar.gameCourse():isShowEffect()
        y3.Sugar.gameCourse():setShowEffect(not isShow)
    elseif index == INDEX_DAMAGETEXT then
        local isShow = y3.Sugar.gameCourse():isShowDamageText()
        y3.Sugar.gameCourse():setShowDamageText(not isShow)
    elseif index == INDEX_CALLSOUL then
        local isShow = y3.Sugar.gameCourse():isShowCallSoul()
        y3.Sugar.gameCourse():setShowCallSoul(not isShow)
    end
    self:updateUI()
end

function SurviveGameInnerSettingUI:show(isShow)
    self:setVisible(isShow)
    if isShow then
        self:updateUI()
    end
end

function SurviveGameInnerSettingUI:_onExitBtnClick(local_player)
    self:show(false)
end

return SurviveGameInnerSettingUI
