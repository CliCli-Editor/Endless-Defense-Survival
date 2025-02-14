local UIBase                     = include("gameplay.base.UIBase")
local SurviveGameAchievementCard = class("SurviveGameAchievementCard", UIBase)

function SurviveGameAchievementCard:ctor(parent, root)
    self._root = root
    SurviveGameAchievementCard.super.ctor(self, parent, y3.SurviveConst.PREFAB_MAP["achievement_levelrecord"])
    self._sel = self._ui:get_child("sel")
    self._avatar_IMG = self._ui:get_child("avatar._avatar_IMG")
    self._level_name_TEXT = self._ui:get_child("avatar._level_name_TEXT")
    self._starList = self._ui:get_child("starlist")

    self._avatar_IMG:add_local_event("左键-点击", function()
        if self._index then
            self._root:onSelectAchievement(self._index)
        end
    end)
end

function SurviveGameAchievementCard:getFilter()
    return self._cfg.filter
end

function SurviveGameAchievementCard:updateUI(cfg, index)
    self._index = index
    self._cfg = cfg
    local achievemnt = y3.gameApp:getLevel():getLogic("SurviveGameAchievement")
    local starNum = achievemnt:getAchievementConditionValue(y3.gameApp:getMyPlayerId(), cfg.id, 1)
    self._level_name_TEXT:set_text(cfg.name)
    local stars = self._starList:get_childs()
    for i, starUI in ipairs(stars) do
        local star = starUI:get_child("star")
        star:set_visible(i <= starNum)
    end
end

function SurviveGameAchievementCard:updateCardSelect(index)
    self._sel:set_visible(index == self._index)
end

return SurviveGameAchievementCard
