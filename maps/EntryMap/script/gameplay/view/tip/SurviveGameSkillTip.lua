local GlobalConfigHelper  = require "gameplay.level.logic.helper.GlobalConfigHelper"
local SurviveHelper       = require "gameplay.level.logic.helper.SurviveHelper"
local SurviveGameSkillTip = class("SurviveGameSkillTip")

function SurviveGameSkillTip:ctor(ui, root)
    self._ui = ui
    self._ui:set_anchor(0, 0)
    self._root = root
    self._titleText = y3.UIHelper.getUI("380641bd-ac8c-4bbd-8bd9-11093f9f8e44")  --self._ui:get_child("title.title_TEXT")
    self._icon = y3.UIHelper.getUI("1796f1f1-2c3a-40f2-ac39-a73e8e9bae89")       --self._ui:get_child("title.icon")
    self._countUI = y3.UIHelper.getUI("39bf14f3-174d-4a4d-a195-a9098a40a83f")    --self._ui:get_child("title.count")
    self._countText = y3.UIHelper.getUI("6a6bce30-4f7b-443a-8e18-c14eeb7b5f1b")  --self._ui:get_child("title.count.title_TEXT")
    self._noteText = y3.UIHelper.getUI("0fc40b73-0d25-4c79-bdc2-8db6c6e431a3")
    self._basic = y3.UIHelper.getUI("04b746ee-0400-437a-8354-5047719853ad")      --self._ui:get_child("basic")
    self._descr_TEXT = y3.UIHelper.getUI("0fc40b73-0d25-4c79-bdc2-8db6c6e431a3") --self._ui:get_child("_descr_TEXT")
    self._label_LIST = y3.UIHelper.getUI("cc27a0ac-9f0f-47b9-948f-ac2425587ce6") --self._ui:get_child("label_LIST")
    self._res = y3.UIHelper.getUI("02acfe97-ed36-4f66-97fe-0be0429462f6")
    self._resIcon = y3.UIHelper.getUI("02fce68f-7008-4e6d-bbbd-7f70e55a84e6")
    self._resValueText = y3.UIHelper.getUI("bd695b9b-f300-4bc7-84bb-03f37cf4fb16")
    self._rootLabelList = y3.UIHelper.getUI("c679a554-f10c-4a55-88ae-99f94de5a160")
    self._rootdescr_LIST = y3.UIHelper.getUI("f9b3de34-ea25-407d-9e07-47134e8c332e")
end

