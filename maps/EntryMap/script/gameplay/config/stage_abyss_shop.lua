--[[

        stage_abyss_shop.lua
        exported by excel2lua.py
        from file:stage_abyss_shop.xlsx

        auto generate by tools, do not modify it!!!

--]]

local _data = {
  [1] = {id = 1,abyss_floor = 100,abyss_floor_refresh_round = 5,abyss_shop_auto_refresh = 120.0,abyss_shop_refresh_gold_price = 2,abyss_shop_block_1 = 10001,abyss_shop_block_2 = 10000,abyss_shop_block_3 = 10002,abyss_shop_block_4 = 10002,abyss_shop_block_5 = 10003,abyss_shop_block_6 = 10003,abyss_shop_block_7 = 10003,abyss_shop_block_8 = 10004,abyss_shop_block_9 = -1,abyss_shop_block_10 = -1,abyss_shop_block_11 = -1,abyss_shop_block_12 = -1,abyss_shop_block_13 = -1,abyss_shop_block_14 = -1,abyss_shop_block_15 = -1,abyss_shop_block_16 = -1,abyss_shop_block_1_hand = 10002,abyss_shop_block_2_hand = 10002,abyss_shop_block_3_hand = 10002,abyss_shop_block_4_hand = 10002,abyss_shop_block_5_hand = 10003,abyss_shop_block_6_hand = 10003,abyss_shop_block_7_hand = 10003,abyss_shop_block_8_hand = 10004,abyss_shop_block_9_hand = -1,abyss_shop_block_10_hand = -1,abyss_shop_block_11_hand = -1,abyss_shop_block_12_hand = -1,abyss_shop_block_13_hand = -1,abyss_shop_block_14_hand = -1,abyss_shop_block_15_hand = -1,abyss_shop_block_16_hand = -1,},
  [2] = {id = 2,abyss_floor = 999,abyss_floor_refresh_round = 5,abyss_shop_auto_refresh = 120.0,abyss_shop_refresh_gold_price = 2,abyss_shop_block_1 = 10001,abyss_shop_block_2 = 10000,abyss_shop_block_3 = 10002,abyss_shop_block_4 = 10002,abyss_shop_block_5 = 10003,abyss_shop_block_6 = 10003,abyss_shop_block_7 = 10003,abyss_shop_block_8 = 10004,abyss_shop_block_9 = -1,abyss_shop_block_10 = -1,abyss_shop_block_11 = -1,abyss_shop_block_12 = -1,abyss_shop_block_13 = -1,abyss_shop_block_14 = -1,abyss_shop_block_15 = -1,abyss_shop_block_16 = -1,abyss_shop_block_1_hand = 10002,abyss_shop_block_2_hand = 10002,abyss_shop_block_3_hand = 10002,abyss_shop_block_4_hand = 10002,abyss_shop_block_5_hand = 10003,abyss_shop_block_6_hand = 10003,abyss_shop_block_7_hand = 10003,abyss_shop_block_8_hand = 10004,abyss_shop_block_9_hand = -1,abyss_shop_block_10_hand = -1,abyss_shop_block_11_hand = -1,abyss_shop_block_12_hand = -1,abyss_shop_block_13_hand = -1,abyss_shop_block_14_hand = -1,abyss_shop_block_15_hand = -1,abyss_shop_block_16_hand = -1,},
}

local id_to_index={
   [1] = 1,
   [2] = 2,
}

local stage_abyss_shop={}
stage_abyss_shop.__index=stage_abyss_shop 

function stage_abyss_shop.length() 
   return #_data 
end 

function stage_abyss_shop.indexOf(index) 
 index = tonumber(index) 
  
 local rawData = _data[index] 
 if not rawData then 
 return nil 
 end 
local ret = setmetatable({}, {__index = function(t, k) local value = rawData[k] 
 assert(value,"表中没有这个字段"..k) return rawData[k] end, __newindex = function(t, k, v)end }) 
 return ret 
end 

function stage_abyss_shop.get(id) 
   
    return stage_abyss_shop.indexOf(id_to_index[id])
end 

return stage_abyss_shop