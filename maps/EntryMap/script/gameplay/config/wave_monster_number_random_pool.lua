--[[

        wave_monster_number_random_pool.lua
        exported by excel2lua.py
        from file:wave_monster_number_random_pool.xlsx

        auto generate by tools, do not modify it!!!

--]]

local _data = {
  [1] = {id = 1,pool_id = 2,content = GameAPI.get_text_config('#-1464723291#lua'),number = 1,weight = 100,},
  [2] = {id = 2,pool_id = 3,content = GameAPI.get_text_config('#-512470767#lua'),number = 5,weight = 100,},
  [3] = {id = 3,pool_id = 4,content = GameAPI.get_text_config('#846720120#lua'),number = 1,weight = 100,},
  [4] = {id = 4,pool_id = 101,content = GameAPI.get_text_config('#1197767913#lua'),number = 1,weight = 750,},
  [5] = {id = 5,pool_id = 101,content = GameAPI.get_text_config('#-498662114#lua'),number = 2,weight = 250,},
  [6] = {id = 6,pool_id = 101,content = '',number = 3,weight = 0,},
  [7] = {id = 7,pool_id = 101,content = '',number = 4,weight = 0,},
  [8] = {id = 8,pool_id = 102,content = GameAPI.get_text_config('#1197767913#lua'),number = 1,weight = 600,},
  [9] = {id = 9,pool_id = 102,content = GameAPI.get_text_config('#-1199264343#lua'),number = 2,weight = 200,},
  [10] = {id = 10,pool_id = 102,content = '',number = 3,weight = 100,},
  [11] = {id = 11,pool_id = 102,content = '',number = 4,weight = 100,},
  [12] = {id = 12,pool_id = 103,content = GameAPI.get_text_config('#-124941549#lua'),number = 1,weight = 400,},
  [13] = {id = 13,pool_id = 103,content = GameAPI.get_text_config('#505203550#lua'),number = 2,weight = 300,},
  [14] = {id = 14,pool_id = 103,content = '',number = 3,weight = 200,},
  [15] = {id = 15,pool_id = 103,content = '',number = 4,weight = 100,},
  [16] = {id = 16,pool_id = 104,content = GameAPI.get_text_config('#-982614807#lua'),number = 1,weight = 200,},
  [17] = {id = 17,pool_id = 104,content = '13+',number = 2,weight = 400,},
  [18] = {id = 18,pool_id = 104,content = '',number = 3,weight = 300,},
  [19] = {id = 19,pool_id = 104,content = '',number = 4,weight = 100,},
}

local id_to_index={
   [1] = 1,
   [2] = 2,
   [3] = 3,
   [4] = 4,
   [5] = 5,
   [6] = 6,
   [7] = 7,
   [8] = 8,
   [9] = 9,
   [10] = 10,
   [11] = 11,
   [12] = 12,
   [13] = 13,
   [14] = 14,
   [15] = 15,
   [16] = 16,
   [17] = 17,
   [18] = 18,
   [19] = 19,
}

local wave_monster_number_random_pool={}
wave_monster_number_random_pool.__index=wave_monster_number_random_pool 

function wave_monster_number_random_pool.length() 
   return #_data 
end 

function wave_monster_number_random_pool.indexOf(index) 
 index = tonumber(index) 
  
 local rawData = _data[index] 
 if not rawData then 
 return nil 
 end 
local ret = setmetatable({}, {__index = function(t, k) local value = rawData[k] 
 assert(value,"表中没有这个字段"..k) return rawData[k] end, __newindex = function(t, k, v)end }) 
 return ret 
end 

function wave_monster_number_random_pool.get(id) 
   
    return wave_monster_number_random_pool.indexOf(id_to_index[id])
end 

return wave_monster_number_random_pool