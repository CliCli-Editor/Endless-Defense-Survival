local GameUtils               = require "gameplay.utils.GameUtils"
local UserDataHelper          = include "gameplay.level.logic.helper.UserDataHelper"
local UIBase                  = include("gameplay.base.UIBase")
local SurviveGameTreasureCard = class("SurviveGameTreasureCard", UIBase)

local CLASS_MAP               = {
    [2] = 134254956,
    [3] = 134238523,
    [4] = 134228669,
    [5] = 134221522,
    [6] = 134278758
}

function SurviveGameTreasureCard:ctor(parent)
    SurviveGameTreasureCard.super.ctor(self, parent, y3.SurviveConst.PREFAB_MAP["slot_gamesave_treasure"])
    self._avatarBg                 = self._ui:get_child("avatar.bg")
    self._avatarIcon               = self._ui:get_child("avatar._icon_IMG")
    self._infoTitleText            = self._ui:get_child("info._title_TEXT")
    self._infoAttrList             = self._ui:get_child("info.attr_LIST")
    self._current_level_title_TEXT = self._ui:get_child("upgrade.title.current_level_title_TEXT")
    self._next_level_title_TEXT    = self._ui:get_child("upgrade.title.next_level_title_TEXT")
    self._upgradeValueList         = self._ui:get_child("upgrade.value_LIST")
    self._levelText                = self._ui:get_child("level._level_TEXT")
    self._levelFlag                = self._ui:get_child("level")
    self._unlockTitleText          = self._ui:get_child("control.unlock.title_TEXT")
    self._unLockCondition          = self._ui:get_child("control.unlock.condition")
    self._condition_TEXT           = self._ui:get_child("control.unlock.condition._condition_TEXT")
    self._upgrade                  = self._ui:get_child("control.upgrade")
    self._unLock                   = self._ui:get_child("control.unlock")

    self._mask                     = self._ui:get_child("mask")
    self._upgrade_BTN              = self._ui:get_child("control.upgrade.upgrade_BTN")
    self._max_levelFlag            = self._ui:get_child("control.upgrade.max_level")
    self._gamesave_res_icon_IMG    = self._ui:get_child("control.upgrade.upgrade_BTN.res._gamesave_res_icon_IMG")
    self._gamesave_res_gold_TEXT   = self._ui:get_child("control.upgrade.upgrade_BTN.res._gamesave_res_gold_TEXT")

    self._upgrade_BTN:add_local_event("左键-按下", handler(self, self._onUpgradeBtnClick))
    self._avatarBg:add_local_event("鼠标-移入", function()
        local cfg = self._cfg
        if cfg then
            y3.Sugar.tipRoot():showUniversalTip({ type = y3.SurviveConst.DROP_TYPE_TREASURE, value = cfg.id })
            -- local desc = UserDataHelper.getTreasureDesc(cfg.id)
            -- local color = y3.ColorConst.QUALITY_COLOR_MAP[cfg.quality] or y3.ColorConst.QUALITY_COLOR_MAP[1]
            -- local lockStr = self._isUnlock and "#" .. y3.ColorConst.TIPS_COLOR_MAP["lvse"] .. "（Active）" or
            --     "#" .. y3.ColorConst.TIPS_COLOR_MAP["hongse"] .. "（Inactive）"
            -- y3.Sugar.tipRoot():showUniversalTip({ title = "#" .. color .. cfg.name .. lockStr, desc = desc })
        end
    end)
    self._avatarBg:add_local_event("鼠标-移出", function()
        y3.Sugar.tipRoot():hideUniversalTip({})
    end)
end

