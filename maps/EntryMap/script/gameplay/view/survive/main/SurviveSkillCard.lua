local SurviveHelper = require "gameplay.level.logic.helper.SurviveHelper"
local GlobalConfigHelper = include "gameplay.level.logic.helper.GlobalConfigHelper"
local SurviveSkillCard = class("SurviveSkillCard")
local UIHelper = include("gameplay.utils.UIHelper")

local CLASS_GRAY_ICON = 134243636
local CLASS_GRAY_ICON2 = 134233100

local CLASS_ICON2 = {
    [1] = 134222388,
    [2] = 134262601,
    [3] = 134281918,
    [4] = 134257324,
    [5] = 134220489,
}
local CLASS_ICON = {
    [1] = 134251733,
    [2] = 134242812,
    [3] = 134251715,
    [4] = 134249593,
    [5] = 134280697,
}

local ABILITY_TYPE_MAP = {
    [1] = 134253467,
    [2] = 134223091,
    [3] = 134258375,
    [4] = 134262286,
    [5] = 134263340,
    [6] = 134253350,
}

function SurviveSkillCard:ctor(ui, index)
    self._ui = ui
    if index <= 4 then
        self._bg = self._ui:get_child("bg")
        self._class_ICON = self._ui:get_child("main.avatar._frame_IMG")
        self._skill_ICON = self._ui:get_child("main.avatar._weapon_ICON")
        self._frame_IMG = self._ui:get_child("main.avatar._frame_IMG")
        self._type_ICON = self._ui:get_child("main.avatar._type_ICON")
        self._name_TEXT = self._ui:get_child("main.title._name_TEXT")
        self._res = self._ui:get_child("main.res")
        self._res_ICON = self._ui:get_child("main.res._res_ICON")
        self._res_TEXT = self._ui:get_child("main.res._res_gold_TEXT")
        self._dmg_type_ICON = self._ui:get_child("main.info.attack.icon")
        self._dmg_value_TEXT = self._ui:get_child("main.info.attack._value_TEXT")
        self._dmg_range_ICON = self._ui:get_child("main.info.attack_range.icon")
        self._dmg_range_TEXT = self._ui:get_child("main.info.attack_range._value_TEXT")
        self._label_value1 = self._ui:get_child("main.title.label.1")
        self._label_value2 = self._ui:get_child("main.title.label.2")
        self._label_value_bg1 = self._ui:get_child("main.title.label.1.bg")
        self._label_value_bg2 = self._ui:get_child("main.title.label.2.bg")
        self._label_value_TEXT1 = self._ui:get_child("main.title.label.1._label_value_TEXT")
        self._label_value_TEXT2 = self._ui:get_child("main.title.label.2._label_value_TEXT")
        self._sell = self._ui:get_child("sel")
        self._sold = self._ui:get_child("sold")
        self._label = self._ui:get_child("main.title.label")
    else
        self._bg = self._ui:get_child("bg")
        self._class_ICON = self._ui:get_child("main.avatar._frame_IMG")
        self._skill_ICON = self._ui:get_child("main.avatar.mask._item_ICON")
        self._frame_IMG = self._ui:get_child("main.avatar.bg")
        self._type_ICON = self._ui:get_child("main.avatar.type._type_ICON")
        self._name_TEXT = self._ui:get_child("main.title._name_TEXT")
        self._res = self._ui:get_child("main.res")
        self._res_ICON = self._ui:get_child("main.res._res_ICON")
        self._res_TEXT = self._ui:get_child("main.res._res_gold_TEXT")

        self._label_value1 = self._ui:get_child("main.label.1")
        self._label_value2 = self._ui:get_child("main.label.2")
        self._label_value_bg1 = self._ui:get_child("main.label.1.bg")
        self._label_value_bg2 = self._ui:get_child("main.label.2.bg")
        self._label_value_TEXT1 = self._ui:get_child("main.label.1._label_value_TEXT")
        self._label_value_TEXT2 = self._ui:get_child("main.label.2._label_value_TEXT")
        self._sell = self._ui:get_child("sel")
        self._sold = self._ui:get_child("sold")
        self._label = self._ui:get_child("main.label")
    end


    self._sold:set_visible(true)
    self._bg:add_local_event("鼠标-移入", function(local_player)
        self._sell:set_visible(true)
        if self._data then
            if self._index >= 5 then
                y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SKIL_TOTAL_HIGHLIGHT, y3.gameApp:getMyPlayerId(),
                    self._data.cfg.skill_icon_highlight)
            end
            y3.gameApp:getLevel():getView("SurviveGameTip"):showSkillTip(self._data)
        end
    end)
    self._bg:add_local_event("鼠标-移出", function(local_player)
        self._sell:set_visible(false)
        y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SKIL_TOTAL_HIDE_HIGHLIGHT, y3.gameApp:getMyPlayerId())
        y3.gameApp:getLevel():getView("SurviveGameTip"):hideSkillTip()
    end)
