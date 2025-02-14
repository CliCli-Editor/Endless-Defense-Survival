local GlobalConfigHelper = include "gameplay.level.logic.helper.GlobalConfigHelper"
local SurviveGameSkillTotalCell = class("SurviveGameSkillTotalCell")

function SurviveGameSkillTotalCell:ctor(ui)
    self._ui = ui
    self._icon = self._ui:get_child("title._weapon_type_ICON")
    self._title_TEXT = self._ui:get_child("title.descr._weapon_name_TEXT")
    self._weapon_bonus_TEXT = self._ui:get_child("title.descr._weapon_bonus_TEXT")
    self._value_TEXT = self._ui:get_child("title.count._value_TEXT")
    self._weapon_GRID = self._ui:get_child("weapon_GRID")
    self._title = self._ui:get_child("title")
    self._weapon_counter_shield_type_ICON = self._ui:get_child(
        "title._weapon_type_ICON._weapon_counter_shield_type_ICON")

    self._weaponCards = {}
    self._title:add_local_event("鼠标-移入", function(local_player)
        if self._root then
            local title, desc = self:getDamageKezhiDesc()
            y3.gameApp:getLevel():getView("SurviveGameTip"):showUniversalTip({ title = title, desc = desc })
        end
    end)
    self._title:add_local_event("鼠标-移出", function(local_player)
        if self._root then
            y3.gameApp:getLevel():getView("SurviveGameTip"):hideUniversalTip()
        end
    end)
end

function SurviveGameSkillTotalCell:getDamageKezhiDesc()
    local skillType = self._skillType
    local title = y3.SurviveConst.DAMAGE_TYPE_NAME_MAP[skillType]
    local armor = y3.SurviveConst.PRIOITY_ARMOR_MAP[skillType] or 0

    local armorName = y3.SurviveConst.ARMOR_NAME_MAP[armor]
    local color = y3.SurviveConst.ARMOR_COLOR_MAP[armor]
    local damageAdd = self:getDamageAddText(skillType)
    local damageAddText = ""
    if damageAdd then
        damageAddText = "\n#8e8e8e-" .. damageAdd[2] .. "#48b05d+" .. math.floor(damageAdd[1]) .. "%"
    end
    if skillType == y3.SurviveConst.DAMAGE_TYPE_5 then
        damageAddText = y3.Lang.get("lang_skill_type_desc5") .. damageAddText
    else
        damageAddText = y3.Lang.get("lang_skill_type_desc",
                { name = armorName, color_ = "#" .. color, color1_ = "#" .. color, name1 = armorName, num = 100 }) ..
            damageAddText
    end
    return title, damageAddText
end

function SurviveGameSkillTotalCell:getDamageAddText(damageType)
    local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local mainActor = playerData:getMainActor()
    local mainUnit = mainActor:getUnit()
    if damageType == y3.SurviveConst.DAMAGE_TYPE_1 then
        return { mainUnit:get_attr("普通伤害加成"), GameAPI.get_text_config('#30000001#lua56') }
    elseif damageType == y3.SurviveConst.DAMAGE_TYPE_2 then
        return { mainUnit:get_attr("穿刺伤害加成"), GameAPI.get_text_config('#550155030#lua') }
    elseif damageType == y3.SurviveConst.DAMAGE_TYPE_3 then
        return { mainUnit:get_attr("魔法伤害加成"), GameAPI.get_text_config('#30000001#lua43') }
    elseif damageType == y3.SurviveConst.DAMAGE_TYPE_4 then
        return { mainUnit:get_attr("攻城伤害加成"), GameAPI.get_text_config('#30000001#lua53') }
    elseif damageType == y3.SurviveConst.DAMAGE_TYPE_5 then
        return { mainUnit:get_attr("混乱伤害加成"), GameAPI.get_text_config('#30000001#lua70') }
    end
end

function SurviveGameSkillTotalCell:updateUI(skillType, root, skillTypeMap, allCardList)
    local weaponList = skillTypeMap[skillType]
    self._root = root
    self._skillType = skillType
    -- print("update skill total cell ui", skillType)
    local armor = y3.SurviveConst.PRIOITY_ARMOR_MAP[skillType] or 0
    local armorIconMap = GlobalConfigHelper.getArmorIconMap()
    if skillType == 5 then
        self._weapon_counter_shield_type_ICON:set_visible(false)
    else
        self._weapon_counter_shield_type_ICON:set_visible(true)
        self._weapon_counter_shield_type_ICON:set_image(armorIconMap[armor] or armorIconMap[1])
    end

    local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local mainActor = playerData:getMainActor()
    local skillCount = 0
    if mainActor then
        skillCount = mainActor:getSkillTypeNum(skillType)
    end
    self._icon:set_image(y3.SurviveConst.SKILLTYPE_ICON[skillType])
    self._title_TEXT:set_text(y3.SurviveConst.DAMAGE_TYPE_NAME_MAP2[skillType])
    self._value_TEXT:set_text(skillCount)
    local damageAddText = self:getDamageAddText(skillType)
    self._weapon_bonus_TEXT:set_text("+" .. string.format("%.2f", damageAddText[1]) .. "%")
    self._weaponList = weaponList
    for i = 1, #weaponList do
        local weapon = weaponList[i]
        local num = mainActor:getSkillNameNum(weapon.id)
        if num > 0 then
            local card = self._weaponCards[i]
            if not card then
                card = include("gameplay.view.survive.main.SurviveGameBuffIcon").new(self._weapon_GRID)
                card:setHoverCallback(function(visible)
                    if visible then
                        local cfg = self._weaponList[i]
                        if cfg then
                            y3.gameApp:getLevel():getView("SurviveGameTip"):showSkillTip({ cfg = cfg })
                        end
                    else
                        y3.gameApp:getLevel():getView("SurviveGameTip"):hideSkillTip()
                    end
                end)
                self._weaponCards[i] = card
                table.insert(allCardList, card)
            end
            card:updateUI(weapon)
        end
    end
end

function SurviveGameSkillTotalCell:_updateWeapon()

end

function SurviveGameSkillTotalCell:setVisible(visible)
    self._ui:set_visible(visible)
end

return SurviveGameSkillTotalCell
