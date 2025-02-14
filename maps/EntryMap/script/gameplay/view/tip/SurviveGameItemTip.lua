local UserDataHelper = include "gameplay.level.logic.helper.UserDataHelper"
local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGameItemTip = class("SurviveGameItemTip", StaticUIBase)

function SurviveGameItemTip:ctor()
    local ui = y3.UIHelper.getUI("267b854c-db26-4528-8dad-1fbfa053e294")
    SurviveGameItemTip.super.ctor(self, ui)

    self._itemName = y3.UIHelper.getUI("240fa296-1037-45e5-a77e-b769c66ead99")
    self._itemDesc = y3.UIHelper.getUI("d5d612be-7d82-4d1a-92ab-5effbda1005a")
    self._ui:set_anchor(0, 0)
end

function SurviveGameItemTip:show(cfgId, item)
    local itemCfg = include("gameplay.config.item").get(tonumber(cfgId))
    if not itemCfg then
        return
    end
    self._item = item
    y3.UIActionMgr:playFadeAction(self._ui)
    self._ui:set_visible(true)
    self._itemCfg = itemCfg
    self._itemName:set_text(itemCfg.item_name)
    self._itemDesc:set_text(self:getDesc(itemCfg))
    local xOffset, yOffset = y3.UIHelper.limitTipOffset(y3.gameApp:getMyPlayerId(), self._ui)
    self._ui:set_follow_mouse(true, xOffset, yOffset)
end

function SurviveGameItemTip:getDesc(itemCfg)
    return UserDataHelper.getItemDescs(itemCfg, self._item)
end

function SurviveGameItemTip:hide()
    self._ui:set_visible(false)
end

return SurviveGameItemTip
