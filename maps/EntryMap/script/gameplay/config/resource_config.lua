--[[

        resource_config.lua
        exported by excel2lua.py
        from file:resource_config.xlsx

        auto generate by tools, do not modify it!!!

--]]

local _data = {
  [1] = {id = 1,resource_name = GameAPI.get_text_config('#62285769#lua'),resource_editor_name = 'gold',resource_img = 134234281,},
  [2] = {id = 2,resource_name = GameAPI.get_text_config('#-1791383143#lua'),resource_editor_name = 'diamond',resource_img = 134269438,},
  [3] = {id = 1001,resource_name = '1',resource_editor_name = '',resource_img = -1,},
  [4] = {id = 1002,resource_name = '1',resource_editor_name = '',resource_img = -1,},
  [5] = {id = 1003,resource_name = '1',resource_editor_name = '',resource_img = -1,},
  [6] = {id = 1004,resource_name = '1',resource_editor_name = '',resource_img = -1,},
  [7] = {id = 1005,resource_name = '1',resource_editor_name = '',resource_img = -1,},
  [8] = {id = 1006,resource_name = '1',resource_editor_name = '',resource_img = -1,},
  [9] = {id = 1007,resource_name = '1',resource_editor_name = '',resource_img = -1,},
  [10] = {id = 1008,resource_name = '1',resource_editor_name = '',resource_img = -1,},
  [11] = {id = 1009,resource_name = '1',resource_editor_name = '',resource_img = -1,},
  [12] = {id = 1010,resource_name = '1',resource_editor_name = '',resource_img = -1,},
  [13] = {id = 1011,resource_name = '1',resource_editor_name = '',resource_img = -1,},
}

local id_to_index={
   [1] = 1,
   [2] = 2,
   [1001] = 3,
   [1002] = 4,
   [1003] = 5,
   [1004] = 6,
   [1005] = 7,
   [1006] = 8,
   [1007] = 9,
   [1008] = 10,
   [1009] = 11,
   [1010] = 12,
   [1011] = 13,
}

local resource_config={}
resource_config.__index=resource_config 

function resource_config.length() 
   return #_data 
end 

function resource_config.indexOf(index) 
 index = tonumber(index) 
  
 local rawData = _data[index] 
 if not rawData then 
 return nil 
 end 
local ret = setmetatable({}, {__index = function(t, k) local value = rawData[k] 
 assert(value,"表中没有这个字段"..k) return rawData[k] end, __newindex = function(t, k, v)end }) 
 return ret 
end 

function resource_config.get(id) 
   
    return resource_config.indexOf(id_to_index[id])
end 

return resource_config