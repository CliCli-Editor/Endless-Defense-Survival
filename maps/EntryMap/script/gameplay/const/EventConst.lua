local EventConst = {
    EVENT_UPDATE_QIUXIAN                    = "EVENT_UPDATE_QIUXIAN",
    EVENT_UPDATE_DRAW                       = "EVENT_UPDATE_DRAW",
    EVENT_BUY_HERO_CARD                     = "EVENT_BUY_HERO_CARD",
    EVENT_BUILDTOWER_SUCCESS                = "EVENT_BUILDTOWER_SUCCESS",
    EVENT_BUILD_SET_TOWER                   = "EVENT_BUILD_SET_TOWER",
    EVENT_ROUND_INFO_UPDATE                 = "EVENT_ROUND_INFO_UPDATE",
    EVENT_UPGRADE_QIUXIAN_SUCCESS           = "EVENT_UPGRADE_QIUXIAN_SUCCESS",
    EVENT_UPGRADE_LIANGCAO_SUCCESS          = "EVENT_UPGRADE_LIANGCAO_SUCCESS",
    EVENT_SELL_TOWER_SUCCESS                = "EVENT_SELL_TOWER_SUCCESS",
    EVENT_SHENGXING_SUCCESS                 = "EVENT_SHENGXING_SUCCESS",
    EVENT_QIANSHAN_SUCCESS                  = "EVENT_QIANSHAN_SUCCESS",
    EVENT_SKILL_OPEN_INDICATOR              = "EVENT_SKILL_OPEN_INDICATOR",
    EVENT_SKILL_CLOSE_INDICATOR             = "EVENT_SKILL_CLOSE_INDICATOR",
    EVENT_BUILD_PRE_START                   = "EVENT_BUILD_PRE_START",
    EVENT_ZHANXUN_TIAOZHAN_START            = "EVENT_ZHANXUN_TIAOZHAN_START",
    EVENT_ZHAN_GET                          = "EVENT_ZHAN_GET",
    EVENT_UPGRADE_JUEWEI_TASK               = "EVENT_UPGRADE_JUEWEI_TASK",
    EVENT_JUEWEI_CHALLENGE_SUCCESS          = "EVENT_JUEWEI_CHALLENGE_SUCCESS",
    EVENT_SELECT_JUEWEI_BUFF                = "EVENT_SELECT_JUEWEI_BUFF",
    EVENT_JUEWEI_CHALLENGE_FAILED           = "EVENT_JUEWEI_CHALLENGE_FAILED",
    EVENT_UP_HERO_OFFICIAL                  = "EVENT_UP_HERO_OFFICIAL",
    EVENT_GLORY_VALUE_CHANGE                = "EVENT_GLORY_VALUE_CHANGE",

    EVENT_SELECT_UNIT                       = "EVENT_SELECT_UNIT",
    EVENT_SELECT_UNIT_GROUP                 = "EVENT_SELECT_UNIT_GROUP",
    EVENT_GOLD_UPDATE                       = "EVENT_GOLD_UPDATE",
    EVENT_LIVE_COUNT                        = "EVENT_LIVE_COUNT",
    EVENT_SCORE_UPDATE                      = "EVENT_SCORE_UPDATE",
    EVENT_MOUSE_MOVE                        = "EVENT_MOUSE_MOVE",
    EVENT_MOUSE_DOWN                        = "EVENT_MOUSE_DOWN",
    EVENT_MOUSE_UP                          = "EVENT_MOUSE_UP",
    EVENT_GAME_RE_START                     = "EVENT_GAME_RE_START",
    EVENT_MOUSE_RIGHT_DOWN                  = "EVENT_MOUSE_RIGHT_DOWN",
    EVENT_MOUSE_RIGHT_UP                    = "EVENT_MOUSE_RIGHT_UP",
    EVENT_HERO_YUANFEN_UPDATE               = "EVENT_HERO_YUANFEN_UPDATE",
    EVENT_SELL_HERO_POP                     = "EVENT_SELL_HERO_POP",
    EVENT_LOCAL_MOUSE_RIGHT_UP              = "EVENT_LOCAL_MOUSE_RIGHT_UP",
    EVENT_GIVE_ITEM_TO_TOWER                = "EVENT_GIVE_ITEM_TO_TOWER",
    EVENT_GAME_STATUS_UPDATE                = "EVENT_GAME_STATUS_UPDATE",

    ---------------------------------------
    EVENT_SURVIVE_REFRESH_SKILl             = "EVENT_SURVIVE_REFRESH_SKILl",
    EVENT_SURVIVE_REFRESH_SKILl_UPDATE_TIME = "EVENT_SURVIVE_REFRESH_SKILl_UPDATE_TIME",
    EVENT_SURVIVE_MONSTER_ENTER_AREA        = "EVENT_SURVIVE_MONSTER_ENTER_AREA",
    EVENT_SURVIVE_GOLD_UPDATE               = "EVENT_SURVIVE_GOLD_UPDATE",
    EVENT_SURVIVE_ADD_STATE_TAG             = "EVENT_SURVIVE_ADD_STATE_TAG",
    EVENT_SURVIVE_REMOVE_STATE_TAG          = "EVENT_SURVIVE_REMOVE_STATE_TAG",
    EVENT_SURVIVE_LEARN_SKILL_SUCCESS       = "EVENT_SURVIVE_LEARN_SKILL_SUCCESS",
    EVENT_READY_COUNT_DOWN                  = "EVENT_READY_COUNT_DOWN",
    EVENT_SURVIVE_SKILL_INFO_UPDATE         = "EVENT_SURVIVE_SKILL_INFO_UPDATE",
    EVENT_SURVIVE_REFRESH_DPS               = "EVENT_SURVIVE_REFRESH_DPS",
    EVENT_SURVIVE_RESOURCE_ADD_GOLD         = "EVENT_SURVIVE_RESOURCE_ADD_GOLD",
    EVENT_SURVIVE_STAGE_CHANGE              = "EVENT_SURVIVE_STAGE_CHANGE",
    EVENT_SURVIVE_SELECT_UNIT               = "EVENT_SURVIVE_SELECT_UNIT",
    EVENT_SURVIVE_START_TIME                = "EVENT_SURVIVE_START_TIME",
    EVENT_SURVIVE_GAME_START                = "EVENT_SURVIVE_GAME_START",
    EVENT_SURVIVE_NOTICE_SHOW               = "EVENT_SURVIVE_NOTICE_SHOW",
    EVENT_SURVIVE_GAME_PAUSE                = "EVENT_SURVIVE_GAME_PAUSE",
    EVENT_SURVIVE_ACHIEVE_PASS_STAGE        = "EVENT_SURVIVE_ACHIEVE_PASS_STAGE",
    EVENT_SURVIVE_SELECT_REWARD             = "EVENT_SURVIVE_SELECT_REWARD",
    EVENT_SURVIVE_GAME_ABYSS_SHOP_REFRESH   = "EVENT_SURVIVE_GAME_ABYSS_SHOP_REFRESH",
    EVENT_SURVIVE_GAME_ABYSS_SHOP_BUY       = "EVENT_SURVIVE_GAME_ABYSS_SHOP_BUY",
    EVENT_SURVIVE_ABYSS_FLOOY_UPDATE        = "EVENT_SURVIVE_ABYSS_FLOOY_UPDATE",
    EVENT_SURVIVE_GET_ITEM                  = "EVENT_SURVIVE_GET_ITEM",
    EVENT_SURVIVE_ABYSS_START_CHALLENGE     = "EVENT_SURVIVE_ABYSS_START_CHALLENGE",
    EVENT_SURVIVE_TRAESURE_LV_UP            = "EVENT_SURVIVE_TRAESURE_LV_UP",
    EVENT_SURVIVE_GAME_READY_START          = "EVENT_SURVIVE_GAME_READY_START",
    EVENT_SURVIVE_GAME_ENTER_START          = "EVENT_SURVIVE_GAME_ENTER_START",
    EVENT_SHOW_HUD                          = "EVENT_SHOW_HUD",
    EVENT_UPDATE_ENTER_TIME                 = "EVENT_UPDATE_ENTER_TIME",
    EVENT_WEAPON_LV_SUCCESS                 = "EVENT_WEAPON_LV_SUCCESS",
    EVENT_TECH_UPGRADE_SUCCESS              = "EVENT_TECH_UPGRADE_SUCCESS",
    EVENT_SURVIVE_ATTR_CHANGE               = "EVENT_SURVIVE_ATTR_CHANGE",
    EVENT_SURVEVE_RESULT_WIN                = "EVENT_SURVEVE_RESULT_WIN",
    EVENT_SURVEVE_RESULT_FAIL               = "EVENT_SURVEVE_RESULT_FAIL",
    EVENT_SURVIVE_SELECT_REWARD_ADD         = "EVENT_SURVIVE_SELECT_REWARD_ADD",
    EVENT_SURVIVE_ABYSS_SHOP_RECHARGE_ADD   = "EVENT_SURVIVE_ABYSS_SHOP_RECHARGE_ADD",
    EVENT_SURVIVE_SHOW_NPC_INFO             = "EVENT_SURVIVE_SHOW_NPC_INFO",
    EVENT_REFRESH_HERO_SHOP                 = "EVENT_REFRESH_HERO_SHOP",
    EVENT_EQUIP_TITLE_SUCCESS               = "EVENT_EQUIP_TITLE_SUCCESS",
    EVENT_SHOP_EXP_ADD                      = "EVENT_SHOP_EXP_ADD",
    EVENT_FUNC_CHECK_UPDATE                 = "EVENT_FUNC_CHECK_UPDATE",
    EVENT_SKIL_TOTAL_HIGHLIGHT              = "EVENT_SKIL_TOTAL_HIGHLIGHT",
    EVENT_SKIL_TOTAL_HIDE_HIGHLIGHT         = "EVENT_SKIL_TOTAL_HIDE_HIGHLIGHT",
    EVENT_BP_DB_Changed                     = "EVENT_BP_DB_Changed",
    HERO_SOUL_ADD_SKILL                     = "HERO_SOUL_ADD_SKILL",
    EVENT_EQUIP_TOWER_SKIN_SUCCESS          = "EVENT_EQUIP_TOWER_SKIN_SUCCESS",
    EVENT_GET_SEVEN_DAY_REWARD_SUCCESS      = "EVENT_GET_SEVEN_DAY_REWARD_SUCCESS",
    EVENT_HERO_ACTOR_ADD_SKILL              = "EVENT_HERO_ACTOR_ADD_SKILL",
    EVENT_RANDOM_LOAD_TIPS_TEXT             = "EVENT_RANDOM_LOAD_TIPS_TEXT",
    EVENT_INSERT_LABEL_SORT_SUCCESS         = "EVENT_INSERT_LABEL_SORT_SUCCESS",
    EVENT_REMOVE_LABEL_SORT_SUCCESS         = "EVENT_REMOVE_LABEL_SORT_SUCCESS",
    EVENT_SHOP_HELPER_OPEN_SUCCESS          = "EVENT_SHOP_HELPER_OPEN_SUCCESS",
    EVENT_SHOP_HELPER_AUTO_SUCCESS          = "EVENT_SHOP_HELPER_AUTO_SUCCESS",
    EVENT_SURVIVE_STAGE_EVENT_WAVE          = "EVENT_SURVIVE_STAGE_EVENT_WAVE",
    EVENT_RECEIVE_AFK_REWARD                = "EVENT_RECEIVE_AFK_REWARD",
    EVENT_TASK_FINISH_SUCCESS               = "EVENT_TASK_FINISH_SUCCESS",
    EVENT_TASK_FINISH_FAILED                = "EVENT_TASK_FINISH_FAILED",
    EVENT_TASK_RECEIVE                      = "EVENT_TASK_RECEIVE"
}

return EventConst
