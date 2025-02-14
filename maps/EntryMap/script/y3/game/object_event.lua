local event_configs = require 'y3.meta.eventconfig'
local event_datas   = require 'y3.meta.event'

---@class ObjectEvent
---@field private object_event_manager? EventManager
---@overload fun(): self
local M = Class 'ObjectEvent'

local special_deal = {
    ["单位-受到伤害前"] = true,
    ["单位-造成伤害前"] = true,
    ["单位-受到伤害时"] = true,
    ["单位-造成伤害时"] = true,
    ["单位-造成伤害后"] = true,
    ["单位-受到伤害后"] = true,
}

-- 注册对象的引擎事件
---@param event_name string
---@param ... any
---@return Trigger
function M:event(event_name, ...)
    if not rawget(self, 'object_event_manager') then
        self.object_event_manager = New 'EventManager' (self)
    end
    local extra_args, callback, unsubscribe
    if special_deal[event_name] then
        return self:subscribe_special_event(event_name, ...)
    else
        extra_args, callback, unsubscribe = self:subscribe_event(event_name, ...)
        local trigger = self.object_event_manager:event(event_name, extra_args, callback)
        ---@diagnostic disable-next-line: invisible
        trigger:on_remove(unsubscribe)
    
        local gcHost = self --[[@as GCHost]]
        if gcHost.bindGC then
            gcHost:bindGC(New 'GCBuffer' (0, trigger))
        end
    
        return trigger
    end
end

---@param self_type string
---@param config table
---@return boolean
local function is_valid_object(self_type, config)
    if config.object == self_type then
        return true
    end
    local extra_objs = config.extraObjs
    if not extra_objs then
        return false
    end
    for _, data in ipairs(extra_objs) do
        if data.luaType == self_type then
            return true
        end
    end
    return false
end

---@param event_name string
---@param ... any
---@return any[]?
---@return Trigger.CallBack
---@return function Unsubscribe
function M:subscribe_event(event_name, ...)
    local config = event_configs.config[event_name]
    local self_type = y3.class.type(self)
    if not config or not self_type then
        error('此事件无法作为对象事件：' .. tostring(event_name))
    end
    if not config or not is_valid_object(self_type, config) then
        error('此事件无法作为对象事件：' .. tostring(event_name))
    end

    local nargs = select('#', ...)
    local extra_args
    ---@type Trigger.CallBack
    local callback
    if nargs == 1 then
        callback = ...
    elseif nargs > 1 then
        extra_args = {...}
        callback = extra_args[nargs]
        extra_args[nargs] = nil
    else
        error('缺少回调函数！')
    end

    if self_type == config.object then
        -- 检查将对象还原到事件参数中
        for i, param in ipairs(config.params) do
            if param.type == config.object then
                if not extra_args then
                    extra_args = {}
                end
                table.insert(extra_args, i, self)
                break
            end
        end
    end

    y3.py_event_sub.event_register(event_name, extra_args)

    local unsubscribe = function ()
        y3.py_event_sub.event_unregister(event_name, extra_args)
    end

    return extra_args, callback, unsubscribe
end

-- 临时处理单位伤害一系列事件带来的性能问题，有些东西没有处理，不要合，不要给其他事件用
function M:subscribe_special_event(event_name, callback)
    local config = event_configs.config[event_name]
    local self_type = y3.class.type(self)
    if not config or not self_type then
        error('此事件无法作为对象事件：' .. tostring(event_name))
    end
    if not config or not is_valid_object(self_type, config) then
        error('此事件无法作为对象事件：' .. tostring(event_name))
    end
    local trigger = self.object_event_manager:event(event_name, {self}, callback)
    local seq = self.handle:reg_event(config.key, function (py_event_name, actor, data)
        local event_data = event_datas[py_event_name]
        ---@diagnostic disable-next-line: invisible
        local lua_params = y3.py_event_sub.convert_py_params_lazy(py_event_name, event_data, data)
        callback(trigger, lua_params)
    end)

    local unsubscribe = function ()
        self.handle:unreg_event(seq)
    end
    ---@diagnostic disable-next-line: invisible
    trigger:on_remove(unsubscribe)
    
    local gcHost = self --[[@as GCHost]]
    if gcHost.bindGC then
        gcHost:bindGC(New 'GCBuffer' (0, trigger))
    end
    return trigger
end

local function get_master(datas, config, lua_params)
    local master = config.master
    if master then
        return lua_params[master]
    end
    for _, data in ipairs(datas) do
        if data.lua_type == config.object then
            master = data.lua_name
            config.master = master
            return lua_params[data.lua_name]
        end
    end
end

local function event_notify(event_name, extra_args, lua_params)
    local config = event_configs.config[event_name]
    if not config or not config.object then
        return
    end
    local datas = event_datas[config.key]
    local master = get_master(datas, config, lua_params)
    if not master then
        return
    end
    ---@type EventManager?
    local event_manager = master.object_event_manager
    if event_manager then
        if config.dispatch then
            event_manager:dispatch(event_name, extra_args, lua_params)
        else
            event_manager:notify(event_name, extra_args, lua_params)
        end
    end

    if config.extraObjs then
        for _, data in ipairs(config.extraObjs) do
            local extraMaster = data.getter(master, lua_params)
            if extraMaster then
                ---@type EventManager?
                local extra_event_manager = extraMaster.object_event_manager
                if extra_event_manager then
                    if config.dispatch then
                        extra_event_manager:dispatch(event_name, extra_args, lua_params)
                    else
                        extra_event_manager:notify(event_name, extra_args, lua_params)
                    end
                end
            end
        end
    end
end

return {
    event_notify = event_notify,
}
