local StaticUIBase    = include("gameplay.base.StaticUIBase")
local SurviveMenuView = class("SurviveMenuView", StaticUIBase)

function SurviveMenuView:ctor()
    local ui = y3.UIHelper.getUI("ed0d6420-e5c0-4308-80cd-1b5fb3956cdd")
    SurviveMenuView.super.ctor(self, ui)
    self:onInit()
end

function SurviveMenuView:onInit()

end

function SurviveMenuView:_initUI()

end

return SurviveMenuView
