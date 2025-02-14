local SettlementUI = include("gameplay.view.settlement.SettlementUI")
local SettlementUIFailed = class("SettlementUIFailed", SettlementUI)

function SettlementUIFailed:ctor()
    local ui = y3.UIHelper.getUI("9cfa9d7d-afe0-4b38-b32d-c88a18c2f9ff")
    SettlementUIFailed.super.ctor(self, ui)
    y3.gameApp:registerEvent(y3.EventConst.EVENT_SURVEVE_RESULT_FAIL, handler(self, self.onSurviveResultFail))
end

function SettlementUIFailed:onSurviveResultFail(id, playerId)
    if playerId == y3.gameApp:getMyPlayerId() then
        self:updatePlayer()
        self:updateReward()
    end
end

return SettlementUIFailed
