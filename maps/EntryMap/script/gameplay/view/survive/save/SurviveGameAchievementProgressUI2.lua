local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGameAchievementProgressUI = class("SurviveGameAchievementProgressUI", StaticUIBase)

function SurviveGameAchievementProgressUI:ctor()
    local ui = y3.UIHelper.getUI("fbf743c0-d7fe-49be-a4a2-6464288b94b2")
    SurviveGameAchievementProgressUI.super.ctor(self, ui)
    self._progress_BAR = y3.UIHelper.getUI("5a2ef405-6cda-471f-ae13-4add99bad211")
    self._progress_value_TEXT = y3.UIHelper.getUI("d451b727-9692-4f50-813f-259f8eeb9677")
    self._totalCountText = y3.UIHelper.getUI("1ed61cfc-5b64-4ef1-9d1b-9202abe2d726")
    self._count_by_badge = y3.UIHelper.getUI("4dc06571-119a-4efe-b26c-19edf39ef944")
    self._count_by_badge:set_visible(true)
    self._hoverMap = {}
end

function SurviveGameAchievementProgressUI:updateUI(collects)
    local totalCount = #collects
    local curCount = 0
    local achievemnt = y3.gameApp:getLevel():getLogic("SurviveGameAchievement")
    local CLASS_MAP = {

    }
    for i = 1, #collects do
        local cfg = collects[i]
        local isUnlock = achievemnt:achievementIsUnLock(y3.gameApp:getMyPlayerId(), cfg)
        if isUnlock then
            curCount = curCount + 1
            if not CLASS_MAP[cfg.class] then
                CLASS_MAP[cfg.class] = 1
            else
                CLASS_MAP[cfg.class] = CLASS_MAP[cfg.class] + 1
            end
        end
    end
    local pro = curCount / totalCount * 100
    self._progress_BAR:set_current_progress_bar_value(pro)
    self._progress_value_TEXT:set_text(string.format("%.2f", pro) .. "%")
    self._totalCountText:set_text(curCount .. "/" .. totalCount)
    local childs = self._count_by_badge:get_childs()
    for i = 1, #childs do
        local itemUI = childs[i]
        itemUI:get_child("_count_value_TEXT"):set_text(CLASS_MAP[tostring(i)] or "0")
        if not self._hoverMap[itemUI] then
            itemUI:add_local_event("鼠标-移入", function(local_player)
                y3.Sugar.tipRoot():showUniversalTip({ type = y3.SurviveConst.TIP_TYPE_ACHI_DESC })
            end)
            itemUI:add_local_event("鼠标-移出", function(local_player)
                y3.Sugar.tipRoot():hideUniversalTip()
            end)
        end
    end
end

return SurviveGameAchievementProgressUI
