---@package generic
Cache = {}

---@private
Cache._cach = {}

-- 添加缓存
function Cache.addCach(cach)
    local key = type(cach) == "string" and cach or tostring(cach)
    if not Cache._cach[key] then
        Cache._cach[key] = 0
    end
    Cache._cach[key] = Cache._cach[key] + 1
end

-- 移除缓存
function Cache.removeCach(cach)
    ---@type string
    local key = type(cach) == "string" and cach or tostring(cach)
    if Cache._cach[key] then
        Cache._cach[key] = nil
    end
end

-- 获取所有缓存数据
function Cache.getAllCach()
    return Cache._cach
end

-- 清空缓存数据
function Cache.clearAllCach()
    Cache._cach = {}
end

-- 是否存在该缓存
---@param cach any
---@return boolean
function Cache.hasCach(cach)
    ---@type string
    local key = type(cach) == "string" and cach or tostring(cach)
    return Cache._cach[key] ~= nil
end

return Cache
