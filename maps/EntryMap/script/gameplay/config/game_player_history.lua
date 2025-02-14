--[[

        game_player_history.lua
        exported by excel2lua.py
        from file:game_player_history.xlsx

        auto generate by tools, do not modify it!!!

--]]

local _data = {
  [1] = {id = 1,game_history_name = GameAPI.get_text_config('#67364957#lua'),game_history_content = '{time}',},
  [2] = {id = 2,game_history_name = GameAPI.get_text_config('#-382479998#lua'),game_history_content = '{num}',},
  [3] = {id = 3,game_history_name = GameAPI.get_text_config('#-966999763#lua'),game_history_content = '{num}',},
  [4] = {id = 4,game_history_name = GameAPI.get_text_config('#-241881987#lua'),game_history_content = '{num}',},
  [5] = {id = 5,game_history_name = GameAPI.get_text_config('#1262442089#lua'),game_history_content = '{num}',},
  [6] = {id = 6,game_history_name = GameAPI.get_text_config('#2133052622#lua'),game_history_content = '{stage_name}',},
}

local id_to_index={
   [1] = 1,
   [2] = 2,
   [3] = 3,
   [4] = 4,
   [5] = 5,
   [6] = 6,
}

local game_player_history={}
game_player_history.__index=game_player_history 

function game_player_history.length() 
   return #_data 
end 

function game_player_history.indexOf(index) 
 index = tonumber(index) 
  
 local rawData = _data[index] 
 if not rawData then 
 return nil 
 end 
local ret = setmetatable({}, {__index = function(t, k) local value = rawData[k] 
 assert(value,"表中没有这个字段"..k) return rawData[k] end, __newindex = function(t, k, v)end }) 
 return ret 
end 

function game_player_history.get(id) 
   
    return game_player_history.indexOf(id_to_index[id])
end 

return game_player_history