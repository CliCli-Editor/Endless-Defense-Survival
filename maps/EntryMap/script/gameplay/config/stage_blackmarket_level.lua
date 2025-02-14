--[[

        stage_blackmarket_level.lua
        exported by excel2lua.py
        from file:stage_blackmarket_level.xlsx

        auto generate by tools, do not modify it!!!

--]]

local _data = {
  [1] = {id = 1,shop_blackmarket_level = 1,shop_blackmarket_next_level_exp = 10000,shop_blackmarket_refresh_block = '5|6',shop_blackmarket_auto_refresh = 300.0,shop_blackmarket_refresh_price = '2#200',},
  [2] = {id = 2,shop_blackmarket_level = 2,shop_blackmarket_next_level_exp = 25000,shop_blackmarket_refresh_block = '5|6|7|8',shop_blackmarket_auto_refresh = 300.0,shop_blackmarket_refresh_price = '2#200',},
  [3] = {id = 3,shop_blackmarket_level = 3,shop_blackmarket_next_level_exp = 50000,shop_blackmarket_refresh_block = '5|6|7|8|9|10',shop_blackmarket_auto_refresh = 300.0,shop_blackmarket_refresh_price = '2#200',},
  [4] = {id = 4,shop_blackmarket_level = 4,shop_blackmarket_next_level_exp = 9999999,shop_blackmarket_refresh_block = '5|6|7|8|9|10|11|12',shop_blackmarket_auto_refresh = 300.0,shop_blackmarket_refresh_price = '2#200',},
}

local id_to_index={
   [1] = 1,
   [2] = 2,
   [3] = 3,
   [4] = 4,
}

local stage_blackmarket_level={}
stage_blackmarket_level.__index=stage_blackmarket_level 

function stage_blackmarket_level.length() 
   return #_data 
end 

function stage_blackmarket_level.indexOf(index) 
 index = tonumber(index) 
  
 local rawData = _data[index] 
 if not rawData then 
 return nil 
 end 
local ret = setmetatable({}, {__index = function(t, k) local value = rawData[k] 
 assert(value,"表中没有这个字段"..k) return rawData[k] end, __newindex = function(t, k, v)end }) 
 return ret 
end 

function stage_blackmarket_level.get(id) 
   
    return stage_blackmarket_level.indexOf(id_to_index[id])
end 

return stage_blackmarket_level