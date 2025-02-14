local SurviveConst                      = {}

SurviveConst.REFRESH_INTER              = 2
SurviveConst.WAVE_MAX_COUNT             = 8

SurviveConst.REFRESH_GOLD_MONSTER_COUNT = {
    [13] = true,
    [25] = true
}
-- 13,25
-- 近战中甲（权重5）、近战普甲（9）、近战重甲（权重5）、车城甲（权重5）、远程（权重5
SurviveConst.TAG_INFANTRY               = "infantry" -- 中甲
SurviveConst.TAG_BANDIT                 = "bandit"   -- 轻甲
SurviveConst.TAG_ROBBER                 = "robber"   -- 近战重甲
SurviveConst.TAG_KNIGHT                 = "knight"   -- 加强型护甲
SurviveConst.TAG_ARCHER                 = "archer"   -- 无护甲
SurviveConst.TAG_POISONED               = "poisoned" --Poisoned

SurviveConst.TAG_ENEMY                  = "enemy"

SurviveConst.MONSTER_TYPE_INFANTRY      = 0
SurviveConst.MONSTER_TYPE_BANDIT        = 1
SurviveConst.MONSTER_TYPE_ROBBER        = 2
SurviveConst.MONSTER_TYPE_KNIGHT        = 3
SurviveConst.MONSTER_TYPE_ARCHER        = 4

SurviveConst.ARMOR_TYPE_MAP             = {
    [1] = "",
    [2] = "",
    [3] = "",
    [4] = "",
    [5] = "",
}

SurviveConst.MONSTER_TYPE_MAP_TAG       = {
    [SurviveConst.MONSTER_TYPE_INFANTRY] = SurviveConst.TAG_INFANTRY,
    [SurviveConst.MONSTER_TYPE_BANDIT] = SurviveConst.TAG_BANDIT,
    [SurviveConst.MONSTER_TYPE_ROBBER] = SurviveConst.TAG_ROBBER,
    [SurviveConst.MONSTER_TYPE_KNIGHT] = SurviveConst.TAG_KNIGHT,
    [SurviveConst.MONSTER_TYPE_ARCHER] = SurviveConst.TAG_ARCHER,
}

SurviveConst.GAME_STATUS_READY          = 1 -- 准备
SurviveConst.GAME_STATUS_BATTLE         = 2 --战斗
SurviveConst.GAME_STATUS_ADDITIONAL     = 3 --额外
SurviveConst.GAME_STATUS_SETTLEMENT     = 4 --结算


SurviveConst.STAGE_WAVE_EVENT_NORMAL  = 1
SurviveConst.STAGE_WAVE_EVENT_COMMOND = 2
SurviveConst.STAGE_WAVE_EVENT_BOSS    = 3

SurviveConst.IS_FIGHT_TEST            = false

-- SurviveConst.STATE_TAG_DANTI=1
-- SurviveConst.STATE_TAG_JIANSHE=2
-- SurviveConst.STATE_TAG_TANSHE = 3
-- SurviveConst.
-- local RADIUS_300          = 450
-- local RADIUS_600          = 900
-- local RADIUS_900          = 1350
-- local RADIUS_1200         = 1800
SurviveConst.RANGE_300                = 450
SurviveConst.RANGE_600                = 900
SurviveConst.RANGE_900                = 1350
SurviveConst.RANGE_1200               = 1800

SurviveConst.STATE_ENEMY_TAG          = "1000"
SurviveConst.STATE_PLAYER_TAG         = "1001"
SurviveConst.STATE_TAG_FINAL_BOSS     = "1002"
SurviveConst.STATE_TAG_JIANCHI        = "1003"
SurviveConst.STATE_TAG_BOSS_NPC       = "1004"
SurviveConst.STATE_TAG_SOUL_ACTOR     = "1005"

SurviveConst.PRIOITY_TYPE_1           = 1
SurviveConst.PRIOITY_TYPE_2           = 2
SurviveConst.PRIOITY_TYPE_3           = 3
SurviveConst.PRIOITY_TYPE_4           = 4
SurviveConst.PRIOITY_TYPE_5           = 5
SurviveConst.PRIOITY_TYPE_6           = 6
SurviveConst.PRIOITY_TYPE_7           = 7
SurviveConst.PRIOITY_TYPE_8           = 8
SurviveConst.PRIOITY_TYPE_9           = 9
SurviveConst.PRIOITY_TYPE_10          = 10
SurviveConst.PRIOITY_TYPE_11          = 11
SurviveConst.PRIOITY_TYPE_12          = 12
SurviveConst.PRIOITY_TYPE_13          = 13
SurviveConst.PRIOITY_TYPE_14          = 14
SurviveConst.PRIOITY_TYPE_15          = 15

SurviveConst.ARMOR_TYPE_WU            = 20000 -- 无甲
SurviveConst.ARMOR_TYPE_QING          = 20001 -- 轻甲
SurviveConst.ARMOR_TYPE_ZHONG         = 20002 -- 中甲
SurviveConst.ARMOR_TYPE_ZZHONG        = 20003 -- 重甲
SurviveConst.ARMOR_TYPE_JIAQIANG      = 20004 --加强重甲

