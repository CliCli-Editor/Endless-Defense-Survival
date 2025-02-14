local StaticUIBase = include("gameplay.base.StaticUIBase")
local AFKModeReceiveUI = class("AFKModeReceiveUI", StaticUIBase)

function AFKModeReceiveUI:ctor()
    local ui = y3.UIHelper.getUI("129f0d48-1eef-4dd1-8434-cd6b9b271d14")
    AFKModeReceiveUI.super.ctor(self, ui)
    self._reward_GRID = y3.UIHelper.getUI("7956cf80-9a83-436c-b00c-c0f13d85ab94")
    self._next_afk_reward_receive_txt = y3.UIHelper.getUI("0187e8bc-d838-46fa-a823-b3efec516522")
    self._title_TEXT_1 = y3.UIHelper.getUI("38fdb175-c9a6-4553-9ec9-2a3bc097096c")
    self._title_TEXT_1:set_text(y3.Lang.get("lang_afk_info_desc"))

    local curStageId = y3.userData:getCurStageId()
    local cfg = include("gameplay.config.stage_config").get(curStageId)
    assert(cfg, "stage config not found")
    self:setVisible(cfg.stage_type == y3.SurviveConst.STAGE_MODE_AFK)
    if cfg.stage_type == y3.SurviveConst.STAGE_MODE_AFK then
        y3.ctimer.loop(0.5, handler(self, self._refreshRewardTimeUI))
        self:_refreshRewardTimeUI()
        self._rewardCards = {}
        y3.gameApp:registerEvent(y3.EventConst.EVENT_RECEIVE_AFK_REWARD, handler(self, self._onEventAfkReward))
    end
end

function AFKModeReceiveUI:_refreshRewardTimeUI()
    local taskSystem = y3.gameApp:getLevel():getLogic("SurviveGameTaskSyetem")
    local nextTime = taskSystem:getAfkTaskRewardTime(y3.gameApp:getMyPlayerId())
    self._next_afk_reward_receive_txt:set_text(y3.Lang.get("lang_afk_reward_text", { time = math.ceil(nextTime) }))
end

function AFKModeReceiveUI:_hideAllCards()
    for i = 1, #self._rewardCards do
        self._rewardCards[i]:setVisible(false)
    end
end

function AFKModeReceiveUI:_updateUI()
    local taskSystem = y3.gameApp:getLevel():getLogic("SurviveGameTaskSyetem")
    local afkRewards = taskSystem:getAfkRewards(y3.gameApp:getMyPlayerId())
    for i = 1, #afkRewards do
        local card = self._rewardCards[i]
        if not card then
            card = include("gameplay.view.survive.main.afk.AFKRewardCell").new(self._reward_GRID)
            self._rewardCards[i] = card
        end
        card:setVisible(true)
        card:updateUI(afkRewards[i])
    end
end

function AFKModeReceiveUI:_onEventAfkReward()
    log.info("AFKModeReceiveUI:_onEventAfkReward")
    self:_updateUI()
end

return AFKModeReceiveUI
