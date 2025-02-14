local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGameDressUpUI = class("SurviveGameDressUpUI", StaticUIBase)

local SHOW_CNT = 1

function SurviveGameDressUpUI:ctor()
    local ui = y3.UIHelper.getUI("4c92690c-7e2e-4233-a61b-c02c4219ade9")
    SurviveGameDressUpUI.super.ctor(self, ui)

    self._menuList = y3.UIHelper.getUI("6a7f0376-26a7-44ac-b845-7b0456b7a6bc")
    self._content = y3.UIHelper.getUI("4c910dcf-c60a-4390-89bb-e8eee8170512")

    self._skinUI = include("gameplay.view.survive.save.dressUp.SurviveGameTowerSkinUI").new()
    self._tabView = {
        self._skinUI,
    }
    self:_initMenu()
    self:_onMenuBtnClick(1)
end

function SurviveGameDressUpUI:_initMenu()
    local childs = self._menuList:get_childs()
    self._menuBtns = {}
    for i = 1, #childs do
        local item = childs[i]
        item:set_visible(i <= SHOW_CNT)
        table.insert(self._menuBtns, item:get_childs()[1])
        item:get_childs()[1]:add_local_event('左键-点击', function(local_player)
            self:_onMenuBtnClick(i)
        end)
    end
end

function SurviveGameDressUpUI:_onMenuBtnClick(index)
    local childs = self._content:get_childs()
    for i = 1, #childs do
        childs[i]:set_visible(index == i)
    end
    for i = 1, #self._menuBtns do
        self._menuBtns[i]:set_image(i == index and 134221722 or 134263068)
    end
    if self._tabView[index] and self._tabView[index].onUpdate then
        self._tabView[index]:onUpdate()
    end
end

function SurviveGameDressUpUI:onUpdate()
    self:_onMenuBtnClick(1)
end

return SurviveGameDressUpUI
