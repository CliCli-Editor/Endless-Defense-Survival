local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGameTowerSkinDetailUI = class("SurviveGameTowerSkinDetailUI", StaticUIBase)

function SurviveGameTowerSkinDetailUI:ctor(ui)
    SurviveGameTowerSkinDetailUI.super.ctor(self, ui)

    self._attr_nature = self._ui:get_child("attr_nature.attr")
    self._attr_in_use = self._ui:get_child("attr_in_use.attr")

    self._specSkillUI = self._ui:get_child("spec.skill")
    self._null_TEXT = self._ui:get_child("spec._null_TEXT")

    self._conditionText = self._ui:get_child("condition._null_TEXT")

    self._use_BTN = self._ui:get_child("control.use_BTN")

    self._use_BTN:add_local_event("左键-点击", handler(self, self._onEquipBtnClick))
end

function SurviveGameTowerSkinDetailUI:updateUI(cfg)
    self._cfg = cfg
    self._conditionText:set_text(cfg.tower_skin_acquire)
    self._specSkillUI:set_visible(false)
    self._null_TEXT:set_visible(true)
    self:_updateTitleAttr(self._attr_nature, cfg.tower_skin_possess_attr_pack)
    self:_updateTitleAttr(self._attr_in_use, cfg.tower_skin_equip_attr_pack)

    local gameCourse = y3.gameApp:getLevel():getLogic("SurviveGameCourse")
    local isUnLock = gameCourse:towerSkinIsUnlock(y3.gameApp:getMyPlayerId(), cfg.id)
    self._use_BTN:set_button_enable(isUnLock)
    if not isUnLock then
        self._use_BTN:get_childs()[1]:set_text(y3.langCfg.get(62).str_content)
    else
        local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
        if playerData:getTowerSkinId() == cfg.id then
            self._use_BTN:get_childs()[1]:set_text(y3.langCfg.get(64).str_content)
        else
            self._use_BTN:get_childs()[1]:set_text(GameAPI.get_text_config('#308579347#lua'))
        end
    end
end

function SurviveGameTowerSkinDetailUI:_updateTitleAttr(attrUI, attr_pack)
    local attrList = y3.userDataHelper.getAttrListByPack(attr_pack)
    local childs = attrUI:get_childs()
    for index, child in ipairs(childs) do
        local attrData = attrList[index]
        if attrData then
            child:set_visible(true)
            child:get_child("_attr_name_TEXT"):set_text(attrData.name)
            if attrData.showType == 1 then
                child:get_child("_attr_value_TEXT"):set_text("+" .. attrData.value)
            else
                child:get_child("_attr_value_TEXT"):set_text("+" .. attrData.value .. "%")
            end
        else
            child:set_visible(false)
        end
    end
end

function SurviveGameTowerSkinDetailUI:_onEquipBtnClick()
    if self._cfg then
        local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
        if playerData:getTowerSkinId() == self._cfg.id then
            y3.SyncMgr:sync(y3.SyncConst.SYNC_UNEQUIP_TOWER_SKIN, { towerSkinId = self._cfg.id })
        else
            y3.SyncMgr:sync(y3.SyncConst.SYNC_EQUIP_TOWER_SKIN, { towerSkinId = self._cfg.id })
        end
    end
end

return SurviveGameTowerSkinDetailUI
