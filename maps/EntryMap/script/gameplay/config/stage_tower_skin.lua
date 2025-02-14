--[[

        stage_tower_skin.lua
        exported by excel2lua.py
        from file:stage_tower_skin.xlsx

        auto generate by tools, do not modify it!!!

--]]

local _data = {
  [1] = {id = 1,tower_skin_name = GameAPI.get_text_config('#2087970804#lua'),tower_skin_quality = 5,tower_skin_model_id = 134252125,tower_skin_icon = 100030002,tower_skin_list_icon = 100030003,tower_skin_acquire = GameAPI.get_text_config('#-1239646624#lua'),tower_desc = GameAPI.get_text_config('#-1239646624#lua'),tower_skin_equip_attr_pack = 'tower_skin_1_1',tower_skin_possess_attr_pack = 'tower_skin_1_2',tower_skin_scale = 1.0,},
  [2] = {id = 2,tower_skin_name = GameAPI.get_text_config('#1196575005#lua'),tower_skin_quality = 5,tower_skin_model_id = 134235437,tower_skin_icon = 100050002,tower_skin_list_icon = 100050003,tower_skin_acquire = GameAPI.get_text_config('#531763283#lua'),tower_desc = GameAPI.get_text_config('#531763283#lua'),tower_skin_equip_attr_pack = 'tower_skin_2_1',tower_skin_possess_attr_pack = 'tower_skin_2_2',tower_skin_scale = 2.0,},
  [3] = {id = 3,tower_skin_name = GameAPI.get_text_config('#-705538472#lua'),tower_skin_quality = 4,tower_skin_model_id = 134269324,tower_skin_icon = 100110002,tower_skin_list_icon = 100110003,tower_skin_acquire = GameAPI.get_text_config('#-1949030341#lua'),tower_desc = GameAPI.get_text_config('#-1949030341#lua'),tower_skin_equip_attr_pack = 'tower_skin_3_1',tower_skin_possess_attr_pack = 'tower_skin_3_2',tower_skin_scale = 1.0,},
  [4] = {id = 4,tower_skin_name = GameAPI.get_text_config('#-568241531#lua'),tower_skin_quality = 4,tower_skin_model_id = 134218985,tower_skin_icon = 100150002,tower_skin_list_icon = 100150003,tower_skin_acquire = GameAPI.get_text_config('#562294839#lua'),tower_desc = GameAPI.get_text_config('#562294839#lua'),tower_skin_equip_attr_pack = 'tower_skin_4_1',tower_skin_possess_attr_pack = 'tower_skin_4_2',tower_skin_scale = 1.0,},
  [5] = {id = 5,tower_skin_name = GameAPI.get_text_config('#1697745521#lua'),tower_skin_quality = 5,tower_skin_model_id = 134227091,tower_skin_icon = 100090002,tower_skin_list_icon = 100090003,tower_skin_acquire = GameAPI.get_text_config('#-1036697915#lua'),tower_desc = GameAPI.get_text_config('#-1036697915#lua'),tower_skin_equip_attr_pack = 'tower_skin_5_1',tower_skin_possess_attr_pack = 'tower_skin_5_2',tower_skin_scale = 1.0,},
  [6] = {id = 6,tower_skin_name = GameAPI.get_text_config('#-624364723#lua'),tower_skin_quality = 4,tower_skin_model_id = 134234524,tower_skin_icon = 100140002,tower_skin_list_icon = 100140003,tower_skin_acquire = GameAPI.get_text_config('#834672231#lua'),tower_desc = GameAPI.get_text_config('#834672231#lua'),tower_skin_equip_attr_pack = 'tower_skin_6_1',tower_skin_possess_attr_pack = 'tower_skin_6_2',tower_skin_scale = 1.0,},
  [7] = {id = 7,tower_skin_name = GameAPI.get_text_config('#-2111430004#lua'),tower_skin_quality = 3,tower_skin_model_id = 134273097,tower_skin_icon = 100060002,tower_skin_list_icon = 100060003,tower_skin_acquire = GameAPI.get_text_config('#-602331299#lua'),tower_desc = GameAPI.get_text_config('#-602331299#lua'),tower_skin_equip_attr_pack = 'tower_skin_7_1',tower_skin_possess_attr_pack = 'tower_skin_7_2',tower_skin_scale = 1.0,},
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

local stage_tower_skin={}
stage_tower_skin.__index=stage_tower_skin 

function stage_tower_skin.length() 
   return #_data 
end 

function stage_tower_skin.indexOf(index) 
 index = tonumber(index) 
  
 local rawData = _data[index] 
 if not rawData then 
 return nil 
 end 
local ret = setmetatable({}, {__index = function(t, k) local value = rawData[k] 
 assert(value,"表中没有这个字段"..k) return rawData[k] end, __newindex = function(t, k, v)end }) 
 return ret 
end 

function stage_tower_skin.get(id) 
   
    return stage_tower_skin.indexOf(id_to_index[id])
end 

return stage_tower_skin