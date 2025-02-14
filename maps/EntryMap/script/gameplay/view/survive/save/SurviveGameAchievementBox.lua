local UIBase                    = include("gameplay.base.UIBase")
local SurviveGameAchievementBox = class("SurviveGameAchievementBox", UIBase)

function SurviveGameAchievementBox:ctor(parent)
    SurviveGameAchievementBox.super.ctor(self, parent, y3.SurviveConst.PREFAB_MAP["main_achievement_levelbonus"])

    self._reward_icon_IMG = self._ui:get_child("_reward_icon_IMG")
    self._value_TEXT = self._ui:get_child("_value_TEXT")
    self._unlock_TEXT = self._ui:get_child("unlock_TEXT")

    self._ui:add_local_event("鼠标-移入", function()
        y3.Sugar.tipRoot():showUniversalTip({ type = y3.SurviveConst.TIP_TYPE_ACHI_PASS, value = self._cfg.id })
    end)
    self._ui:add_local_event("鼠标-移出", function()
        y3.Sugar.tipRoot():hideUniversalTip()
    end)
end

function SurviveGameAchievementBox:updateUI(cfg)
    self._cfg = cfg
    local achievemnt = y3.gameApp:getLevel():getLogic("SurviveGameAchievement")
    local isUnLock = achievemnt:achievementIsUnLock(y3.gameApp:getMyPlayerId(), cfg)
    self._value_TEXT:set_text(cfg.value)
    self._unlock_TEXT:set_visible(isUnLock)
    local images = string.split(cfg.image, "|")
    assert(images, "")
    self._reward_icon_IMG:set_image(isUnLock and tonumber(images[1]) or tonumber(images[2]))
end

return SurviveGameAchievementBox
