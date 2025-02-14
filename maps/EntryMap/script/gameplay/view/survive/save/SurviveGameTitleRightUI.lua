local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGameTitleRightUI = class("SurviveGameTitleRightUI", StaticUIBase)

function SurviveGameTitleRightUI:ctor(root)
    self._root = root
    local ui = y3.UIHelper.getUI("3d3b917b-4c01-4d80-a0b0-0260253de897")
    SurviveGameTitleRightUI.super.ctor(self, ui)

    self._nameText     = y3.UIHelper.getUI("99860f4a-73d0-4c41-92fd-986292c7628f")
    self._useAttr      = y3.UIHelper.getUI("4d8149b2-8add-48fb-a489-dd91aa534f1a")
    self._useTitleText = y3.UIHelper.getUI("0916a292-c07c-42f4-924b-2a4ffbb507d3")
    self._useTitleText:set_text(GameAPI.get_text_config('#965307952#lua'))
    self._fixAttr = y3.UIHelper.getUI("49ebabed-7436-4a35-89c2-6c2772ee0796")
    self._fixTitleText = y3.UIHelper.getUI("6e3c8779-deb1-4030-8bbf-849877198f1d")
    self._fixTitleText:set_text(GameAPI.get_text_config('#1751683681#lua'))

    self._equipAllTitleText = y3.UIHelper.getUI("eacf0481-e4d0-49c1-9cac-1f83c3753045")

    -- self._useAttr:set_visible(false)

    self._condition_TEXT = y3.UIHelper.getUI("9a64f324-c7d5-4cd7-9121-b1a1fa5932b2")
    self._use_BTN = y3.UIHelper.getUI("9a50acbe-f41f-47a7-a880-afc73624efa1")
    self._btnText = y3.UIHelper.getUI("de8867b1-3b14-4256-8a8e-7e20c0f48997")

    self._use_BTN:add_local_event("左键-点击", handler(self, self._onUseBtnClick))

    y3.gameApp:registerEvent(y3.EventConst.EVENT_EQUIP_TITLE_SUCCESS, handler(self, self._onEventEquipTitleSuccess))
end

function SurviveGameTitleRightUI:_onEventEquipTitleSuccess(id, playerId, titleId)
    if playerId == y3.gameApp:getMyPlayerId() then
        if self._titleCfg then
            self:updateUI(self._titleCfg)
        end
    end
end

function SurviveGameTitleRightUI:updateUI(titleCfg)
    self._titleCfg = titleCfg
    local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    self._btnText:set_text(playerData:isEquipTitle(titleCfg.id) and GameAPI.get_text_config('#30000001#lua28') or GameAPI.get_text_config('#30000001#lua29'))
    self._nameText:set_text(titleCfg.name)
    self._condition_TEXT:set_text(titleCfg.getway)
    self._equipAllTitleText:set_text(self._root:getAllTtileText())
    self:_updateTitleAttr(self._fixAttr, titleCfg.attr_pack)
    self:_updateTitleAttr(self._useAttr, titleCfg.equip_attr_pack)
end

function SurviveGameTitleRightUI:_onUseBtnClick()
    if self._titleCfg then
        local AchievementTitle = y3.gameApp:getLevel():getLogic("SurviveGameAchievementTitle")
        local isUnlock = AchievementTitle:titleIsUnLock(y3.gameApp:getMyPlayerId(), self._titleCfg.id)
        if isUnlock then
            y3.SyncMgr:sync(y3.SyncConst.SYNC_EQUIP_TITLE, { titleId = self._titleCfg.id })
        end
    end
end

function SurviveGameTitleRightUI:_updateTitleAttr(attrUI, attr_pack)
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

return SurviveGameTitleRightUI
