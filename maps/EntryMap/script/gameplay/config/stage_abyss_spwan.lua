--[[

        stage_abyss_spwan.lua
        exported by excel2lua.py
        from file:stage_abyss_spwan.xlsx

        auto generate by tools, do not modify it!!!

--]]

local _data = {
  [1] = {id = 1,abyss_monster_id = 30003,abyss_max_floor = 999,abyss_monster_spawn_door = 105132,abyss_monster_spawn_door_min_time = 1.0,abyss_monster_spawn_range = '1500#1000',},
  [2] = {id = 2,abyss_monster_id = 30004,abyss_max_floor = 999,abyss_monster_spawn_door = 105132,abyss_monster_spawn_door_min_time = 1.0,abyss_monster_spawn_range = '1500#1000',},
  [3] = {id = 3,abyss_monster_id = 30005,abyss_max_floor = 999,abyss_monster_spawn_door = 105132,abyss_monster_spawn_door_min_time = 1.0,abyss_monster_spawn_range = '1500#1000',},
  [4] = {id = 4,abyss_monster_id = 30006,abyss_max_floor = 999,abyss_monster_spawn_door = 105132,abyss_monster_spawn_door_min_time = 1.0,abyss_monster_spawn_range = '1500#1000',},
  [5] = {id = 5,abyss_monster_id = 30007,abyss_max_floor = 999,abyss_monster_spawn_door = 105132,abyss_monster_spawn_door_min_time = 1.0,abyss_monster_spawn_range = '1500#1000',},
  [6] = {id = 6,abyss_monster_id = 30008,abyss_max_floor = 999,abyss_monster_spawn_door = 105132,abyss_monster_spawn_door_min_time = 1.0,abyss_monster_spawn_range = '1500#1000',},
  [7] = {id = 7,abyss_monster_id = 30009,abyss_max_floor = 999,abyss_monster_spawn_door = 105132,abyss_monster_spawn_door_min_time = 1.0,abyss_monster_spawn_range = '1500#1000',},
  [8] = {id = 8,abyss_monster_id = 30014,abyss_max_floor = 999,abyss_monster_spawn_door = 105132,abyss_monster_spawn_door_min_time = 1.0,abyss_monster_spawn_range = '500#1000|400#500',},
  [9] = {id = 9,abyss_monster_id = 30015,abyss_max_floor = 999,abyss_monster_spawn_door = 105132,abyss_monster_spawn_door_min_time = 1.0,abyss_monster_spawn_range = '500#1000|400#500',},
  [10] = {id = 10,abyss_monster_id = 30016,abyss_max_floor = 999,abyss_monster_spawn_door = 105132,abyss_monster_spawn_door_min_time = 1.0,abyss_monster_spawn_range = '500#1000|400#500',},
  [11] = {id = 11,abyss_monster_id = 30017,abyss_max_floor = 999,abyss_monster_spawn_door = 105132,abyss_monster_spawn_door_min_time = 1.0,abyss_monster_spawn_range = '500#1000|400#500',},
  [12] = {id = 12,abyss_monster_id = 30039,abyss_max_floor = 999,abyss_monster_spawn_door = 105132,abyss_monster_spawn_door_min_time = 1.0,abyss_monster_spawn_range = '1500#1000',},
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
}

local stage_abyss_spwan={}
stage_abyss_spwan.__index=stage_abyss_spwan 

function stage_abyss_spwan.length() 
   return #_data 
end 

function stage_abyss_spwan.indexOf(index) 
 index = tonumber(index) 
  
 local rawData = _data[index] 
 if not rawData then 
 return nil 
 end 
local ret = setmetatable({}, {__index = function(t, k) local value = rawData[k] 
 assert(value,"表中没有这个字段"..k) return rawData[k] end, __newindex = function(t, k, v)end }) 
 return ret 
end 

function stage_abyss_spwan.get(id) 
   
    return stage_abyss_spwan.indexOf(id_to_index[id])
end 

return stage_abyss_spwan