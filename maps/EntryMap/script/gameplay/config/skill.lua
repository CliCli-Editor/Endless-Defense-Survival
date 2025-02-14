--[[

        skill.lua
        exported by excel2lua.py
        from file:skill.xlsx

        auto generate by tools, do not modify it!!!

--]]

local _data = {
  [1] = {id = '11001',name = GameAPI.get_text_config('#790618602#lua'),icon = '投掷斧',type = 1,labels = '',quality = 1,funcid = '',range = 900,cd = 1.0,min_cd = -1,target_type = 1,target_type_param = 1,splash = -1,pri_target = '1',target_limit = '',damage = 75,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = 0,ability_name_1 = '',ability_desc_1 = '',ability_name_2 = '',ability_desc_2 = '',},
  [2] = {id = '11002',name = GameAPI.get_text_config('#2077100896#lua'),icon = '神圣箭',type = 1,labels = '',quality = 2,funcid = '',range = 1200,cd = 2.0,min_cd = -1,target_type = 1,target_type_param = 1,splash = -1,pri_target = '1',target_limit = '',damage = 500,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '恢复',ability_desc_1 = '每次攻击治疗80点生命值',ability_name_2 = '',ability_desc_2 = '',},
  [3] = {id = '11003',name = 'Quills',icon = '刺刺',type = 1,labels = '',quality = 2,funcid = '',range = 600,cd = 0.33,min_cd = -1,target_type = 3,target_type_param = 300,splash = -1,pri_target = '',target_limit = '',damage = 75,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = '',ability_name_2 = '',ability_desc_2 = '',},
  [4] = {id = '11004',name = GameAPI.get_text_config('#-536862674#lua'),icon = '追踪飞斧',type = 1,labels = '',quality = 2,funcid = '',range = 600,cd = 1.0,min_cd = -1,target_type = 5,target_type_param = 4,splash = -1,pri_target = '',target_limit = '',damage = 150,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = '',ability_name_2 = '',ability_desc_2 = '',},
  [5] = {id = '11005',name = 'Shocker',icon = '电击者',type = 1,labels = '',quality = 2,funcid = '',range = 1200,cd = 0.5,min_cd = -1,target_type = 1,target_type_param = 1,splash = -1,pri_target = '',target_limit = '',damage = 125,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Stun (0.75s)',ability_name_2 = '',ability_desc_2 = '',},
  [6] = {id = '11006',name = GameAPI.get_text_config('#1203128756#lua'),icon = '冲击波',type = 1,labels = '',quality = 2,funcid = '',range = 300,cd = 2.0,min_cd = -1,target_type = 6,target_type_param = 300,splash = -1,pri_target = '',target_limit = '',damage = 500,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = '',ability_name_2 = '',ability_desc_2 = '',},
  [7] = {id = '11007',name = 'Thorn',icon = '荆棘',type = 1,labels = '',quality = 2,funcid = '',range = 900,cd = 0.5,min_cd = -1,target_type = 1,target_type_param = 1,splash = -1,pri_target = '',target_limit = '',damage = 100,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Attacks Increase Normal Damage Taken by 5%, Stacks',ability_name_2 = '',ability_desc_2 = '',},
  [8] = {id = '11008',name = GameAPI.get_text_config('#2095157100#lua'),icon = '啤酒发射器',type = 1,labels = '',quality = 3,funcid = '',range = 300,cd = 3.0,min_cd = -1,target_type = 1,target_type_param = 1,splash = 300,pri_target = '',target_limit = '',damage = 900,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Attacks Reduce Enemy Chance to Hit by 25% for 3s',ability_name_2 = '',ability_desc_2 = '',},
  [9] = {id = '11009',name = 'Firebreather',icon = '喷火者',type = 1,labels = '13',quality = 3,funcid = '',range = 300,cd = 2.0,min_cd = -1,target_type = 6,target_type_param = 150,splash = -1,pri_target = '',target_limit = '',damage = 400,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Fire (20)',ability_name_2 = '',ability_desc_2 = '',},
  [10] = {id = '11010',name = GameAPI.get_text_config('#-1349333080#lua'),icon = '',type = 1,labels = '6',quality = 3,funcid = '',range = 600,cd = 1.5,min_cd = -1,target_type = 7,target_type_param = 4,splash = -1,pri_target = '',target_limit = '',damage = 450,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Frost (5)',ability_name_2 = '',ability_desc_2 = '',},
  [11] = {id = '11011',name = GameAPI.get_text_config('#42534963#lua'),icon = '网投射器',type = 1,labels = '',quality = 3,funcid = '',range = 900,cd = 2.0,min_cd = -1,target_type = 1,target_type_param = 1,splash = 300,pri_target = '',target_limit = '',damage = 500,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Stun (2s)',ability_name_2 = '',ability_desc_2 = '',},
  [12] = {id = '11012',name = GameAPI.get_text_config('#164944977#lua'),icon = '',type = 1,labels = '4',quality = 3,funcid = '',range = 600,cd = 1.0,min_cd = -1,target_type = 1,target_type_param = 1,splash = -1,pri_target = '',target_limit = '',damage = 600,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Poison (750/2s)',ability_name_2 = '',ability_desc_2 = '',},
  [13] = {id = '11013',name = GameAPI.get_text_config('#-1847354398#lua'),icon = '风暴之锤',type = 1,labels = '',quality = 3,funcid = '',range = 900,cd = 3.0,min_cd = -1,target_type = 5,target_type_param = 4,splash = -1,pri_target = '',target_limit = '',damage = 600,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Stun (3s)',ability_name_2 = '',ability_desc_2 = '',},
  [14] = {id = '11014',name = GameAPI.get_text_config('#156463614#lua'),icon = '',type = 1,labels = '',quality = 4,funcid = '',range = 600,cd = 3.0,min_cd = -1,target_type = 5,target_type_param = 4,splash = -1,pri_target = '',target_limit = '',damage = 9000,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Heal 200 HP per Enemy Hit',ability_name_2 = '',ability_desc_2 = '',},
  [15] = {id = '11015',name = 'Entangler',icon = '',type = 1,labels = '4',quality = 4,funcid = '',range = 900,cd = 0.5,min_cd = -1,target_type = 1,target_type_param = 1,splash = -1,pri_target = '',target_limit = '',damage = 3000,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Roots enemy for 2s, dealing DOT (dmg. over time); Rooted enemies cannot move and are considered Stunned and Poisoned',ability_name_2 = '',ability_desc_2 = '',},
  [16] = {id = '11016',name = 'Impaler',icon = '',type = 1,labels = '12',quality = 4,funcid = '',range = 300,cd = 1.0,min_cd = -1,target_type = 6,target_type_param = 250,splash = -1,pri_target = '',target_limit = '',damage = 5000,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Stun (1s)',ability_name_2 = '',ability_desc_2 = '',},
  [17] = {id = '12001',name = 'Bow',icon = '',type = 2,labels = '',quality = 1,funcid = '',range = 900,cd = 1.0,min_cd = -1,target_type = 1,target_type_param = 1,splash = -1,pri_target = '',target_limit = '',damage = 75,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = '',ability_name_2 = '',ability_desc_2 = '',},
  [18] = {id = '12002',name = GameAPI.get_text_config('#449887385#lua'),icon = '',type = 2,labels = '13',quality = 2,funcid = '',range = 900,cd = 0.5,min_cd = -1,target_type = 1,target_type_param = 1,splash = 150,pri_target = '',target_limit = '',damage = 100,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Fire (5)',ability_name_2 = '',ability_desc_2 = '',},
  [19] = {id = '12003',name = GameAPI.get_text_config('#2077744162#lua'),icon = '',type = 2,labels = '6',quality = 2,funcid = '',range = 900,cd = 0.5,min_cd = -1,target_type = 1,target_type_param = 1,splash = -1,pri_target = '',target_limit = '',damage = 125,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Frost (5)',ability_name_2 = '',ability_desc_2 = '',},
  [20] = {id = '12004',name = GameAPI.get_text_config('#847068938#lua'),icon = '',type = 2,labels = '',quality = 2,funcid = '',range = 300,cd = 0.5,min_cd = -1,target_type = 5,target_type_param = 4,splash = -1,pri_target = '',target_limit = '',damage = 100,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = '',ability_name_2 = '',ability_desc_2 = '',},
  [21] = {id = '12005',name = GameAPI.get_text_config('#796384625#lua'),icon = '',type = 2,labels = '4',quality = 2,funcid = '',range = 900,cd = 1.0,min_cd = -1,target_type = 1,target_type_param = 1,splash = -1,pri_target = '',target_limit = '',damage = 200,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Poison (250/2s)',ability_name_2 = '',ability_desc_2 = '',},
  [22] = {id = '12006',name = 'Poisonspitter',icon = '',type = 2,labels = '4',quality = 2,funcid = '',range = 900,cd = 0.5,min_cd = -1,target_type = 7,target_type_param = 4,splash = -1,pri_target = '',target_limit = '',damage = 50,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = '',ability_name_2 = '',ability_desc_2 = '',},
  [23] = {id = '12007',name = 'Serpent',icon = '',type = 2,labels = '',quality = 2,funcid = '',range = 600,cd = 0.5,min_cd = -1,target_type = 1,target_type_param = 1,splash = -1,pri_target = '',target_limit = '',damage = 150,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Stun (0.75s)',ability_name_2 = '',ability_desc_2 = '',},
  [24] = {id = '12008',name = 'Frostbolt',icon = '',type = 2,labels = '6',quality = 3,funcid = '',range = 600,cd = 0.5,min_cd = -1,target_type = 1,target_type_param = 1,splash = 100,pri_target = '',target_limit = '',damage = 400,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = '',ability_name_2 = '',ability_desc_2 = '',},
  [25] = {id = '12009',name = GameAPI.get_text_config('#-1915529261#lua'),icon = '',type = 2,labels = '',quality = 3,funcid = '',range = 1200,cd = 2.0,min_cd = -1,target_type = 1,target_type_param = 1,splash = 300,pri_target = '',target_limit = '',damage = 400,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Attacks Increase Piercing Damage Taken by 10%, Stacks',ability_name_2 = '',ability_desc_2 = '',},
  [26] = {id = '12010',name = 'Knives',icon = '',type = 2,labels = '12',quality = 3,funcid = '',range = 600,cd = 2.0,min_cd = -1,target_type = 3,target_type_param = 600,splash = -1,pri_target = '',target_limit = '',damage = 150,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = '',ability_name_2 = '',ability_desc_2 = '',},
  [27] = {id = '12011',name = 'Lavaspitter',icon = '',type = 2,labels = '13',quality = 3,funcid = '',range = 600,cd = 1.0,min_cd = -1,target_type = 7,target_type_param = 4,splash = -1,pri_target = '',target_limit = '',damage = 300,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = '',ability_name_2 = '',ability_desc_2 = '',},
  [28] = {id = '12012',name = 'Lifeleecher',icon = '',type = 2,labels = '',quality = 3,funcid = '',range = 600,cd = 1.0,min_cd = -1,target_type = 1,target_type_param = 1,splash = -1,pri_target = '',target_limit = '',damage = 1000,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Attacks Grant Permanent 0.2 HP Regen and 60 Instant HP Regen',ability_name_2 = '',ability_desc_2 = '',},
  [29] = {id = '12013',name = 'Splasher',icon = '',type = 2,labels = '',quality = 3,funcid = '',range = 900,cd = 1.0,min_cd = -1,target_type = 5,target_type_param = 4,splash = 150,pri_target = '',target_limit = '',damage = 150,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = '',ability_name_2 = '',ability_desc_2 = '',},
  [30] = {id = '12014',name = 'Ballista',icon = '',type = 2,labels = '',quality = 4,funcid = '',range = 1200,cd = 5.0,min_cd = -1,target_type = 7,target_type_param = 8,splash = -1,pri_target = '',target_limit = '',damage = 2000,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Stun (3s)',ability_name_2 = '',ability_desc_2 = '',},
  [31] = {id = '12015',name = 'Shadowglaive',icon = '',type = 2,labels = '',quality = 4,funcid = '',range = 600,cd = -1,min_cd = -1,target_type = -1,target_type_param = -1,splash = -1,pri_target = '',target_limit = '',damage = 2500,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '逆时针在150范围内旋转，并逐渐扩大到600范围；触碰到的任何物体都会受到伤害。| 攻击速度提升旋转速度。',ability_desc_1 = 'Rotates in counterclockwise pattern at 150 range and builds up distance to 600 range; damages anything it touches. | Attack Speed increases rotation speed.',ability_name_2 = '',ability_desc_2 = '',},
  [32] = {id = '12016',name = GameAPI.get_text_config('#1655823074#lua'),icon = '',type = 2,labels = '',quality = 4,funcid = '',range = 900,cd = 1.0,min_cd = -1,target_type = 1,target_type_param = 1,splash = -1,pri_target = '',target_limit = '',damage = 4000,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Knockback (300)',ability_name_2 = '',ability_desc_2 = '',},
  [33] = {id = '13001',name = GameAPI.get_text_config('#-1032693266#lua'),icon = '',type = 3,labels = '',quality = 1,funcid = '',range = 1200,cd = 1.0,min_cd = -1,target_type = 1,target_type_param = -1,splash = -1,pri_target = '',target_limit = '',damage = 75,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = '',ability_name_2 = '',ability_desc_2 = '',},
  [34] = {id = '13002',name = 'Flamecaster',icon = '',type = 3,labels = '13',quality = 2,funcid = '',range = 900,cd = 0.2,min_cd = -1,target_type = 6,target_type_param = 150,splash = -1,pri_target = '',target_limit = '',damage = 60,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Fire (2)',ability_name_2 = '',ability_desc_2 = '',},
  [35] = {id = '13003',name = GameAPI.get_text_config('#-604188736#lua'),icon = '',type = 3,labels = '6',quality = 2,funcid = '',range = 300,cd = 1.0,min_cd = -1,target_type = 1,target_type_param = -1,splash = 150,pri_target = '',target_limit = '',damage = 200,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Frost (2)',ability_name_2 = '',ability_desc_2 = '',},
  [36] = {id = '13004',name = GameAPI.get_text_config('#-1853311376#lua'),icon = '',type = 3,labels = '4',quality = 2,funcid = '',range = 300,cd = 1.0,min_cd = -1,target_type = 1,target_type_param = -1,splash = -1,pri_target = '',target_limit = '',damage = 200,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Poison (250/2s)',ability_name_2 = '',ability_desc_2 = '',},
  [37] = {id = '13005',name = GameAPI.get_text_config('#-566799736#lua'),icon = '',type = 3,labels = '',quality = 2,funcid = '',range = 300,cd = 1.0,min_cd = -1,target_type = 1,target_type_param = -1,splash = -1,pri_target = '',target_limit = '',damage = 300,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Stun (1.5s)',ability_name_2 = '',ability_desc_2 = '',},
  [38] = {id = '13006',name = GameAPI.get_text_config('#-1085470169#lua'),icon = '',type = 3,labels = '',quality = 2,funcid = '',range = 900,cd = 2.0,min_cd = -1,target_type = 5,target_type_param = 4,splash = -1,pri_target = '',target_limit = '',damage = 300,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = '',ability_name_2 = '',ability_desc_2 = '',},
  [39] = {id = '13007',name = 'Soulstealer',icon = '',type = 3,labels = '',quality = 2,funcid = '',range = 900,cd = 2.0,min_cd = -1,target_type = 1,target_type_param = -1,splash = -1,pri_target = '',target_limit = '',damage = 1200,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = '+20 Max Mana Shield',ability_name_2 = '',ability_desc_2 = '',},
  [40] = {id = '13008',name = GameAPI.get_text_config('#1118247364#lua'),icon = '',type = 3,labels = '',quality = 3,funcid = '',range = 900,cd = 2.0,min_cd = -1,target_type = 1,target_type_param = -1,splash = 300,pri_target = '',target_limit = '',damage = 400,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Attacks Increase Magic Damage Taken by 10%, Stacks',ability_name_2 = '',ability_desc_2 = '',},
  [41] = {id = '13009',name = 'Icebreather',icon = '',type = 3,labels = '6',quality = 3,funcid = '',range = 600,cd = 2.0,min_cd = -1,target_type = 6,target_type_param = 150,splash = -1,pri_target = '',target_limit = '',damage = 500,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Frost (3)',ability_name_2 = '',ability_desc_2 = '',},
  [42] = {id = '13010',name = GameAPI.get_text_config('#-408828140#lua'),icon = '',type = 3,labels = '',quality = 3,funcid = '',range = 600,cd = 3.0,min_cd = -1,target_type = 5,target_type_param = 4,splash = -1,pri_target = '',target_limit = '',damage = 1200,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = '',ability_name_2 = '',ability_desc_2 = '',},
  [43] = {id = '13011',name = GameAPI.get_text_config('#-938128075#lua'),icon = '',type = 3,labels = '',quality = 3,funcid = '',range = 900,cd = 3.0,min_cd = -1,target_type = 6,target_type_param = 300,splash = -1,pri_target = '',target_limit = '',damage = 800,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Stun (2s)',ability_name_2 = '',ability_desc_2 = '',},
  [44] = {id = '13012',name = 'Manastone',icon = '',type = 3,labels = '',quality = 3,funcid = '',range = 1200,cd = 0.33,min_cd = -1,target_type = 1,target_type_param = -1,splash = -1,pri_target = '',target_limit = '',damage = 200,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Restores 80 Mana/s while Attacking',ability_name_2 = '',ability_desc_2 = '',},
  [45] = {id = '13013',name = GameAPI.get_text_config('#1042778024#lua'),icon = '',type = 3,labels = '',quality = 3,funcid = '',range = 1200,cd = 1.0,min_cd = -1,target_type = 5,target_type_param = 4,splash = -1,pri_target = '',target_limit = '',damage = 300,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = '+1% Damage per 1000 Max Mana Shield and +% Damage equal to +% Mana Regen While Mana Shield is Active, Otherwise Restore 20 mana per Enemy Hit',ability_name_2 = '',ability_desc_2 = '',},
  [46] = {id = '13014',name = GameAPI.get_text_config('#-892721525#lua'),icon = '',type = 3,labels = '6',quality = 4,funcid = '',range = 300,cd = 1.0,min_cd = -1,target_type = 3,target_type_param = 300,splash = -1,pri_target = '',target_limit = '',damage = 1500,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Frost (5) | Additional Ice Generators increase AoE (area-of-effect) by 75',ability_name_2 = '',ability_desc_2 = '',},
  [47] = {id = '13015',name = GameAPI.get_text_config('#854549090#lua'),icon = '',type = 3,labels = '13',quality = 4,funcid = '',range = 300,cd = 5.0,min_cd = -1,target_type = 1,target_type_param = -1,splash = 300,pri_target = '',target_limit = '',damage = 5000,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Fire (250 over 1s)',ability_name_2 = '',ability_desc_2 = '',},
  [48] = {id = '13016',name = GameAPI.get_text_config('#-384615704#lua'),icon = '',type = 3,labels = '',quality = 4,funcid = '',range = 600,cd = 3.0,min_cd = -1,target_type = 3,target_type_param = 600,splash = -1,pri_target = '',target_limit = '',damage = 600,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Activates once per round (30s), damages all enemies in range every 1.5s for 15s. +% Att. Speed increases duration.',ability_name_2 = '',ability_desc_2 = '',},
  [49] = {id = '14001',name = 'Boulder',icon = '',type = 4,labels = '',quality = 1,funcid = '',range = 900,cd = 1.0,min_cd = -1,target_type = 1,target_type_param = 1,splash = -1,pri_target = '',target_limit = '',damage = 75,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = '',ability_name_2 = '',ability_desc_2 = '',},
  [50] = {id = '14002',name = 'Blaster',icon = '',type = 4,labels = '',quality = 2,funcid = '',range = 600,cd = 1.0,min_cd = -1,target_type = 1,target_type_param = 1,splash = -1,pri_target = '',target_limit = '',damage = 300,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = '+10% Damage per Bash Upgrade and +25% Damage per Dazing Stuns Upgrade',ability_name_2 = '',ability_desc_2 = '',},
  [51] = {id = '14003',name = 'Bombs',icon = '',type = 4,labels = '',quality = 2,funcid = '',range = 300,cd = 1.0,min_cd = -1,target_type = 1,target_type_param = 1,splash = 300,pri_target = '',target_limit = '',damage = 250,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Stun (0.5s)',ability_name_2 = '',ability_desc_2 = '',},
  [52] = {id = '14004',name = GameAPI.get_text_config('#2021958801#lua'),icon = '',type = 4,labels = '',quality = 2,funcid = '',range = 900,cd = 0.5,min_cd = -1,target_type = 1,target_type_param = 1,splash = 150,pri_target = '',target_limit = '',damage = 100,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Heal 4HP per Enemy Hit',ability_name_2 = '',ability_desc_2 = '',},
  [53] = {id = '14005',name = GameAPI.get_text_config('#-1798939127#lua'),icon = '',type = 4,labels = '',quality = 2,funcid = '',range = 1200,cd = 1.0,min_cd = -1,target_type = 7,target_type_param = 4,splash = -1,pri_target = '',target_limit = '',damage = 100,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = '',ability_name_2 = '',ability_desc_2 = '',},
  [54] = {id = '14006',name = GameAPI.get_text_config('#-1692248209#lua'),icon = '',type = 4,labels = '',quality = 2,funcid = '',range = 1200,cd = 2.0,min_cd = -1,target_type = 1,target_type_param = 1,splash = 300,pri_target = '',target_limit = '',damage = 300,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = '',ability_name_2 = '',ability_desc_2 = '',},
  [55] = {id = '14007',name = GameAPI.get_text_config('#2047156208#lua'),icon = '',type = 4,labels = '',quality = 2,funcid = '',range = 600,cd = 0.5,min_cd = -1,target_type = 1,target_type_param = 1,splash = -1,pri_target = '',target_limit = '',damage = 150,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Attacks Increase Siege Damage Taken by 5%, Stacks',ability_name_2 = '',ability_desc_2 = '',},
  [56] = {id = '14008',name = GameAPI.get_text_config('#1567479695#lua'),icon = '',type = 4,labels = '',quality = 3,funcid = '',range = 1200,cd = 2.0,min_cd = -1,target_type = 5,target_type_param = 8,splash = -1,pri_target = '',target_limit = '',damage = 350,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = '',ability_name_2 = '',ability_desc_2 = '',},
  [57] = {id = '14009',name = GameAPI.get_text_config('#-1005853629#lua'),icon = '',type = 4,labels = '',quality = 3,funcid = '',range = 900,cd = 0.25,min_cd = -1,target_type = 3,target_type_param = 375,splash = -1,pri_target = '',target_limit = '',damage = 125,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Stun (2s)',ability_name_2 = '',ability_desc_2 = '',},
  [58] = {id = '14010',name = GameAPI.get_text_config('#874034219#lua'),icon = '',type = 4,labels = '6',quality = 3,funcid = '',range = 900,cd = 3.0,min_cd = -1,target_type = 1,target_type_param = 1,splash = 300,pri_target = '',target_limit = '',damage = 600,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Frost (2) | Creates a bomb that explodes after 1s dealing 600 Damage and Frost (3)',ability_name_2 = '',ability_desc_2 = '',},
  [59] = {id = '14011',name = GameAPI.get_text_config('#277701640#lua'),icon = '',type = 4,labels = '13',quality = 3,funcid = '',range = 900,cd = 0.5,min_cd = -1,target_type = 1,target_type_param = 1,splash = -1,pri_target = '',target_limit = '',damage = 500,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Attacks Increase Fire Damage Taken by 20% for 1s',ability_name_2 = '',ability_desc_2 = '',},
  [60] = {id = '14012',name = 'Meatapult',icon = '',type = 4,labels = '',quality = 3,funcid = '',range = 600,cd = 2.0,min_cd = -1,target_type = 1,target_type_param = 1,splash = 300,pri_target = '',target_limit = '',damage = 600,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = '+1% Damage per 500 Max HP Gained and +% Damage equal to +% Max HP',ability_name_2 = '',ability_desc_2 = '',},
  [61] = {id = '14013',name = GameAPI.get_text_config('#647571629#lua'),icon = '',type = 4,labels = '4',quality = 3,funcid = '',range = 1200,cd = 2.0,min_cd = -1,target_type = 1,target_type_param = 1,splash = 300,pri_target = '',target_limit = '',damage = 600,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Poison (250/2s)',ability_name_2 = '',ability_desc_2 = '',},
  [62] = {id = '14014',name = GameAPI.get_text_config('#754481647#lua'),icon = '',type = 4,labels = '',quality = 4,funcid = '',range = 600,cd = 5.0,min_cd = -1,target_type = 3,target_type_param = 300,splash = -1,pri_target = '',target_limit = '',damage = 10000,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Places Mines that Last 30s around the tower | Stun (3s)',ability_name_2 = '',ability_desc_2 = '',},
  [63] = {id = '14015',name = GameAPI.get_text_config('#-71514#lua'),icon = '',type = 4,labels = '',quality = 4,funcid = '',range = 1200,cd = 10.0,min_cd = -1,target_type = 7,target_type_param = 8,splash = 300,pri_target = '',target_limit = '',damage = 5000,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = '',ability_name_2 = '',ability_desc_2 = '',},
  [64] = {id = '14016',name = GameAPI.get_text_config('#1870138470#lua'),icon = '',type = 4,labels = '13',quality = 4,funcid = '',range = 300,cd = 3.0,min_cd = -1,target_type = 6,target_type_param = 900,splash = -1,pri_target = '',target_limit = '',damage = 1500,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Fire (75) | Attacks Leave Behind Burning Oil for 3s dealing 1000 DPS and Fire (25/s)',ability_name_2 = '',ability_desc_2 = '',},
  [65] = {id = '15001',name = GameAPI.get_text_config('#-197020425#lua'),icon = '',type = 5,labels = '',quality = 1,funcid = '',range = 600,cd = 1.0,min_cd = -1,target_type = 1,target_type_param = -1,splash = -1,pri_target = '',target_limit = '',damage = 75,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = '',ability_name_2 = '',ability_desc_2 = '',},
  [66] = {id = '15002',name = GameAPI.get_text_config('#1763052477#lua'),icon = '',type = 5,labels = '',quality = 2,funcid = '',range = 1200,cd = 0.5,min_cd = -1,target_type = 5,target_type_param = 4,splash = -1,pri_target = '',target_limit = '',damage = 75,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = '',ability_name_2 = '',ability_desc_2 = '',},
  [67] = {id = '15003',name = GameAPI.get_text_config('#-1783234651#lua'),icon = '',type = 5,labels = '',quality = 2,funcid = '',range = 900,cd = 1.0,min_cd = -1,target_type = 1,target_type_param = -1,splash = 300,pri_target = '',target_limit = '',damage = 150,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = '',ability_name_2 = '',ability_desc_2 = '',},
  [68] = {id = '15004',name = GameAPI.get_text_config('#1341356244#lua'),icon = '',type = 5,labels = '',quality = 2,funcid = '',range = 1200,cd = 3.0,min_cd = -1,target_type = -1,target_type_param = -1,splash = 150,pri_target = '',target_limit = '',damage = 450,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Stun (1.5s)',ability_name_2 = '',ability_desc_2 = '',},
  [69] = {id = '15005',name = GameAPI.get_text_config('#-873090232#lua'),icon = '',type = 5,labels = '',quality = 2,funcid = '',range = 300,cd = 1.0,min_cd = -1,target_type = 1,target_type_param = -1,splash = -1,pri_target = '',target_limit = '',damage = 200,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Attacks Increase Chaos Damage Taken by 10%, Stacks',ability_name_2 = '',ability_desc_2 = '',},
  [70] = {id = '15006',name = GameAPI.get_text_config('#654364031#lua'),icon = '',type = 5,labels = '',quality = 2,funcid = '',range = 900,cd = 1.0,min_cd = -1,target_type = 1,target_type_param = -1,splash = -1,pri_target = '',target_limit = '',damage = 250,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Stun (1.5s)',ability_name_2 = '',ability_desc_2 = '',},
  [71] = {id = '15007',name = 'Healthstone',icon = '',type = 5,labels = '4',quality = 2,funcid = '',range = 600,cd = 0.33,min_cd = -1,target_type = 1,target_type_param = -1,splash = -1,pri_target = '',target_limit = '',damage = 125,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Heal 40HP/s While Attacking',ability_name_2 = '',ability_desc_2 = '',},
  [72] = {id = '15008',name = GameAPI.get_text_config('#-450471785#lua'),icon = '',type = 5,labels = '',quality = 3,funcid = '',range = 600,cd = 4.0,min_cd = -1,target_type = 7,target_type_param = 12,splash = -1,pri_target = '',target_limit = '',damage = 600,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = '',ability_name_2 = '',ability_desc_2 = '',},
  [73] = {id = '15009',name = GameAPI.get_text_config('#82906028#lua'),icon = '',type = 5,labels = '',quality = 3,funcid = '',range = 900,cd = 3.0,min_cd = -1,target_type = 6,target_type_param = 300,splash = -1,pri_target = '',target_limit = '',damage = 600,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Heal 40HP per Enemy Hit',ability_name_2 = '',ability_desc_2 = '',},
  [74] = {id = '15010',name = 'Crippler',icon = '',type = 5,labels = '',quality = 3,funcid = '',range = 1200,cd = 1.0,min_cd = -1,target_type = 1,target_type_param = -1,splash = -1,pri_target = '',target_limit = '',damage = 800,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Attacks Reduce Enemy Damage by 50% for 10 Seconds',ability_name_2 = '',ability_desc_2 = '',},
  [75] = {id = '15011',name = GameAPI.get_text_config('#1898668466#lua'),icon = '',type = 5,labels = '',quality = 3,funcid = '',range = 900,cd = 0.33,min_cd = -1,target_type = 1,target_type_param = -1,splash = -1,pri_target = '',target_limit = '',damage = 200,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = '+10% damage for every additional Death Generator',ability_name_2 = '',ability_desc_2 = '',},
  [76] = {id = '15012',name = 'Immolation',icon = '',type = 5,labels = '',quality = 3,funcid = '',range = 600,cd = 1.0,min_cd = -1,target_type = 3,target_type_param = 300,splash = -1,pri_target = '',target_limit = '',damage = 200,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Fire (20)',ability_name_2 = '',ability_desc_2 = '',},
  [77] = {id = '15013',name = GameAPI.get_text_config('#454854770#lua'),icon = '',type = 5,labels = '13',quality = 3,funcid = '',range = 300,cd = 1.5,min_cd = -1,target_type = 1,target_type_param = -1,splash = -1,pri_target = '',target_limit = '',damage = 1500,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Every 10s, Raise a Skeletal Mage for 10s from a corpse, Duration increased by +% Attack Speed',ability_name_2 = '',ability_desc_2 = '',},
  [78] = {id = '15014',name = GameAPI.get_text_config('#-1769914318#lua'),icon = '',type = 5,labels = '13',quality = 4,funcid = '',range = 900,cd = 1.0,min_cd = -1,target_type = 5,target_type_param = 8,splash = -1,pri_target = '',target_limit = '',damage = 250,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Poison (250/2s)',ability_name_2 = '',ability_desc_2 = '',},
  [79] = {id = '15015',name = GameAPI.get_text_config('#-1494428756#lua'),icon = '',type = 5,labels = '',quality = 4,funcid = '',range = 1200,cd = 8.0,min_cd = -1,target_type = 3,target_type_param = 150,splash = -1,pri_target = '',target_limit = '',damage = 3000,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Summon Infernal (8s) 2000 DPS, Immolation (500 DPS) Fire (100) | Stun (2s)',ability_name_2 = '',ability_desc_2 = '',},
  [80] = {id = '15016',name = 'Parasite',icon = '',type = 5,labels = '',quality = 4,funcid = '',range = 1200,cd = 1.0,min_cd = -1,target_type = 1,target_type_param = -1,splash = -1,pri_target = '',target_limit = '',damage = 800,damage_modify = -1,bullet_id = '',path_speed = -1,effect_hit = '',sound_id = '',ability_count = -1,ability_name_1 = '',ability_desc_1 = 'Stackable 800 DPS that Heals 50 HP/s',ability_name_2 = '',ability_desc_2 = '',},
}

local id_to_index={
   ['11001'] = 1,
   ['11002'] = 2,
   ['11003'] = 3,
   ['11004'] = 4,
   ['11005'] = 5,
   ['11006'] = 6,
   ['11007'] = 7,
   ['11008'] = 8,
   ['11009'] = 9,
   ['11010'] = 10,
   ['11011'] = 11,
   ['11012'] = 12,
   ['11013'] = 13,
   ['11014'] = 14,
   ['11015'] = 15,
   ['11016'] = 16,
   ['12001'] = 17,
   ['12002'] = 18,
   ['12003'] = 19,
   ['12004'] = 20,
   ['12005'] = 21,
   ['12006'] = 22,
   ['12007'] = 23,
   ['12008'] = 24,
   ['12009'] = 25,
   ['12010'] = 26,
   ['12011'] = 27,
   ['12012'] = 28,
   ['12013'] = 29,
   ['12014'] = 30,
   ['12015'] = 31,
   ['12016'] = 32,
   ['13001'] = 33,
   ['13002'] = 34,
   ['13003'] = 35,
   ['13004'] = 36,
   ['13005'] = 37,
   ['13006'] = 38,
   ['13007'] = 39,
   ['13008'] = 40,
   ['13009'] = 41,
   ['13010'] = 42,
   ['13011'] = 43,
   ['13012'] = 44,
   ['13013'] = 45,
   ['13014'] = 46,
   ['13015'] = 47,
   ['13016'] = 48,
   ['14001'] = 49,
   ['14002'] = 50,
   ['14003'] = 51,
   ['14004'] = 52,
   ['14005'] = 53,
   ['14006'] = 54,
   ['14007'] = 55,
   ['14008'] = 56,
   ['14009'] = 57,
   ['14010'] = 58,
   ['14011'] = 59,
   ['14012'] = 60,
   ['14013'] = 61,
   ['14014'] = 62,
   ['14015'] = 63,
   ['14016'] = 64,
   ['15001'] = 65,
   ['15002'] = 66,
   ['15003'] = 67,
   ['15004'] = 68,
   ['15005'] = 69,
   ['15006'] = 70,
   ['15007'] = 71,
   ['15008'] = 72,
   ['15009'] = 73,
   ['15010'] = 74,
   ['15011'] = 75,
   ['15012'] = 76,
   ['15013'] = 77,
   ['15014'] = 78,
   ['15015'] = 79,
   ['15016'] = 80,
}

local skill={}
skill.__index=skill 

function skill.length() 
   return #_data 
end 

function skill.indexOf(index) 
 index = tonumber(index) 
  
 local rawData = _data[index] 
 if not rawData then 
 return nil 
 end 
local ret = setmetatable({}, {__index = function(t, k) return rawData[k] end, __newindex = function(t, k, v)end }) 
 return ret 
end 

function skill.get(id) 
   
    return skill.indexOf(id_to_index[id])
end 

return skill