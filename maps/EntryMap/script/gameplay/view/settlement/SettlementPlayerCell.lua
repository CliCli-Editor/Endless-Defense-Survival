local StaticUIBase = include("gameplay.base.StaticUIBase")
local SettlementPlayerCell = class("SettlementPlayerCell", StaticUIBase)

function SettlementPlayerCell:ctor(ui)
    SettlementPlayerCell.super.ctor(self, ui)
    self._playerAvatarImg = self._ui:get_child("name.avatar.mask._player_plat_avatar_IMG")
    self._name_text = self._ui:get_child("name._name_TEXT")
    self._powerText = self._ui:get_child("_value_1_TEXT")
    self._maxDpsText = self._ui:get_child("_value_2_TEXT")
    self._finalBossHurtText = self._ui:get_child("_value_3_TEXT")
    self._topWeaponList = self._ui:get_child("_value_4._value_4_LIST")
    self._host = self._ui:get_child("name.avatar.host")
    self._hoverMap = {}
end

function SettlementPlayerCell:_updateEmpty()
    self._name_text:set_text(GameAPI.get_text_config('#384979971#lua'))
    self._powerText:set_text("0")
    self._maxDpsText:set_text("0")
    self._finalBossHurtText:set_text("0%")
    self._topWeaponList:set_visible(false)
    self._host:set_visible(false)
end

function SettlementPlayerCell:updateUI(playerData, totalDamage)
    if not playerData then
        self:_updateEmpty()
        return
    end
    self._host:set_visible(playerData:isRoomMaster())
    self._topWeaponList:set_visible(true)
    self._playerAvatarImg:set_image(playerData:getPlayer():get_platform_icon())
    self._name_text:set_text(playerData:getPlayer():get_platform_name())
    local mainActor = playerData:getMainActor()
    self._powerText:set_text(math.floor(mainActor:getPower()))
    self._maxDpsText:set_text(string.format("%.2f", mainActor:getMaxDps()))

    local damage = mainActor:getFinalBossHurt()
    if totalDamage > 0 then
        local pro = damage / totalDamage * 100
        self._finalBossHurtText:set_text(string.format("%.2f", pro) .. "%")
    else
        self._finalBossHurtText:set_text("0%")
    end

    local dpsSkills = mainActor:getSkillAllTimeDps()
    table.sort(dpsSkills, function(a, b)
        return a.damage > b.damage
    end)
    local childs = self._topWeaponList:get_childs()
    for i, child in ipairs(childs) do
        local dpsSKill = dpsSkills[i]
        if dpsSKill then
            local cfg = include("gameplay.config.config_skillData").get(tostring(dpsSKill.key))
            if cfg then
                child:set_image(tonumber(cfg.icon))
            end
            child:set_visible(true)
            if not self._hoverMap[child] then
                self._hoverMap[child] = true
                child:add_local_event("鼠标-移入", function()
                    y3.Sugar.tipRoot():showSkillTip({ cfg = cfg, noAnim = true })
                end)
                child:add_local_event("鼠标-移出", function()
                    y3.Sugar.tipRoot():hideSkillTip()
                end)
            end
        else
            child:set_visible(false)
        end
    end
end

return SettlementPlayerCell
