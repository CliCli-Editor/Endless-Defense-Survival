--[[

        game_guide_trigger.lua
        exported by excel2lua.py
        from file:game_guide_trigger.xlsx

        auto generate by tools, do not modify it!!!

--]]

local _data = {
  [1] = {id = 1,guide_trigger_type = '1|1001',guide_trigger_module_id = 1,},
}

local id_to_index={
   [1] = 1,
}

local game_guide_trigger={}
game_guide_trigger.__index=game_guide_trigger 

function game_guide_trigger.length() 
   return #_data 
end 

function game_guide_trigger.indexOf(index) 
 index = tonumber(index) 
  
 local rawData = _data[index] 
 if not rawData then 
 return nil 
 end 
local ret = setmetatable({}, {__index = function(t, k) local value = rawData[k] 
 assert(value,"表中没有这个字段"..k) return rawData[k] end, __newindex = function(t, k, v)end }) 
 return ret 
end 

function game_guide_trigger.get(id) 
   
    return game_guide_trigger.indexOf(id_to_index[id])
end 

return game_guide_trigger