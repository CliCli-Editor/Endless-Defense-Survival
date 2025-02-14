--[[

        game_acitivity.lua
        exported by excel2lua.py
        from file:game_acitivity.xlsx

        auto generate by tools, do not modify it!!!

--]]

local _data = {
  [1] = {id = 1,game_activity_name = GameAPI.get_text_config('#-1778767627#lua'),game_activity_type = 1,game_activity_start_time = '',game_activity_end_time = '',game_activity = '',game_activity_args = '1#2001#1500',game_activity_reward = '1#1001#300|1#1001#300|1#1001#300',},
  [2] = {id = 2,game_activity_name = GameAPI.get_text_config('#556801104#lua'),game_activity_type = 2,game_activity_start_time = '',game_activity_end_time = '',game_activity = '',game_activity_args = '',game_activity_reward = '',},
}

local id_to_index={
   [1] = 1,
   [2] = 2,
}

local game_acitivity={}
game_acitivity.__index=game_acitivity 

function game_acitivity.length() 
   return #_data 
end 

function game_acitivity.indexOf(index) 
 index = tonumber(index) 
  
 local rawData = _data[index] 
 if not rawData then 
 return nil 
 end 
local ret = setmetatable({}, {__index = function(t, k) local value = rawData[k] 
 assert(value,"表中没有这个字段"..k) return rawData[k] end, __newindex = function(t, k, v)end }) 
 return ret 
end 

function game_acitivity.get(id) 
   
    return game_acitivity.indexOf(id_to_index[id])
end 

return game_acitivity