local Permanent = class("Permanent")

function Permanent:ctor()
    self._globalUnits = {}
    self._globalPro = {}
    y3.game:event("单位-创建", function(trg, data)
        local unit = data.unit
        self._globalUnits[unit:get_id()] = unit
    end)
    y3.game:event("单位-移除", function(trg, data)
        local unit = data.unit
        self._globalUnits[unit:get_id()] = nil
    end)
    y3.game:event("投射物-创建", function(trg, data)
        local projectile = data.projectile
        self._globalPro[projectile] = projectile
    end)
    y3.game:event("投射物-死亡", function(trg, data)
        local projectile = data.projectile
        self._globalPro[projectile] = nil
    end)
end

function Permanent:clear()
    for i, unit in pairs(self._globalUnits) do
        unit:remove()
    end
    self._globalUnits = {}
    for same, pro in pairs(self._globalPro) do
        pro:remove()
    end
    self._globalPro = {}
end

function Permanent:findUnitByTag(tag)
    local result = {}
    for i, unit in ipairs(self._globalUnits) do
        if unit:has_tag(tag) then
            table.insert(result, unit)
        end
    end
    return result
end

function Permanent:findUnitByKey(key)
    local result = {}
    for i, unit in ipairs(self._globalUnits) do
        if unit:get_key() == key then
            table.insert(result, unit)
        end
    end
    return result
end

function Permanent:findUnitById(Id)
    for i, unit in ipairs(self._globalUnits) do
        if unit:get_id() == Id then
            return unit
        end
    end
end

y3.Permanent = Permanent.new()
