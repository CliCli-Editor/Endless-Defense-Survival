--[[

        stage_shop_level.lua
        exported by excel2lua.py
        from file:stage_shop_level.xlsx

        auto generate by tools, do not modify it!!!

--]]

local _data = {
  [1] = {id = 1,shop_level = 1,shop_next_level_exp = 16,shop_block1_pool_id = '1001',shop_block2_pool_id = '1001',shop_block3_pool_id = '1001',shop_block4_pool_id = '1001',shop_block5_pool_id = '2000',shop_block6_pool_id = '2001',shop_block7_pool_id = '2001',shop_block8_pool_id = '2001',tips = GameAPI.get_text_config('#-1993288622#lua'),},
  [2] = {id = 2,shop_level = 2,shop_next_level_exp = 90,shop_block1_pool_id = '1002',shop_block2_pool_id = '1002',shop_block3_pool_id = '1002',shop_block4_pool_id = '1002',shop_block5_pool_id = '2000',shop_block6_pool_id = '2002',shop_block7_pool_id = '2002',shop_block8_pool_id = '2002',tips = GameAPI.get_text_config('#2049664070#lua'),},
  [3] = {id = 3,shop_level = 3,shop_next_level_exp = 200,shop_block1_pool_id = '1003',shop_block2_pool_id = '1003',shop_block3_pool_id = '1003',shop_block4_pool_id = '1003',shop_block5_pool_id = '2000',shop_block6_pool_id = '2003',shop_block7_pool_id = '2003',shop_block8_pool_id = '2003',tips = GameAPI.get_text_config('#-1015450813#lua'),},
  [4] = {id = 4,shop_level = 4,shop_next_level_exp = 400,shop_block1_pool_id = '1004',shop_block2_pool_id = '1004',shop_block3_pool_id = '1004',shop_block4_pool_id = '1004',shop_block5_pool_id = '2000',shop_block6_pool_id = '2004',shop_block7_pool_id = '2004',shop_block8_pool_id = '2004',tips = GameAPI.get_text_config('#902513033#lua'),},
  [5] = {id = 5,shop_level = 5,shop_next_level_exp = 750,shop_block1_pool_id = '1005',shop_block2_pool_id = '1005',shop_block3_pool_id = '1005',shop_block4_pool_id = '1005',shop_block5_pool_id = '2000',shop_block6_pool_id = '2005',shop_block7_pool_id = '2005',shop_block8_pool_id = '2005',tips = GameAPI.get_text_config('#-434039907#lua'),},
  [6] = {id = 6,shop_level = 6,shop_next_level_exp = 1200,shop_block1_pool_id = '1006',shop_block2_pool_id = '1006',shop_block3_pool_id = '1006',shop_block4_pool_id = '1006',shop_block5_pool_id = '2000',shop_block6_pool_id = '2006',shop_block7_pool_id = '2006',shop_block8_pool_id = '2006',tips = GameAPI.get_text_config('#462732725#lua'),},
  [7] = {id = 7,shop_level = 7,shop_next_level_exp = 0,shop_block1_pool_id = '1007',shop_block2_pool_id = '1007',shop_block3_pool_id = '1007',shop_block4_pool_id = '1007',shop_block5_pool_id = '2000',shop_block6_pool_id = '2007',shop_block7_pool_id = '2007',shop_block8_pool_id = '2007',tips = GameAPI.get_text_config('#-1421289821#lua'),},
}

local id_to_index={
   [1] = 1,
   [2] = 2,
   [3] = 3,
   [4] = 4,
   [5] = 5,
   [6] = 6,
   [7] = 7,
}

local stage_shop_level={}
stage_shop_level.__index=stage_shop_level 

function stage_shop_level.length() 
   return #_data 
end 

function stage_shop_level.indexOf(index) 
 index = tonumber(index) 
  
 local rawData = _data[index] 
 if not rawData then 
 return nil 
 end 
local ret = setmetatable({}, {__index = function(t, k) local value = rawData[k] 
 assert(value,"表中没有这个字段"..k) return rawData[k] end, __newindex = function(t, k, v)end }) 
 return ret 
end 

function stage_shop_level.get(id) 
   
    return stage_shop_level.indexOf(id_to_index[id])
end 

return stage_shop_level