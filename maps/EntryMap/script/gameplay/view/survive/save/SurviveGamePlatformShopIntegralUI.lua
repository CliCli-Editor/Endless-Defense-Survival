local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGamePlatformShopIntegralUI = class("SurviveGamePlatformShopIntegralUI", StaticUIBase)

function SurviveGamePlatformShopIntegralUI:ctor()
    local ui = y3.UIHelper.getUI("e495ef77-4806-431f-85cf-2dbe83acb626")
    SurviveGamePlatformShopIntegralUI.super.ctor(self, ui)
    self._tab = y3.UIHelper.getUI("7ec075e4-6475-4b9e-bc2c-a0896507cb05")
    self._content = y3.UIHelper.getUI("8ce2834b-9c00-400f-b2fa-2199417666bf")
    self:_initUI()
    self:_initShop()
end

function SurviveGamePlatformShopIntegralUI:_initUI()
    local tab_childs = self._tab:get_childs()
    self._tabBtns = {}
    for i, child in ipairs(tab_childs) do
        local index = tonumber(child:get_name())
        if index then
            if index == 1 then
                child:get_child("_title_TEXT"):set_text(GameAPI.get_text_config('#80404462#lua'))
            end
            if index == 2 then
                child:set_visible(false)
            end
            table.insert(self._tabBtns, child)
            child:add_local_event("左键-点击", function(local_player)
                self:_onTabClick(index)
            end)
        end
    end
end

function SurviveGamePlatformShopIntegralUI:_onTabClick(index)
    local childs = self._content:get_childs()
    for i, child in ipairs(childs) do
        child:set_visible(index == i)
    end
    for i = 1, #self._tabBtns do
        self._tabBtns[i]:set_image(i == index and 134237413 or 134274921)
    end
end

function SurviveGamePlatformShopIntegralUI:_initShop()
    local config_localMall = include("gameplay.config.config_localMall")
    local len = config_localMall.length()
    self._tabList = { {}, {} }
    for i = 1, len do
        local cfg = config_localMall.indexOf(i)
        assert(cfg, "")
        if cfg.filter_1 == 2 then
            if self._tabList[cfg.filter_2] then
                table.insert(self._tabList[cfg.filter_2], cfg)
            end
        end
    end
    self._tabView = {}
    for i = 1, #self._tabList do
        local viewUI = self._content:get_child("" .. i)
        self._tabView[i] = include("gameplay.view.survive.save.SurviveGamePlatformShopCommonUI").new(viewUI,
            self._tabList[i])
    end
end

return SurviveGamePlatformShopIntegralUI
