local SettlementUI = include("gameplay.view.settlement.SettlementUI")
local SettlementUIWin = class("SettlementUIWin", SettlementUI)

function SettlementUIWin:ctor()
    local ui = y3.UIHelper.getUI("f47dc064-8b20-40b8-af68-e92cd111d568")
    SettlementUIWin.super.ctor(self, ui)
    local stageId = y3.userData:getCurStageId()
    local stageCfg = include("gameplay.config.stage_config").get(stageId)
    assert(stageCfg, "stageCfg is nil")
    self._stageCfg = stageCfg
    self._stage_live_txt = y3.UIHelper.getUI("5c355025-92b1-41d6-a5b1-c6d81dcec6fe")
    self._stage_highest_live_txt = y3.UIHelper.getUI("af779723-a645-4fda-b3e2-0b2b07d02952")
    self._stage_new_highest_live_img = y3.UIHelper.getUI("6eb7d9af-dcf3-4b3e-bced-49faa7343bf1")
    self._stage_live_txt:set_visible(stageCfg.stage_type == y3.SurviveConst.STAGE_MODE_SURVIVE)
    self._stage_highest_live_txt:set_visible(stageCfg.stage_type == y3.SurviveConst.STAGE_MODE_SURVIVE)

    y3.gameApp:registerEvent(y3.EventConst.EVENT_SURVEVE_RESULT_WIN, handler(self, self.onSurviveResultWin))
end

function SettlementUIWin:onSurviveResultWin(id, playerId)
    print("onSurviveResultWin", id, playerId)
    if playerId == y3.gameApp:getMyPlayerId() then
        if self._stageCfg.stage_type == y3.SurviveConst.STAGE_MODE_SURVIVE then
            local achievement = y3.gameApp:getLevel():getLogic("SurviveGameAchievement")
            local readyEndTotalTime = math.floor(achievement:getPlayedEndTime())
            self._stage_live_txt:set_text(y3.Lang.get("lang_survive_time_text", { time = readyEndTotalTime }))
            local lastMaxTime = achievement:getOldMaxLiveTime()
            self._stage_highest_live_txt:set_visible(lastMaxTime > 0)
            self._stage_highest_live_txt:set_text(y3.Lang.get("lang_survive_highest_time_text", { time = lastMaxTime }))
            if lastMaxTime < readyEndTotalTime then
                self._stage_new_highest_live_img:set_visible(true)
            else
                self._stage_new_highest_live_img:set_visible(false)
            end
        end
        self:updatePlayer()
        self:updateReward()
    end
end

return SettlementUIWin
