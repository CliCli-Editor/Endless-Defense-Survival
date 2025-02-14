--[[

        game_function_state.lua
        exported by excel2lua.py
        from file:game_function_state.xlsx

        auto generate by tools, do not modify it!!!

--]]

local _data = {
  [1] = {id = 1,game_function_name = GameAPI.get_text_config('#1398355645#lua'),game_function_state = 1,},
  [2] = {id = 2,game_function_name = GameAPI.get_text_config('#-1859245536#lua'),game_function_state = 1,},
  [3] = {id = 3,game_function_name = GameAPI.get_text_config('#891910886#lua'),game_function_state = 1,},
  [4] = {id = 4,game_function_name = GameAPI.get_text_config('#-1338857514#lua'),game_function_state = 1,},
  [5] = {id = 5,game_function_name = GameAPI.get_text_config('#948637298#lua'),game_function_state = 1,},
  [6] = {id = 6,game_function_name = GameAPI.get_text_config('#41132210#lua'),game_function_state = 1,},
  [7] = {id = 7,game_function_name = GameAPI.get_text_config('#98999628#lua'),game_function_state = 1,},
  [8] = {id = 8,game_function_name = GameAPI.get_text_config('#1361287201#lua'),game_function_state = 1,},
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

local game_function_state={}
game_function_state.__index=game_function_state 

function game_function_state.length() 
   return #_data 
end 

function game_function_state.indexOf(index) 
 index = tonumber(index) 
  
 local rawData = _data[index] 
 if not rawData then 
 return nil 
 end 
local ret = setmetatable({}, {__index = function(t, k) local value = rawData[k] 
 assert(value,"表中没有这个字段"..k) return rawData[k] end, __newindex = function(t, k, v)end }) 
 return ret 
end 

function game_function_state.get(id) 
   
    return game_function_state.indexOf(id_to_index[id])
end 

return game_function_state