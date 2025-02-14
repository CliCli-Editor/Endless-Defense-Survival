local GlobalConfigHelper = require "gameplay.level.logic.helper.GlobalConfigHelper"
local SurviveGameMonsterDefTip = class("SurviveGameMonsterDefTip")

function SurviveGameMonsterDefTip:ctor()
    self._ui = y3.UIHelper.getUI("7287b8bc-6f26-407f-9ba7-2d9eb514c820")
    self._monster_def_num_text = y3.UIHelper.getUI("dc99502d-d626-4bcc-a321-b400b8d9b08f")
    self._monster_armor_type_text = y3.UIHelper.getUI("1ceac674-4436-444e-a10f-e9bc3f006645")
    self._monster_armor_decrease_text = y3.UIHelper.getUI("08a67000-5048-4ece-b463-214f20c8d508")
    self._armor_text = y3.UIHelper.getUI("74da252f-564b-4e48-8649-37d1d0c605f9")
    self._ui:set_anchor(0, 0)
    local armorStrs = string.split(GlobalConfigHelper.get(24), "|")
    self._armorMap = {}
    for _, armorStr in ipairs(armorStrs) do
        local params = string.split(armorStr, "@")
        local id = tonumber(params[1])
        local desc = params[2]
        self._armorMap[id] = desc
    end
end

function SurviveGameMonsterDefTip:show()
    local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local player = playerData:getPlayer()
    local unit = player:get_selecting_unit()
    if unit and y3.class.isValid(unit) and unit:has_tag(y3.SurviveConst.STATE_ENEMY_TAG) then
        y3.UIActionMgr:playFadeAction(self._ui)

        self._ui:set_visible(true)

        local def = math.floor(unit:get_attr(y3.const.UnitAttr['物理防御']))
        self._monster_def_num_text:set_text(tostring(def))
        local cfgId = unit:kv_load("cfgId", "integer")
        local cfg = include("gameplay.config.monster").get(cfgId)
        self._monster_armor_type_text:set_text(y3.SurviveConst.ARMOR_NAME_MAP[cfg.armor_type] or "")

        local targetHuJia    = unit:get_attr("物理防御")
        local sourceChuantou = playerData:getMainActor():getUnit():get_attr("物理穿透")
        local defenseRate    = 0
        if targetHuJia - sourceChuantou >= 0 then
            defenseRate = (targetHuJia - sourceChuantou) * 0.05 / (1 + 0.05 * (targetHuJia - sourceChuantou))
        else
            local tempp = 0.99 ^ (targetHuJia - sourceChuantou)
            defenseRate = 1 - tempp
        end
        defenseRate = math.floor(defenseRate * 100)
        self._monster_armor_decrease_text:set_text(tostring(defenseRate) .. "%")
        print(cfg.armor_type)
        self._armor_text:set_text(self._armorMap[cfg.armor_type] or "")

        local xOffset, yOffset = y3.UIHelper.limitTipOffset(y3.gameApp:getMyPlayerId(), self._ui)
        self._ui:set_follow_mouse(true, xOffset, yOffset)
    end
end

function SurviveGameMonsterDefTip:hide()
    self._ui:set_follow_mouse(false, 10, 20)
    self._ui:set_visible(false)
end

return SurviveGameMonsterDefTip
