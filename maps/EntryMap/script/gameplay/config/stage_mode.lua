--[[

        stage_mode.lua
        exported by excel2lua.py
        from file:stage_mode.xlsx

        auto generate by tools, do not modify it!!!

--]]

local _data = {
  [1] = {id = 1,name = GameAPI.get_text_config('#-817704592#lua'),mode_released = 1,max_level = 12,released_level = 12,player_born_points = '10000|10001|10002|10003',stage_wave_born_poins = '1|1800',abyss_born_points = '1|1800',challenge_born_points = '1|1800',pass_ordeal_born_points = '1|1800',lose_extra_condition = '',mode_start_phase_button_pos = '750|-1100',mode_phase_show_args = '1#2|3#4|5#6#7',},
  [2] = {id = 2,name = GameAPI.get_text_config('#802448550#lua'),mode_released = 1,max_level = 1,released_level = 1,player_born_points = '10000|10001|10002|10003',stage_wave_born_poins = '1|1800',abyss_born_points = '1|1800',challenge_born_points = '1|1800',pass_ordeal_born_points = '1|1800',lose_extra_condition = '',mode_start_phase_button_pos = '750|-1100',mode_phase_show_args = '1#2|3#4|5#6#7',},
  [3] = {id = 3,name = GameAPI.get_text_config('#-1832388450#lua'),mode_released = 1,max_level = 1,released_level = 1,player_born_points = '10278|10279|10280|10281',stage_wave_born_poins = '2|10286#10287#10288#10289',abyss_born_points = '1|1800',challenge_born_points = '2|10286#10287#10288#10289',pass_ordeal_born_points = '2|10286#10287#10288#10289',lose_extra_condition = '1|100#200#300#400#30',mode_start_phase_button_pos = '2000|500',mode_phase_show_args = '1|2',},
  [4] = {id = 4,name = GameAPI.get_text_config('#1690136771#lua'),mode_released = 1,max_level = 1,released_level = 1,player_born_points = '10000|10001|10002|10003',stage_wave_born_poins = '1|1800',abyss_born_points = '1|1800',challenge_born_points = '1|1800',pass_ordeal_born_points = '1|1800',lose_extra_condition = '',mode_start_phase_button_pos = '750|-1100',mode_phase_show_args = '1|2',},
}

local id_to_index={
   [1] = 1,
   [2] = 2,
   [3] = 3,
   [4] = 4,
}

local stage_mode={}
stage_mode.__index=stage_mode 

function stage_mode.length() 
   return #_data 
end 

function stage_mode.indexOf(index) 
 index = tonumber(index) 
  
 local rawData = _data[index] 
 if not rawData then 
 return nil 
 end 
local ret = setmetatable({}, {__index = function(t, k) local value = rawData[k] 
 assert(value,"表中没有这个字段"..k) return rawData[k] end, __newindex = function(t, k, v)end }) 
 return ret 
end 

function stage_mode.get(id) 
   
    return stage_mode.indexOf(id_to_index[id])
end 

return stage_mode