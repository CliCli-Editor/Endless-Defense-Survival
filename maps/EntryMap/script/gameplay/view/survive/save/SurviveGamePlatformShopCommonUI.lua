local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGamePlatformShopCommonUI = class("SurviveGamePlatformShopCommonUI", StaticUIBase)

local SKU_CLASS_MAP = {
    [1] = 134234682,
    [2] = 134269241,
    [3] = 134258138,
    [4] = 134274479,
    [5] = 134252896,

}

function SurviveGamePlatformShopCommonUI:ctor(ui, shopList)
    self._shopList = shopList
    SurviveGamePlatformShopCommonUI.super.ctor(self, ui)
    self._filter = self._ui:get_child("left.filter")
    self._contenGrid = self._ui:get_child("left.grid.content_GRID")

    self._icon_img = self._ui:get_child("right.avatar._icon_IMG")
    self._sku_class_img = self._ui:get_child("right.avatar._sku_class_IMG")
    self._name_text = self._ui:get_child("right.avatar._title_TEXT")
    self._source_descr_TEXT = self._ui:get_child("right.descr.source._descr_TEXT")
    self._reward_descr_TEXT = self._ui:get_child("right.descr.reward.descr_LIST._descr_TEXT")

    self._right = self._ui:get_child("right")

    self._control = self._ui:get_child("right.control")
    self._control:set_visible(true)
    self._jump_to_the_platmall_BTN = self._ui:get_child("right.control.jump_to_the_platmall_BTN")

    self._jump_to_the_platmall_BTN:add_local_event("左键-点击", handler(self, self._onJumpToPlatmallBtnClick))

    if #self._shopList > 0 then
        self._shopType = self._shopList[1].filter_1
    else
        self._shopType = 0
    end

    self:_initCards()
    self:_initFilter()
    self:_onFilterBtnClick(1)
    if #shopList > 0 then
        self._right:set_visible(true)
        self:onSelectCard(self._shopList[1].key)
    else
        self._right:set_visible(false)
    end
end

function SurviveGamePlatformShopCommonUI:_initCards()
    self._shopCards = {}
    for i = 1, #self._shopList do
        self._shopCards[i] = include("gameplay.view.survive.save.SurviveGamePlatformShopCard").new(self._contenGrid, self)
    end
end

function SurviveGamePlatformShopCommonUI:_initFilter()
    local filterChilds = self._filter:get_childs()
    self._filterBtns = {}
    for index, v in ipairs(filterChilds) do
        if self._shopType == 1 then
            v:set_visible(false)
        end
        local btn = v:get_childs()[1]
        table.insert(self._filterBtns, btn)
        btn:add_local_event("左键-点击", function()
            self:_onFilterBtnClick(index)
        end)
    end
end

function SurviveGamePlatformShopCommonUI:_onFilterBtnClick(index)
    for i, btn in ipairs(self._filterBtns) do
        btn:set_image(i == index and 134278900 or 134227385)
    end
    local IDX_MAP_CLASS = {
        [1] = 5,
        [2] = 4,
        [3] = 3,
        [4] = 2,
        [5] = 1,
    }
    local list = {}
    if self._shopType == 1 then
        list = self._shopList
    else
        for i = 1, #self._shopList do
            local cfg = self._shopList[i]
            if cfg.class == IDX_MAP_CLASS[index] then
                table.insert(list, cfg)
            end
        end
    end
    self:_refreshShopList(list)
end

function SurviveGamePlatformShopCommonUI:_refreshShopList(list)
    for i = 1, #self._shopCards do
        self._shopCards[i]:setVisible(false)
    end
    for i = 1, #list do
        self._shopCards[i]:setVisible(true)
        self._shopCards[i]:updateUI(list[i])
    end
end

function SurviveGamePlatformShopCommonUI:_onJumpToPlatmallBtnClick()
    if self._selectKey then
        local cfg = include("gameplay.config.config_localMall").get(self._selectKey)
        if not cfg then
            return
        end
        local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
        local player = playerData:getPlayer()
        if cfg.skuType > 0 then
            print(cfg.skuType)
            player:open_platform_shop(cfg.skuType)
        end
    end
end

function SurviveGamePlatformShopCommonUI:onSelectCard(key)
    self._selectKey = key
    self:_updateRight()
end

function SurviveGamePlatformShopCommonUI:_updateRight()
    if self._selectKey then
        local cfg = include("gameplay.config.config_localMall").get(self._selectKey)
        self._jump_to_the_platmall_BTN:set_visible(false)
        if not cfg then
            return
        end
        self._icon_img:set_image(tonumber(cfg.icon))
        self._sku_class_img:set_image(SKU_CLASS_MAP[cfg.class])
        self._name_text:set_text(cfg.name)
        self._source_descr_TEXT:set_text(cfg.src)
        self._reward_descr_TEXT:set_text(cfg.descr)
        self._jump_to_the_platmall_BTN:set_visible(cfg.directLink > 0)
    end
end

return SurviveGamePlatformShopCommonUI
