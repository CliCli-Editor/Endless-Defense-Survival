local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGameSevenDayUI = class("SurviveGameSevenDayUI", StaticUIBase)

function SurviveGameSevenDayUI:ctor()
    local ui = y3.UIHelper.getUI("xxx")
    SurviveGameSevenDayUI.super.ctor(self, ui)
    self:_checkShowUI()
    y3.gameApp:registerEvent(y3.EventConst.EVENT_GET_SEVEN_DAY_REWARD_SUCCESS,
        handler(self, self._onEventGetSevenDayRewardSuccess))
    self:updateUI()
end

function SurviveGameSevenDayUI:updateUI()
    local gameCourse = y3.gameApp:getLevel():getLogic("SurviveGameSevenDay")
    local hasReward = gameCourse:checkSignDayHasReward(y3.gameApp:getMyPlayerId())
    self._ui:set_visible(hasReward)
end

function SurviveGameSevenDayUI:_onEventGetSevenDayRewardSuccess(id, playerId)
    if playerId == y3.gameApp:getMyPlayerId() then
        self:updateUI()
    end
end

function SurviveGameSevenDayUI:_checkShowUI()
    local gameCourse = y3.gameApp:getLevel():getLogic("SurviveGameSevenDay")
    local hasReward = gameCourse:checkSignDayHasReward(y3.gameApp:getMyPlayerId())
    self._ui:set_visible(hasReward)
    if hasReward then
        y3.ctimer.wait(3, function(timer, count, local_player)
            y3.SyncMgr:sync(y3.SyncConst.SYNC_GET_SIGNDAY_REWARD, {})
        end)
    end
end

return SurviveGameSevenDayUI
