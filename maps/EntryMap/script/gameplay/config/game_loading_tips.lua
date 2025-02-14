--[[

        game_loading_tips.lua
        exported by excel2lua.py
        from file:game_loading_tips.xlsx

        auto generate by tools, do not modify it!!!

--]]

local _data = {
  [1] = {id = 1,game_tips_type = GameAPI.get_text_config('#1146230751#lua'),game_tips_content = GameAPI.get_text_config('#1325915594#lua'),},
  [2] = {id = 2,game_tips_type = GameAPI.get_text_config('#1146230751#lua'),game_tips_content = GameAPI.get_text_config('#1925700503#lua'),},
  [3] = {id = 3,game_tips_type = GameAPI.get_text_config('#1703134291#lua'),game_tips_content = GameAPI.get_text_config('#996172106#lua'),},
  [4] = {id = 4,game_tips_type = GameAPI.get_text_config('#1703134291#lua'),game_tips_content = GameAPI.get_text_config('#-2068756922#lua'),},
  [5] = {id = 5,game_tips_type = GameAPI.get_text_config('#1703134291#lua'),game_tips_content = GameAPI.get_text_config('#-1479818717#lua'),},
  [6] = {id = 6,game_tips_type = GameAPI.get_text_config('#2018746044#lua'),game_tips_content = GameAPI.get_text_config('#-2066991389#lua'),},
  [7] = {id = 7,game_tips_type = GameAPI.get_text_config('#-747028197#lua'),game_tips_content = GameAPI.get_text_config('#368002341#lua'),},
  [8] = {id = 8,game_tips_type = GameAPI.get_text_config('#-747028197#lua'),game_tips_content = GameAPI.get_text_config('#1716734314#lua'),},
  [9] = {id = 9,game_tips_type = GameAPI.get_text_config('#-747028197#lua'),game_tips_content = GameAPI.get_text_config('#1239369151#lua'),},
  [10] = {id = 10,game_tips_type = GameAPI.get_text_config('#-747028197#lua'),game_tips_content = GameAPI.get_text_config('#749108555#lua'),},
  [11] = {id = 11,game_tips_type = GameAPI.get_text_config('#133968154#lua'),game_tips_content = GameAPI.get_text_config('#1884277962#lua'),},
  [12] = {id = 12,game_tips_type = GameAPI.get_text_config('#133968154#lua'),game_tips_content = GameAPI.get_text_config('#-1294286527#lua'),},
  [13] = {id = 13,game_tips_type = GameAPI.get_text_config('#133968154#lua'),game_tips_content = GameAPI.get_text_config('#-963326985#lua'),},
  [14] = {id = 14,game_tips_type = GameAPI.get_text_config('#133968154#lua'),game_tips_content = GameAPI.get_text_config('#-1195221533#lua'),},
  [15] = {id = 15,game_tips_type = GameAPI.get_text_config('#-1729900455#lua'),game_tips_content = GameAPI.get_text_config('#-384683992#lua'),},
  [16] = {id = 16,game_tips_type = GameAPI.get_text_config('#-1729900455#lua'),game_tips_content = GameAPI.get_text_config('#-28533148#lua'),},
  [17] = {id = 17,game_tips_type = GameAPI.get_text_config('#-1729900455#lua'),game_tips_content = GameAPI.get_text_config('#858221190#lua'),},
  [18] = {id = 18,game_tips_type = GameAPI.get_text_config('#-1729900455#lua'),game_tips_content = GameAPI.get_text_config('#1046599674#lua'),},
  [19] = {id = 19,game_tips_type = GameAPI.get_text_config('#333330688#lua'),game_tips_content = GameAPI.get_text_config('#-908694799#lua'),},
  [20] = {id = 20,game_tips_type = GameAPI.get_text_config('#333330688#lua'),game_tips_content = GameAPI.get_text_config('#1260658166#lua'),},
  [21] = {id = 21,game_tips_type = GameAPI.get_text_config('#333330688#lua'),game_tips_content = GameAPI.get_text_config('#-1756594923#lua'),},
  [22] = {id = 22,game_tips_type = GameAPI.get_text_config('#790801506#lua'),game_tips_content = GameAPI.get_text_config('#-1303451635#lua'),},
  [23] = {id = 23,game_tips_type = GameAPI.get_text_config('#790801506#lua'),game_tips_content = GameAPI.get_text_config('#562949677#lua'),},
  [24] = {id = 24,game_tips_type = GameAPI.get_text_config('#-1372105589#lua'),game_tips_content = GameAPI.get_text_config('#1821660182#lua'),},
  [25] = {id = 25,game_tips_type = GameAPI.get_text_config('#-1372105589#lua'),game_tips_content = GameAPI.get_text_config('#1646075141#lua'),},
  [26] = {id = 26,game_tips_type = GameAPI.get_text_config('#-1372105589#lua'),game_tips_content = GameAPI.get_text_config('#-1502652849#lua'),},
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
   [25] = 25,
   [26] = 26,
}

local game_loading_tips={}
game_loading_tips.__index=game_loading_tips 

function game_loading_tips.length() 
   return #_data 
end 

function game_loading_tips.indexOf(index) 
 index = tonumber(index) 
  
 local rawData = _data[index] 
 if not rawData then 
 return nil 
 end 
local ret = setmetatable({}, {__index = function(t, k) local value = rawData[k] 
 assert(value,"表中没有这个字段"..k) return rawData[k] end, __newindex = function(t, k, v)end }) 
 return ret 
end 

function game_loading_tips.get(id) 
   
    return game_loading_tips.indexOf(id_to_index[id])
end 

return game_loading_tips