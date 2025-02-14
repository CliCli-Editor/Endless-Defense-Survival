--[[

        game_guide.lua
        exported by excel2lua.py
        from file:game_guide.xlsx

        auto generate by tools, do not modify it!!!

--]]

local _data = {
  [1] = {id = 1,guide_module_id = 1,guide_step_enter = '',guide_step_id = 1,guide_step_next_id = 2,guide_step_sever_refresh = -1,guide_step_type = -1,guide_step_hide_time = -1,guide_step_block = -1,guide_step_block_args = '',guide_step_block_offset = '',guide_step_text = '',guide_step_complete_type = '',},
  [2] = {id = 2,guide_module_id = 1,guide_step_enter = '',guide_step_id = 2,guide_step_next_id = 3,guide_step_sever_refresh = -1,guide_step_type = -1,guide_step_hide_time = -1,guide_step_block = -1,guide_step_block_args = '',guide_step_block_offset = '',guide_step_text = '',guide_step_complete_type = '',},
  [3] = {id = 3,guide_module_id = 1,guide_step_enter = '',guide_step_id = 3,guide_step_next_id = 4,guide_step_sever_refresh = -1,guide_step_type = -1,guide_step_hide_time = -1,guide_step_block = -1,guide_step_block_args = '',guide_step_block_offset = '',guide_step_text = '',guide_step_complete_type = '',},
  [4] = {id = 4,guide_module_id = 1,guide_step_enter = '',guide_step_id = 4,guide_step_next_id = 5,guide_step_sever_refresh = -1,guide_step_type = -1,guide_step_hide_time = -1,guide_step_block = -1,guide_step_block_args = '',guide_step_block_offset = '',guide_step_text = '',guide_step_complete_type = '',},
  [5] = {id = 5,guide_module_id = 1,guide_step_enter = '',guide_step_id = 5,guide_step_next_id = 6,guide_step_sever_refresh = -1,guide_step_type = -1,guide_step_hide_time = -1,guide_step_block = -1,guide_step_block_args = '',guide_step_block_offset = '',guide_step_text = '',guide_step_complete_type = '',},
  [6] = {id = 6,guide_module_id = 1,guide_step_enter = '',guide_step_id = 6,guide_step_next_id = 7,guide_step_sever_refresh = -1,guide_step_type = -1,guide_step_hide_time = -1,guide_step_block = -1,guide_step_block_args = '',guide_step_block_offset = '',guide_step_text = '',guide_step_complete_type = '',},
  [7] = {id = 7,guide_module_id = 1,guide_step_enter = '',guide_step_id = 7,guide_step_next_id = 8,guide_step_sever_refresh = -1,guide_step_type = -1,guide_step_hide_time = -1,guide_step_block = -1,guide_step_block_args = '',guide_step_block_offset = '',guide_step_text = '',guide_step_complete_type = '',},
  [8] = {id = 8,guide_module_id = 1,guide_step_enter = '',guide_step_id = 8,guide_step_next_id = 9,guide_step_sever_refresh = -1,guide_step_type = -1,guide_step_hide_time = -1,guide_step_block = -1,guide_step_block_args = '',guide_step_block_offset = '',guide_step_text = '',guide_step_complete_type = '',},
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
}

local game_guide={}
game_guide.__index=game_guide 

function game_guide.length() 
   return #_data 
end 

function game_guide.indexOf(index) 
 index = tonumber(index) 
  
 local rawData = _data[index] 
 if not rawData then 
 return nil 
 end 
local ret = setmetatable({}, {__index = function(t, k) local value = rawData[k] 
 assert(value,"表中没有这个字段"..k) return rawData[k] end, __newindex = function(t, k, v)end }) 
 return ret 
end 

function game_guide.get(id) 
   
    return game_guide.indexOf(id_to_index[id])
end 

return game_guide