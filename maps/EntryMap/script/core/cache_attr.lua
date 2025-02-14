---@diagnostic disable: duplicate-set-field, invisible

---@class Unit
local M = Class "Unit"

local __get_attr = M.get_attr

local function __update_cache_attr(trigger, event, actor, data)
    local id = data.__unit_id
    local unit = y3.unit.ref_manager:get(id)
    if unit then
        unit._cache_attr_list[data.__attr] = unit.handle:api_get_float_attr(data.__attr):float()
    end
end

---获取属性（默认为实际属性）
---@param attr_name y3.Const.UnitAttr
---@param attr_type? '实际' | '额外' | y3.Const.UnitAttrType
---@return number
function M:get_attr(attr_name, attr_type)
    if self._is_hero == nil then
        self._is_hero = self:is_hero()
    end
    if self._is_hero then
        if not self._cache_attr_list then
            self._cache_attr_list = {}
        end
    
        if not self._attr_change_events then
            self._attr_change_events = {}
        end
    
        if attr_type == "实际" or attr_type == nil then
            local actual_name = y3.const.UnitAttr[attr_name] or attr_name
            if not self._cache_attr_list[actual_name] then
                self._cache_attr_list[actual_name] = self.handle:api_get_float_attr(actual_name):float()
            end
    
            if not self._attr_change_events[actual_name] then
                local trigger_id = y3.py_event_sub.next_id()
                local py_trigger = new_global_trigger(trigger_id, "UNIT_ATTR_CHANGE", {"ET_UNIT_ATTR_CHANGE", actual_name}, true, function ()
                    return self.handle
                end)
                py_trigger.on_event = __update_cache_attr
                GameAPI.enable_global_lua_trigger(py_trigger)
                self._attr_change_events[actual_name] = py_trigger
                self:bindGC(
                    function ()
                        local dummy_trigger = new_global_trigger(trigger_id, 'GAME_INIT', 'ET_GAME_INIT', false)
                        GameAPI.enable_global_lua_trigger(dummy_trigger)
                    end
                )
            end
            return self._cache_attr_list[actual_name]
        end
    end
    return __get_attr(self, attr_name, attr_type)
end