SurviveConst.ARMOR_NAME_MAP           = {
    [SurviveConst.ARMOR_TYPE_WU] = GameAPI.get_text_config('#716885839#lua'),
    [SurviveConst.ARMOR_TYPE_QING] = GameAPI.get_text_config('#1788376027#lua'),
    [SurviveConst.ARMOR_TYPE_ZHONG] = GameAPI.get_text_config('#652282779#lua'),
    [SurviveConst.ARMOR_TYPE_ZZHONG] = GameAPI.get_text_config('#1273253062#lua'),
    [SurviveConst.ARMOR_TYPE_JIAQIANG] = GameAPI.get_text_config('#1183599919#lua'),
}

-- skilldata type中
-- 普通 1 ~= 10000
-- 穿刺 2 ~= 10001
-- 魔法 3 ~= 10002
-- 攻城 4 ~= 10003
-- 混乱 5 ~= 10004
-- monster armor_type
-- 无甲 20000
-- 轻甲 20001
-- 中甲 20002
-- 重甲 20003
-- 加强型护甲 20004
SurviveConst.PRIOITY_ARMOR_MAP        = {
    [SurviveConst.PRIOITY_TYPE_1] = 20002,
    [SurviveConst.PRIOITY_TYPE_2] = 20001,
    [SurviveConst.PRIOITY_TYPE_3] = 20003,
    [SurviveConst.PRIOITY_TYPE_4] = 20004,
    [SurviveConst.PRIOITY_TYPE_5] = 20000,
}

SurviveConst.ARMOR_COLOR_MAP          = {
    [SurviveConst.ARMOR_TYPE_WU] = "48b05d",
    [SurviveConst.ARMOR_TYPE_QING] = "c89348",
    [SurviveConst.ARMOR_TYPE_ZHONG] = "ffffff",
    [SurviveConst.ARMOR_TYPE_ZZHONG] = "5ba0fc",
    [SurviveConst.ARMOR_TYPE_JIAQIANG] = "cf513c",
}

SurviveConst.PRIOITY_BUFF_MAP         = {
    [SurviveConst.PRIOITY_TYPE_6] = 1101201,
    [SurviveConst.PRIOITY_TYPE_7] = 1101501,
    [SurviveConst.PRIOITY_TYPE_8] = 1000003,
    [SurviveConst.PRIOITY_TYPE_9] = 1200501,
    [SurviveConst.PRIOITY_TYPE_10] = 1500901,
    [SurviveConst.PRIOITY_TYPE_11] = 1300301,
    [SurviveConst.PRIOITY_TYPE_12] = 1400801,
    [SurviveConst.PRIOITY_TYPE_13] = 1501601,
    [SurviveConst.PRIOITY_TYPE_14] = 1000002,
    [SurviveConst.PRIOITY_TYPE_15] = 1501501,
}

SurviveConst.DAMAGE_TYPE_1            = 1 -- 普通
SurviveConst.DAMAGE_TYPE_2            = 2 -- 穿刺
SurviveConst.DAMAGE_TYPE_3            = 3 -- 魔法
SurviveConst.DAMAGE_TYPE_4            = 4 -- 攻城
SurviveConst.DAMAGE_TYPE_5            = 5 -- 混乱
SurviveConst.DAMAGE_TYPE_6            = 6 -- 战斗
SurviveConst.DAMAGE_TYPE_7            = 7 --收入
SurviveConst.DAMAGE_TYPE_8            = 8 --通用

SurviveConst.DAMAGE_TYPE_NAME_MAP     = {
    [SurviveConst.DAMAGE_TYPE_1] = GameAPI.get_text_config('#-1979606396#lua'),
    [SurviveConst.DAMAGE_TYPE_2] = GameAPI.get_text_config('#-1995563702#lua'),
    [SurviveConst.DAMAGE_TYPE_3] = GameAPI.get_text_config('#268643451#lua'),
    [SurviveConst.DAMAGE_TYPE_4] = GameAPI.get_text_config('#1493984107#lua'),
    [SurviveConst.DAMAGE_TYPE_5] = GameAPI.get_text_config('#1573547953#lua'),
    [SurviveConst.DAMAGE_TYPE_6] = GameAPI.get_text_config('#473460941#lua'),
}


SurviveConst.DAMAGE_TYPE_NAME_MAP2                  = {
    [SurviveConst.DAMAGE_TYPE_1] = GameAPI.get_text_config('#827834880#lua'),
    [SurviveConst.DAMAGE_TYPE_2] = GameAPI.get_text_config('#220769121#lua'),
    [SurviveConst.DAMAGE_TYPE_3] = GameAPI.get_text_config('#-440483825#lua'),
    [SurviveConst.DAMAGE_TYPE_4] = GameAPI.get_text_config('#673154106#lua'),
    [SurviveConst.DAMAGE_TYPE_5] = GameAPI.get_text_config('#-448889043#lua'),
    [SurviveConst.DAMAGE_TYPE_6] = GameAPI.get_text_config('#-1677169521#lua'),
}

