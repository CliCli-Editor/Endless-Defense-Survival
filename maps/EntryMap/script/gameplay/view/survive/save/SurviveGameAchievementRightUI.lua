local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGameAchievementRightUI = class("SurviveGameAchievementRightUI", StaticUIBase)

local PRE_MAP = {
    [1] = "①",
    [2] = "②",
    [3] = "③",
    [4] = "④",
    [5] = "⑤",
    [6] = "⑥",
    [7] = "⑦",
    [8] = "⑧",
    [9] = "⑨",
    [10] = "⑩",
}

function SurviveGameAchievementRightUI:ctor()
    local ui = y3.UIHelper.getUI("45f0f8fe-adb1-4a72-a6e3-cc72dc95d86f")
    SurviveGameAchievementRightUI.super.ctor(self, ui)
    self._title_TEXT = y3.UIHelper.getUI("dfa84fa9-0f96-4733-8b1f-c98e6d020ba1")
    self._bottom = y3.UIHelper.getUI("b5f2e618-c84c-4532-9de6-8e4ec996eede")
    self._condition = y3.UIHelper.getUI("4d5529a4-3a07-4b9e-aa35-cc7d5c6ab342")
end

function SurviveGameAchievementRightUI:updateUI(cfg)
    local achievemnt = y3.gameApp:getLevel():getLogic("SurviveGameAchievement")
    local starNum = achievemnt:getAchievementConditionValue(y3.gameApp:getMyPlayerId(), cfg.id, 1)
    self._title_TEXT:set_text(cfg.name)
    local childs = self._bottom:get_childs()
    local packs = string.split(cfg.reward_attr_pack, "|")
    assert(packs, "")
    for i, child in ipairs(childs) do
        local bonusList = child:get_child("bonus.bonus_LIST")
        local bonusTexts = bonusList:get_childs()
        local attrList = y3.userDataHelper.getAttrListByPack(packs[i])
        for j, bonusText in ipairs(bonusTexts) do
            if attrList[j] then
                if attrList[j].showType == 1 then
                    bonusText:set_text(GameAPI.get_text_config('#30000001#lua16') .. PRE_MAP[j] .. "：" .. attrList[j].name .. "+" .. attrList[j].value)
                else
                    bonusText:set_text(GameAPI.get_text_config('#30000001#lua16') .. PRE_MAP[j] .. "：" .. attrList[j].name .. "+" .. attrList[j].value .. "%")
                end
            else
                bonusText:set_text("")
            end
        end
    end
    local descs = string.split(cfg.desc, "|")
    assert(descs, "")
    local condChilds = self._condition:get_childs()
    for i=1,#condChilds do
        if descs[i] then
            condChilds[i]:set_visible(true)
            condChilds[i]:get_child("title_TEXT"):set_text(descs[i])
        else
            condChilds[i]:set_visible(false)
        end
    end
end

return SurviveGameAchievementRightUI
