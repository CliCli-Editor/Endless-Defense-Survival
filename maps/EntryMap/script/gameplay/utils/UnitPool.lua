local UnitPool = class("UnitPool")

local HIDE_X = 10000000
local HIDE_Y = 10000000

function UnitPool:ctor(key, initSize, maxSize)
    self._key = key
    self._initSize = initSize or 300
    self._poolSize = maxSize or 2000
    self._units = {}
    self:initPool()
end

function UnitPool:initPool()
    for i = 1, self._initSize do
        local unit = y3.unit.create_unit(y3.player(y3.GameConst.PLAYER_ID_ENEMY), self._key,
            y3.point.create(HIDE_X, HIDE_Y, 0), 0)
        self:recycleUnit(unit)
    end
end

function UnitPool:getUnit()
    local unit = table.remove(self._units)
    if not unit then
        self:initPool()
        return self:getUnit()
    end
    return unit
end

--- @param unit Unit
function UnitPool:recycleUnit(unit)
    local size = #self._units
    if size >= self._poolSize then
        return
    end
    unit:reborn()
    unit:set_point(y3.point.create(HIDE_X, HIDE_Y))
    table.insert(self._units, unit)
end

return UnitPool
