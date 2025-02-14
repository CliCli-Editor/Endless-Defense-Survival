local UserDataHelper = include "gameplay.level.logic.helper.UserDataHelper"
local SurviveGameUniversalTip = class("SurviveGameUniversalTip")

function SurviveGameUniversalTip:ctor(ui, root)
    self._ui = ui
    self._ui:set_anchor(0, 0)
    self._root = root
    self._titleText = y3.UIHelper.getUI("7185efad-0335-4f70-b7eb-42949ea8a09d")
    self._descText = y3.UIHelper.getUI("0413f077-8dfc-414b-b5df-81b250f4fe50")
end

function SurviveGameUniversalTip:show(data)
    -- y3.UIActionMgr:playFadeAction(self._ui)
    self._ui:set_visible(true)
    self._data = data
    if data.type then
        if data.type == y3.SurviveConst.DROP_TYPE_SAVE_ITEM then
            self:_showSaveItemTip()
        elseif data.type == y3.SurviveConst.DROP_TYPE_TREASURE then
            self:_showTreasureTip()
        elseif data.type == y3.SurviveConst.TIP_TYPE_ACHI_DESC then
            self:_showAchievementDescTip()
        elseif data.type == y3.SurviveConst.TIP_TYPE_ACHI_PASS then
            self:_showAchievementDailyTip()
        elseif data.type == y3.SurviveConst.DROP_TYPE_WEANPON_EXP then
            self:_showWeanponExpTip()
        end
    else
        if data.title ~= "" then
            self._titleText:set_visible(true)
            self._titleText:set_text(data.title)
        else
            self._titleText:set_visible(false)
        end
        self._descText:set_text(data.desc)
    end
    self._hide = false
    local xOffset, yOffset = y3.UIHelper.limitTipOffset(y3.gameApp:getMyPlayerId(), self._ui)
    self._ui:set_follow_mouse(true, xOffset, yOffset)

    y3.ctimer.wait_frame(3, function(timer, count, local_player)
        if self._hide then
            return
        end
        local xOffset, yOffset = y3.UIHelper.limitTipOffset(y3.gameApp:getMyPlayerId(), self._ui)
        self._ui:set_follow_mouse(true, xOffset, yOffset)
    end)
end

function SurviveGameUniversalTip:_showSaveItemTip()
    local cfg = include("gameplay.config.save_item").get(self._data.value)
    if cfg then
        self._titleText:set_visible(true)
        self._titleText:set_text(cfg.item_name)
        self._descText:set_text(cfg.item_desc)
    end
end

function SurviveGameUniversalTip:_showTreasureTip()
    local cfg = include("gameplay.config.treasure").get(self._data.value)
    if cfg then
        local desc = UserDataHelper.getTreasureDesc(cfg.id)
        local treasureLogic = y3.gameApp:getLevel():getLogic("SurviveGameTreasure")
        local isUnLock = treasureLogic:treasureIsUnlock(y3.gameApp:getMyPlayerId(), cfg.id)
        local color = y3.ColorConst.QUALITY_COLOR_MAP[cfg.quality] or y3.ColorConst.QUALITY_COLOR_MAP[1]
        local lockStr = isUnLock and "#" .. y3.ColorConst.TIPS_COLOR_MAP["lvse"] .. "（Active）" or
            "#" .. y3.ColorConst.TIPS_COLOR_MAP["hongse"] .. "（Inactive）"
        self._titleText:set_visible(true)
        self._titleText:set_text("#" .. color .. cfg.name .. lockStr)
        self._descText:set_text(desc)
    end
end

function SurviveGameUniversalTip:_showAchievementDescTip()
    local title, desc = y3.userDataHelper.getAchievementBigDesc(y3.gameApp:getMyPlayerId())
    self._titleText:set_visible(true)
    self._titleText:set_text(title)
    self._descText:set_text(desc)
end

function SurviveGameUniversalTip:_showAchievementDailyTip()
    local cfg = include("gameplay.config.collect").get(self._data.value)
    local title, desc = y3.userDataHelper.getAchievementPassDesc(y3.gameApp:getMyPlayerId(), cfg)
    self._titleText:set_visible(true)
    self._titleText:set_text(title)
    self._descText:set_text(desc)
end

function SurviveGameUniversalTip:_showWeanponExpTip()
    local cfg = include("gameplay.config.config_skillData").get(tostring(self._data.value))
    if cfg then
        self._titleText:set_visible(true)
        self._titleText:set_text(GameAPI.get_text_config('#956522893#lua'))
        local desc = UserDataHelper.getMyPlayerWeaponExpTip()
        self._descText:set_text(desc)
    end
end

function SurviveGameUniversalTip:hide()
    self._hide = true
    self._ui:set_follow_mouse(false)
    self._ui:set_visible(false)
end

return SurviveGameUniversalTip
