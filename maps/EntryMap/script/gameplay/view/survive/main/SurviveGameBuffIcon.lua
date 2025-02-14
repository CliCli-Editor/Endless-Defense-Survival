local SurviveGameBuffIcon = class("SurviveGameBuffIcon")

function SurviveGameBuffIcon:ctor(parent, needNotifyHighlight)
    local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local uiPre = y3.ui_prefab.create(playerData:getPlayer(), y3.SurviveConst.PREFAB_MAP["buff_weapon"], parent)
    local ui = uiPre:get_child("")
    self._ui = ui
    self._needNotifyHighlight = needNotifyHighlight
    self._icon = self._ui:get_child("_buff_ICON")
    self._countTEXT = self._ui:get_child("_count_TEXT")
    self._highlight = self._ui:get_child("highlight")
    self._refreshAnim = self._ui:get_child("refresh_ANIM")
    -- 根据技能ID高亮组|根据技能type高亮组|根据技能range高亮组|武器标签组(label)|武器攻击类型组(atk_target)
    self._icon:add_local_event("鼠标-移入", function(local_player)
        if self._noHover then
            return
        end
        if self._hoverCallback then
            self._hoverCallback(true)
            return
        end
        local data = self._data
        if data then
            if self._needNotifyHighlight then
                y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SKIL_TOTAL_HIGHLIGHT, y3.gameApp:getMyPlayerId(),
                    data.skill_icon_highlight)
            end
            local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
            local mainActor  = playerData:getMainActor()
            y3.gameApp:getLevel():getView("SurviveGameTip"):showUniversalTip({
                title = data.name,
                desc = self
                    :getSkillDesc(data, mainActor:getSkillNameNum(data.id))
            })
        end
    end)
    self._icon:add_local_event("鼠标-移出", function(local_player)
        if self._noHover then
            return
        end
        if self._hoverCallback then
            self._hoverCallback(false)
            return
        end
        if self._needNotifyHighlight then
            y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SKIL_TOTAL_HIDE_HIGHLIGHT, y3.gameApp:getMyPlayerId())
        end
        y3.gameApp:getLevel():getView("SurviveGameTip"):hideUniversalTip()
    end)
end

function SurviveGameBuffIcon:isVisible()
    return self._ui:is_visible()
end

function SurviveGameBuffIcon:setHighlight(need)
    self._highlight:set_visible(need)
end

function SurviveGameBuffIcon:noHover(hover)
    self._noHover = hover
end

function SurviveGameBuffIcon:setHoverCallback(callback)
    self._hoverCallback = callback
end

function SurviveGameBuffIcon:getValue(value)
    if value == "" then
        return 0
    end
    if tonumber(value) then
        return tonumber(value)
    else
        -- print("SurviveGameSkillTip:getValue", value)
        local attrPack = include("gameplay.config.attr_pack").get(value)
        if not attrPack then
            return 0
        end
        assert(attrPack, "can found cfg by id=" .. value)
        local attrs = string.split(attrPack.attr, "|")
        assert(attrs, "")
        local params = string.split(attrs[1], "#")
        assert(params, "")
        return tonumber(params[2])
    end
end

function SurviveGameBuffIcon:getSkillDesc(skillCfg, skillNum)
    local ret = ""
    if skillCfg.ability_type ~= "" then
        local types = string.split(skillCfg.ability_type, "|")
        local descrs = string.split(skillCfg.buff_desc, "|")
        local values = string.split(skillCfg.value, "|")
        assert(types, "")
        assert(descrs, "")
        assert(values, "")
        for i = 1, 2 do
            if types[i] then
                local params = string.split(types[i], "#")
                assert(params, "")
                local desc = descrs[i] or ""
                desc = string.gsub(desc, "({%a+[0-9]})", function(s)
                    local lenStr = string.len(s)
                    if string.find(s, "value") then
                        local e = self:getValue(values[tonumber(string.sub(s, 7, 7))])
                        if self:isInteger(e) then
                            return string.format("%d", e * skillNum)
                        else
                            return string.format("%.2f", e * skillNum)
                        end
                    elseif string.find(s, "upgrade") then
                        local index = tonumber(string.sub(s, 9, 9))
                        if not values[1] then
                            return s
                        end
                        local attrPack = include("gameplay.config.attr_pack").get(values[1])
                        assert(attrPack, "")
                        local attrs = string.split(attrPack.attr, "|")
                        assert(attrs, "")
                        if not attrs[index] then
                            return s
                        end
                        local attrValues = string.split(attrs[index], "#")
                        assert(attrValues, "")
                        if not attrValues[2] then
                            return s
                        end
                        local finalValue = tonumber(attrValues[2]) * skillNum
                        if self:isInteger(finalValue) then
                            return string.format("%d", finalValue)
                        else
                            return string.format("%.2f", finalValue)
                        end
                    end
                    return s
                end)
                ret = ret .. desc .. "\n"
            end
        end
    end
    return ret
end

function SurviveGameBuffIcon:isInteger(num)
    return num == math.floor(num)
end

function SurviveGameBuffIcon:updateUI(data, isSoul)
    self._data = data
    local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local mainActor = playerData:getMainActor()
    local soulActor = mainActor:getSoulHeroActor()
    self._icon:set_image(tonumber(data.icon))
    if isSoul then
        self._countTEXT:set_text(soulActor:getSkillNameNum(data.id))
    else
        self._countTEXT:set_text(mainActor:getSkillNameNum(data.id))
    end
end

function SurviveGameBuffIcon:getCfg()
    return self._data
end

function SurviveGameBuffIcon:setVisible(visible)
    self._ui:set_visible(visible)
end

return SurviveGameBuffIcon
