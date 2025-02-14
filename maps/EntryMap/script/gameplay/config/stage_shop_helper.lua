--[[

        stage_shop_helper.lua
        exported by excel2lua.py
        from file:stage_shop_helper.xlsx

        auto generate by tools, do not modify it!!!

--]]

local _data = {
  [1] = {id = 1,shop_helper_name = '系统默认',shop_helper_weapon_type = '',shop_helper_damage_addition_lable = '',shop_helper_normal_addition_lable = '',shop_helper_quality = '4|3|2|1',},
}

local id_to_index={
   [1] = 1,
}

local stage_shop_helper={}
stage_shop_helper.__index=stage_shop_helper 

function stage_shop_helper.length() 
   return #_data 
end 

function stage_shop_helper.indexOf(index) 
 index = tonumber(index) 
  
 local rawData = _data[index] 
 if not rawData then 
 return nil 
 end 
local ret = setmetatable({}, {__index = function(t, k) local value = rawData[k] 
 assert(value,"表中没有这个字段"..k) return rawData[k] end, __newindex = function(t, k, v)end }) 
 return ret 
end 

function stage_shop_helper.get(id) 
   
    return stage_shop_helper.indexOf(id_to_index[id])
end 

return stage_shop_helper