function SurviveGameTreasureCard:updateUI(cfg, treasureLogic)
    self._cfg = cfg
    self._avatarIcon:set_image(tonumber(cfg.icon))
    self._avatarBg:set_image(y3.SurviveConst.ITEM_CLASS_MAP[cfg.quality] or y3.SurviveConst.ITEM_CLASS_MAP[2])
    self._infoTitleText:set_text(cfg.name)
    self._infoTitleText:set_text_color_hex(y3.ColorConst.QUALITY_COLOR_MAP[cfg.quality] or
        y3.ColorConst.QUALITY_COLOR_MAP[1], 255)

    local isUnLock = treasureLogic:treasureIsUnlock(y3.gameApp:getMyPlayerId(), cfg.id)
    self._isUnlock = isUnLock
    local level = treasureLogic:getTreasureLevel(y3.gameApp:getMyPlayerId(), cfg.id)
    local maxLevel = cfg.max_level
    local nextLevel = math.min(maxLevel, level + 1)
    self._current_level_title_TEXT:set_text("Lv." .. level)
    self._next_level_title_TEXT:set_text("Lv." .. nextLevel)
    self:_updateAttr(level, nextLevel)
    self._mask:set_visible(not isUnLock)
    self._unLock:set_visible(not isUnLock)
    self._upgrade:set_visible(isUnLock)
    self._upgrade_BTN:set_visible(level < maxLevel)
    self._max_levelFlag:set_visible(level >= maxLevel)

    self._condition_TEXT:set_text(cfg.unlock_desc)
    self._levelText:set_text(cfg.desc)
    self._levelFlag:set_visible(isUnLock)
    local costCfg = include("gameplay.config.save_item").get(tonumber(cfg.cost_up_item))
    self._gamesave_res_icon_IMG:set_image(tonumber(costCfg.item_icon))
    local cost_up_num = string.split(cfg.cost_up_num, "|")
    self._gamesave_res_gold_TEXT:set_text(cost_up_num[nextLevel] .. GameAPI.get_text_config('#30000001#lua01'))
    return isUnLock
end

function SurviveGameTreasureCard:_updateAttr(level, nextLevel)
    local attrPack = self._cfg.attr_pack
    local attrList = self._infoAttrList:get_childs()
    local baseAttrs = UserDataHelper.getAttrListByPack(attrPack)
    assert(baseAttrs)
    for attrIndex, attrUI in ipairs(attrList) do
        if baseAttrs[attrIndex] then
            if baseAttrs[attrIndex].showType == 1 then
                attrUI:set_text(baseAttrs[attrIndex].name .. "+" .. baseAttrs[attrIndex].value)
            else
                attrUI:set_text(baseAttrs[attrIndex].name .. "+" .. baseAttrs[attrIndex].value .. "%")
            end
            attrUI:set_visible(true)
        else
            attrUI:set_visible(false)
        end
    end
    local curAttrMap = {}
    for lv = 1, level do
        local lvAttrs = UserDataHelper.getAttrListByPack(self._cfg.attr_pack_up)
        assert(lvAttrs)
        for slotIndex, slotAttr in ipairs(lvAttrs) do
            curAttrMap[slotAttr.name] = (curAttrMap[slotAttr.name] or 0) + slotAttr.value
        end
    end
    local nextAttrMap = {}
    for lv = 1, nextLevel do
        local lvAttrs = UserDataHelper.getAttrListByPack(self._cfg.attr_pack_up)
        assert(lvAttrs)
        for slotIndex, slotAttr in ipairs(lvAttrs) do
            nextAttrMap[slotAttr.name] = (nextAttrMap[slotAttr.name] or 0) + slotAttr.value
        end
    end
    local valueAttrList = self._upgradeValueList:get_childs()
    for index, valueAttrUI in ipairs(valueAttrList) do
        if baseAttrs[index] then
            valueAttrUI:set_visible(true)
            local attrName = baseAttrs[index].name
            local curValuete = curAttrMap[attrName] or 0
            local nextValuete = nextAttrMap[attrName] or 0

            local curValue = GameUtils.isInteger(curValuete) and curValuete or
                string.format("%.2f", curValuete)
            local nextValue = GameUtils.isInteger(nextValuete) and nextValuete or
                string.format("%.2f", nextValuete)

            local current_level_value_TEXT = valueAttrUI:get_child("_current_level_value_TEXT")
            local next_level_value_TEXT = valueAttrUI:get_child("_next_level_value_TEXT")
            if baseAttrs[index].showType == 1 then
                current_level_value_TEXT:set_text("+" .. curValue)
                next_level_value_TEXT:set_text("+" .. nextValue)
            else
                current_level_value_TEXT:set_text("+" .. curValue .. "%")
                next_level_value_TEXT:set_text("+" .. nextValue .. "%")
            end
        else
            valueAttrUI:set_visible(false)
        end
    end
end

function SurviveGameTreasureCard:_onUpgradeBtnClick()
    if self._cfg then
        y3.SyncMgr:sync(y3.SyncConst.SYNC_TREASURE_UPGRADE, { treasureId = self._cfg.id })
    end
end

return SurviveGameTreasureCard
