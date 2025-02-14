--[[

        stage_shop_helper_lable.lua
        exported by excel2lua.py
        from file:stage_shop_helper_lable.xlsx

        auto generate by tools, do not modify it!!!

--]]

local _data = {
  [1] = {id = 1,shop_helper_lable_type = 1,shop_helper_lable_name = GameAPI.get_text_config('#827834880#lua'),},
  [2] = {id = 2,shop_helper_lable_type = 1,shop_helper_lable_name = GameAPI.get_text_config('#220769121#lua'),},
  [3] = {id = 3,shop_helper_lable_type = 1,shop_helper_lable_name = GameAPI.get_text_config('#-440483825#lua'),},
  [4] = {id = 4,shop_helper_lable_type = 1,shop_helper_lable_name = GameAPI.get_text_config('#673154106#lua'),},
  [5] = {id = 5,shop_helper_lable_type = 1,shop_helper_lable_name = GameAPI.get_text_config('#-448889043#lua'),},
  [6] = {id = 100,shop_helper_lable_type = 2,shop_helper_lable_name = GameAPI.get_text_config('#602204774#lua'),},
  [7] = {id = 101,shop_helper_lable_type = 2,shop_helper_lable_name = GameAPI.get_text_config('#1080023892#lua'),},
  [8] = {id = 102,shop_helper_lable_type = 2,shop_helper_lable_name = GameAPI.get_text_config('#2055542538#lua'),},
  [9] = {id = 103,shop_helper_lable_type = 2,shop_helper_lable_name = GameAPI.get_text_config('#219863649#lua'),},
  [10] = {id = 104,shop_helper_lable_type = 2,shop_helper_lable_name = GameAPI.get_text_config('#934375639#lua'),},
  [11] = {id = 105,shop_helper_lable_type = 2,shop_helper_lable_name = GameAPI.get_text_config('#60827849#lua'),},
  [12] = {id = 106,shop_helper_lable_type = 2,shop_helper_lable_name = GameAPI.get_text_config('#100588946#lua'),},
  [13] = {id = 107,shop_helper_lable_type = 2,shop_helper_lable_name = GameAPI.get_text_config('#-1780233803#lua'),},
  [14] = {id = 108,shop_helper_lable_type = 2,shop_helper_lable_name = GameAPI.get_text_config('#967661869#lua'),},
  [15] = {id = 109,shop_helper_lable_type = 2,shop_helper_lable_name = GameAPI.get_text_config('#-689571847#lua'),},
  [16] = {id = 200,shop_helper_lable_type = 3,shop_helper_lable_name = GameAPI.get_text_config('#-1370888858#lua'),},
  [17] = {id = 201,shop_helper_lable_type = 3,shop_helper_lable_name = GameAPI.get_text_config('#-1175983648#lua'),},
  [18] = {id = 202,shop_helper_lable_type = 3,shop_helper_lable_name = GameAPI.get_text_config('#-1462055751#lua'),},
  [19] = {id = 203,shop_helper_lable_type = 3,shop_helper_lable_name = GameAPI.get_text_config('#-2116435450#lua'),},
  [20] = {id = 204,shop_helper_lable_type = 3,shop_helper_lable_name = GameAPI.get_text_config('#-905276372#lua'),},
  [21] = {id = 205,shop_helper_lable_type = 3,shop_helper_lable_name = GameAPI.get_text_config('#915323723#lua'),},
  [22] = {id = 401,shop_helper_lable_type = 4,shop_helper_lable_name = GameAPI.get_text_config('#-761469180#lua'),},
  [23] = {id = 402,shop_helper_lable_type = 4,shop_helper_lable_name = GameAPI.get_text_config('#225958054#lua'),},
  [24] = {id = 403,shop_helper_lable_type = 4,shop_helper_lable_name = GameAPI.get_text_config('#-1834671662#lua'),},
  [25] = {id = 404,shop_helper_lable_type = 4,shop_helper_lable_name = GameAPI.get_text_config('#-2025214980#lua'),},
}

local id_to_index={
   [1] = 1,
   [2] = 2,
   [3] = 3,
   [4] = 4,
   [5] = 5,
   [100] = 6,
   [101] = 7,
   [102] = 8,
   [103] = 9,
   [104] = 10,
   [105] = 11,
   [106] = 12,
   [107] = 13,
   [108] = 14,
   [109] = 15,
   [200] = 16,
   [201] = 17,
   [202] = 18,
   [203] = 19,
   [204] = 20,
   [205] = 21,
   [401] = 22,
   [402] = 23,
   [403] = 24,
   [404] = 25,
}

local stage_shop_helper_lable={}
stage_shop_helper_lable.__index=stage_shop_helper_lable 

function stage_shop_helper_lable.length() 
   return #_data 
end 

function stage_shop_helper_lable.indexOf(index) 
 index = tonumber(index) 
  
 local rawData = _data[index] 
 if not rawData then 
 return nil 
 end 
local ret = setmetatable({}, {__index = function(t, k) local value = rawData[k] 
 assert(value,"表中没有这个字段"..k) return rawData[k] end, __newindex = function(t, k, v)end }) 
 return ret 
end 

function stage_shop_helper_lable.get(id) 
   
    return stage_shop_helper_lable.indexOf(id_to_index[id])
end 

return stage_shop_helper_lable