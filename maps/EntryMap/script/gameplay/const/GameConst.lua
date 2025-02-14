local GameConst = {}
GameConst.GAME_FPS = 30
GameConst.BLOCK_SIZE = 50
GameConst.ROLE_1 = "玩家 1"
GameConst.ROLE_2 = "玩家 2"
GameConst.ROLE_3 = "玩家 3"
GameConst.ROLE_4 = "玩家 4"
GameConst.ROLE_ENEMY = "中立 敌对"
GameConst.ROLE_FRIEND = "中立 友善"
GameConst.ROLE_STATE_ONLINE = 1
GameConst.ROLE_STATE_OFFLINE = 2
GameConst.PLAYER_ID_ENEMY = 31
GameConst.PLAYER_ID_FRIEND = 32

GameConst.INVALID_ROLE = {
    [GameConst.PLAYER_ID_ENEMY] = true,
    [GameConst.PLAYER_ID_FRIEND] = true,
}
-- class GameResult(object):
-- 	VICTORY = 'victory'
-- 	DEFEAT = 'defeat'
-- 	NEUTRAL = 'neutral'
GameConst.VICTORY = 'victory'
GameConst.DEFEAT = 'defeat'
GameConst.NEUTRAL = 'neutral'

GameConst.BAR_NAME = "物品栏"
GameConst.PKG_NAME = "背包栏"

GameConst.MODE_BATTLE = 1
GameConst.MODE_HULAOGUAN = 2
GameConst.MODE_ENDLESS = 3
GameConst.MODE_JIJIAO = 4
GameConst.MODE_ZHULU = 5

-- 挑战
GameConst.CHANNEL_HP = 5000


-- GameConst.FATIELEIJIHUOZHAN = 0
-- GameConst.JINHUATIESHULIANG = 1
-- GameConst.HUIFUTIEZICISHU = 2
-- GameConst.SHOUDAOHUANLESHU= 3
-- GameConst.

return GameConst
