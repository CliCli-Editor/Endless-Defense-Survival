--[[

        stage_tower.lua
        exported by excel2lua.py
        from file:stage_tower.xlsx

        auto generate by tools, do not modify it!!!

--]]

local _data = {
  [1] = {id = 1,tower_name = GameAPI.get_text_config('#-230764741#lua'),tower_quality = 1,tower_model_id = 134230075,tower_icon = 100070002,tower_avatar = 100070001,tower_acquire_desc = GameAPI.get_text_config('#1560261024#lua'),tower_desc = GameAPI.get_text_config('#1560261024#lua'),tower_editor_skill_id = 19010,tower_config_skill_id = 19010,tower_default_own = 1,},
  [2] = {id = 2,tower_name = GameAPI.get_text_config('#69010683#lua'),tower_quality = 3,tower_model_id = 134275715,tower_icon = 100020002,tower_avatar = 100020001,tower_acquire_desc = GameAPI.get_text_config('#1049099180#lua'),tower_desc = GameAPI.get_text_config('#1049099180#lua'),tower_editor_skill_id = 19001,tower_config_skill_id = 19001,tower_default_own = 0,},
  [3] = {id = 3,tower_name = GameAPI.get_text_config('#-2041408200#lua'),tower_quality = 3,tower_model_id = 134241598,tower_icon = 100130002,tower_avatar = 100130001,tower_acquire_desc = GameAPI.get_text_config('#-1953251953#lua'),tower_desc = GameAPI.get_text_config('#-1953251953#lua'),tower_editor_skill_id = 19004,tower_config_skill_id = 19004,tower_default_own = 0,},
  [4] = {id = 5,tower_name = GameAPI.get_text_config('#880579306#lua'),tower_quality = 3,tower_model_id = 134222458,tower_icon = 100100002,tower_avatar = 100100001,tower_acquire_desc = GameAPI.get_text_config('#-530900218#lua'),tower_desc = GameAPI.get_text_config('#-530900218#lua'),tower_editor_skill_id = 19002,tower_config_skill_id = 19002,tower_default_own = 0,},
  [5] = {id = 6,tower_name = GameAPI.get_text_config('#-1982053990#lua'),tower_quality = 3,tower_model_id = 134282838,tower_icon = 100160002,tower_avatar = 100160001,tower_acquire_desc = GameAPI.get_text_config('#-431456066#lua'),tower_desc = GameAPI.get_text_config('#-431456066#lua'),tower_editor_skill_id = 19003,tower_config_skill_id = 19003,tower_default_own = 0,},
  [6] = {id = 7,tower_name = GameAPI.get_text_config('#-567142362#lua'),tower_quality = 3,tower_model_id = 134226725,tower_icon = 100080002,tower_avatar = 100080001,tower_acquire_desc = GameAPI.get_text_config('#1684285525#lua'),tower_desc = GameAPI.get_text_config('#1684285525#lua'),tower_editor_skill_id = 19008,tower_config_skill_id = 19008,tower_default_own = 0,},
}

local id_to_index={
   [1] = 1,
   [2] = 2,
   [3] = 3,
   [5] = 4,
   [6] = 5,
   [7] = 6,
}

local stage_tower={}
stage_tower.__index=stage_tower 

function stage_tower.length() 
   return #_data 
end 

function stage_tower.indexOf(index) 
 index = tonumber(index) 
  
 local rawData = _data[index] 
 if not rawData then 
 return nil 
 end 
local ret = setmetatable({}, {__index = function(t, k) local value = rawData[k] 
 assert(value,"表中没有这个字段"..k) return rawData[k] end, __newindex = function(t, k, v)end }) 
 return ret 
end 

function stage_tower.get(id) 
   
    return stage_tower.indexOf(id_to_index[id])
end 

return stage_tower