SurviveConst.SKILLTYPE_ICON                         = {
    [SurviveConst.DAMAGE_TYPE_1] = 134245656,
    [SurviveConst.DAMAGE_TYPE_2] = 134260680,
    [SurviveConst.DAMAGE_TYPE_3] = 134248404,
    [SurviveConst.DAMAGE_TYPE_4] = 134231000,
    [SurviveConst.DAMAGE_TYPE_5] = 134253684,
    [SurviveConst.DAMAGE_TYPE_6] = 134233424,
    [SurviveConst.DAMAGE_TYPE_7] = 134233424,
    [SurviveConst.DAMAGE_TYPE_8] = 134233424,
}

SurviveConst.LABEL_1                                = 1 -- 火焰
SurviveConst.LABEL_2                                = 2 -- 尖刺
SurviveConst.LABEL_3                                = 3 -- 冰冻
SurviveConst.LABEL_4                                = 4 -- 中毒

SurviveConst.LABEL_NAME_MAP                         = {
    [SurviveConst.LABEL_1] = GameAPI.get_text_config('#-446382284#lua'),
    [SurviveConst.LABEL_2] = GameAPI.get_text_config('#-231491169#lua'),
    [SurviveConst.LABEL_3] = GameAPI.get_text_config('#795420703#lua'),
    [SurviveConst.LABEL_4] = GameAPI.get_text_config('#-84266371#lua'),
}

SurviveConst.ABILITY_TYPE_MAP                       = {
    [1] = 134253467,
    [2] = 134223091,
    [3] = 134258375,
    [4] = 134262286,
    [5] = 134263340,
    [6] = 134253350,
}

SurviveConst.STAGE_CONDITION_ANY_ONE                = 1
SurviveConst.STAGE_CONDITION_ALL                    = 2

SurviveConst.TAG_AREA_300                           = "area300"
SurviveConst.TAG_AREA_600                           = "area600"
SurviveConst.TAG_AREA_900                           = "area900"
SurviveConst.TAG_AREA_1200                          = "area1200"

SurviveConst.ATK_TARGET_TYPE_1                      = 1 -- 单体目标
SurviveConst.ATK_TARGET_TYPE_2                      = 2 -- 弹幕
SurviveConst.ATK_TARGET_TYPE_3                      = 3 -- 溅射
SurviveConst.ATK_TARGET_TYPE_4                      = 4 -- 冲击波
SurviveConst.ATK_TARGET_TYPE_5                      = 5 -- 弹射
SurviveConst.ATK_TARGET_TYPE_6                      = 6 -- 自身周围
SurviveConst.ATK_TARGET_TYPE_7                      = 7 -- 环绕

SurviveConst.ATK_TARGET_NAME_MAP                    = {
    [SurviveConst.ATK_TARGET_TYPE_1] = GameAPI.get_text_config('#-1020296211#lua'),
    [SurviveConst.ATK_TARGET_TYPE_2] = GameAPI.get_text_config('#-892143210#lua'),
    [SurviveConst.ATK_TARGET_TYPE_3] = GameAPI.get_text_config('#450914416#lua'),
    [SurviveConst.ATK_TARGET_TYPE_4] = GameAPI.get_text_config('#614343347#lua'),
    [SurviveConst.ATK_TARGET_TYPE_5] = GameAPI.get_text_config('#-1832333332#lua'),
    [SurviveConst.ATK_TARGET_TYPE_6] = GameAPI.get_text_config('#-1770305516#lua'),
    [SurviveConst.ATK_TARGET_TYPE_7] = GameAPI.get_text_config('#-357699902#lua'),
}

SurviveConst.ATK_TARGET_VALUE_MAP                   = {
    [SurviveConst.ATK_TARGET_TYPE_2] = GameAPI.get_text_config('#1653121002#lua'),
    [SurviveConst.ATK_TARGET_TYPE_3] = GameAPI.get_text_config('#824887180#lua'),
    [SurviveConst.ATK_TARGET_TYPE_4] = GameAPI.get_text_config('#-1871614377#lua'),
    [SurviveConst.ATK_TARGET_TYPE_5] = GameAPI.get_text_config('#1506952231#lua'),
    [SurviveConst.ATK_TARGET_TYPE_6] = GameAPI.get_text_config('#815404667#lua'),
}

SurviveConst.RESOURCE_TYPE_GOLD                     = 1 -- 金币
SurviveConst.RESOURCE_TYPE_DIAMOND                  = 2 -- 钻石

SurviveConst.RESOURCE_TYPE_NAME_MAP                 = {
    [SurviveConst.RESOURCE_TYPE_GOLD] = GameAPI.get_text_config('#62285769#lua'),
    [SurviveConst.RESOURCE_TYPE_DIAMOND] = GameAPI.get_text_config('#-1237842745#lua'),
}

