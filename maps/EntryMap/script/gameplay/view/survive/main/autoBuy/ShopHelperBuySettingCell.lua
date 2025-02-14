local UIBase = include("gameplay.base.UIBase")
local ShopHelperBuySettingCell = class("ShopHelperBuySettingCell", UIBase)

function ShopHelperBuySettingCell:ctor(parent, root)
    ShopHelperBuySettingCell.super.ctor(self, parent, y3.SurviveConst.PREFAB_MAP["shop_help_setting"])
    self._root = root
    self._setting_index_TEXT = self._ui:get_child("bg.setting_index_TEXT")
    self._bgImg = self._ui:get_child("bg.image_1")
    self._setting_name_TEXT = self._ui:get_child("tips.setting_name_TEXT")

    self._bgImg:add_local_event("左键-点击", handler(self, self._onSettIndexClick))

    self._ui:add_local_event("鼠标-移入", function()
        if self._cfg.shop_helper_lable_type ~= 4 then
            local desc = self._root:getLabelTips(self._cfg.id)
            if desc ~= "" then
                desc = y3.langCfg.get(76).str_content .. "\n" .. desc
                y3.Sugar.tipRoot():showUniversalTip({ title = self._cfg.shop_helper_lable_name, desc = desc })
            end
        end
    end)
    self._ui:add_local_event("鼠标-移出", function()
        y3.Sugar.tipRoot():hideUniversalTip()
    end)
end

function ShopHelperBuySettingCell:refresh()
    self:updateUI(self._cfg, self._shopHelper)
end

function ShopHelperBuySettingCell:updateUI(cfg, shopHelper)
    self._shopHelper = shopHelper
    self._cfg = cfg
    local collectIndex = 0
    if cfg.shop_helper_lable_type == 4 then
        collectIndex = self._shopHelper:getCollectLabelIndex(cfg.shop_helper_lable_type, cfg.id - 400)
    else
        collectIndex = self._shopHelper:getCollectLabelIndex(cfg.shop_helper_lable_type, cfg.id)
    end
    if collectIndex > 0 then
        self._setting_index_TEXT:set_text(collectIndex .. "")
    else
        self._setting_index_TEXT:set_text("")
    end
    self._setting_name_TEXT:set_text(cfg.shop_helper_lable_name)
end

function ShopHelperBuySettingCell:_onSettIndexClick()
    local cfg = self._cfg
    local collectIndex = 0
    local label = 0
    if cfg.shop_helper_lable_type == 4 then
        label = cfg.id - 400
        collectIndex = self._shopHelper:getCollectLabelIndex(cfg.shop_helper_lable_type, cfg.id - 400)
    else
        label = cfg.id
        collectIndex = self._shopHelper:getCollectLabelIndex(cfg.shop_helper_lable_type, cfg.id)
    end
    if collectIndex == 0 then
        y3.SyncMgr:sync(y3.SyncConst.SYNC_INSERT_LABEL_SORT, { labelType = cfg.shop_helper_lable_type, label = label })
    else
        y3.SyncMgr:sync(y3.SyncConst.SYNC_REMOVE_LABEL_SORT, { labelType = cfg.shop_helper_lable_type, label = label })
    end
end

return ShopHelperBuySettingCell
