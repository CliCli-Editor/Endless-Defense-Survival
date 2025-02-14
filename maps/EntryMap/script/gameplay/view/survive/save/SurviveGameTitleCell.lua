local UIBase               = include("gameplay.base.UIBase")
local SurviveGameTitleCell = class("SurviveGameTitleCell", UIBase)

function SurviveGameTitleCell:ctor(parent)
    self._parent = parent
    SurviveGameTitleCell.super.ctor(self, parent, y3.SurviveConst.PREFAB_MAP["main_title"])

    self._sel = self._ui:get_child("sel")
    self._bg_BTN = self._ui:get_child("bg_BTN")
    self._lock = self._ui:get_child("lock")
    self._title_detail_TEXT = self._ui:get_child("title_detail_TEXT")
    self._useUI = self._ui:get_child("use")

    self._bg_BTN:add_local_event("左键-点击", handler(self, self.on_click))
end

function SurviveGameTitleCell:updateUI(cfg, root)
    local AchievementTitle = y3.gameApp:getLevel():getLogic("SurviveGameAchievementTitle")
    local isUnlock = AchievementTitle:titleIsUnLock(y3.gameApp:getMyPlayerId(), cfg.id)
    local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local isEquip = playerData:isEquipTitle(cfg.id)
    self._root = root
    self._cfg = cfg
    self._title_detail_TEXT:set_text(cfg.name)
    self._lock:set_visible(not isUnlock)
    self._useUI:set_visible(isEquip)
end

function SurviveGameTitleCell:updateSelect(selectId)
    self._sel:set_visible(selectId == self._cfg.id)
end

function SurviveGameTitleCell:on_click()
    self._root:onSelectTtile(self._parent, self._cfg.id)
end

return SurviveGameTitleCell
