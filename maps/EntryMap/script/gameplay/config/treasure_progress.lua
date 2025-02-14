--[[

        treasure_progress.lua
        exported by excel2lua.py
        from file:treasure_progress.xlsx

        auto generate by tools, do not modify it!!!

--]]

local _data = {
  [1] = {id = 1,progress_type = 1,progress = 15,progress_max = 45,name = GameAPI.get_text_config('#-1170606077#lua'),icon = '',quality = 4,attr_pack = 'treasure_progress_1',},
  [2] = {id = 2,progress_type = 1,progress = 30,progress_max = 45,name = GameAPI.get_text_config('#-176050995#lua'),icon = '',quality = 5,attr_pack = 'treasure_progress_2',},
  [3] = {id = 3,progress_type = 1,progress = 45,progress_max = 45,name = GameAPI.get_text_config('#-961385418#lua'),icon = '',quality = 6,attr_pack = 'treasure_progress_3',},
  [4] = {id = 4,progress_type = 2,progress = 10,progress_max = 32,name = GameAPI.get_text_config('#-1676108092#lua'),icon = '',quality = 4,attr_pack = 'treasure_progress_4',},
  [5] = {id = 5,progress_type = 2,progress = 20,progress_max = 32,name = GameAPI.get_text_config('#-1501394639#lua'),icon = '',quality = 5,attr_pack = 'treasure_progress_5',},
  [6] = {id = 6,progress_type = 2,progress = 32,progress_max = 32,name = GameAPI.get_text_config('#-424629311#lua'),icon = '',quality = 6,attr_pack = 'treasure_progress_6',},
  [7] = {id = 7,progress_type = 3,progress = 8,progress_max = 24,name = GameAPI.get_text_config('#-2081477107#lua'),icon = '',quality = 4,attr_pack = 'treasure_progress_7',},
  [8] = {id = 8,progress_type = 3,progress = 16,progress_max = 24,name = GameAPI.get_text_config('#1086890179#lua'),icon = '',quality = 5,attr_pack = 'treasure_progress_8',},
  [9] = {id = 9,progress_type = 3,progress = 24,progress_max = 24,name = GameAPI.get_text_config('#-585014612#lua'),icon = '',quality = 6,attr_pack = 'treasure_progress_9',},
  [10] = {id = 10,progress_type = 4,progress = 6,progress_max = 18,name = GameAPI.get_text_config('#121597961#lua'),icon = '',quality = 4,attr_pack = 'treasure_progress_10',},
  [11] = {id = 11,progress_type = 4,progress = 12,progress_max = 18,name = GameAPI.get_text_config('#-100455617#lua'),icon = '',quality = 5,attr_pack = 'treasure_progress_11',},
  [12] = {id = 12,progress_type = 4,progress = 18,progress_max = 18,name = GameAPI.get_text_config('#2087573186#lua'),icon = '',quality = 6,attr_pack = 'treasure_progress_12',},
  [13] = {id = 13,progress_type = 5,progress = 6,progress_max = 18,name = GameAPI.get_text_config('#1581106198#lua'),icon = '',quality = 4,attr_pack = 'treasure_progress_13',},
  [14] = {id = 14,progress_type = 5,progress = 12,progress_max = 18,name = GameAPI.get_text_config('#189382559#lua'),icon = '',quality = 5,attr_pack = 'treasure_progress_14',},
  [15] = {id = 15,progress_type = 5,progress = 18,progress_max = 18,name = GameAPI.get_text_config('#1353717363#lua'),icon = '',quality = 6,attr_pack = 'treasure_progress_15',},
  [16] = {id = 16,progress_type = 10,progress = 4,progress_max = 12,name = GameAPI.get_text_config('#-1465278145#lua'),icon = '',quality = 4,attr_pack = 'treasure_progress_16',},
  [17] = {id = 17,progress_type = 10,progress = 8,progress_max = 12,name = GameAPI.get_text_config('#492628076#lua'),icon = '',quality = 5,attr_pack = 'treasure_progress_17',},
  [18] = {id = 18,progress_type = 10,progress = 12,progress_max = 12,name = GameAPI.get_text_config('#928518470#lua'),icon = '',quality = 6,attr_pack = 'treasure_progress_18',},
  [19] = {id = 19,progress_type = 11,progress = 4,progress_max = 12,name = GameAPI.get_text_config('#-1456496226#lua'),icon = '',quality = 4,attr_pack = 'treasure_progress_19',},
  [20] = {id = 20,progress_type = 11,progress = 8,progress_max = 12,name = GameAPI.get_text_config('#1857225302#lua'),icon = '',quality = 5,attr_pack = 'treasure_progress_20',},
  [21] = {id = 21,progress_type = 11,progress = 12,progress_max = 12,name = GameAPI.get_text_config('#1496843173#lua'),icon = '',quality = 6,attr_pack = 'treasure_progress_21',},
  [22] = {id = 22,progress_type = 12,progress = 4,progress_max = 12,name = GameAPI.get_text_config('#1836797068#lua'),icon = '',quality = 4,attr_pack = 'treasure_progress_22',},
  [23] = {id = 23,progress_type = 12,progress = 8,progress_max = 12,name = GameAPI.get_text_config('#1057338166#lua'),icon = '',quality = 5,attr_pack = 'treasure_progress_23',},
  [24] = {id = 24,progress_type = 12,progress = 12,progress_max = 12,name = GameAPI.get_text_config('#1364205261#lua'),icon = '',quality = 6,attr_pack = 'treasure_progress_24',},
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
   [20] = 20,
   [21] = 21,
   [22] = 22,
   [23] = 23,
   [24] = 24,
}

local treasure_progress={}
treasure_progress.__index=treasure_progress 

function treasure_progress.length() 
   return #_data 
end 

function treasure_progress.indexOf(index) 
 index = tonumber(index) 
  
 local rawData = _data[index] 
 if not rawData then 
 return nil 
 end 
local ret = setmetatable({}, {__index = function(t, k) local value = rawData[k] 
 assert(value,"表中没有这个字段"..k) return rawData[k] end, __newindex = function(t, k, v)end }) 
 return ret 
end 

function treasure_progress.get(id) 
   
    return treasure_progress.indexOf(id_to_index[id])
end 

return treasure_progress