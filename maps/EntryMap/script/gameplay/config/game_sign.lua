--[[

        game_sign.lua
        exported by excel2lua.py
        from file:game_sign.xlsx

        auto generate by tools, do not modify it!!!

--]]

local _data = {
  [1] = {id = 1,game_sign_type = 1,game_sign_day = 1,game_sign_reward = '',},
  [2] = {id = 2,game_sign_type = 1,game_sign_day = 2,game_sign_reward = '',},
  [3] = {id = 3,game_sign_type = 1,game_sign_day = 3,game_sign_reward = '',},
  [4] = {id = 4,game_sign_type = 1,game_sign_day = 4,game_sign_reward = '',},
  [5] = {id = 5,game_sign_type = 1,game_sign_day = 5,game_sign_reward = '',},
  [6] = {id = 6,game_sign_type = 1,game_sign_day = 6,game_sign_reward = '',},
  [7] = {id = 7,game_sign_type = 1,game_sign_day = 7,game_sign_reward = '',},
}

local id_to_index={
   [1] = 1,
   [2] = 2,
   [3] = 3,
   [4] = 4,
   [5] = 5,
   [6] = 6,
   [7] = 7,
}

local game_sign={}
game_sign.__index=game_sign 

function game_sign.length() 
   return #_data 
end 

function game_sign.indexOf(index) 
 index = tonumber(index) 
  
 local rawData = _data[index] 
 if not rawData then 
 return nil 
 end 
local ret = setmetatable({}, {__index = function(t, k) local value = rawData[k] 
 assert(value,"表中没有这个字段"..k) return rawData[k] end, __newindex = function(t, k, v)end }) 
 return ret 
end 

function game_sign.get(id) 
   
    return game_sign.indexOf(id_to_index[id])
end 

return game_sign