local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGameSkillStatisticsCell = class("SurviveGameSkillStatisticsCell", StaticUIBase)

local COLOR_ICON = {
    [1] = 134255262,
    [2] = 134236214,
    [3] = 134264401,
    [4] = 134250661,
    [5] = 134264565
}

function SurviveGameSkillStatisticsCell:ctor(ui)
    SurviveGameSkillStatisticsCell.super.ctor(self, ui)

    self._weapon_icon_img = self._ui:get_child("icon._weapon_icon_IMG")
    self._title_text = self._ui:get_child("name.title_TEXT")
    self._weapon_class_img = self._ui:get_child("class._weapon_icon_IMG")
    self._count_value_text = self._ui:get_child("count._value_TEXT")
    self._dps_value_text = self._ui:get_child("dps._value_TEXT")
    self._dmg_total_value_text = self._ui:get_child("dmg_total._value_TEXT")
    self._kill_total_value_text = self._ui:get_child("kills_total._value_TEXT")
end

function SurviveGameSkillStatisticsCell:updateUI(skillCfg)
    -- local skillCfg = include("gameplay.config.config_skillData").get(skillId)
    local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local mainActor  = playerData:getMainActor()
    self._weapon_icon_img:set_image(tonumber(skillCfg.icon))
    self._title_text:set_text(skillCfg.name)
    self._title_text:set_text_color_hex(y3.ColorConst.QUALITY_COLOR_MAP[skillCfg.class + 1], 255)
    self._weapon_class_img:set_image(COLOR_ICON[skillCfg.class + 1])
    self._count_value_text:set_text(mainActor:getSkillNameNum(skillCfg.id))
    local dps = mainActor:getSkillDps(skillCfg.id)
    self._dps_value_text:set_text(string.format("%.2f", dps))
    local dmgTotal = mainActor:getSkillDmgTotal(skillCfg.id)
    self._dmg_total_value_text:set_text(string.format("%.2f", dmgTotal))
    local killTotal = mainActor:getSkillKillTotal(skillCfg.id)
    self._kill_total_value_text:set_text(math.floor(killTotal))
    return dps, dmgTotal, killTotal
end

return SurviveGameSkillStatisticsCell
