local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGamePlatformShopUI = class("SurviveGamePlatformShopUI", StaticUIBase)

function SurviveGamePlatformShopUI:ctor()
    local ui = y3.UIHelper.getUI("ff2b2d1a-5885-419b-aa65-27aa7e1c0767")
    SurviveGamePlatformShopUI.super.ctor(self, ui)
    self._menuList = y3.UIHelper.getUI("e6598923-39f0-4669-a693-cc3e98cdce63")
    self._content = y3.UIHelper.getUI("466aefa0-388f-4f76-9b24-d2503ac62ea5")

    self._moneyUI = include("gameplay.view.survive.save.SurviveGamePlatformShopMoneyUI").new()
    self._integralUI = include("gameplay.view.survive.save.SurviveGamePlatformShopIntegralUI").new()
    self:_initUI()
    self:_onMenuClick(1)
end

function SurviveGamePlatformShopUI:_initUI()
    local menu_childs = self._menuList:get_childs()
    self._menuBtns = {}
    for index, menuBtn in ipairs(menu_childs) do
        local btn = menuBtn:get_childs()[1]
        table.insert(self._menuBtns, btn)
        btn:add_local_event("左键-点击", function(local_player)
            self:_onMenuClick(index)
        end)
    end
end

function SurviveGamePlatformShopUI:_onMenuClick(index)
    local childs = self._content:get_childs()
    for i, child in ipairs(childs) do
        child:set_visible(i == index)
    end
    for i = 1, #self._menuBtns do
        self._menuBtns[i]:set_image(i == index and 134221722 or 134263068)
    end
end

return SurviveGamePlatformShopUI
