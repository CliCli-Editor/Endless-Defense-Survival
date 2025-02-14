local GlobalConfigHelper = require "gameplay.level.logic.helper.GlobalConfigHelper"
local SurviveGameMonsterAtkTip = class("SurviveGameMonsterAtkTip")

function SurviveGameMonsterAtkTip:ctor()
    self._ui = y3.UIHelper.getUI("bc591bc9-4f57-496d-b621-9b1ff19500cb")
    self._monster_damage_number_text = y3.UIHelper.getUI("95f1af80-c812-46f3-aa96-397104a4c82c")
    self._monster_damage_range_text = y3.UIHelper.getUI("45c36492-265a-45c3-9a76-ff79c1838076")
    self._monster_damage_atlk_speed_text = y3.UIHelper.getUI("29fa6387-64df-4de2-841e-92ea1a1dc988")
    self._ui:set_anchor(0, 0)

    local atkRangeStrs = string.split(GlobalConfigHelper.get(21), "|")
    self._rangeMap = {}
    for _, atkRangeStr in ipairs(atkRangeStrs) do
        local param = string.split(atkRangeStr, "#")
        table.insert(self._rangeMap, { range = tonumber(param[1]), text = param[2] })
    end
    local atkSpeedStrs = string.split(GlobalConfigHelper.get(22), "|")
    self._speedMap = {}
    for _, atkSpeedStr in ipairs(atkSpeedStrs) do
        local param = string.split(atkSpeedStr, "#")
        table.insert(self._speedMap, { speed = tonumber(param[1]), text = param[2] })
    end
end

function SurviveGameMonsterAtkTip:getRangeText(range)
    for i = #self._rangeMap, 1, -1 do
        local data = self._rangeMap[i]
        if range >= data.range then
            return data.text
        end
    end
    return self._rangeMap[1].text
end

function SurviveGameMonsterAtkTip:getSpeedText(speed)
    print("speed", speed)
    for i = #self._speedMap, 1, -1 do
        local data = self._speedMap[i]
        if speed >= data.speed then
            print(data.text)
            return data.text
        end
    end
    return self._speedMap[1].text
end

function SurviveGameMonsterAtkTip:show()
    local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local player = playerData:getPlayer()
    local unit = player:get_selecting_unit()
    if unit and y3.class.isValid(unit) and unit:has_tag(y3.SurviveConst.STATE_ENEMY_TAG) then
        y3.UIActionMgr:playFadeAction(self._ui)
        self._ui:set_visible(true)

        local atk = math.floor(unit:get_attr(y3.const.UnitAttr['物理攻击']))
        local range = math.floor(unit:get_attr(y3.const.UnitAttr['攻击范围']))
        local speed = math.floor(unit:get_attr(y3.const.UnitAttr['攻击间隔']))
        self._monster_damage_number_text:set_text(atk)
        self._monster_damage_range_text:set_text(self:getRangeText(range))
        self._monster_damage_atlk_speed_text:set_text(self:getSpeedText(speed))

        local xOffset, yOffset = y3.UIHelper.limitTipOffset(y3.gameApp:getMyPlayerId(), self._ui)
        self._ui:set_follow_mouse(true, xOffset, yOffset)
    end
end

function SurviveGameMonsterAtkTip:hide()
    self._ui:set_follow_mouse(false, 10, 20)
    self._ui:set_visible(false)
end

return SurviveGameMonsterAtkTip
