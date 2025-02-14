local UIBase = include("gameplay.base.UIBase")
local SurviveGameBarItem = class("SurviveGameBarItem", UIBase)

function SurviveGameBarItem:ctor(ui)
    self._ui = ui
    -- SurviveGameBarItem.super.ctor(self, parent, "item")
    self._item_panel = self._ui --self._ui:get_child("item_panel")

    -- self._item_panel:set_equip_slot_use_operation("左键双击")
    -- self._item_panel:add_local_event("左键-点击", handler(self, self._onItemClick))
    -- self._lock = self._item_panel:get_child("equip_disabled_img")
    -- self._lock:set_visible(false)
    -- self._icon = self._item_panel:get_child("equip_icon_img")
    -- self._cdProgress = self._item_panel:get_child("equip_cd_progress")
    -- self._cdProgress:set_visible(false)
    self._item_panel:add_local_event("鼠标-移入", function(local_player)
        if self._item and self._item:kv_has("cfgId") then
            local cfgId = self._item:kv_load("cfgId", "integer")
            y3.gameApp:getLevel():getView("SurviveGameTip"):showItemTip(cfgId)
        end
    end)
    self._item_panel:add_local_event("鼠标-移出", function(local_player)
        y3.gameApp:getLevel():getView("SurviveGameTip"):hideItemTip()
    end)
end

function SurviveGameBarItem:updateUI(item, mainUnit)
    self._mainUnit = mainUnit
    self._item = item
    self._item_panel:bind_unit(mainUnit)
    self._item_panel:set_ui_unit_slot(mainUnit, item:get_slot_type(), item:get_slot() - 1)
    -- self._icon:set_image(self._item:get_icon())
end

function SurviveGameBarItem:_onItemClick(slot_type, slot)
    print("SurviveGameBarItem:_onItemClick", slot_type, slot)
    print(self._item)
    self._mainUnit:use_item(self._item, self._mainUnit)
end

return SurviveGameBarItem
