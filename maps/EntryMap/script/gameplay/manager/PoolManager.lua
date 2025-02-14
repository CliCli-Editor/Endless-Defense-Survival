local UnitConst = include "gameplay.const.UnitConst"
local PoolManager = class("PoolManager")

local HIDE_X = 10000000
local HIDE_Y = 10000000

function PoolManager:ctor()
    -- print("PoolManager:ctor")
    -- self._monsterPool = include("gameplay.utils.UnitPool").new(UnitConst.UNIT_MONSTER_ID)
    self._monsterPoolMap = {}
    -- self._monsterPoolMap[UnitConst.UNIT_MONSTER_ID] = self._monsterPool
    -- self._monsterPoolMap[UnitConst.UNIT_MONSTER_JINZHAN_ID] = include("gameplay.utils.UnitPool").new(UnitConst
    -- .UNIT_MONSTER_JINZHAN_ID)
    -- self._monsterPoolMap[UnitConst.UNIT_MONSTER_YUANCHNEG_ID] = include("gameplay.utils.UnitPool").new(UnitConst
    -- .UNIT_MONSTER_YUANCHNEG_ID)

    -- self._bombPool = include("gameplay.utils.ProjectilePool").new(y3.ProjectConst.PROJECTILE_FLY_BALL, 100)
    self._proPoolMap = {}
    -- self._proPoolMap[y3.ProjectConst.PROJECTILE_FLY_BALL] = self._bombPool
    -- self._proPoolMap[y3.ProjectConst.PROJECTILE_FIRE] = include("gameplay.utils.ProjectilePool").new(
    --     y3.ProjectConst.PROJECTILE_FIRE, 100)
    -- self:initMonsterPool()
end

function PoolManager:initMonsterPool()
    local monster = include("gameplay.config.monster")
    local len = monster.length()
    for i = 1, len do
        local cfg = monster.indexOf(i)
        assert(cfg, "monster_template_id not found")
        if not self._monsterPoolMap[cfg.monster_template_id] then
            self._monsterPoolMap[cfg.monster_template_id] = include("gameplay.utils.UnitPool").new(cfg
                .monster_template_id, 20)
        end
    end
end

function PoolManager:getMonsterUnitByKey(key)
    if self._monsterPoolMap[key] then
        return self._monsterPoolMap[key]:getUnit()
    else
        local unit = y3.unit.create_unit(y3.player(y3.GameConst.PLAYER_ID_ENEMY), key,
            y3.point.create(HIDE_X, HIDE_Y, 0), 0)
        return unit
    end
end

function PoolManager:recycleMonsterUnitByKey(key, unit)
    if self._monsterPoolMap[key] then
        self._monsterPoolMap[key]:recycleUnit(unit)
    else
        unit:remove()
        -- self._monsterPoolMap[key] = include("gameplay.utils.UnitPool").new(key, 0)
        -- self._monsterPoolMap[key]:recycleUnit(unit)
    end
end

function PoolManager:getBomb()
    return self._bombPool:getProjectile()
end

function PoolManager:recycleBomb(bomb)
    return self._bombPool:recycleProjectile(bomb)
end

function PoolManager:getProjectile(key)
    if not self._proPoolMap[key] then
        local data = {}
        data.key = key
        data.target = y3.point.create(HIDE_X, HIDE_Y, 0)
        data.time = -1
        local pro = y3.projectile.create(data)
        return pro
    else
        return self._proPoolMap[key]:getProjectile()
    end
end

---comment
---@param key any
---@param projectile Projectile
function PoolManager:recycleProjectile(key, projectile)
    if not self._proPoolMap[key] then
        projectile:remove()
    else
        self._proPoolMap[key]:recycleProjectile(projectile)
    end
end

return PoolManager
