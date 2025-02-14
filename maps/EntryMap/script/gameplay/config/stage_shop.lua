--[[

        stage_shop.lua
        exported by excel2lua.py
        from file:stage_shop.xlsx

        auto generate by tools, do not modify it!!!

--]]

local _data = {
  [1] = {id = 1,shop_duration = 30,shop_type = 1,shop_block1_pool_id = '11',shop_block2_pool_id = '12',shop_block3_pool_id = '13',shop_block4_pool_id = '14',shop_block5_pool_id = '15',shop_block6_pool_id = '16',shop_block7_pool_id = '17',shop_block8_pool_id = '18',shop_refresh_limit = 0,shop_refresh_free_times = 5,mult = 1,shop_help_auto = 0,},
  [2] = {id = 2,shop_duration = 30,shop_type = 2,shop_block1_pool_id = '21',shop_block2_pool_id = '22',shop_block3_pool_id = '23',shop_block4_pool_id = '24',shop_block5_pool_id = '25',shop_block6_pool_id = '26',shop_block7_pool_id = '27',shop_block8_pool_id = '28',shop_refresh_limit = 1,shop_refresh_free_times = -1,mult = 1,shop_help_auto = 1,},
  [3] = {id = 3,shop_duration = 30,shop_type = 2,shop_block1_pool_id = '31',shop_block2_pool_id = '32',shop_block3_pool_id = '33',shop_block4_pool_id = '34',shop_block5_pool_id = '35',shop_block6_pool_id = '36',shop_block7_pool_id = '37',shop_block8_pool_id = '38',shop_refresh_limit = 1,shop_refresh_free_times = -1,mult = 1,shop_help_auto = 1,},
  [4] = {id = 4,shop_duration = 30,shop_type = 2,shop_block1_pool_id = '41',shop_block2_pool_id = '42',shop_block3_pool_id = '43',shop_block4_pool_id = '44',shop_block5_pool_id = '45',shop_block6_pool_id = '46',shop_block7_pool_id = '47',shop_block8_pool_id = '48',shop_refresh_limit = 1,shop_refresh_free_times = -1,mult = 1,shop_help_auto = 1,},
  [5] = {id = 5,shop_duration = 30,shop_type = 2,shop_block1_pool_id = '51',shop_block2_pool_id = '52',shop_block3_pool_id = '53',shop_block4_pool_id = '54',shop_block5_pool_id = '55',shop_block6_pool_id = '56',shop_block7_pool_id = '57',shop_block8_pool_id = '58',shop_refresh_limit = 1,shop_refresh_free_times = -1,mult = 1,shop_help_auto = 1,},
  [6] = {id = 6,shop_duration = 30,shop_type = 2,shop_block1_pool_id = '61',shop_block2_pool_id = '62',shop_block3_pool_id = '63',shop_block4_pool_id = '64',shop_block5_pool_id = '65',shop_block6_pool_id = '66',shop_block7_pool_id = '67',shop_block8_pool_id = '68',shop_refresh_limit = 2,shop_refresh_free_times = -1,mult = 1,shop_help_auto = 1,},
  [7] = {id = 7,shop_duration = 30,shop_type = 2,shop_block1_pool_id = '71',shop_block2_pool_id = '72',shop_block3_pool_id = '73',shop_block4_pool_id = '74',shop_block5_pool_id = '75',shop_block6_pool_id = '76',shop_block7_pool_id = '77',shop_block8_pool_id = '78',shop_refresh_limit = 2,shop_refresh_free_times = -1,mult = 1,shop_help_auto = 1,},
  [8] = {id = 8,shop_duration = 30,shop_type = 2,shop_block1_pool_id = '81',shop_block2_pool_id = '82',shop_block3_pool_id = '83',shop_block4_pool_id = '84',shop_block5_pool_id = '85',shop_block6_pool_id = '86',shop_block7_pool_id = '87',shop_block8_pool_id = '88',shop_refresh_limit = 2,shop_refresh_free_times = -1,mult = 1,shop_help_auto = 1,},
  [9] = {id = 9,shop_duration = 30,shop_type = 2,shop_block1_pool_id = '91',shop_block2_pool_id = '92',shop_block3_pool_id = '93',shop_block4_pool_id = '94',shop_block5_pool_id = '95',shop_block6_pool_id = '96',shop_block7_pool_id = '97',shop_block8_pool_id = '98',shop_refresh_limit = 2,shop_refresh_free_times = -1,mult = 1,shop_help_auto = 1,},
  [10] = {id = 10,shop_duration = 30,shop_type = 2,shop_block1_pool_id = '101',shop_block2_pool_id = '102',shop_block3_pool_id = '103',shop_block4_pool_id = '104',shop_block5_pool_id = '105',shop_block6_pool_id = '106',shop_block7_pool_id = '107',shop_block8_pool_id = '108',shop_refresh_limit = 2,shop_refresh_free_times = -1,mult = 1,shop_help_auto = 1,},
  [11] = {id = 11,shop_duration = 30,shop_type = 2,shop_block1_pool_id = '111',shop_block2_pool_id = '112',shop_block3_pool_id = '113',shop_block4_pool_id = '114',shop_block5_pool_id = '115',shop_block6_pool_id = '116',shop_block7_pool_id = '117',shop_block8_pool_id = '118',shop_refresh_limit = 3,shop_refresh_free_times = -1,mult = 1,shop_help_auto = 1,},
  [12] = {id = 12,shop_duration = 30,shop_type = 2,shop_block1_pool_id = '121',shop_block2_pool_id = '122',shop_block3_pool_id = '123',shop_block4_pool_id = '124',shop_block5_pool_id = '125',shop_block6_pool_id = '126',shop_block7_pool_id = '127',shop_block8_pool_id = '128',shop_refresh_limit = 3,shop_refresh_free_times = -1,mult = 1,shop_help_auto = 1,},
  [13] = {id = 13,shop_duration = 30,shop_type = 2,shop_block1_pool_id = '131',shop_block2_pool_id = '132',shop_block3_pool_id = '133',shop_block4_pool_id = '134',shop_block5_pool_id = '135',shop_block6_pool_id = '136',shop_block7_pool_id = '137',shop_block8_pool_id = '138',shop_refresh_limit = -1,shop_refresh_free_times = -1,mult = 1,shop_help_auto = 1,},
  [14] = {id = 14,shop_duration = 30,shop_type = 2,shop_block1_pool_id = '141',shop_block2_pool_id = '142',shop_block3_pool_id = '143',shop_block4_pool_id = '144',shop_block5_pool_id = '145',shop_block6_pool_id = '146',shop_block7_pool_id = '147',shop_block8_pool_id = '148',shop_refresh_limit = -1,shop_refresh_free_times = -1,mult = 1,shop_help_auto = 1,},
  [15] = {id = 15,shop_duration = 30,shop_type = 2,shop_block1_pool_id = '151',shop_block2_pool_id = '152',shop_block3_pool_id = '153',shop_block4_pool_id = '154',shop_block5_pool_id = '155',shop_block6_pool_id = '156',shop_block7_pool_id = '157',shop_block8_pool_id = '158',shop_refresh_limit = -1,shop_refresh_free_times = -1,mult = 1,shop_help_auto = 1,},
  [16] = {id = 16,shop_duration = 30,shop_type = 2,shop_block1_pool_id = '161',shop_block2_pool_id = '162',shop_block3_pool_id = '163',shop_block4_pool_id = '164',shop_block5_pool_id = '165',shop_block6_pool_id = '166',shop_block7_pool_id = '167',shop_block8_pool_id = '168',shop_refresh_limit = -1,shop_refresh_free_times = -1,mult = 1,shop_help_auto = 1,},
  [17] = {id = 17,shop_duration = 30,shop_type = 2,shop_block1_pool_id = '171',shop_block2_pool_id = '172',shop_block3_pool_id = '173',shop_block4_pool_id = '174',shop_block5_pool_id = '175',shop_block6_pool_id = '176',shop_block7_pool_id = '177',shop_block8_pool_id = '178',shop_refresh_limit = -1,shop_refresh_free_times = -1,mult = 1,shop_help_auto = 1,},
  [18] = {id = 18,shop_duration = 30,shop_type = 2,shop_block1_pool_id = '181',shop_block2_pool_id = '182',shop_block3_pool_id = '183',shop_block4_pool_id = '184',shop_block5_pool_id = '185',shop_block6_pool_id = '186',shop_block7_pool_id = '187',shop_block8_pool_id = '188',shop_refresh_limit = -1,shop_refresh_free_times = -1,mult = 1,shop_help_auto = 1,},
  [19] = {id = 19,shop_duration = 30,shop_type = 2,shop_block1_pool_id = '191',shop_block2_pool_id = '192',shop_block3_pool_id = '193',shop_block4_pool_id = '194',shop_block5_pool_id = '195',shop_block6_pool_id = '196',shop_block7_pool_id = '197',shop_block8_pool_id = '198',shop_refresh_limit = -1,shop_refresh_free_times = -1,mult = 1,shop_help_auto = 1,},
  [20] = {id = 20,shop_duration = 30,shop_type = 2,shop_block1_pool_id = '201',shop_block2_pool_id = '202',shop_block3_pool_id = '203',shop_block4_pool_id = '204',shop_block5_pool_id = '205',shop_block6_pool_id = '206',shop_block7_pool_id = '207',shop_block8_pool_id = '208',shop_refresh_limit = -1,shop_refresh_free_times = -1,mult = 1,shop_help_auto = 1,},
  [21] = {id = 21,shop_duration = 30,shop_type = 2,shop_block1_pool_id = '211',shop_block2_pool_id = '212',shop_block3_pool_id = '213',shop_block4_pool_id = '214',shop_block5_pool_id = '215',shop_block6_pool_id = '216',shop_block7_pool_id = '217',shop_block8_pool_id = '218',shop_refresh_limit = -1,shop_refresh_free_times = -1,mult = 1,shop_help_auto = 1,},
  [22] = {id = 22,shop_duration = 30,shop_type = 2,shop_block1_pool_id = '221',shop_block2_pool_id = '222',shop_block3_pool_id = '223',shop_block4_pool_id = '224',shop_block5_pool_id = '225',shop_block6_pool_id = '226',shop_block7_pool_id = '227',shop_block8_pool_id = '228',shop_refresh_limit = -1,shop_refresh_free_times = -1,mult = 1,shop_help_auto = 1,},
  [23] = {id = 23,shop_duration = 30,shop_type = 2,shop_block1_pool_id = '231',shop_block2_pool_id = '232',shop_block3_pool_id = '233',shop_block4_pool_id = '234',shop_block5_pool_id = '235',shop_block6_pool_id = '236',shop_block7_pool_id = '237',shop_block8_pool_id = '238',shop_refresh_limit = -1,shop_refresh_free_times = -1,mult = 1,shop_help_auto = 1,},
  [24] = {id = 24,shop_duration = 30,shop_type = 2,shop_block1_pool_id = '241',shop_block2_pool_id = '242',shop_block3_pool_id = '243',shop_block4_pool_id = '244',shop_block5_pool_id = '245',shop_block6_pool_id = '246',shop_block7_pool_id = '247',shop_block8_pool_id = '248',shop_refresh_limit = -1,shop_refresh_free_times = -1,mult = 1,shop_help_auto = 1,},
  [25] = {id = 25,shop_duration = 30,shop_type = 2,shop_block1_pool_id = '251',shop_block2_pool_id = '252',shop_block3_pool_id = '253',shop_block4_pool_id = '254',shop_block5_pool_id = '255',shop_block6_pool_id = '256',shop_block7_pool_id = '257',shop_block8_pool_id = '258',shop_refresh_limit = -1,shop_refresh_free_times = -1,mult = 1,shop_help_auto = 1,},
  [26] = {id = 26,shop_duration = 30,shop_type = 2,shop_block1_pool_id = '261',shop_block2_pool_id = '262',shop_block3_pool_id = '263',shop_block4_pool_id = '264',shop_block5_pool_id = '265',shop_block6_pool_id = '266',shop_block7_pool_id = '267',shop_block8_pool_id = '268',shop_refresh_limit = -1,shop_refresh_free_times = -1,mult = 1,shop_help_auto = 1,},
  [27] = {id = 27,shop_duration = 30,shop_type = 2,shop_block1_pool_id = '271',shop_block2_pool_id = '272',shop_block3_pool_id = '273',shop_block4_pool_id = '274',shop_block5_pool_id = '275',shop_block6_pool_id = '276',shop_block7_pool_id = '277',shop_block8_pool_id = '278',shop_refresh_limit = -1,shop_refresh_free_times = -1,mult = 1,shop_help_auto = 1,},
  [28] = {id = 28,shop_duration = 30,shop_type = 2,shop_block1_pool_id = '281',shop_block2_pool_id = '282',shop_block3_pool_id = '283',shop_block4_pool_id = '284',shop_block5_pool_id = '285',shop_block6_pool_id = '286',shop_block7_pool_id = '287',shop_block8_pool_id = '288',shop_refresh_limit = -1,shop_refresh_free_times = -1,mult = 1,shop_help_auto = 1,},
  [29] = {id = 29,shop_duration = 30,shop_type = 2,shop_block1_pool_id = '291',shop_block2_pool_id = '292',shop_block3_pool_id = '293',shop_block4_pool_id = '294',shop_block5_pool_id = '295',shop_block6_pool_id = '296',shop_block7_pool_id = '297',shop_block8_pool_id = '298',shop_refresh_limit = -1,shop_refresh_free_times = -1,mult = 1,shop_help_auto = 1,},
  [30] = {id = 30,shop_duration = 30,shop_type = 2,shop_block1_pool_id = '301',shop_block2_pool_id = '302',shop_block3_pool_id = '303',shop_block4_pool_id = '304',shop_block5_pool_id = '305',shop_block6_pool_id = '306',shop_block7_pool_id = '307',shop_block8_pool_id = '308',shop_refresh_limit = -1,shop_refresh_free_times = -1,mult = 1,shop_help_auto = 1,},
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

local stage_shop={}
stage_shop.__index=stage_shop 

function stage_shop.length() 
   return #_data 
end 

function stage_shop.indexOf(index) 
 index = tonumber(index) 
  
 local rawData = _data[index] 
 if not rawData then 
 return nil 
 end 
local ret = setmetatable({}, {__index = function(t, k) local value = rawData[k] 
 assert(value,"表中没有这个字段"..k) return rawData[k] end, __newindex = function(t, k, v)end }) 
 return ret 
end 

function stage_shop.get(id) 
   
    return stage_shop.indexOf(id_to_index[id])
end 

return stage_shop