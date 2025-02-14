--[[

        stage_funcation_unlock.lua
        exported by excel2lua.py
        from file:stage_funcation_unlock.xlsx

        auto generate by tools, do not modify it!!!

--]]

local _data = {
  [1] = {id = 1,stage_funcation = 'blackmarket',stage_funcation_name = GameAPI.get_text_config('#1146230751#lua'),stage_funcation_unlock = '1#10',stage_funcation_unlock_notice_id = 46,},
  [2] = {id = 2,stage_funcation = 'towersoulTech',stage_funcation_name = GameAPI.get_text_config('#1671577707#lua'),stage_funcation_unlock = '1#2',stage_funcation_unlock_notice_id = 47,},
  [3] = {id = 3,stage_funcation = 'abyss',stage_funcation_name = GameAPI.get_text_config('#1730502700#lua'),stage_funcation_unlock = '3#15',stage_funcation_unlock_notice_id = 48,},
}

local id_to_index={
   [1] = 1,
   [2] = 2,
   [3] = 3,
}

local stage_funcation_unlock={}
stage_funcation_unlock.__index=stage_funcation_unlock 

function stage_funcation_unlock.length() 
   return #_data 
end 

function stage_funcation_unlock.indexOf(index) 
 index = tonumber(index) 
  
 local rawData = _data[index] 
 if not rawData then 
 return nil 
 end 
local ret = setmetatable({}, {__index = function(t, k) local value = rawData[k] 
 assert(value,"表中没有这个字段"..k) return rawData[k] end, __newindex = function(t, k, v)end }) 
 return ret 
end 

function stage_funcation_unlock.get(id) 
   
    return stage_funcation_unlock.indexOf(id_to_index[id])
end 

return stage_funcation_unlock