SurviveConst.SELECT_REWARD_SKILL                    = 1                 -- 明牌三选一
SurviveConst.SELECT_REWARD_SKILL_HIDE               = 2                 -- 暗牌三选一
SurviveConst.SELECT_REWARD_SOUL                     = 3                 --选塔魂
SurviveConst.SELECT_REWARD_TASK                     = 4                 -- 选任务

SurviveConst.REWARD_TYPE_RES                        = 1                 ---直接发货币奖励
SurviveConst.REWARD_TYPE_SELECT                     = 2                 ---三选一
SurviveConst.RRWARD_TYPE_RANDOM                     = 3                 ---随机奖励

SurviveConst.UI_MOUSE_TYPE_MONSTER_ATK              = 1                 --怪物攻击信息
SurviveConst.UI_MOUSE_TYPE_MONSTER_DEF              = 2                 --怪物防御信息
SurviveConst.UI_MOUSE_TYPE_PLAYER_INFO              = 3                 --玩家信息

SurviveConst.ACHIEVEMENT_COND_PASS                  = "1"               -- 通关
SurviveConst.ACHIEVEMENT_COND_PASS_NO_DIE           = "2"               -- 不死通关
SurviveConst.ACHIEVEMENT_COND_PASS_SIGNAL_SKILL     = "3"               -- 购买单系通关
SurviveConst.ACHIEVEMENT_COND_PASS_NO_HURT          = "4"               --全局无伤通关
SurviveConst.ACHIEVEMENT_COND_KILL_COUNT            = "5"               --累计击杀敌人
SurviveConst.ACHIEVEMENT_COND_GOLD_IN               = "6"               --累计金币收入
SurviveConst.ACHIEVEMENT_COND_ATTR                  = "7"               --单局特定属性达到
SurviveConst.ACHIEVEMENT_COND_SKILL_BUY             = "8"               --一局内购买指定技能/升级次数
SurviveConst.ACHIEVEMENT_COND_CUR_GOLD_IN           = "9"               --局内当前金币达到xxx
SurviveConst.ACHIEVEMENT_COND_MISS                  = "10"              --累计闪避次数
SurviveConst.ACHIEVEMENT_COND_ZUDUI_PASS            = "11"              --组队通关次数
SurviveConst.ACHIEVEMENT_COND_SHOP_REFRESH          = "12"              --累计商店刷新次数
SurviveConst.ACHIEVEMENT_COND_DANXI_PASS            = "13"              --购买单系通关xx难度以上
SurviveConst.ACHIEVEMENT_COND_CHAOGUO_100           = "14"              --单局游戏某类型武器数量超过100个
SurviveConst.ACHIEVEMENT_COND_NO_CHENGSE_PASS_N2    = "15"              --未购买橙色品质武器通关N2以上难度
SurviveConst.ACHIEVEMENT_COND_JIANCHI_KILL          = "16"              --累计通过尖刺伤害击杀敌人
SurviveConst.ACHIEVEMENT_COND_FIGHT_FAILED          = "17"              --累计挑战失败
SurviveConst.ACHIEVEMENT_COND_SHUAXIN_IN            = "18"              -- 单局内刷新次数
SurviveConst.ACHIEVEMENT_COND_5WUQI_CHAOGUO         = "19"              -- 一局游戏内,5种系列武器数量均超过
SurviveConst.ACHIEVEMENT_COND_BOSS_KILL_TIME        = "20"              -- 击杀最终boss时间
SurviveConst.ACHIEVEMENT_COND_SHOP_REFRESH_COUNT    = "21"              -- 一局游戏内,连续20次商店刷新都未购买
SurviveConst.ACHIEVEMENT_COND_JIXIAO                = "22"              -- 通过任意难度有极小概率获取
SurviveConst.ACHIEVEMENT_COND_HP_LESS_PASS          = "23"              --- 血量未低于%x通关
SurviveConst.ACHIEVEMENT_COND_SHOUCANGDITU          = "24"              -- 收藏地图
SurviveConst.ACHIEVEMENT_COND_HAOPING               = "25"              -- 好评
SurviveConst.ACHIEVEMENT_COND_SHEQUTIEZIBEIJIAJING  = "26"              -- 社区帖子被加精
SurviveConst.ACHIEVEMENT_COND_SHEQUPINGLUNHUANLESHU = "27"              -- 帖子评论欢乐数
SurviveConst.ACHIEVEMENT_COND_HERO_ATTR_IN          = "28"              --英雄属性达到，param：属性ID; VALUE:属性值
SurviveConst.ACHIEVEMENT_COND_SAVE_ITEM             = "29"              --持有saveitem数量达到，param:道具ID;VALUE:数量
SurviveConst.ACHIEVEMENT_COND_MAP_LV_DIFF           = "30"              --组队通关，param：等级差（玩家地图等级-通关后与其他玩家地图等级>=param），value：通关次数
SurviveConst.ACHIEVEMENT_COND_DIAMOND_IN            = "31"              --局内累计魂石收入：VALUE:数量
SurviveConst.ACHIEVEMENT_COND_ABYSS_FLOOR           = "32"              -- 魂石之路层级，param：暂无，value 层级
SurviveConst.ACHIEVEMENT_COND_KILL_MONSTERID        = "33"              --击杀特定id怪物
SurviveConst.ACHIEVEMENT_COND_STAGE_TIME_RECORD     = "34"              -- 关卡时长记录

