local StaticUIBase                   = include("gameplay.base.StaticUIBase")
local SurviveGameAchievementRightUI2 = class("SurviveGameAchievementRightUI2", StaticUIBase)

local UNLOCK_IMG                     = 134253879
local LOCK_IMG                       = 134281483

local INDEX_NAME                     = {
    [1] = "①",
    [2] = "②",
    [3] = "③",
    [4] = "④",
}

function SurviveGameAchievementRightUI2:ctor()
    local ui = y3.UIHelper.getUI("b397d4c4-67c6-43c8-a312-dcf718768ad9")
    SurviveGameAchievementRightUI2.super.ctor(self, ui)

    self._level_name_TEXT = y3.UIHelper.getUI("6d6c7a92-88b0-4c46-8d3a-423a649eebea")
    self._avatar_IMG = y3.UIHelper.getUI("b2df2cd2-3a04-42fa-88f4-109e1f40b5bc")
    self._condition_TEXT = y3.UIHelper.getUI("418fa795-b873-4cba-a64e-a718acb639db")
    self._progress_TEXT = y3.UIHelper.getUI("ba23c46f-329f-43c0-b484-0fc39f71257c")
    self._bonus_LIST = y3.UIHelper.getUI("1b5d0488-e602-44e3-a430-f36752cc552e")
end

function SurviveGameAchievementRightUI2:updateUI(cfg)
    local achievemnt = y3.gameApp:getLevel():getLogic("SurviveGameAchievement")
    local isUnlock = achievemnt:achievementIsUnLock(y3.gameApp:getMyPlayerId(), cfg)

    self._avatar_IMG:set_image(isUnlock and
        (y3.SurviveConst.ACHI_UNLOCK_MAP[cfg.class] or y3.SurviveConst.ACHI_UNLOCK_MAP["1"]) or
        (y3.SurviveConst.ACHI_LOCK_MAP[cfg.class] or y3.SurviveConst.ACHI_LOCK_MAP["1"]))

    self._level_name_TEXT:set_text(cfg.name)
    if cfg.class == "4" then
        if isUnlock then
            self._condition_TEXT:set_text(cfg.desc)
        else
            self._condition_TEXT:set_text(GameAPI.get_text_config('#-1199829907#lua'))
        end
    else
        self._condition_TEXT:set_text(cfg.desc)
    end
    local maxValue = tonumber(cfg.value) or 0
    local curValue = achievemnt:getAchievementConditionValue(y3.gameApp:getMyPlayerId(), cfg.id, 1)
    if cfg.progress_type == 1 then
        if isUnlock then
            self._progress_TEXT:set_text("1/1")
        else
            self._progress_TEXT:set_text("0/1")
        end
    else
        if isUnlock then
            self._progress_TEXT:set_text(maxValue .. "/" .. maxValue)
        else
            self._progress_TEXT:set_text(curValue .. "/" .. maxValue)
        end
    end


    local attrList = y3.userDataHelper.getAttrListByPack(cfg.reward_attr_pack)
    local childs = self._bonus_LIST:get_childs()
    local endIndex = 1
    for i, child in ipairs(childs) do
        if i <= #attrList then
            local attr = attrList[i]
            if attr.showType == 1 then
                child:set_text(GameAPI.get_text_config('#30000001#lua16') .. INDEX_NAME[i] .. "：" .. attr.name .. " +" .. attr.value)
            else
                child:set_text(GameAPI.get_text_config('#30000001#lua16') .. INDEX_NAME[i] .. "：" .. attr.name .. " +" .. attr.value .. "%")
            end
            endIndex = i + 1
        else
            child:set_text("")
        end
    end
    if cfg.reward_item ~= "" then
        if childs[endIndex] then
            local itemParams = y3.userDataHelper.getCommonItemParam(cfg.reward_item)
            childs[endIndex]:set_text(GameAPI.get_text_config('#30000001#lua16') .. INDEX_NAME[endIndex] .. "：" .. itemParams.name .. " x" .. itemParams.size)
        end
    end
end

return SurviveGameAchievementRightUI2
