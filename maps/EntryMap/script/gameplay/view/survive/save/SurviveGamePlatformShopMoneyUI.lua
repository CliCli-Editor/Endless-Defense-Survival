local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGamePlatformShopMoneyUI = class("SurviveGamePlatformShopMoneyUI", StaticUIBase)

function SurviveGamePlatformShopMoneyUI:ctor()
    local ui = y3.UIHelper.getUI("4de202ca-37a4-40f0-bb7b-c4f18efc57a4")
    SurviveGamePlatformShopMoneyUI.super.ctor(self, ui)
    self._tab = y3.UIHelper.getUI("849f8c57-fcde-437f-ae95-24a74bc0c913")
    self._content = y3.UIHelper.getUI("c94e2881-9f92-40c9-bc1e-6f099d55433d")


    self:_initUI()
    self:_initShop()
end

function SurviveGamePlatformShopMoneyUI:_initUI()
    local tab_childs = self._tab:get_childs()
    self._tabBtns = {}
    for i, child in ipairs(tab_childs) do
        local index = tonumber(child:get_name())
        if index then
            if index == 3 then
                child:get_child("_title_TEXT"):set_text(GameAPI.get_text_config('#2038764133#lua'))
            end
            table.insert(self._tabBtns, child)
            child:add_local_event("左键-点击", function(local_player)
                self:_onTabClick(index)
            end)
        end
    end
end

function SurviveGamePlatformShopMoneyUI:_onTabClick(index)
    local childs = self._content:get_childs()
    for i, child in ipairs(childs) do
        child:set_visible(index == i)
    end
    for i = 1, #self._tabBtns do
        self._tabBtns[i]:set_image(i == index and 134237413 or 134274921)
    end
end

function SurviveGamePlatformShopMoneyUI:_initShop()
    local config_localMall = include("gameplay.config.config_localMall")
    local len = config_localMall.length()
    self._tabList = { {}, {}, {} }
    for i = 1, len do
        local cfg = config_localMall.indexOf(i)
        assert(cfg, "")
        if cfg.filter_1 == 1 then
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

return SurviveGamePlatformShopMoneyUI
