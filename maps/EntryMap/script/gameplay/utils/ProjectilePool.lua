local ProjectilePool = class("ProjectilePool")

local HIDE_X = 10000000
local HIDE_Y = 10000000

function ProjectilePool:ctor(projectileKey, maxSize)
    self._projectileKey = projectileKey
    self._maxSize = maxSize
    self._pool = {}
    self:initPool()
end

function ProjectilePool:initPool()
    for i = 1, self._maxSize do
        local data = {}
        data.key = self._projectileKey
        data.target = y3.point.create(HIDE_X, HIDE_Y, 0)
        data.time = -1
        local pro = y3.projectile.create(data)
        self:recycleProjectile(pro)
    end
end

function ProjectilePool:recycleProjectile(projectile)
    projectile:set_point(y3.point.create(HIDE_X, HIDE_Y, 0))
    projectile:set_scale(0.1, 0.1, 0.1)
    table.insert(self._pool, projectile)
end

function ProjectilePool:getProjectile()
    local pro = table.remove(self._pool)
    if not pro then
        self:initPool()
        return self:getProjectile()
    end
    pro:set_scale(1, 1, 1)
    return pro
end

return ProjectilePool
