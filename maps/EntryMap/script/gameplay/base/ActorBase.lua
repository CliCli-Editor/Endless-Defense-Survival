local ActorBase = class("ActorBase")

function ActorBase:ctor(player_id, unitTypeId)
    self:init(player_id, unitTypeId)
end

function ActorBase:init(player_id, unitTypeId)
    local unit = y3.unit.create_unit(y3.player(player_id), unitTypeId, y3.point.create(0, 0, 0), 0) --y3.player(1):create_unit(unitdata.key)
    self:_setUnit(unit)
end

function ActorBase:_setUnit(unit)
    self._actorUnit = unit
    self:_attachEvent()
end

function ActorBase:_attachEvent()
    self._trigger = self._actorUnit:event('单位-移除', function()
        self:cleanup()
    end)
end

function ActorBase:cleanup()
    if self._trigger then
        self._trigger:remove()
        self._trigger = nil
    end
    self = nil
end

function ActorBase:setPosition(pos)
    self._actorUnit:set_point(pos, false)
end

function ActorBase:getPosition()
    return self._actorUnit:get_point()
end

function ActorBase:remove()
    self._actorUnit:remove()
end

function ActorBase:getUnit()
    return self._actorUnit
end

function ActorBase:setIsMonster(isMonster)
    self._isMonster = isMonster
end

function ActorBase:isMonster()
    return self._isMonster
end

function ActorBase:addSkill(ability)

end

function ActorBase:removeSkill(ability)

end

function ActorBase:getSkillNameNum(name)
    return 0
end

function ActorBase:learnSkill(skillCfgId)
end

function ActorBase:forgetSkill(skillCfgId)
end

return ActorBase
