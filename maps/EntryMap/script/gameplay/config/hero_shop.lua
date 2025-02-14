--[[

        hero_shop.lua
        exported by excel2lua.py
        from file:hero_shop.xlsx

        auto generate by tools, do not modify it!!!

--]]

local _data = {
  [1] = {id = 1,round = 1,round_desc = '',slot = 1,unlock_slot = -1,max_level = 1,price = '1#500#0',rate = '',up_stage = -1,skill_id = 40018,skill_to = '2',unique_skill = 0,not_ = GameAPI.get_text_config('#-1228990767#lua'),},
  [2] = {id = 2,round = 2,round_desc = '',slot = 1,unlock_slot = -1,max_level = 10,price = '2#150#150',rate = '',up_stage = -1,skill_id = 40019,skill_to = '2',unique_skill = 0,not_ = GameAPI.get_text_config('#587653284#lua'),},
  [3] = {id = 3,round = 2,round_desc = '',slot = 2,unlock_slot = -1,max_level = 10,price = '2#300#150',rate = '',up_stage = -1,skill_id = 40014,skill_to = '1|2',unique_skill = 0,not_ = GameAPI.get_text_config('#1513551417#lua'),},
  [4] = {id = 4,round = 2,round_desc = '',slot = 3,unlock_slot = 2,max_level = 10,price = '2#600#300',rate = '',up_stage = -1,skill_id = 40005,skill_to = '1',unique_skill = 0,not_ = GameAPI.get_text_config('#-1264272061#lua'),},
  [5] = {id = 5,round = 2,round_desc = '',slot = 4,unlock_slot = 2,max_level = 50,price = '2#50#0',rate = '',up_stage = -1,skill_id = 40009,skill_to = '1',unique_skill = 0,not_ = GameAPI.get_text_config('#65929758#lua'),},
  [6] = {id = 6,round = 2,round_desc = '',slot = 5,unlock_slot = 3,max_level = 50,price = '2#200#50',rate = '',up_stage = -1,skill_id = 40007,skill_to = '1',unique_skill = 0,not_ = GameAPI.get_text_config('#1549609871#lua'),},
  [7] = {id = 7,round = 2,round_desc = '',slot = 6,unlock_slot = 3,max_level = 100,price = '2#200#50',rate = '',up_stage = -1,skill_id = 40021,skill_to = '1',unique_skill = 0,not_ = GameAPI.get_text_config('#-1599327572#lua'),},
  [8] = {id = 8,round = 2,round_desc = '',slot = 7,unlock_slot = 3,max_level = 100,price = '2#200#50',rate = '',up_stage = -1,skill_id = 40022,skill_to = '1',unique_skill = 0,not_ = GameAPI.get_text_config('#1148505865#lua'),},
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
}

local hero_shop={}
hero_shop.__index=hero_shop 

function hero_shop.length() 
   return #_data 
end 

function hero_shop.indexOf(index) 
 index = tonumber(index) 
  
 local rawData = _data[index] 
 if not rawData then 
 return nil 
 end 
local ret = setmetatable({}, {__index = function(t, k) local value = rawData[k] 
 assert(value,"表中没有这个字段"..k) return rawData[k] end, __newindex = function(t, k, v)end }) 
 return ret 
end 

function hero_shop.get(id) 
   
    return hero_shop.indexOf(id_to_index[id])
end 

return hero_shop