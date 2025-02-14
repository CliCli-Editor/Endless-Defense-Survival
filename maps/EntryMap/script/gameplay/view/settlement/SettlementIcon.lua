local UserDataHelper = include "gameplay.level.logic.helper.UserDataHelper"
local UIBase = include("gameplay.base.UIBase")
local SettlementIcon = class("SettlementIcon", UIBase)

function SettlementIcon:ctor(parent)
    SettlementIcon.super.ctor(self, parent, y3.SurviveConst.PREFAB_MAP["endgame_levelreward"])
    self._icon_IMG = self._ui:get_child("_icon_IMG")
    self._count_TEXT = self._ui:get_child("_count_TEXT")
    self._label = self._ui:get_child("label")
    self._labelBg = self._ui:get_child("label.bg")

    self._ui:add_local_event("鼠标-移入", function()
        y3.Sugar.tipRoot():showUniversalTip(self._data)
    end)
    self._ui:add_local_event("鼠标-移出", function()
        y3.Sugar.tipRoot():hideUniversalTip()
    end)
end

function SettlementIcon:updateUI(data)
    local type = data.type
    self._data = data

    if self._data.tag then
        self._label:set_visible(true)
        self._labelBg:set_image(y3.SurviveConst.REWARD_TAG_NAME[self._data.tag] or y3.SurviveConst.REWARD_TAG_NAME[1])
    else
        self._label:set_visible(false)
    end
    if type == y3.SurviveConst.DROP_TYPE_SAVE_ITEM then
        self:_update_save_item()
    elseif type == y3.SurviveConst.DROP_TYPE_TREASURE then
        self:_update_treasure()
    elseif type == y3.SurviveConst.DROP_TYPE_WEANPON_EXP then
        self:_update_weanpond_exp()
    end
end

function SettlementIcon:_update_save_item()
    local cfg = include("gameplay.config.save_item").get(self._data.value)
    assert(cfg, "save item config not found by id=" .. self._data.value)
    self._title = cfg.item_name
    self._desc = cfg.item_desc
    if tonumber(cfg.item_icon) then
        self._icon_IMG:set_image(tonumber(cfg.item_icon))
    end
    if self._data.size > 0 then
        self._count_TEXT:set_text(self._data.size)
    else
        self._count_TEXT:set_text("")
    end
end

function SettlementIcon:_update_treasure()
    local cfg = include("gameplay.config.treasure").get(self._data.value)
    assert(cfg, "save item config not found by id=" .. self._data.value)
    local treasureLogic = y3.gameApp:getLevel():getLogic("SurviveGameTreasure")
    local isUnLock = treasureLogic:treasureIsUnlock(y3.gameApp:getMyPlayerId(), cfg.id)
    local lockStr = isUnLock and "#" .. y3.ColorConst.TIPS_COLOR_MAP["lvse"] .. "（Active）" or
        "#" .. y3.ColorConst.TIPS_COLOR_MAP["hongse"] .. "（Inactive）"
    local color = y3.ColorConst.QUALITY_COLOR_MAP[cfg.quality] or y3.ColorConst.QUALITY_COLOR_MAP[1]
    self._title = "#" .. color .. cfg.name .. lockStr
    self._desc = UserDataHelper.getTreasureDesc(self._data.value) --cfg.unlock_desc
    print("宝物")
    print(cfg.icon)
    self._icon_IMG:set_image(tonumber(cfg.icon))
    if self._data.size > 0 then
        self._count_TEXT:set_text(self._data.size)
    else
        self._count_TEXT:set_text("")
    end
end

function SettlementIcon:_update_weanpond_exp()
    self._icon_IMG:set_image(134243572)
    if self._data.size > 0 then
        self._count_TEXT:set_text(self._data.size)
    else
        self._count_TEXT:set_text("")
    end
end

return SettlementIcon