SurviveConst.ACHIEVEMENT_REFRESH_TYPE_PASS          = "pass"            --通关关卡
SurviveConst.ACHIEVEMENT_REFRESH_TYPE_KILL          = "kill"            --击杀敌人
SurviveConst.ACHIEVEMENT_REFRESH_TYPE_GOLD          = "gold"            --获取金币
SurviveConst.ACHIEVEMENT_REFRESH_TYPE_ATTR          = "attr"            --达到特定属性
SurviveConst.ACHIEVEMENT_REFRESH_TYPE_BUY_SKILL     = "skill"           --购买技能
SurviveConst.ACHIEVEMENT_REFRESH_TYPE_MISS          = "miss"            --闪避次数
SurviveConst.ACHIEVEMENT_REFRESH_TYPE_REFRESH_SKILL = "refresh_skill"   --刷新商店
SurviveConst.ACHIEVEMENT_REFRESH_TYPE_PLAYED        = "played"          -- 结束一局
SurviveConst.ACHIEVEMENT_REFRESH_ADD_SKILL          = "add_skill"       -- 增加技能
SurviveConst.ACHIEVEMENT_REFRESH_KILL_FINAL_BOSS    = "kill_final_boss" --击杀最终boss
SurviveConst.ACHIEVEMENT_REFRESH_TYPE_DIAMOND       = "diamond"

SurviveConst.ACHIEVEMENT_REFRESH_TYPE_MAP           = {
    [SurviveConst.ACHIEVEMENT_REFRESH_TYPE_PASS] = {
        [SurviveConst.ACHIEVEMENT_COND_PASS] = 1,
        [SurviveConst.ACHIEVEMENT_COND_PASS_NO_DIE] = 1,
        [SurviveConst.ACHIEVEMENT_COND_PASS_SIGNAL_SKILL] = 1,
        [SurviveConst.ACHIEVEMENT_COND_PASS_NO_HURT] = 1,
        [SurviveConst.ACHIEVEMENT_COND_ZUDUI_PASS] = 1,
        [SurviveConst.ACHIEVEMENT_COND_DANXI_PASS] = 1,
        [SurviveConst.ACHIEVEMENT_COND_NO_CHENGSE_PASS_N2] = 1,
        [SurviveConst.ACHIEVEMENT_COND_JIXIAO] = 1,
        [SurviveConst.ACHIEVEMENT_COND_HP_LESS_PASS] = 1,
        [SurviveConst.ACHIEVEMENT_COND_MAP_LV_DIFF] = 1,
    },
    [SurviveConst.ACHIEVEMENT_REFRESH_TYPE_KILL] = {
        [SurviveConst.ACHIEVEMENT_COND_KILL_COUNT] = 1,
        [SurviveConst.ACHIEVEMENT_COND_JIANCHI_KILL] = 1,
    },
    [SurviveConst.ACHIEVEMENT_REFRESH_TYPE_GOLD] = {
        [SurviveConst.ACHIEVEMENT_COND_GOLD_IN] = 1,
        [SurviveConst.ACHIEVEMENT_COND_CUR_GOLD_IN] = 1,
    },
    [SurviveConst.ACHIEVEMENT_REFRESH_TYPE_ATTR] = {
        [SurviveConst.ACHIEVEMENT_COND_ATTR] = 1,
        [SurviveConst.ACHIEVEMENT_COND_HERO_ATTR_IN] = 1
    },
    [SurviveConst.ACHIEVEMENT_REFRESH_TYPE_BUY_SKILL] = {
        [SurviveConst.ACHIEVEMENT_COND_SKILL_BUY] = 1,
    },
    [SurviveConst.ACHIEVEMENT_REFRESH_TYPE_MISS] = {
        [SurviveConst.ACHIEVEMENT_COND_MISS] = 1,
    },
    [SurviveConst.ACHIEVEMENT_REFRESH_TYPE_REFRESH_SKILL] = {
        [SurviveConst.ACHIEVEMENT_COND_SHOP_REFRESH] = 1,
        [SurviveConst.ACHIEVEMENT_COND_SHUAXIN_IN] = 1,
        [SurviveConst.ACHIEVEMENT_COND_SHOP_REFRESH_COUNT] = 1,
    },
    [SurviveConst.ACHIEVEMENT_REFRESH_TYPE_PLAYED] = {
        [SurviveConst.ACHIEVEMENT_COND_FIGHT_FAILED] = 1,
        [SurviveConst.ACHIEVEMENT_COND_SAVE_ITEM] = 1,
        [SurviveConst.ACHIEVEMENT_COND_ABYSS_FLOOR] = 1,
        [SurviveConst.ACHIEVEMENT_COND_KILL_MONSTERID] = 1,
        [SurviveConst.ACHIEVEMENT_COND_STAGE_TIME_RECORD] = 1
    },
    [SurviveConst.ACHIEVEMENT_REFRESH_ADD_SKILL] = {
        [SurviveConst.ACHIEVEMENT_COND_CHAOGUO_100] = 1,
        [SurviveConst.ACHIEVEMENT_COND_5WUQI_CHAOGUO] = 1,
    },
    [SurviveConst.ACHIEVEMENT_REFRESH_KILL_FINAL_BOSS] = {
        [SurviveConst.ACHIEVEMENT_COND_BOSS_KILL_TIME] = 1,
    },
    [SurviveConst.ACHIEVEMENT_REFRESH_TYPE_DIAMOND] = {
        [SurviveConst.ACHIEVEMENT_COND_DIAMOND_IN] = 1,
    },
}

