--[[

        hero.lua
        exported by excel2lua.py
        from file:hero.xlsx

        auto generate by tools, do not modify it!!!

--]]

local _data = {
  [1] = {id = 1,name = GameAPI.get_text_config('#-1763841694#lua'),quality = 4,editor_id = 206238,hero_icon = 110010001,hero_desc = GameAPI.get_text_config('#-245960980#lua'),hero_talent_skill_group = '40003',hero_skill_id = 41001,attr_pack = 'hero_primary_10001',default_own = 1,hero_atk_type = -1,hero_atk_range = 450.0,model_scale = 1.0,},
  [2] = {id = 2,name = GameAPI.get_text_config('#-1575982206#lua'),quality = 4,editor_id = 206623,hero_icon = 110020001,hero_desc = GameAPI.get_text_config('#-592685688#lua'),hero_talent_skill_group = '40003',hero_skill_id = 41002,attr_pack = 'hero_primary_10001',default_own = 1,hero_atk_type = 1,hero_atk_range = 1100.0,model_scale = 1.0,},
  [3] = {id = 3,name = GameAPI.get_text_config('#-474707598#lua'),quality = 4,editor_id = 208217,hero_icon = 110030001,hero_desc = GameAPI.get_text_config('#-592685688#lua'),hero_talent_skill_group = '40003',hero_skill_id = 41003,attr_pack = 'hero_primary_10001',default_own = 1,hero_atk_type = 1,hero_atk_range = 1100.0,model_scale = 1.0,},
  [4] = {id = 4,name = GameAPI.get_text_config('#849505832#lua'),quality = 4,editor_id = 208203,hero_icon = 110040001,hero_desc = GameAPI.get_text_config('#-592685688#lua'),hero_talent_skill_group = '40003',hero_skill_id = 41004,attr_pack = 'hero_primary_10001',default_own = 1,hero_atk_type = 1,hero_atk_range = 1100.0,model_scale = 1.0,},
  [5] = {id = 5,name = GameAPI.get_text_config('#1403961673#lua'),quality = 4,editor_id = 208204,hero_icon = 110050001,hero_desc = GameAPI.get_text_config('#-592685688#lua'),hero_talent_skill_group = '40003',hero_skill_id = 41005,attr_pack = 'hero_primary_10001',default_own = 1,hero_atk_type = 1,hero_atk_range = 1100.0,model_scale = 1.0,},
  [6] = {id = 6,name = GameAPI.get_text_config('#1363385042#lua'),quality = 4,editor_id = 206228,hero_icon = 110060001,hero_desc = GameAPI.get_text_config('#-245960980#lua'),hero_talent_skill_group = '40003',hero_skill_id = 41006,attr_pack = 'hero_primary_10001',default_own = 1,hero_atk_type = -1,hero_atk_range = 450.0,model_scale = 1.0,},
  [7] = {id = 7,name = GameAPI.get_text_config('#580816577#lua'),quality = 4,editor_id = 206848,hero_icon = 110070001,hero_desc = GameAPI.get_text_config('#-592685688#lua'),hero_talent_skill_group = '40003',hero_skill_id = 41007,attr_pack = 'hero_primary_10001',default_own = 1,hero_atk_type = 1,hero_atk_range = 1100.0,model_scale = 1.0,},
  [8] = {id = 8,name = GameAPI.get_text_config('#2142432548#lua'),quality = 4,editor_id = 208188,hero_icon = 110080001,hero_desc = GameAPI.get_text_config('#-592685688#lua'),hero_talent_skill_group = '40003',hero_skill_id = 41008,attr_pack = 'hero_primary_10001',default_own = 1,hero_atk_type = 1,hero_atk_range = 1100.0,model_scale = 1.0,},
  [9] = {id = 9,name = GameAPI.get_text_config('#-996683270#lua'),quality = 4,editor_id = 206613,hero_icon = 110090001,hero_desc = GameAPI.get_text_config('#-245960980#lua'),hero_talent_skill_group = '40003',hero_skill_id = 41009,attr_pack = 'hero_primary_10001',default_own = 1,hero_atk_type = -1,hero_atk_range = 450.0,model_scale = 1.0,},
  [10] = {id = 10,name = GameAPI.get_text_config('#831462393#lua'),quality = 4,editor_id = 207366,hero_icon = 110100001,hero_desc = GameAPI.get_text_config('#-245960980#lua'),hero_talent_skill_group = '40003',hero_skill_id = 41010,attr_pack = 'hero_primary_10001',default_own = 1,hero_atk_type = -1,hero_atk_range = 450.0,model_scale = 1.0,},
  [11] = {id = 11,name = GameAPI.get_text_config('#1825610489#lua'),quality = 4,editor_id = 208197,hero_icon = 110110001,hero_desc = GameAPI.get_text_config('#-245960980#lua'),hero_talent_skill_group = '40003',hero_skill_id = 41011,attr_pack = 'hero_primary_10001',default_own = 1,hero_atk_type = -1,hero_atk_range = 450.0,model_scale = 1.0,},
  [12] = {id = 12,name = GameAPI.get_text_config('#-476338809#lua'),quality = 4,editor_id = 200485,hero_icon = 110120001,hero_desc = GameAPI.get_text_config('#-245960980#lua'),hero_talent_skill_group = '40003',hero_skill_id = 41012,attr_pack = 'hero_primary_10001',default_own = 1,hero_atk_type = -1,hero_atk_range = 450.0,model_scale = 1.0,},
  [13] = {id = 13,name = GameAPI.get_text_config('#-212446952#lua'),quality = 4,editor_id = 206849,hero_icon = 110130001,hero_desc = GameAPI.get_text_config('#-592685688#lua'),hero_talent_skill_group = '40003',hero_skill_id = 41013,attr_pack = 'hero_primary_10001',default_own = 1,hero_atk_type = 1,hero_atk_range = 1100.0,model_scale = 1.0,},
  [14] = {id = 14,name = GameAPI.get_text_config('#-493889661#lua'),quality = 4,editor_id = 206231,hero_icon = 110140001,hero_desc = GameAPI.get_text_config('#-592685688#lua'),hero_talent_skill_group = '40003',hero_skill_id = 41014,attr_pack = 'hero_primary_10001',default_own = 1,hero_atk_type = 1,hero_atk_range = 1100.0,model_scale = 1.0,},
  [15] = {id = 15,name = GameAPI.get_text_config('#-57057145#lua'),quality = 4,editor_id = 206851,hero_icon = 110150001,hero_desc = GameAPI.get_text_config('#-245960980#lua'),hero_talent_skill_group = '40003',hero_skill_id = 41015,attr_pack = 'hero_primary_10001',default_own = 1,hero_atk_type = -1,hero_atk_range = 450.0,model_scale = 1.0,},
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
}

local hero={}
hero.__index=hero 

function hero.length() 
   return #_data 
end 

function hero.indexOf(index) 
 index = tonumber(index) 
  
 local rawData = _data[index] 
 if not rawData then 
 return nil 
 end 
local ret = setmetatable({}, {__index = function(t, k) local value = rawData[k] 
 assert(value,"表中没有这个字段"..k) return rawData[k] end, __newindex = function(t, k, v)end }) 
 return ret 
end 

function hero.get(id) 
   
    return hero.indexOf(id_to_index[id])
end 

return hero