end

function SurviveSkillCard:updateUI(data, gold, index)
    self._data = data
    local cfg = self._data.cfg
    self._index = index
    self._skill_ICON:set_image(tonumber(cfg.icon))
    local iconMap = GlobalConfigHelper.getSkillTopIconMap()
    self._type_ICON:set_image(iconMap[cfg.type] or iconMap[1]) --y3.SurviveConst.SKILLTYPE_ICON[cfg.type] or y3.SurviveConst.SKILLTYPE_ICON[1])
    self._name_TEXT:set_text(cfg.name)
    self._name_TEXT:set_text_color_hex(y3.ColorConst.QUALITY_COLOR_MAP[cfg.class + 1], 255)
    local allPrice = data.price * data.mult
    if gold >= allPrice then
        self._res_TEXT:set_text_color_hex("ffffff", 255)
    else
        self._res_TEXT:set_text_color_hex("d0513c", 255)
    end
    self._res_TEXT:set_text(math.floor(allPrice) .. "")

    if data.state == 0 then
        if index <= 4 then
            self._class_ICON:set_image(CLASS_ICON2[cfg.class] or CLASS_ICON2[1])
        else
            self._class_ICON:set_image(CLASS_ICON[cfg.class] or CLASS_ICON[1])
        end
        self._sold:set_visible(false)
        self._res:set_visible(true)
    else
        if index <= 4 then
            self._class_ICON:set_image(CLASS_GRAY_ICON2)
        else
            self._class_ICON:set_image(CLASS_GRAY_ICON)
        end
        self._sold:set_visible(true)
        self._res:set_visible(false)
    end
    if index <= 4 then
        if cfg.dmg > 0 then
            self._dmg_type_ICON:set_visible(true)
            self._dmg_value_TEXT:set_text(SurviveHelper.getSkillDmgStr(y3.gameApp:getMyPlayerId(), cfg, cfg.type))
        else
            self._dmg_type_ICON:set_visible(false)
            self._dmg_value_TEXT:set_text("")
        end
        if cfg.range > 0 then
            self._dmg_range_ICON:set_visible(true)
            local rangeMap = GlobalConfigHelper.getSkillRangeMap()
            local range = math.floor(cfg.range)
            self._dmg_range_TEXT:set_text(rangeMap[range] or cfg.range)
        else
            self._dmg_range_ICON:set_visible(false)
            self._dmg_range_TEXT:set_text("")
        end
    end

    if cfg.ability_type ~= "" then
        local types = string.split(cfg.ability_type, "|")
        assert(types, "")
        for i = 1, 2 do
            if types[i] then
                local params = string.split(types[i], "#")
                assert(params, "")
                self["_label_value_bg" .. i]:set_image(ABILITY_TYPE_MAP[tonumber(params[1])])
                if params[2] == "冰" then
                    self["_label_value_TEXT" .. i]:set_text_color_hex("38c4fe", 255)
                elseif params[2] == "火" then
                    self["_label_value_TEXT" .. i]:set_text_color_hex("f04646", 255)
                elseif params[2] == "毒" then
                    self["_label_value_TEXT" .. i]:set_text_color_hex("48e668", 255)
                else
                    self["_label_value_TEXT" .. i]:set_text_color_hex("ffffff", 255)
                end
                self["_label_value_TEXT" .. i]:set_text(params[2] or "未知")
                self["_label_value" .. i]:set_visible(true)
            else
                self["_label_value" .. i]:set_visible(false)
            end
        end
    else
        self._label_value1:set_visible(false)
        self._label_value2:set_visible(false)
    end
end

function SurviveSkillCard:setVisible(visible)
    self._ui:set_visible(visible)
end

function SurviveSkillCard:getPos()
    return self._ui:get_absolute_x(), self._ui:get_absolute_y()
end

function SurviveSkillCard:playAnim()
    local scaleTo = include("gameplay.utils.uiAction.ScaleTo").new(self._ui, { x = 1, y = 0.4 }, { x = 1, y = 1 }, 0.4)
    scaleTo:runAction(2)
end

return SurviveSkillCard
