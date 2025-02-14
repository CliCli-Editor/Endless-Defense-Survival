--[[

        stage_task_desc.lua
        exported by excel2lua.py
        from file:stage_task_desc.xlsx

        auto generate by tools, do not modify it!!!

--]]

local _data = {
  [1] = {id = 1,stage_task_target_desc = GameAPI.get_text_config('#-1364487938#lua'),},
  [2] = {id = 2,stage_task_target_desc = GameAPI.get_text_config('#325408920#lua'),},
  [3] = {id = 3,stage_task_target_desc = GameAPI.get_text_config('#1898479516#lua'),},
  [4] = {id = 4,stage_task_target_desc = GameAPI.get_text_config('#72922617#lua'),},
  [5] = {id = 5,stage_task_target_desc = GameAPI.get_text_config('#584366561#lua'),},
  [6] = {id = 6,stage_task_target_desc = GameAPI.get_text_config('#-729219274#lua'),},
  [7] = {id = 7,stage_task_target_desc = GameAPI.get_text_config('#-896959663#lua'),},
  [8] = {id = 8,stage_task_target_desc = GameAPI.get_text_config('#-1922791874#lua'),},
  [9] = {id = 9,stage_task_target_desc = '',},
  [10] = {id = 10,stage_task_target_desc = GameAPI.get_text_config('#977061718#lua'),},
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
}

local stage_task_desc={}
stage_task_desc.__index=stage_task_desc 

function stage_task_desc.length() 
   return #_data 
end 

function stage_task_desc.indexOf(index) 
 index = tonumber(index) 
  
 local rawData = _data[index] 
 if not rawData then 
 return nil 
 end 
local ret = setmetatable({}, {__index = function(t, k) local value = rawData[k] 
 assert(value,"表中没有这个字段"..k) return rawData[k] end, __newindex = function(t, k, v)end }) 
 return ret 
end 

function stage_task_desc.get(id) 
   
    return stage_task_desc.indexOf(id_to_index[id])
end 

return stage_task_desc