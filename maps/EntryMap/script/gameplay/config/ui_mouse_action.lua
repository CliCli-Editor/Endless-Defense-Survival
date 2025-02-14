--[[

        ui_mouse_action.lua
        exported by excel2lua.py
        from file:ui_mouse_action.xlsx

        auto generate by tools, do not modify it!!!

--]]

local _data = {
  [1] = {id = 1,element_id = 'a3ba783e-38c8-4657-b6f9-e375d1024dfa',element_action = 3,content = GameAPI.get_text_config('#-1407562214#lua'),},
  [2] = {id = 2,element_id = 'dd55d0b6-2118-4b5a-b834-b5d48df498c9',element_action = 3,content = GameAPI.get_text_config('#-585579628#lua'),},
  [3] = {id = 3,element_id = '22eb9b64-9085-4ebb-891f-bffaafc55bfe',element_action = 2,content = GameAPI.get_text_config('#-1021705234#lua'),},
  [4] = {id = 4,element_id = '751cb00e-d323-4675-a5e6-afb4dccf0985',element_action = 1,content = '',},
  [5] = {id = 5,element_id = 'e4d0551b-efc0-43f9-a0a2-8dc78548d60e',element_action = 2,content = '',},
  [6] = {id = 6,element_id = '31e903e2-9ef3-4993-8567-aea7b53881ad',element_action = 4,content = GameAPI.get_text_config('#-732315520#lua'),},
  [7] = {id = 7,element_id = 'fdb35b9e-6025-4747-8a54-5b80ebee326a',element_action = 4,content = GameAPI.get_text_config('#1642165048#lua'),},
  [8] = {id = 8,element_id = '507a532f-7ecc-4485-9110-fe345d69aa11',element_action = 4,content = GameAPI.get_text_config('#-1015559891#lua'),},
  [9] = {id = 9,element_id = '14100aab-ffbf-4cbc-945b-e9a360f80de8',element_action = 4,content = GameAPI.get_text_config('#173272894#lua'),},
  [10] = {id = 10,element_id = '8a136a72-49b8-4b27-9422-630eeaf6faf6',element_action = 4,content = GameAPI.get_text_config('#1992209730#lua'),},
  [11] = {id = 11,element_id = 'c11948d8-7f75-4d4f-ae09-b7300c03d06b',element_action = 4,content = GameAPI.get_text_config('#628263607#lua'),},
  [12] = {id = 12,element_id = '2b14c07e-cbbf-41ac-8ad8-fab06a411210',element_action = 4,content = GameAPI.get_text_config('#1136607466#lua'),},
  [13] = {id = 13,element_id = 'ca7fc96b-8e37-4445-ae2b-07e21e694e7c',element_action = 4,content = GameAPI.get_text_config('#-660077537#lua'),},
  [14] = {id = 14,element_id = 'bcce930f-07a1-4742-a2f6-fe6532ebd2c1',element_action = 4,content = GameAPI.get_text_config('#-1053463034#lua'),},
  [15] = {id = 15,element_id = '78add718-572c-403c-bfaf-79a1c68d58ab',element_action = 4,content = GameAPI.get_text_config('#1469646323#lua'),},
  [16] = {id = 16,element_id = '0058230a-0159-4176-bfa0-42805289e4aa',element_action = 4,content = GameAPI.get_text_config('#-365329091#lua'),},
  [17] = {id = 17,element_id = '26bc72f7-1f47-42a1-b2f9-8b019931ea2b',element_action = 4,content = GameAPI.get_text_config('#1196927327#lua'),},
  [18] = {id = 18,element_id = '1cf84a42-6c7e-48b0-b6c3-d4f51baef3a6',element_action = 4,content = GameAPI.get_text_config('#-364499695#lua'),},
  [19] = {id = 19,element_id = 'ef111a6a-bc48-414a-b4c3-6542e64aa57e',element_action = 4,content = GameAPI.get_text_config('#595465200#lua'),},
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

local ui_mouse_action={}
ui_mouse_action.__index=ui_mouse_action 

function ui_mouse_action.length() 
   return #_data 
end 

function ui_mouse_action.indexOf(index) 
 index = tonumber(index) 
  
 local rawData = _data[index] 
 if not rawData then 
 return nil 
 end 
local ret = setmetatable({}, {__index = function(t, k) local value = rawData[k] 
 assert(value,"表中没有这个字段"..k) return rawData[k] end, __newindex = function(t, k, v)end }) 
 return ret 
end 

function ui_mouse_action.get(id) 
   
    return ui_mouse_action.indexOf(id_to_index[id])
end 

return ui_mouse_action