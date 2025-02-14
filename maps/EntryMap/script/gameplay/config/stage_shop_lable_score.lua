--[[

        stage_shop_lable_score.lua
        exported by excel2lua.py
        from file:stage_shop_lable_score.xlsx

        auto generate by tools, do not modify it!!!

--]]

local _data = {
  [1] = {id = 1,shop_helper_lable_score = 100,shop_helper_quality_score = 10,},
  [2] = {id = 2,shop_helper_lable_score = 50,shop_helper_quality_score = 5,},
  [3] = {id = 3,shop_helper_lable_score = 30,shop_helper_quality_score = 3,},
  [4] = {id = 4,shop_helper_lable_score = 20,shop_helper_quality_score = 2,},
  [5] = {id = 5,shop_helper_lable_score = 10,shop_helper_quality_score = 1,},
  [6] = {id = 6,shop_helper_lable_score = 5,shop_helper_quality_score = 1,},
  [7] = {id = 7,shop_helper_lable_score = 4,shop_helper_quality_score = 1,},
  [8] = {id = 8,shop_helper_lable_score = 3,shop_helper_quality_score = 1,},
  [9] = {id = 9,shop_helper_lable_score = 2,shop_helper_quality_score = 1,},
  [10] = {id = 10,shop_helper_lable_score = 1,shop_helper_quality_score = 1,},
  [11] = {id = 11,shop_helper_lable_score = 1,shop_helper_quality_score = 1,},
  [12] = {id = 12,shop_helper_lable_score = 1,shop_helper_quality_score = 1,},
  [13] = {id = 13,shop_helper_lable_score = 1,shop_helper_quality_score = 1,},
  [14] = {id = 14,shop_helper_lable_score = 1,shop_helper_quality_score = 1,},
  [15] = {id = 15,shop_helper_lable_score = 1,shop_helper_quality_score = 1,},
  [16] = {id = 16,shop_helper_lable_score = 1,shop_helper_quality_score = 1,},
  [17] = {id = 17,shop_helper_lable_score = 1,shop_helper_quality_score = 1,},
  [18] = {id = 18,shop_helper_lable_score = 1,shop_helper_quality_score = 1,},
  [19] = {id = 19,shop_helper_lable_score = 1,shop_helper_quality_score = 1,},
  [20] = {id = 20,shop_helper_lable_score = 1,shop_helper_quality_score = 1,},
  [21] = {id = 21,shop_helper_lable_score = 1,shop_helper_quality_score = 1,},
  [22] = {id = 22,shop_helper_lable_score = 1,shop_helper_quality_score = 1,},
  [23] = {id = 23,shop_helper_lable_score = 1,shop_helper_quality_score = 1,},
  [24] = {id = 24,shop_helper_lable_score = 1,shop_helper_quality_score = 1,},
  [25] = {id = 25,shop_helper_lable_score = 1,shop_helper_quality_score = 1,},
  [26] = {id = 26,shop_helper_lable_score = 1,shop_helper_quality_score = 1,},
  [27] = {id = 27,shop_helper_lable_score = 1,shop_helper_quality_score = 1,},
  [28] = {id = 28,shop_helper_lable_score = 1,shop_helper_quality_score = 1,},
  [29] = {id = 29,shop_helper_lable_score = 1,shop_helper_quality_score = 1,},
  [30] = {id = 30,shop_helper_lable_score = 1,shop_helper_quality_score = 1,},
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
   [27] = 27,
   [28] = 28,
   [29] = 29,
   [30] = 30,
}

local stage_shop_lable_score={}
stage_shop_lable_score.__index=stage_shop_lable_score 

function stage_shop_lable_score.length() 
   return #_data 
end 

function stage_shop_lable_score.indexOf(index) 
 index = tonumber(index) 
  
 local rawData = _data[index] 
 if not rawData then 
 return nil 
 end 
local ret = setmetatable({}, {__index = function(t, k) local value = rawData[k] 
 assert(value,"表中没有这个字段"..k) return rawData[k] end, __newindex = function(t, k, v)end }) 
 return ret 
end 

function stage_shop_lable_score.get(id) 
   
    return stage_shop_lable_score.indexOf(id_to_index[id])
end 

return stage_shop_lable_score