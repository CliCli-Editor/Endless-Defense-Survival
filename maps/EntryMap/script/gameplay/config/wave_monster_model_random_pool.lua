--[[

        wave_monster_model_random_pool.lua
        exported by excel2lua.py
        from file:wave_monster_model_random_pool.xlsx

        auto generate by tools, do not modify it!!!

--]]

local _data = {
  [1] = {id = 1,pool_id = 100,content = '',model = 206847,weight = 100,},
  [2] = {id = 2,pool_id = 100,content = '',model = 206853,weight = 100,},
  [3] = {id = 3,pool_id = 100,content = '',model = 206860,weight = 100,},
  [4] = {id = 4,pool_id = 100,content = '',model = 206625,weight = 100,},
  [5] = {id = 5,pool_id = 101,content = '',model = 206625,weight = 100,},
}

local id_to_index={
   [1] = 1,
   [2] = 2,
   [3] = 3,
   [4] = 4,
   [5] = 5,
}

local wave_monster_model_random_pool={}
wave_monster_model_random_pool.__index=wave_monster_model_random_pool 

function wave_monster_model_random_pool.length() 
   return #_data 
end 

function wave_monster_model_random_pool.indexOf(index) 
 index = tonumber(index) 
  
 local rawData = _data[index] 
 if not rawData then 
 return nil 
 end 
local ret = setmetatable({}, {__index = function(t, k) local value = rawData[k] 
 assert(value,"表中没有这个字段"..k) return rawData[k] end, __newindex = function(t, k, v)end }) 
 return ret 
end 

function wave_monster_model_random_pool.get(id) 
   
    return wave_monster_model_random_pool.indexOf(id_to_index[id])
end 

return wave_monster_model_random_pool