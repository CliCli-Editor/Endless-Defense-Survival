local UIBase                      = include("gameplay.base.UIBase")
local SurviveGameAchievementCard2 = class("SurviveGameAchievementCard2", UIBase)

local UNLOCK_IMG                  = 134253879
local LOCK_IMG                    = 134281483


function SurviveGameAchievementCard2:ctor(parent, root)
    self._root = root
    SurviveGameAchievementCard2.super.ctor(self, parent, y3.SurviveConst.PREFAB_MAP["main_achievement_trophy"])
    self._sel = self._ui:get_child("sel")
    self._avatar_IMG = self._ui:get_child("avatar._avatar_IMG")
    self._level_name_TEXT = self._ui:get_child("avatar._level_name_TEXT")

    self._avatar_IMG:add_local_event("左键-点击", function()
        if self._index then
            self._root:onSelectAchievementCom(self._index)
        end
    end)
end

function SurviveGameAchievementCard2:getFilter()
    return self._cfg.filter
end

function SurviveGameAchievementCard2:updateUI(cfg, index)
    self._index = index
    self._cfg = cfg
    local achievemnt = y3.gameApp:getLevel():getLogic("SurviveGameAchievement")
    local isUnLock = achievemnt:achievementIsUnLock(y3.gameApp:getMyPlayerId(), cfg)
    self._level_name_TEXT:set_text(cfg.name)
    self._avatar_IMG:set_image(isUnLock and
        (y3.SurviveConst.ACHI_UNLOCK_MAP[cfg.class] or y3.SurviveConst.ACHI_UNLOCK_MAP["1"]) or
        (y3.SurviveConst.ACHI_LOCK_MAP[cfg.class] or y3.SurviveConst.ACHI_LOCK_MAP["1"]))
end

function SurviveGameAchievementCard2:updateCardSelect(index)
    self._sel:set_visible(index == self._index)
end

return SurviveGameAchievementCard2