SurviveConst.DROP_TYPE_SAVE_ITEM                    = 1
SurviveConst.DROP_TYPE_TREASURE                     = 2
SurviveConst.DROP_TYPE_TITLE                        = 3
SurviveConst.DROP_TYPE_STAGE_TOWER                  = 4
SurviveConst.DROP_TYPE_HERO_SKIN                    = 5
SurviveConst.DROP_TYPE_ATTR_PACK                    = 6
SurviveConst.DROP_TYPE_TOWER_SKIN                   = 7
SurviveConst.DROP_TYPE_WEANPON_EXP                  = 2000

SurviveConst.TIP_TYPE_ACHI_DESC                     = 1000 -- 成就描述
SurviveConst.TIP_TYPE_ACHI_PASS                     = 1002 -- 成就通关

SurviveConst.AFK_TASK_ID                            = 1000 -- 挂机任务

SurviveConst.STAGE_MODE_AFK                         = 2    --挂机
SurviveConst.STAGE_MODE_SURVIVE                     = 4    --挂机


SurviveConst.ITEM_CLASS_MAP    = {
    [2] = 134254956,
    [3] = 134238523,
    [4] = 134228669,
    [5] = 134221522,
    [6] = 134278758
}

---平台道具
SurviveConst.PLATFORM_ITEM_MAP = {
    S1_BP_ADVANCED         = 134265665,
    S1_BP_ULTIMATE         = 134227460,
    S1_BP_EXP_ITEM         = 134236740,
    KAIJULIBAO             = 134264638, --开局礼包
    XINSHOULIBAO           = 134226439, --新手礼包
    CANGPINGUANJIA         = 134253773, --藏品管家
    BAIYINTEQUAN           = 134252434, --白银特权
    HUANGJINTEQUAN         = 134227329, --黄金特权
    JINSHOUZHI             = 134259814, --金手指
    WUSHENDIAN             = 134224216, --武神殿
    JUBAOPEN               = 134269867, -- 聚宝盆
    WUXIANHUOLICHENGZHANG  = 134255681, --无限火力成长
    WUXIANFANGYUCHENGZHANG = 134257656, --无限防御成长
    XINSHOUZHIDUN          = 134265040, --新手之盾
    XINSHOUZHIJIAN         = 134258311, --新手之剑
    HUANHUA_JINKUBANG      = 134267956, --幻化：金箍棒
    HUANHUA_HEILONGYAOTA   = 134266511, --幻化：黑龙妖塔
    HUANHUA_SHALUYOULING   = 134226245, --幻化：杀戮幽灵
    UR4                    = 134219106, --UR4
    UR5                    = 134242546, -- UR5
    HUANHUA_HUALOU         = 134249677, --幻化：花楼
    HUANHUA_CANGBAODAI     = 134280991, --幻化：藏宝袋
    SSR3                   = 134235314, -- SSR3
    SSR4                   = 134270092, -- SSR4
    SSR5                   = 134274290, --SSR5
    SR1                    = 134224119, -- SR1
    SR2                    = 134239566, -- SR2
    SR3                    = 134218718, -- SR3
    SR4                    = 134272611, -- SR4
    SR5                    = 134260119, -- SR5
    SR6                    = 134279572, --SR6
    SR7                    = 134275995, --SR7
    SR8                    = 134246130, --SR8
    R1                     = 134261577, --R1
    R2                     = 134271622, --R2
    R3                     = 134256235, --R3
    R4                     = 134273901, --R4
    R5                     = 134241444, --R5
    N1                     = 134238269, --N1
    N2                     = 134226219, --N2
    N3                     = 134225937, --N3
    N4                     = 134240238, --N4
    N5                     = 134238818, --N5
    N6                     = 134281320, --N6
    N7                     = 134283184, --N7
    N8                     = 134226509, --N8
    N9                     = 134268524, --N9
    N10                    = 134263445, --N10
    YERENZHANFU            = 134257732, -- 夜刃战斧
    ZHIJINJIAOKUI          = 134224618, --紫金角盔
    YUYUELIBAO             = 134244324, -- 预约礼包
    CESHILIBAO             = 134242798, --测试礼包

    OUHUANG                = 134225506, --欧皇
    ANSHANGMIANYOUREN      = 134221364, --俺上面有人
    TUO                    = 134263952, -- 托！
    ZHUDAPEIBAN            = 134220615, -- 主打陪伴
    GAOHU666               = 134225564, --高呼666
    HUOYANJINJING          = 134263397, --火眼金睛
    MUHOUDALAO             = 134278339, --幕后大佬
    TAFANGDAREN            = 134237350, -- 塔防达人
    JIANDINGZHICHI         = 134249663, --坚定支持
    TEGANFENSI             = 134270541, --铁杆粉丝
    YOUYIJIANZHENG         = 134273039, --友谊见证
    HUOJIANFADONGJI        = 134267788, --  火箭发动机		消耗型，可叠加	134267788
    WANNNEGCHONGDIANQI     = 134248770, --万能充电器		消耗型，可叠加	134248770
    WANNENGDIANCHI         = 134249102, --万能电池		消耗型，可叠加	134249102
    WANRENMI               = 134221932, --万人迷	无需icon	时效型，永久时效	134221932
    WANWANGZHIWANG         = 134238665, --万王之王	无需icon	时效型，永久时效	134238665
    DALAO                  = 134272864, --大佬	无需icon	时效型，永久时效	134272864
    SANYAO                 = 134263580, --闪耀	无需icon	时效型，永久时效	134263580
    DACALLKUANGREN         = 134272024, --打Call狂人	无需icon	时效型，永久时效	134272024

    JINSHUMIYAO            = 134269588, -- 金属秘药		消耗型		R	每个金属伤害加成+0.1% 每10个金属攻击强度+25 可叠加	金属伤害加成: 10#0.1 金属攻击强度：55#25
    CHUANCHIMIYAO          = 134260375, -- 穿刺秘药		消耗型		R	每个穿刺伤害加成+0.1% 每10个穿刺攻击强度+25 可叠加	穿刺伤害加成: 11#0.1 穿刺攻击强度：56#25
    MOFAMIYAO              = 134257768, --魔法秘药		消耗型		R	每个魔法伤害加成+0.1% 每10个魔法攻击强度+25 可叠加	魔法伤害加成: 12#0.1 魔法攻击强度：57#25
    GONGCHNEGMIYAO         = 134243159, --攻城秘药		消耗型		R	每个攻城伤害加成+0.1% 每10个攻城攻击强度+25 可叠加	攻城伤害加成: 13#0.1 攻城攻击强度：58#25
    HUNLUANMIYAO           = 134263920, --混乱秘药		消耗型		R	每个混乱伤害加成+0.1% 每10个混乱攻击强度+25 可叠加	混乱伤害加成: 14#0.1 混乱攻击强度：59#25
    HUANGSHIMIBAO          = 134222751, --皇室密宝

    TEYAOQINGJIAN          = 134230147, --特邀请柬		时效型，永久时效	134230147	UR	全攻击强度+50 最大生命值+588 生命恢复+5	全攻击强度    3#50 最大生命值    1#588 生命恢复        5#5	运营活动产出
    TEBIEZENGLI            = 134245893, --特别赠礼		时效型，永久时效	134245893	UR	激活称号链接词：之 [固有属性]： 最终伤害加成+2% 初始金币+288 [穿戴属性]： 穿刺伤害加成+5%	titile_id=202	运营活动产出
    NENGLIANGHEXIN         = 134259550, -- 能量核心		时效型，永久时效	134259550	SSR	魔法攻击强度+60 魔法伤害加成+3% 最大护盾值+500	魔法攻击强度   57#60 魔法伤害加成    12#3 最大护盾值       2#500	运营活动产出
    QISHIXUNZHANG          = 134255107, -- 骑士勋章		时效型，永久时效	134255107	SSR	激活称号前缀： [固有属性]： 金属攻击强度+40 近距离增伤+3% 溅射武器增伤+1% [穿戴属性]： 金属伤害加成+3%	titile_id=108	运营活动产出
    QINGLINGJIAN           = 134239793, -- 青翎剑		时效型，永久时效	134239793	SSR	金属攻击强度+65 最大生命值+350 生命恢复+3	金属攻击强度   55#65 最大生命值      1#350 生命恢复         5#3	运营活动产出
    SHENGTUSHIZI           = 134253135, -- 圣徒十字		时效型，永久时效	134253135	SSR	混乱攻击强度+60 混乱伤害加成+3% 单体武器增伤+3%	混乱攻击强度     59#60 混乱伤害加成       14#3 单体武器增伤      32#3	运营活动产出
}

