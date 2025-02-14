--[[

        stage_abyss_blackmarket.lua
        exported by excel2lua.py
        from file:stage_abyss_blackmarket.xlsx

        auto generate by tools, do not modify it!!!

--]]

local _data = {
  [1] = {id = 1,abyss_shop_block_id = 1,abyss_shop_block_type = 1,abyss_shop_item_random_pool = '',abyss_shop_item = '40106#1',abyss_shop_block_buy_base_price = '9999#2#0#0',abyss_shop_default_inventory = 1,abyss_shop_block_recharge = 120,abyss_shop_block_recharge_max_num = 3,abyss_shop_block_buy_max_num = 15,},
  [2] = {id = 2,abyss_shop_block_id = 2,abyss_shop_block_type = 1,abyss_shop_item_random_pool = '',abyss_shop_item = '40107#1',abyss_shop_block_buy_base_price = '9999#2#0#0',abyss_shop_default_inventory = 1,abyss_shop_block_recharge = 150,abyss_shop_block_recharge_max_num = 3,abyss_shop_block_buy_max_num = 15,},
  [3] = {id = 3,abyss_shop_block_id = 3,abyss_shop_block_type = 2,abyss_shop_item_random_pool = '',abyss_shop_item = '',abyss_shop_block_buy_base_price = '',abyss_shop_default_inventory = -1,abyss_shop_block_recharge = -1,abyss_shop_block_recharge_max_num = -1,abyss_shop_block_buy_max_num = -1,},
  [4] = {id = 4,abyss_shop_block_id = 4,abyss_shop_block_type = 2,abyss_shop_item_random_pool = '',abyss_shop_item = '',abyss_shop_block_buy_base_price = '',abyss_shop_default_inventory = -1,abyss_shop_block_recharge = -1,abyss_shop_block_recharge_max_num = -1,abyss_shop_block_buy_max_num = -1,},
  [5] = {id = 5,abyss_shop_block_id = 5,abyss_shop_block_type = 2,abyss_shop_item_random_pool = '40000#1',abyss_shop_item = '',abyss_shop_block_buy_base_price = '',abyss_shop_default_inventory = 1,abyss_shop_block_recharge = -1,abyss_shop_block_recharge_max_num = -1,abyss_shop_block_buy_max_num = 1,},
  [6] = {id = 6,abyss_shop_block_id = 6,abyss_shop_block_type = 2,abyss_shop_item_random_pool = '40000#1',abyss_shop_item = '',abyss_shop_block_buy_base_price = '',abyss_shop_default_inventory = 1,abyss_shop_block_recharge = -1,abyss_shop_block_recharge_max_num = -1,abyss_shop_block_buy_max_num = 1,},
  [7] = {id = 7,abyss_shop_block_id = 7,abyss_shop_block_type = 2,abyss_shop_item_random_pool = '40000#1',abyss_shop_item = '',abyss_shop_block_buy_base_price = '',abyss_shop_default_inventory = 1,abyss_shop_block_recharge = -1,abyss_shop_block_recharge_max_num = -1,abyss_shop_block_buy_max_num = 1,},
  [8] = {id = 8,abyss_shop_block_id = 8,abyss_shop_block_type = 2,abyss_shop_item_random_pool = '40000#1',abyss_shop_item = '',abyss_shop_block_buy_base_price = '',abyss_shop_default_inventory = 1,abyss_shop_block_recharge = -1,abyss_shop_block_recharge_max_num = -1,abyss_shop_block_buy_max_num = 1,},
  [9] = {id = 9,abyss_shop_block_id = 9,abyss_shop_block_type = 2,abyss_shop_item_random_pool = '40000#1',abyss_shop_item = '',abyss_shop_block_buy_base_price = '',abyss_shop_default_inventory = 1,abyss_shop_block_recharge = -1,abyss_shop_block_recharge_max_num = -1,abyss_shop_block_buy_max_num = 1,},
  [10] = {id = 10,abyss_shop_block_id = 10,abyss_shop_block_type = 2,abyss_shop_item_random_pool = '40000#1',abyss_shop_item = '',abyss_shop_block_buy_base_price = '',abyss_shop_default_inventory = 1,abyss_shop_block_recharge = -1,abyss_shop_block_recharge_max_num = -1,abyss_shop_block_buy_max_num = 1,},
  [11] = {id = 11,abyss_shop_block_id = 11,abyss_shop_block_type = 2,abyss_shop_item_random_pool = '40000#1',abyss_shop_item = '',abyss_shop_block_buy_base_price = '',abyss_shop_default_inventory = 1,abyss_shop_block_recharge = -1,abyss_shop_block_recharge_max_num = -1,abyss_shop_block_buy_max_num = 1,},
  [12] = {id = 12,abyss_shop_block_id = 12,abyss_shop_block_type = 2,abyss_shop_item_random_pool = '40000#1',abyss_shop_item = '',abyss_shop_block_buy_base_price = '',abyss_shop_default_inventory = 1,abyss_shop_block_recharge = -1,abyss_shop_block_recharge_max_num = -1,abyss_shop_block_buy_max_num = 1,},
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

local stage_abyss_blackmarket={}
stage_abyss_blackmarket.__index=stage_abyss_blackmarket 

function stage_abyss_blackmarket.length() 
   return #_data 
end 

function stage_abyss_blackmarket.indexOf(index) 
 index = tonumber(index) 
  
 local rawData = _data[index] 
 if not rawData then 
 return nil 
 end 
local ret = setmetatable({}, {__index = function(t, k) local value = rawData[k] 
 assert(value,"表中没有这个字段"..k) return rawData[k] end, __newindex = function(t, k, v)end }) 
 return ret 
end 

function stage_abyss_blackmarket.get(id) 
   
    return stage_abyss_blackmarket.indexOf(id_to_index[id])
end 

return stage_abyss_blackmarket