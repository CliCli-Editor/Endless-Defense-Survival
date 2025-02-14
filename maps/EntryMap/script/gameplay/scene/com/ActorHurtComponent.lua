local SurviveHelper = include "gameplay.level.logic.helper.SurviveHelper"
local ActorHurtComponent = class("ActorHurtComponent")

function ActorHurtComponent:ctor(actor)
    self._actor = actor
    self._unit = self._actor:getUnit()
    self._triggerList = {}
    self:addTrigger(self._unit:event("单位-受到伤害时", function(trg, data)
        if self._actor:isMonster() then
        else
            self:_onBeHurtTower(trg, data)
        end
    end))
end

function ActorHurtComponent:_handleHurt(trg, data)
    local damage_instance = data.damage_instance
    local damage = data.damage
    local source_unit = data.source_unit
    local target_unit = data.target_unit
    local ability = data.ability
    damage = SurviveHelper.calculateDamagePure({ source_unit:get_id(), target_unit:get_id(), 0, 0, false, damage, ability
    .phandle })
    damage_instance:set_damage(damage)
end

-- -@class EventParam.ET_UNIT_BE_HURT_BEFORE_APPLY
-- -@field is_normal_hit boolean # 是否是普通攻击
-- -@field damage number # 受到的伤害值
-- -@field source_unit Unit # 施加伤害的单位
-- -@field target_unit Unit # 承受伤害的单位
-- -@field ability Ability # 当前伤害所属技能
-- -@field damage_type integer # 伤害类型
-- -@field unit Unit # 无描述
-- -@field damage_instance DamageInstance # 伤害实例
-- M.DamageTypeMap = {
--     ['物理'] = 0,
--     ['法术'] = 1,
--     ['真实'] = 2,
-- }
function ActorHurtComponent:_onBeHurtMonster(trg, data)
    self:_handleHurt(trg, data)
end

function ActorHurtComponent:_onBeHurtTower(trg, data)
    self:_handleHurt(trg, data)
end

function ActorHurtComponent:addTrigger(trigger)
    table.insert(self._triggerList, trigger)
end

function ActorHurtComponent:clear()
    for i = 1, #self._triggerList do
        self._triggerList[i]:remove()
    end
    self._triggerList = {}
end

return ActorHurtComponent
