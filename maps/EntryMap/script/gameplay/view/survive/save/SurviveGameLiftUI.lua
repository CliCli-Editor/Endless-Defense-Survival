local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGameLiftUI = class("SurviveGameLiftUI", StaticUIBase)

function SurviveGameLiftUI:ctor()
    local ui = y3.UIHelper.getUI("04360229-d268-4320-993c-7d71d5301f20")
    SurviveGameLiftUI.super.ctor(self, ui)

    self._menuList = y3.UIHelper.getUI("160d8ef3-aa30-4417-8736-0895fb54c573")
    self._content = y3.UIHelper.getUI("d5734f17-84cc-416e-87f9-3a4fb2621682")
    self._achievementUI = include("gameplay.view.survive.save.SurviveGameAchievementUI").new()
    self._playerInfoUI = include("gameplay.view.survive.save.SurviveGamePlayerInfoUI").new()
    self._titleInfoUI = include("gameplay.view.survive.save.SurviveGameTitleUI").new()

    self._tabView = {
        [1] = self._playerInfoUI,
        [2] = self._achievementUI,
        [3] = self._titleInfoUI,
    }
    self:_initMenu()
    self:_onMenuBtnClick(1)
end

function SurviveGameLiftUI:onUpdate()
    self:_onMenuBtnClick(1)
end

function SurviveGameLiftUI:_initMenu()
    local childs = self._menuList:get_childs()
    self._menuBtns = {}
    for i = 1, #childs do
        local item = childs[i]
        table.insert(self._menuBtns, item:get_childs()[1])
        item:get_childs()[1]:add_local_event('左键-点击', function(local_player)
            self:_onMenuBtnClick(i)
        end)
    end
end

function SurviveGameLiftUI:_onMenuBtnClick(index)
    local childs = self._content:get_childs()
    for i = 1, #childs do
        childs[i]:set_visible(index == i)
    end
    for i = 1, #self._menuBtns do
        self._menuBtns[i]:set_image(i == index and 134221722 or 134263068)
    end
    if self._tabView[index].onUpdate then
        self._tabView[index]:onUpdate()
    end
end

return SurviveGameLiftUI
