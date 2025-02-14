--[[

        random_pool_guarant.lua
        exported by excel2lua.py
        from file:random_pool_guarant.xlsx

        auto generate by tools, do not modify it!!!

--]]

local _data = {
}

local id_to_index={
}

local random_pool_guarant={}
random_pool_guarant.__index=random_pool_guarant 

function random_pool_guarant.length() 
   return #_data 
end 

function random_pool_guarant.indexOf(index) 
 index = tonumber(index) 
  
 local rawData = _data[index] 
 if not rawData then 
 return nil 
 end 
local ret = setmetatable({}, {__index = function(t, k) local value = rawData[k] 
 assert(value,"表中没有这个字段"..k) return rawData[k] end, __newindex = function(t, k, v)end }) 
 return ret 
end 

function random_pool_guarant.get(id) 
   
    return random_pool_guarant.indexOf(id_to_index[id])
end 

return random_pool_guarant