SurviveConst.BP                = {
    S1_EXP_ITEM_REAL_VALUE = 1000,
}



SurviveConst.ACHI_UNLOCK_MAP = {
    ["1"] = 134259638,
    ["2"] = 134241573,
    ["3"] = 134272219,
    ["4"] = 134253879,
}
SurviveConst.ACHI_LOCK_MAP = {
    ["1"] = 134278924,
    ["2"] = 134272026,
    ["3"] = 134254318,
    ["4"] = 134281483
}

SurviveConst.WEAPON_TYPE_1 = 1 -- 金属武器
SurviveConst.WEAPON_TYPE_2 = 2 --穿刺武器
SurviveConst.WEAPON_TYPE_3 = 3 --魔法武器
SurviveConst.WEAPON_TYPE_4 = 4 --攻城武器
SurviveConst.WEAPON_TYPE_5 = 5 --混乱武器

SurviveConst.WEAPON_TYPE_LIST = {
    SurviveConst.WEAPON_TYPE_1,
    SurviveConst.WEAPON_TYPE_2,
    SurviveConst.WEAPON_TYPE_3,
    SurviveConst.WEAPON_TYPE_4,
    SurviveConst.WEAPON_TYPE_5
}

SurviveConst.STAGE_CHALLENGE_GOLD = 1            -- 金币挑战
SurviveConst.STAGE_CHALLENGE_DIAMOND = 2         -- 砖石挑战
SurviveConst.STAGE_CHALLENGE_ITEM = 3            -- 道具挑战

