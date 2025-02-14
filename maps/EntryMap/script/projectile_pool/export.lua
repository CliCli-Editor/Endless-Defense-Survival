---@type table<py.ProjectileKey, ProjectilePool>
local projectile_pool_by_key = {}

local M = require 'projectile_pool.projectile_pool'

New 'ECAFunction' '投射物分配-初始化配置'
    : with_param("默认点", "py.Point")
    : with_param("默认所属玩家", "py.Role")
    : call(function (point, owner)
        M.init(point, owner)
        for _,v in pairs(projectile_pool_by_key) do
            v:update_defalut_setting()
        end
    end)

New 'ECAFunction' '投射物分配-配置类型缓存'
    : with_param("投射物类型", "py.ProjectileKey")
    : with_param('缓存大小', "integer")
    : with_param("分帧调整(小于0时不分帧)", "integer")
    : with_param("每步调整数量", "integer")
    : call(function (key, pool_size, update_interval, update_num)
        if projectile_pool_by_key[key] then
           local pool = projectile_pool_by_key[key]
           pool:set_update_num(update_num)
           pool.update_interval = update_interval
           pool:set_size(pool_size)
        else
            local pool = New 'ProjectilePool'(pool_size, key, update_interval, update_num)
            projectile_pool_by_key[key] = pool
        end
    end)

Bind["投射物分配-分配投射物"] = function (key, point, owner, facing, height)
    if projectile_pool_by_key[key] then
        local p = projectile_pool_by_key[key]:allocate()
        if p and GameAPI.projectile_is_exist(p.handle) then
            p.handle:api_set_position(point, false)
            p.handle:api_set_face_angle(facing)
            p.handle:api_raise_height(height)
            -- if owner and owner:is_exist() then
            --     GameAPI.change_projectile_owner(p.handle, owner.handle)
            -- end
            return p
        end
    else
        error(string.format("pool with key: %s not existed", tostring(key)))
    end
end

Bind["投射物分配-取消分配"] = function (projectile)
    local key = projectile:api_get_key()
    if projectile_pool_by_key[key] then
        local pool = projectile_pool_by_key[key]
        return pool:deallocate(projectile)
    else
        error(string.format("pool with key: %s not existed", tostring(key)))
    end
end

New 'ECAFunction' '投射物分配-获取池大小'
    : with_param('投射物类型', 'py.ProjectileKey')
    : with_return('大小', 'integer')
    : call(function (key)
        return projectile_pool_by_key[key] and projectile_pool_by_key[key]:get_size() or 0
    end)

return projectile_pool_by_key