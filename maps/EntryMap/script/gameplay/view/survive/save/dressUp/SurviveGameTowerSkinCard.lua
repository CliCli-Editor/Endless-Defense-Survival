local UIBase                   = include("gameplay.base.UIBase")
local SurviveGameTowerSkinCard = class("SurviveGameTowerSkinCard", UIBase)

local CLASS_MAP                = {
    [1] = 134227847,
    [2] = 134255520,
    [3] = 134239340,
    [4] = 134240980,
    [5] = 134237429,
}

local SKU_CLASS_MAP            = {
    [1] = 134234682,
    [2] = 134269241,
    [3] = 134258138,
    [4] = 134274479,
    [5] = 134252896,
}

function SurviveGameTowerSkinCard:ctor(parent, root)
    self._root = root
    SurviveGameTowerSkinCard.super.ctor(self, parent, y3.SurviveConst.PREFAB_MAP["main_skin"])

    self._bg = self._ui:get_child("bg")
    self._sel = self._ui:get_child("sel")
    self._skin_IMG = self._ui:get_child("_skin_IMG")
    self._class_IMG = self._ui:get_child("_class_IMG")
    self._title_TEXT = self._ui:get_child("_title_TEXT")
    self._in_use = self._ui:get_child("in_use")

    self._bg:add_local_event("左键-点击", handler(self, self._onSkinCardClick))
end

function SurviveGameTowerSkinCard:updateUI(cfg)
    self._cfg = cfg
    self._skin_IMG:set_image(cfg.tower_skin_list_icon)
    self._bg:set_image(CLASS_MAP[cfg.tower_skin_quality])
    self._title_TEXT:set_text(cfg.tower_skin_name)
    self._class_IMG:set_image(SKU_CLASS_MAP[cfg.tower_skin_quality])
    self._in_use:set_visible(false)
end

function SurviveGameTowerSkinCard:_onSkinCardClick(local_player)
    self._root:onSelectSkin(self._cfg.id)
end

function SurviveGameTowerSkinCard:updateSelect(seleid)
    self._sel:set_visible(seleid == self._cfg.id)
end

return SurviveGameTowerSkinCard