SurviveConst.STAGE_TECH_HP = 1                   -- 生命
SurviveConst.STAGE_TECH_SHIELD = 2               -- 护盾
SurviveConst.STAGE_TECH_ATK_SPEED = 3            -- 攻速
SurviveConst.STAGE_TECH_WEAPON_ADD_JINSHU = 4    -- 金属
SurviveConst.STAGE_TECH_WEAPON_ADD_CHUANCHI = 5  -- 穿刺
SurviveConst.STAGE_TECH_WEAPON_ADD_MOFA = 6      -- 魔法
SurviveConst.STAGE_TECH_WEAPON_ADD_GONGCHENG = 7 -- 攻城
SurviveConst.STAGE_TECH_WEAPON_ADD_HUNLUAN = 8   -- 混乱
SurviveConst.STAGE_TECH_WEAPON_ADD_GOLD = 9      -- 金币
SurviveConst.MAX_STAGE_TEACH_NUM = 9

SurviveConst.WEAPON_SPEED = 1
SurviveConst.WEAPON_DMG = 2

SurviveConst.REWARD_TAG_NAME = {
    [1] = 134235651,
    [2] = 134245448,
    [3] = 134222500,
    [4] = 134262557,
    [5] = 134230523,
    [6] = 134253291,
    [7] = 134255417,
}

SurviveConst.WEAPON_ATTR_SPEED = "atk_speed"
SurviveConst.WEAPON_ATTR_DMG = "atk_dmg"

SurviveConst.WEAPON_DMG_ATTR_MAP = {
    [SurviveConst.WEAPON_TYPE_1] = 55,
    [SurviveConst.WEAPON_TYPE_2] = 56,
    [SurviveConst.WEAPON_TYPE_3] = 57,
    [SurviveConst.WEAPON_TYPE_4] = 58,
    [SurviveConst.WEAPON_TYPE_5] = 59
}

------------------------
SurviveConst.PREFAB_MAP = {
    ["notice"] = "hud_noti_stack",
    ["abyss_reward"] = "skill",
    ["shop_weapon"] = "slot_shop_weapon",
    ["shop_upgrade"] = "slot_shop_upgrade",
    ["buff_weapon"] = "slot_buff_weapon",
    ["abyss_shop_item"] = "abyss_shop_item",
    ["timeline_boss"] = "timeline_boss",
    ["timeline_mark"] = "timeline_mark",
    ["timeline_highlight"] = "timeline_highlight",
    ["blackmarket_item"] = "slot_blackmarket_item",
    ["buffCustom"] = "buffCustom",
    ["slot_gamesave_treasure"] = "slot_gamesave_treasure",
    ["common_icon"] = "slot_main_menu_levelreward",
    ["achievement_levelrecord"] = "slot_main_achievement_levelrecord",
    ["main_achievement_trophy"] = "slot_main_achievement_trophy",
    ["main_achievement_levelbonus"] = "slot_main_achievement_levelbonus",
    ["noti_slider"] = "global_noti_slider",
    ["main_wiki_weapon"] = "slot_main_wiki_weapon",
    ["main_mall"] = "slot_main_mall",
    ["endgame_levelreward"] = "slot_endgame_levelreward",
    ["select_reward"] = "reward",
    ["windows_gamesave_boss"] = "slot_windows_gamesave_boss",
    ["windows_hero_tech"] = "slot_windows_hero_tech",
    ["bp_reward_info"] = "slot_main_bp",
    ["main_title"] = "slot_main_title",
    ["main_lifetime"] = "slot_main_lifetime",
    ["main_rank"] = "slot_main_rank",
    ["main_skin"] = "slot_main_skin",
    ["shop_help_record"] = "shop_help_record",
    ["shop_help_setting"] = "shop_help_setting"
}

return SurviveConst
