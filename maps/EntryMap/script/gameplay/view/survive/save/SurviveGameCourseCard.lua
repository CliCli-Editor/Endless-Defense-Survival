local UIBase                = include("gameplay.base.UIBase")
local SurviveGameCourseCard = class("SurviveGameCourseCard", UIBase)

function SurviveGameCourseCard:ctor(parent)
    SurviveGameCourseCard.super.ctor(self, parent, y3.SurviveConst.PREFAB_MAP["main_lifetime"])
    self._title_TEXT = self._ui:get_child("_title_TEXT")
    self._value_TEXT = self._ui:get_child("_value_TEXT")
    self._bg = self._ui:get_child("bg")
end

function SurviveGameCourseCard:updateUI(cfg, index)
    self._title_TEXT:set_text(cfg.name)
    local gameCourse = y3.gameApp:getLevel():getLogic("SurviveGameCourse")
    self._value_TEXT:set_text(gameCourse:getValue(y3.gameApp:getMyPlayerId(), cfg.id))
    if index % 2 == 0 then
        self._bg:set_visible(true)
    else
        self._bg:set_visible(false)
    end
end

return SurviveGameCourseCard
