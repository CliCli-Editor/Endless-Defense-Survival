local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGameResUI = class("SurviveGameResUI", StaticUIBase)

function SurviveGameResUI:ctor()
    local ui = y3.UIHelper.getUI("fe0c274a-7c20-452f-bd53-2b34c3e40f96")
    SurviveGameResUI.super.ctor(self, ui)
    self._res_gold_TEXT = y3.UIHelper.getUI("e12bbb9b-98bf-4289-bb2b-dbffa8bea77c")
    self._res_stone_TEXT = y3.UIHelper.getUI("0d70102c-4f7d-4a6b-bb6f-fa62b905cd1d")

    y3.gameApp:registerEvent(y3.EventConst.EVENT_SURVIVE_RESOURCE_ADD_GOLD, handler(self, self.onEventAddGold))
    self:updateUI()
end

function SurviveGameResUI:onEventAddGold(trg, player)
    if player:get_id() == y3.gameApp:getMyPlayerId() then
        self:updateUI()
    end
end

function SurviveGameResUI:updateUI()
    local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local player = playerData:getPlayer()
    self._res_gold_TEXT:set_text(math.floor(player:get_attr("gold")) .. "")
    self._res_stone_TEXT:set_text(math.floor(player:get_attr("diamond")) .. "")
end

return SurviveGameResUI
