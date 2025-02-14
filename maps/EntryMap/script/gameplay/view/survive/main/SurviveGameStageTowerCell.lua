local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGameStageTowerCell = class("SurviveGameStageTowerCell", StaticUIBase)

local SELECTED_IMG = 134260409
local UNSELECTED_IMG = 134245321


function SurviveGameStageTowerCell:ctor(ui, parent)
    self._parent = parent
    SurviveGameStageTowerCell.super.ctor(self, ui)

    self._bg_btn = self._ui:get_child("bg_BTN")
    self._icon_Img = self._ui:get_child("_tower_icon_IMG")
    self._mask = self._ui:get_child("mask")
    self._tower_name_TEXT = self._ui:get_child("_tower_name_TEXT")

    self._mask:set_intercepts_operations(false)
    self._bg_btn:add_local_event("左键-点击", handler(self, self._onBgBtnClick))
end

function SurviveGameStageTowerCell:updateUI(cfg, index)
    self._index = index
    local gameCourse = y3.gameApp:getLevel():getLogic("SurviveGameCourse")
    self._mask:set_visible(not gameCourse:stageTowerIsUnlock(y3.gameApp:getMyPlayerId(), cfg.id))
    self._icon_Img:set_image(cfg.tower_icon)
    self._tower_name_TEXT:set_text(cfg.tower_name)
    
end

function SurviveGameStageTowerCell:updateSelect(index)
    self._bg_btn:set_image(index == self._index and SELECTED_IMG or UNSELECTED_IMG)
end

function SurviveGameStageTowerCell:_onBgBtnClick(local_player)
    self._parent:onSelectedTower(self._index)
end

return SurviveGameStageTowerCell
