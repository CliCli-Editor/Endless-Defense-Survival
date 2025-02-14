local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGameSkillStatisticsTotalCell = class("SurviveGameSkillStatisticsTotalCell", StaticUIBase)

local RANGE_INDEX_MAP = {
    [1] = 450,
    [2] = 900,
    [3] = 1350,
    [4] = 1800,
}

local RANGE_NAME_MAP = {
    [1] = GameAPI.get_text_config('#30000001#lua79'),
    [2] = GameAPI.get_text_config('#30000001#lua80'),
    [3] = GameAPI.get_text_config('#30000001#lua81'),
    [4] = GameAPI.get_text_config('#30000001#lua82'),
}

function SurviveGameSkillStatisticsTotalCell:ctor(ui)
    SurviveGameSkillStatisticsTotalCell.super.ctor(self, ui)

    self._title_text = self._ui:get_child("name.title_TEXT")
    self._count_value_text = self._ui:get_child("count._value_TEXT")
    self._dps_value_text = self._ui:get_child("dps._value_TEXT")
    self._dmg_total_value_text = self._ui:get_child("dmg_total._value_TEXT")
    self._kill_total_value_text = self._ui:get_child("kills_total._value_TEXT")
end

function SurviveGameSkillStatisticsTotalCell:updateUI(totalNum, rangeIndex, dps, totalDamage, killNum)
    -- local skillCfg = include("gameplay.config.config_skillData").get(skillId)
    local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local mainActor  = playerData:getMainActor()
    self._title_text:set_text(RANGE_NAME_MAP[rangeIndex] .. "(" .. RANGE_INDEX_MAP[rangeIndex] .. ")GameAPI.get_text_config('#30000001#lua77')")
    self._count_value_text:set_text(totalNum)--mainActor:getSkillTypeNum(skillType))
    self._dps_value_text:set_text(string.format("%.2f", dps))               --mainActor:getSkillDps(skillCfg.id))
    self._dmg_total_value_text:set_text(string.format("%.2f", totalDamage)) --mainActor:getSkillDmgTotal(skillCfg.id))
    self._kill_total_value_text:set_text(killNum)                           --mainActor:getSkillKillTotal(skillCfg.id))
end

return SurviveGameSkillStatisticsTotalCell
