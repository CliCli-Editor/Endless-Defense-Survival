--[[

        cdk.lua
        exported by excel2lua.py
        from file:cdk.xlsx

        auto generate by tools, do not modify it!!!

--]]

local _data = {
  [1] = {id = 1,type = 1,key = 'WXHLQQQUN',reward = '2#20302#1',not_ = GameAPI.get_text_config('#-1127000067#lua'),},
}

local id_to_index={
   [1] = 1,
}

local cdk={}
cdk.__index=cdk 

function cdk.length() 
   return #_data 
end 

function cdk.indexOf(index) 
 index = tonumber(index) 
  
 local rawData = _data[index] 
 if not rawData then 
 return nil 
 end 
local ret = setmetatable({}, {__index = function(t, k) local value = rawData[k] 
 assert(value,"表中没有这个字段"..k) return rawData[k] end, __newindex = function(t, k, v)end }) 
 return ret 
end 

function cdk.get(id) 
   
    return cdk.indexOf(id_to_index[id])
end 

return cdk