function SurviveGameSkillTip:show(data)
    if not data.noAnim then
        y3.UIActionMgr:playFadeAction(self._ui)
    end
    if data.price then
        self._res:set_visible(true)
        self._resValueText:set_text(data.price)
    else
        self._res:set_visible(false)
    end
    local skillCfg = data.cfg
    local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local mainActor = playerData:getMainActor()
    local count = 0
    if mainActor then
        count = mainActor:getSkillNameNum(skillCfg.id)
    end

    local iconMap = GlobalConfigHelper.getSkillTopIconMap()
    self._icon:set_image(iconMap[skillCfg.type] or 0)
    self._titleText:set_text(skillCfg.name)
    self._countText:set_text(count .. "")
    self._countUI:set_visible(count > 0)
    if skillCfg.note ~= "" then
        self._rootdescr_LIST:set_visible(true)
        self._noteText:set_visible(true)
        self._noteText:set_text(skillCfg.note)
    else
        self._rootdescr_LIST:set_visible(false)
        self._noteText:set_visible(false)
    end
    if skillCfg.dmg > 0 then
        self._basic:set_visible(true)
        local basicCells = self._basic:get_childs()
        if skillCfg.cd > 0 then
            basicCells[1]:get_child("_atk_value_TEXT"):set_text(SurviveHelper.getSkillDmgStr(y3.gameApp:getMyPlayerId(),
                skillCfg, skillCfg.type))
            local jiange = y3.Lang.getLang(y3.langCfg.get(20).str_content, { sec = string.format("%.1f", skillCfg.cd) })
            basicCells[2]:get_child("_atk_spd_value_TEXT"):set_text(jiange)
        else
            basicCells[1]:get_child("_atk_value_TEXT"):set_text(SurviveHelper.getSkillDmgStr(y3.gameApp:getMyPlayerId(),
                skillCfg, skillCfg.type))
            basicCells[2]:get_child("_atk_spd_value_TEXT"):set_text(GameAPI.get_text_config('#2131988829#lua'))
        end
        local rangeMap = GlobalConfigHelper.getSkillRangeMap()
        local range = math.floor(skillCfg.range)
        basicCells[3]:get_child("_atk_range_value_TEXT"):set_text(rangeMap[range] or range .. "")
        local targets = string.split(skillCfg.atk_target, "|")
        local targetValues = string.split(skillCfg.atk_target_value, "|")
        local label4 = ""
        for i, target in ipairs(targets) do
            local targetK = tonumber(target)
            local targetValue = tonumber(targetValues[i])
            local targetName = y3.SurviveConst.ATK_TARGET_NAME_MAP[targetK]
            local valueName = y3.SurviveConst.ATK_TARGET_VALUE_MAP[targetK] or ""
            if valueName ~= "" then
                label4 = label4 .. targetName .. "(" .. targetValue .. ")"
            else
                label4 = label4 .. targetName
            end
            if i < #targets then
                label4 = label4 .. "&"
            end
        end
        if label4 ~= "" then
            basicCells[4]:set_visible(true)
            basicCells[4]:get_child("_atk_type_value_TEXT"):set_text(label4)
        else
            basicCells[4]:set_visible(false)
        end
    else
        self._basic:set_visible(false)
    end
    local labelCells = self._label_LIST:get_childs()
    if skillCfg.ability_type_inner ~= "" then
        self._label_LIST:set_visible(true)
        local types = string.split(skillCfg.ability_type_inner, "|")
        local descrs = string.split(skillCfg.descr, "|")
        local values = string.split(skillCfg.value, "|")
        assert(types, "")
        assert(descrs, "")
        assert(values, "")
        local haveLabel = false
        for i = 1, #labelCells do
            local label = labelCells[i]:get_child("label")
            label:set_visible(true)
            local type_TEXT = labelCells[i]:get_child("_descr_TEXT")
            if types[i] then
                haveLabel = true
                labelCells[i]:set_visible(true)
                local params = string.split(types[i], "#")
                assert(params, "")
                label:get_child("bg"):set_image(y3.SurviveConst.ABILITY_TYPE_MAP[tonumber(params[1])])
                label:get_child("_label_TEXT"):set_text(params[2] or "")
                local desc = descrs[i] or ""
                desc = string.gsub(desc, "({%a+[0-9]})", function(s)
                    local lenStr = string.len(s)
                    if string.find(s, "pvalue") then
                        local e = self:getValue(values[tonumber(string.sub(s, 8, 8))])
                        return string.format("%.1f", (e * 100)) .. "%"
                    elseif string.find(s, "value") then
                        local e = self:getValue(values[tonumber(string.sub(s, 7, 7))])
                        return e .. ""
                    end
                    return s
                end)
                type_TEXT:set_text(desc)
            else
                labelCells[i]:set_visible(false)
            end
        end
        self._rootLabelList:set_visible(haveLabel)
    else
        self._rootLabelList:set_visible(skillCfg.descr ~= "")
        labelCells[2]:set_visible(false)
        local label = labelCells[1]:get_child("label")
        local type_TEXT = labelCells[1]:get_child("_descr_TEXT")
        label:set_visible(false)
        type_TEXT:set_text(skillCfg.descr)
    end

    self._hide = false
    self._ui:set_visible(true)

    local xOffset, yOffset = y3.UIHelper.limitTipOffset(y3.gameApp:getMyPlayerId(), self._ui)
    self._ui:set_follow_mouse(true, xOffset, yOffset)

    y3.ctimer.wait(3 / 30, function(timer, count)
        if self._hide then
            return
        end
        local xOffset, yOffset = y3.UIHelper.limitTipOffset(y3.gameApp:getMyPlayerId(), self._ui)
        self._ui:set_follow_mouse(true, xOffset, yOffset)
    end)
end

function SurviveGameSkillTip:hide()
    self._hide = true
    self._ui:set_follow_mouse(true)
    self._ui:set_visible(false)
end

function SurviveGameSkillTip:getValue(value)
    if value == "" then
        return value
    end
    if tonumber(value) then
        return tonumber(value)
    else
        -- print("SurviveGameSkillTip:getValue", value)
        local attrPack = include("gameplay.config.attr_pack").get(value)
        if not attrPack then
            return value
        end
        local attrs = string.split(attrPack.attr, "|")
        local params = string.split(attrs[1], "#")
        return tonumber(params[2])
    end
end

return SurviveGameSkillTip
