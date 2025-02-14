local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGameRankUI = class("SurviveGameRankUI", StaticUIBase)
local SurviveGameRankSaveUI = include("gameplay.view.survive.save.SurviveGameRankSaveUI")

local MENU_NAME = {
    [1] = "存档战力",
    [2] = "遗迹森林"
}

function SurviveGameRankUI:ctor()
    local ui = y3.UIHelper.getUI("bd5090d0-7700-4c48-9794-4e99400055a9")
    SurviveGameRankUI.super.ctor(self, ui)
    self._menuList = y3.UIHelper.getUI("7007b9b1-2ab8-49b3-b784-ae18fb218db4")
    self._content = y3.UIHelper.getUI("2ababed8-3d5c-498d-ad26-14205c09e440")

    local powerUi = y3.UIHelper.getUI("ff11390e-09fc-4ce8-b0d9-bdca80f10afc")
    self._rankPowerUI = SurviveGameRankSaveUI.new(powerUi, y3.userData:getSaveSlot("maxPower"))
    local passUi = y3.UIHelper.getUI("85970da0-be3e-41de-941a-1387c3fa22de")
    self._rankPassUI = SurviveGameRankSaveUI.new(passUi, y3.userData:getSaveSlot("passValue"))

    self:_initMenu()
    self:_onMenuBtnClick(1)
end

function SurviveGameRankUI:_initMenu()
    local childs = self._menuList:get_childs()
    self._menuBtns = {}
    for i = 1, #childs do
        local item = childs[i]
        item:get_child("_title_TEXT"):set_text(MENU_NAME[i])
        table.insert(self._menuBtns, item:get_childs()[1])
        item:get_childs()[1]:add_local_event('左键-点击', function(local_player)
            self:_onMenuBtnClick(i)
        end)
    end
end

function SurviveGameRankUI:_onMenuBtnClick(index)
    print("on menu btn click", index)
    local childs = self._content:get_childs()
    for i = 1, #childs do
        childs[i]:set_visible(index == i)
    end
    for i = 1, #self._menuBtns do
        self._menuBtns[i]:set_image(i == index and 134221722 or 134263068)
    end
end

return SurviveGameRankUI
