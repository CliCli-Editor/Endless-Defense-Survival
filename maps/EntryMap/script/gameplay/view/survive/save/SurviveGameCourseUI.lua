local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGameCourseUI = class("SurviveGameCourseUI", StaticUIBase)

function SurviveGameCourseUI:ctor()
    local ui = y3.UIHelper.getUI("450d2925-cb18-48df-b4c9-7542f36e8798")
    SurviveGameCourseUI.super.ctor(self, ui)
    self._list = y3.UIHelper.getUI("028b8395-86b6-47a9-8a88-c42a41bc81c9")

    self._listCards = {}
    self:_initUI()
end

function SurviveGameCourseUI:_initUI()
    local gameCourse = y3.gameApp:getLevel():getLogic("SurviveGameCourse")
    local cfgList = gameCourse:getCfgList()
    for i = 1, #cfgList do
        local card = self._listCards[i]
        if not card then
            card = include("gameplay.view.survive.save.SurviveGameCourseCard").new(self._list)
            self._listCards[i] = card
        end
        card:updateUI(cfgList[i], i)
    end
end

return SurviveGameCourseUI
