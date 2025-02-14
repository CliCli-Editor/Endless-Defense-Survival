local StaticUIBase           = include("gameplay.base.StaticUIBase")
local SurviveMenuLoadingView = class("SurviveMenuLoadingView", StaticUIBase)

function SurviveMenuLoadingView:ctor()
    local ui = y3.UIHelper.getUI("1e60a01d-1355-4c3b-86b0-d72b68d65a56")
    SurviveMenuLoadingView.super.ctor(self, ui)
    self._loadingTips = y3.UIHelper.getUI("0df22d1a-a8a2-4cb4-a7bc-33231b1663d5")
    y3.gameApp:registerEvent(y3.EventConst.EVENT_RANDOM_LOAD_TIPS_TEXT, handler(self, self._onRandomLoadTipsText))
    self:onInit()
end

function SurviveMenuLoadingView:onInit()
    y3.SyncMgr:sync(y3.SyncConst.SYNC_RANDOM_LOAD_TIPS_TEXT, {})
end

function SurviveMenuLoadingView:_initUI()
end

function SurviveMenuLoadingView:_onRandomLoadTipsText(trg, playerId, cfgId)
    if playerId == y3.gameApp:getMyPlayerId() then
        local cfg = include("gameplay.config.game_loading_tips").get(cfgId)
        if cfg then
            self._loadingTips:set_text(y3.Lang.getLang(y3.langCfg.get(66).str_content,
                { tip_tips = cfg.game_tips_type, tips_content = cfg.game_tips_content }))
        end
    end
end

return SurviveMenuLoadingView
