local GameUtils = require "gameplay.utils.GameUtils"
local LogicBase = include("gameplay.level.logic.LogicBase")
local SurviveGamePlatformShop = class("SurviveGamePlatformShop", LogicBase)

local ZERO_MIN = 0
local SIX_MIN = 6 * 60
local TWELVE_MIN = 12 * 60
local TEN_MIN = 10 * 60

local JUBAOPEN_INTERVAL = 30
local SSR_TAOZHUANG_INTERVAL = 30

function SurviveGamePlatformShop:ctor(level)
    SurviveGamePlatformShop.super.ctor(self, level)
    self._random_num = math.random(1, 100001) - 1
    local saveInfo = y3.userData:loadTable("PlayerInfo")
    self._playerInfo = saveInfo
    y3.game:event("玩家-平台道具变化", handler(self, self._onPlatformShopChange))
    y3.game:event("玩家-使用平台道具", handler(self, self._onPlatformItemUsed))
    self._totalDt = 0
    self._jubaopengDt = 0
    self._ssrTaozhuangDt = 0
    self._jubaopenFlag = false
    y3.gameApp:addTimerLoop(1, handler(self, self._onGameTimeLogic))
end

function SurviveGamePlatformShop:_checkDropItem(itemId)
    local allInPlayers = y3.userData:getAllInPlayers()
    for _, playerData in ipairs(allInPlayers) do
        local player = playerData:getPlayer()
        if y3.userDataHelper.has_store_item(player, y3.SurviveConst.PLATFORM_ITEM_MAP.WUSHENDIAN) then
            y3.surviveHelper.dropItem(playerData:getId(), itemId)
        end
    end
end

function SurviveGamePlatformShop:_checkHaveSrrTaoZhuang(player)
    if y3.userDataHelper.has_store_item(player, y3.SurviveConst.PLATFORM_ITEM_MAP.SSR3) and
        y3.userDataHelper.has_store_item(player, y3.SurviveConst.PLATFORM_ITEM_MAP.SSR4) and
        y3.userDataHelper.has_store_item(player, y3.SurviveConst.PLATFORM_ITEM_MAP.SSR5) then
        return true
    end
    return false
end

function SurviveGamePlatformShop:_onGameTimeLogic(delay)
    if not self._level:isGameStart() then
        return
    end
    local gameStatus = self._level:getLogic("SurviveGameStatus")
    if not gameStatus:isInBattle() then
        return
    end

    if not self._jubaopenFlag then
        self._jubaopenFlag = true
        local allPlayers = y3.userData:getAllInPlayers()
        for _, playerData in ipairs(allPlayers) do
            local player = playerData:getPlayer()
            if y3.userDataHelper.has_store_item(player, y3.SurviveConst.PLATFORM_ITEM_MAP.JUBAOPEN) then
                y3.userDataHelper.dropRes(player:get_id(), 1, 1000)
            end
        end
    end

    local dt = delay:float()
    local lastDt = self._totalDt
    self._totalDt = self._totalDt + dt
    if lastDt <= ZERO_MIN and self._totalDt > ZERO_MIN then
        self:_checkDropItem(40095)
        local allInPlayers = y3.userData:getAllInPlayers()
        for _, playerData in ipairs(allInPlayers) do
            if self:_checkHaveSrrTaoZhuang(playerData:getPlayer()) then
                y3.userDataHelper.dropRes(playerData:getId(), y3.SurviveConst.RESOURCE_TYPE_DIAMOND, 100)
            end
        end
    end
    if lastDt <= SIX_MIN and self._totalDt > SIX_MIN then
        self:_checkDropItem(40096)
    end
    if lastDt <= TWELVE_MIN and self._totalDt > TWELVE_MIN then
        self:_checkDropItem(40097)
    end
    -------
    self._jubaopengDt = self._jubaopengDt + dt
    if self._jubaopengDt >= JUBAOPEN_INTERVAL then
        self._jubaopengDt = 0
        local allInPlayers = y3.userData:getAllInPlayers()
        for _, playerData in ipairs(allInPlayers) do
            local player = playerData:getPlayer()
            if y3.userDataHelper.has_store_item(player, y3.SurviveConst.PLATFORM_ITEM_MAP.JUBAOPEN) then
                if self._totalDt <= TEN_MIN then
                    y3.userDataHelper.dropRes(playerData:getId(), y3.SurviveConst.RESOURCE_TYPE_GOLD, 250)
                else
                    y3.userDataHelper.dropRes(playerData:getId(), y3.SurviveConst.RESOURCE_TYPE_GOLD, 500)
                end
            end
        end
    end
    ---
    self._ssrTaozhuangDt = self._ssrTaozhuangDt + dt
    if self._ssrTaozhuangDt >= SSR_TAOZHUANG_INTERVAL then
        self._ssrTaozhuangDt = 0
        local allInPlayers = y3.userData:getAllInPlayers()
        for _, playerData in ipairs(allInPlayers) do
            local player = playerData:getPlayer()
            if self:_checkHaveSrrTaoZhuang(player) then
                y3.userDataHelper.dropRes(playerData:getId(), y3.SurviveConst.RESOURCE_TYPE_DIAMOND, 50)
            end
        end
    end
end

-- -@class EventParam.ET_ROLE_STORE_ITEM_CHANGED
-- -@field store_key py.StoreKey # 道具编号
-- -@field store_item_type py.StoreItemType # 道具类型
-- -@field store_item_change_count integer # 平台道具变化数
-- -@field store_item_expire_date integer # 平台道具到期时间戳
-- -@field player Player # 玩家
function SurviveGamePlatformShop:_onPlatformShopChange(trg, data)
    local player = data.player
    if player:get_id() == y3.gameApp:getMyPlayerId() then
        xpcall(function(...)
            local store_key = data.store_key
            local store_item_type = data.store_item_type
            local store_item_change_count = data.store_item_change_count
            local store_item_expire_date = data.store_item_expire_date
            self:_useShopItem(store_key, store_item_change_count)
            self:_initStartGet()
        end, __G__TRACKBACK__)
    end
end

---@class EventParam.ET_ROLE_USE_STORE_ITEM_END
---@field player Player # 玩家
---@field store_key py.StoreKey # 收费道具编号
---@field use_cnt integer # 使用次数
function SurviveGamePlatformShop:_onPlatformItemUsed(trg, data)
    local player = data.player
    if player:get_id() == y3.gameApp:getMyPlayerId() then
        xpcall(function(...)
            local store_key = data.store_key
            local store_item_change_count = data.use_cnt
            if y3.SurviveConst.PLATFORM_ITEM_MAP.S1_BP_EXP_ITEM == store_key then
                local basttlePassData = y3.gameApp:getLevel():getLogic("SurviveGameBattlePass")
                if basttlePassData then
                    local seasonIndex = 1
                    local exp = math.abs(store_item_change_count) * y3.SurviveConst.BP.S1_EXP_ITEM_REAL_VALUE
                    basttlePassData:addExp(player, seasonIndex, exp, true)
                end
            end
        end, __G__TRACKBACK__)
    end
end

function SurviveGamePlatformShop:_useShopItem(store_key, store_item_change_count)
    if y3.SurviveConst.PLATFORM_ITEM_MAP.S1_BP_ADVANCED == store_key or
        y3.SurviveConst.PLATFORM_ITEM_MAP.S1_BP_ULTIMATE == store_key then
        y3.gameApp:dispatchEvent(y3.EventConst.EVENT_BP_DB_Changed, y3.gameApp:getMyPlayerId())
    elseif y3.SurviveConst.PLATFORM_ITEM_MAP.S1_BP_EXP_ITEM == store_key then
        local player = y3.player(y3.gameApp:getMyPlayerId())
        if store_item_change_count > 0 then
            player:use_store_item(store_item_change_count, store_key)
        end
    end
end

function SurviveGamePlatformShop:_initStartGet()
    xpcall(function()
        ----------------------------------------------------------------------------------
        local player = y3.player(y3.gameApp:getMyPlayerId())
        local towerSkinList = {
            { skuKey = y3.SurviveConst.PLATFORM_ITEM_MAP.HUANHUA_JINKUBANG,    skin_id = 2 },
            { skuKey = y3.SurviveConst.PLATFORM_ITEM_MAP.HUANHUA_HEILONGYAOTA, skin_id = 5 },
            { skuKey = y3.SurviveConst.PLATFORM_ITEM_MAP.HUANHUA_SHALUYOULING, skin_id = 1 },
            { skuKey = y3.SurviveConst.PLATFORM_ITEM_MAP.HUANHUA_HUALOU,       skin_id = 6 },
            { skuKey = y3.SurviveConst.PLATFORM_ITEM_MAP.HUANHUA_CANGBAODAI,   skin_id = 4 },
        }
        local gameCourse = y3.gameApp:getLevel():getLogic("SurviveGameCourse")
        for i = 1, #towerSkinList do
            local data = towerSkinList[i]
            if y3.userDataHelper.has_store_item(player, data.skuKey) then
                gameCourse:dropTowerSkin(player:get_id(), data.skin_id)
            end
        end
        -----------------------------------------------------------------------------------
        local player = y3.player(y3.gameApp:getMyPlayerId())
        if y3.userDataHelper.has_store_item(player, y3.SurviveConst.PLATFORM_ITEM_MAP.XINSHOULIBAO) then -- 新手礼包
            if not self._playerInfo["newbie_gift_count"] then
                self._playerInfo["newbie_gift_count"] = 1
                local saveItemList = { 1004, 1005, 1006, 1007, 1008 }
                for i = 1, #saveItemList do
                    y3.userDataHelper.dropSaveItem2(player:get_id(), y3.SurviveConst.DROP_TYPE_SAVE_ITEM,
                        saveItemList[i], 5000)
                end
            end
        end
        if y3.userDataHelper.has_store_item(player, y3.SurviveConst.PLATFORM_ITEM_MAP.CANGPINGUANJIA) then
            if not self._playerInfo["cangpinguanjia_count"] then
                self._playerInfo["cangpinguanjia_count"] = 1
                y3.userDataHelper.dropSaveItem2(player:get_id(), y3.SurviveConst.DROP_TYPE_SAVE_ITEM,
                    1001, 1000)
            end
        end
        if y3.userDataHelper.has_store_item(player, y3.SurviveConst.PLATFORM_ITEM_MAP.BAIYINTEQUAN) then
            local timestamp = y3.gameUtils.get_server_time(8).timestamp
            local year, month, day = GameUtils.getCurrentDate(timestamp)
            local myDayStr = ""
            local toDayStr = year .. "#" .. month .. "#" .. day
            if not self._playerInfo["baiyintequan_count"] then
                self._playerInfo["baiyintequan_count"] = year .. "#" .. month .. "#" .. day
            else
                myDayStr = self._playerInfo["baiyintequan_count"]
            end
            if myDayStr ~= toDayStr then
                self._playerInfo["baiyintequan_count"] = toDayStr
                y3.userDataHelper.dropSaveItem2(player:get_id(), y3.SurviveConst.DROP_TYPE_SAVE_ITEM, 1001, 40)
            end
        end
        if y3.userDataHelper.has_store_item(player, y3.SurviveConst.PLATFORM_ITEM_MAP.HUANGJINTEQUAN) then
            local timestamp = y3.gameUtils.get_server_time(8).timestamp
            local year, month, day = GameUtils.getCurrentDate(timestamp)
            local myDayStr = ""
            local toDayStr = year .. "#" .. month .. "#" .. day
            if not self._playerInfo["huangjintequan_count"] then
                self._playerInfo["huangjintequan_count"] = year .. "#" .. month .. "#" .. day
            else
                myDayStr = self._playerInfo["huangjintequan_count"]
            end
            if myDayStr ~= toDayStr then
                self._playerInfo["huangjintequan_count"] = toDayStr
                y3.userDataHelper.dropSaveItem2(player:get_id(), y3.SurviveConst.DROP_TYPE_SAVE_ITEM, 1001, 80)
            end
        end
        if y3.userDataHelper.has_store_item(player, y3.SurviveConst.PLATFORM_ITEM_MAP.JINSHOUZHI) then
            local achievementTitle = y3.gameApp:getLevel():getLogic("SurviveGameAchievementTitle")
            achievementTitle:dropTitle(player:get_id(), 305)
        end
        if y3.userDataHelper.has_store_item(player, y3.SurviveConst.PLATFORM_ITEM_MAP.WUSHENDIAN) then
            local gameCourse = y3.gameApp:getLevel():getLogic("SurviveGameCourse")
            gameCourse:dropStageTower(player:get_id(), 6)
        end
        if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.TAFANGDAREN) > 0 then
            if not self._playerInfo["tafangdaren_count"] then
                self._playerInfo["tafangdaren_count"] = 1
                y3.userDataHelper.dropSaveItem2(player:get_id(), y3.SurviveConst.DROP_TYPE_SAVE_ITEM,
                    1001, 150)
                y3.userDataHelper.dropSaveItem2(player:get_id(), y3.SurviveConst.DROP_TYPE_SAVE_ITEM,
                    1013, 3)
            end
        end
        if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.YOUYIJIANZHENG) > 0 then
            local gameCourse = y3.gameApp:getLevel():getLogic("SurviveGameCourse")
            gameCourse:dropStageTower(player:get_id(), 3)
        end
        if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.WANRENMI) > 0 then
            local achievementTitle = y3.gameApp:getLevel():getLogic("SurviveGameAchievementTitle")
            achievementTitle:dropTitle(player:get_id(), 306)
        end
        if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.WANWANGZHIWANG) > 0 then
            local achievementTitle = y3.gameApp:getLevel():getLogic("SurviveGameAchievementTitle")
            achievementTitle:dropTitle(player:get_id(), 307)
        end
        if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.DALAO) > 0 then
            local achievementTitle = y3.gameApp:getLevel():getLogic("SurviveGameAchievementTitle")
            achievementTitle:dropTitle(player:get_id(), 308)
        end
        if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.SANYAO) > 0 then
            local achievementTitle = y3.gameApp:getLevel():getLogic("SurviveGameAchievementTitle")
            achievementTitle:dropTitle(player:get_id(), 107)
        end
        if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.DACALLKUANGREN) > 0 then
            local achievementTitle = y3.gameApp:getLevel():getLogic("SurviveGameAchievementTitle")
            achievementTitle:dropTitle(player:get_id(), 309)
        end
        if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.TEBIEZENGLI) > 0 then
            local achievementTitle = y3.gameApp:getLevel():getLogic("SurviveGameAchievementTitle")
            achievementTitle:dropTitle(player:get_id(), 202)
        end
        if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.QISHIXUNZHANG) > 0 then
            local achievementTitle = y3.gameApp:getLevel():getLogic("SurviveGameAchievementTitle")
            achievementTitle:dropTitle(player:get_id(), 108)
        end
    end, __G__TRACKBACK__)
end

function SurviveGamePlatformShop:initPlatformShopStart()
    xpcall(function(...)
        self:_initStartGet()
    end, __G__TRACKBACK__)
end

function SurviveGamePlatformShop:initPlatformShopGameStart()
    xpcall(function(...)
        local attrList, skillList = self:getPlatformShopAttrList(y3.gameApp:getMyPlayerId())
        y3.SyncMgr:sync(y3.SyncConst.SYNC_PLATFORM_ATTR_LIST, { attrList = attrList })
        y3.SyncMgr:sync(y3.SyncConst.SYNC_PLATFORM_SKILL_LIST, { skillList = skillList })
    end, __G__TRACKBACK__)
end

function SurviveGamePlatformShop:getPlatformShopAttrList(playerId)
    local attrList = {}
    local skillList = {}
    local player = y3.player(playerId)
    local map_level = player:get_map_level()
    if y3.userDataHelper.has_store_item(player, y3.SurviveConst.PLATFORM_ITEM_MAP.KAIJULIBAO) then --开局礼包
        table.insert(attrList, { id = 15, value = 500 })
        table.insert(attrList, { id = 16, value = 5 })
        local list = { 11001, 12001, 13001, 14001, 15001, }
        local randIndex = self._random_num % #list + 1
        local randItem = list[randIndex]
        table.insert(skillList, { id = randItem })
    end
    if y3.userDataHelper.has_store_item(player, y3.SurviveConst.PLATFORM_ITEM_MAP.XINSHOULIBAO) then -- 新手礼包
        table.insert(attrList, { id = 1, value = 500 })
        table.insert(attrList, { id = 3, value = 30 })
        table.insert(attrList, { id = 5, value = 10 })
    end
    if y3.userDataHelper.has_store_item(player, y3.SurviveConst.PLATFORM_ITEM_MAP.BAIYINTEQUAN) then
        table.insert(attrList, { id = 19, value = 1 })
        table.insert(attrList, { id = 4, value = 5 })
        table.insert(attrList, { id = 15, value = 500 + map_level * 20 })
    end
    if y3.userDataHelper.has_store_item(player, y3.SurviveConst.PLATFORM_ITEM_MAP.HUANGJINTEQUAN) then
        table.insert(attrList, { id = 19, value = 2 })
        table.insert(attrList, { id = 4, value = 10 })
        table.insert(attrList, { id = 3, value = 50 + map_level * 2 })
    end
    if y3.userDataHelper.has_store_item(player, y3.SurviveConst.PLATFORM_ITEM_MAP.WUSHENDIAN) then
        table.insert(attrList, { id = 53, value = (5 + map_level * 0.1) })
        table.insert(attrList, { id = 52, value = (5 + map_level * 0.1) })
        table.insert(attrList, { id = 51, value = (5 + map_level * 0.1) })
    end
    if y3.userDataHelper.has_store_item(player, y3.SurviveConst.PLATFORM_ITEM_MAP.WUXIANHUOLICHENGZHANG) then
        table.insert(attrList, { id = 10, value = (map_level * 0.1) })
        table.insert(attrList, { id = 11, value = (map_level * 0.1) })
        table.insert(attrList, { id = 12, value = (map_level * 0.1) })
        table.insert(attrList, { id = 13, value = (map_level * 0.1) })
        table.insert(attrList, { id = 14, value = (map_level * 0.1) })
    end
    if y3.userDataHelper.has_store_item(player, y3.SurviveConst.PLATFORM_ITEM_MAP.WUXIANFANGYUCHENGZHANG) then
        table.insert(attrList, { id = 1, value = (map_level * 10) })
        table.insert(attrList, { id = 5, value = math.ceil(map_level * 0.4) })
        table.insert(attrList, { id = 2, value = (map_level * 20) })
    end
    if y3.userDataHelper.has_store_item(player, y3.SurviveConst.PLATFORM_ITEM_MAP.XINSHOUZHIDUN) then
        table.insert(attrList, { id = 1, value = 100 })
    end
    if y3.userDataHelper.has_store_item(player, y3.SurviveConst.PLATFORM_ITEM_MAP.XINSHOUZHIJIAN) then
        table.insert(attrList, { id = 3, value = 10 })
    end
    if y3.userDataHelper.has_store_item(player, y3.SurviveConst.PLATFORM_ITEM_MAP.UR4) then
        table.insert(attrList, { id = 15, value = 2500 })
        table.insert(attrList, { id = 16, value = 10 })
        table.insert(attrList, { id = 17, value = 20 })
        table.insert(skillList, { id = 20027 })
    end
    if y3.userDataHelper.has_store_item(player, y3.SurviveConst.PLATFORM_ITEM_MAP.UR5) then
        table.insert(attrList, { id = 3, value = 100 })
        table.insert(attrList, { id = 6, value = 5 })
        table.insert(attrList, { id = 7, value = 10 })
        table.insert(skillList, { id = 20035 })
    end
    if y3.userDataHelper.has_store_item(player, y3.SurviveConst.PLATFORM_ITEM_MAP.SSR3) then
        table.insert(attrList, { id = 3, value = 60 })
        table.insert(attrList, { id = 53, value = 10 })
    end
    if y3.userDataHelper.has_store_item(player, y3.SurviveConst.PLATFORM_ITEM_MAP.SSR4) then
        table.insert(attrList, { id = 45, value = 20 })
        table.insert(attrList, { id = 1, value = 2000 })
        table.insert(attrList, { id = 5, value = 50 })
    end
    if y3.userDataHelper.has_store_item(player, y3.SurviveConst.PLATFORM_ITEM_MAP.SSR5) then
        table.insert(attrList, { id = 46, value = 10 })
        table.insert(attrList, { id = 2, value = 4000 })
        table.insert(attrList, { id = 49, value = 3 })
    end
    if y3.userDataHelper.has_store_item(player, y3.SurviveConst.PLATFORM_ITEM_MAP.SR1) then
        table.insert(attrList, { id = 6, value = 2 })
        table.insert(attrList, { id = 7, value = 5 })
    end
    if y3.userDataHelper.has_store_item(player, y3.SurviveConst.PLATFORM_ITEM_MAP.SR2) then
        table.insert(attrList, { id = 23, value = 3 })
        table.insert(attrList, { id = 52, value = 3 })
    end
    if y3.userDataHelper.has_store_item(player, y3.SurviveConst.PLATFORM_ITEM_MAP.SR3) then
        table.insert(attrList, { id = 5, value = 30 })
        table.insert(attrList, { id = 18, value = 5 })
    end
    if y3.userDataHelper.has_store_item(player, y3.SurviveConst.PLATFORM_ITEM_MAP.SR4) then
        table.insert(attrList, { id = 4, value = 5 })
        table.insert(attrList, { id = 5, value = 20 })
    end
    if y3.userDataHelper.has_store_item(player, y3.SurviveConst.PLATFORM_ITEM_MAP.SR5) then
        table.insert(attrList, { id = 37, value = 60 })
        table.insert(attrList, { id = 39, value = 5 })
    end
    if y3.userDataHelper.has_store_item(player, y3.SurviveConst.PLATFORM_ITEM_MAP.SR6) then
        table.insert(attrList, { id = 2, value = 2000 })
        table.insert(attrList, { id = 21, value = 20 })
    end
    if y3.userDataHelper.has_store_item(player, y3.SurviveConst.PLATFORM_ITEM_MAP.SR7) then
        table.insert(attrList, { id = 15, value = 750 })
        table.insert(attrList, { id = 16, value = 3 })
    end
    if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.SR8) > 0 then
        local storeNum = math.min(10, player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.SR8))
        table.insert(attrList, { id = 3, value = 30 * storeNum })
    end
    if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.R1) > 0 then
        local storeNum = math.min(30 + map_level * 5,
            player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.R1))
        table.insert(attrList, { id = 55, value = 10 * storeNum })
        local limitNum = math.floor(storeNum / 5)
        table.insert(attrList, { id = 10, value = 1 * limitNum })
    end
    if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.R2) > 0 then
        local storeNum = math.min(30 + map_level * 5,
            player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.R2))
        table.insert(attrList, { id = 56, value = 10 * storeNum })
        local limitNum = math.floor(storeNum / 5)
        table.insert(attrList, { id = 11, value = 1 * limitNum })
    end
    if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.R3) > 0 then
        local storeNum = math.min(30 + map_level * 5,
            player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.R3))
        table.insert(attrList, { id = 57, value = 10 * storeNum })
        local limitNum = math.floor(storeNum / 5)
        table.insert(attrList, { id = 12, value = 1 * limitNum })
    end
    if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.R4) > 0 then
        local storeNum = math.min(30 + map_level * 5,
            player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.R4))
        table.insert(attrList, { id = 58, value = 10 * storeNum })
        local limitNum = math.floor(storeNum / 5)
        table.insert(attrList, { id = 13, value = 1 * limitNum })
    end
    if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.R5) > 0 then
        local storeNum = math.min(30 + map_level * 5,
            player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.R5))
        table.insert(attrList, { id = 59, value = 10 * storeNum })
        local limitNum = math.floor(storeNum / 5)
        table.insert(attrList, { id = 14, value = 1 * limitNum })
    end
    if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.N1) > 0 then
        table.insert(attrList, { id = 35, value = 1 })
        table.insert(attrList, { id = 36, value = 1 })
    end
    if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.N2) > 0 then
        table.insert(attrList, { id = 32, value = 1 })
    end
    if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.N3) > 0 then
        table.insert(attrList, { id = 42, value = 1 })
    end
    if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.N4) > 0 then
        local storeNum = math.min(10,
            player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.N4))
        table.insert(attrList, { id = 1, value = 100 * storeNum })
    end
    if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.N5) > 0 then
        local storeNum = math.min(10,
            player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.N5))
        table.insert(attrList, { id = 3, value = 6 * storeNum })
    end
    if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.N6) > 0 then
        table.insert(attrList, { id = 50, value = 1 })
        table.insert(attrList, { id = 51, value = 1 })
    end
    if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.N7) > 0 then
        table.insert(attrList, { id = 28, value = 2 })
    end
    if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.N8) > 0 then
        table.insert(attrList, { id = 29, value = 2 })
    end
    if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.N9) > 0 then
        table.insert(attrList, { id = 30, value = 2 })
    end
    if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.N10) > 0 then
        table.insert(attrList, { id = 31, value = 2 })
    end
    if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.YERENZHANFU) > 0 then
        table.insert(attrList, { id = 55, value = 30 })
        table.insert(attrList, { id = 10, value = 2 })
    end
    if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.ZHIJINJIAOKUI) > 0 then
        table.insert(attrList, { id = 1, value = 600 })
        table.insert(attrList, { id = 5, value = 15 })
    end
    if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.YUYUELIBAO) > 0 then
        table.insert(attrList, { id = 15, value = 250 })
        table.insert(attrList, { id = 3, value = 20 })
    end
    if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.CESHILIBAO) > 0 then
        table.insert(attrList, { id = 10, value = 1 })
        table.insert(attrList, { id = 11, value = 1 })
    end
    if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.OUHUANG) > 0 then
        table.insert(attrList, { id = 23, value = 3 })
        table.insert(attrList, { id = 18, value = 3 })
        table.insert(attrList, { id = 3, value = 50 })
    end
    if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.ANSHANGMIANYOUREN) > 0 then
        table.insert(attrList, { id = 15, value = 800 })
        table.insert(attrList, { id = 17, value = 5 })
    end
    if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.TUO) > 0 then
        table.insert(attrList, { id = 17, value = 3 })
    end
    if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.ZHUDAPEIBAN) > 0 then
        table.insert(attrList, { id = 15, value = 200 })
    end
    if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.GAOHU666) > 0 then
        table.insert(attrList, { id = 1, value = 300 })
    end
    if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.HUOYANJINJING) > 0 then
        table.insert(attrList, { id = 2, value = 300 })
    end
    if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.MUHOUDALAO) > 0 then
        table.insert(attrList, { id = 3, value = 50 })
        table.insert(attrList, { id = 10, value = 3 })
        table.insert(attrList, { id = 11, value = 3 })
        table.insert(attrList, { id = 12, value = 3 })
        table.insert(attrList, { id = 13, value = 3 })
        table.insert(attrList, { id = 14, value = 3 })
    end
    if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.TAFANGDAREN) > 0 then
        table.insert(attrList, { id = 3, value = 25 })
    end
    if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.JIANDINGZHICHI) > 0 then
        table.insert(attrList, { id = 10, value = 1 })
        table.insert(attrList, { id = 11, value = 1 })
        table.insert(attrList, { id = 12, value = 1 })
        table.insert(attrList, { id = 13, value = 1 })
        table.insert(attrList, { id = 14, value = 1 })
    end
    if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.TEGANFENSI) > 0 then
        table.insert(attrList, { id = 1, value = 500 })
        table.insert(attrList, { id = 15, value = 300 })
        table.insert(attrList, { id = 16, value = 1 })
    end
    if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.HUOJIANFADONGJI) > 0 then
        local storeNum = player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.HUOJIANFADONGJI)
        table.insert(attrList, { id = 1, value = 120 * storeNum })
        table.insert(attrList, { id = 58, value = 25 * storeNum })
        table.insert(attrList, { id = 59, value = 25 * storeNum })
    end
    if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.WANNNEGCHONGDIANQI) > 0 then
        local storeNum = player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.WANNNEGCHONGDIANQI)
        table.insert(attrList, { id = 1, value = 120 * storeNum })
        table.insert(attrList, { id = 55, value = 25 * storeNum })
        table.insert(attrList, { id = 56, value = 25 * storeNum })
        table.insert(attrList, { id = 57, value = 25 * storeNum })
    end

    if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.JINSHUMIYAO) > 0 then
        local storeNum = player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.JINSHUMIYAO)
        local storeNum2 = math.floor(storeNum / 10)
        table.insert(attrList, { id = 10, value = 0.1 * storeNum })
        table.insert(attrList, { id = 55, value = 25 * storeNum2 })
    end
    if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.CHUANCHIMIYAO) > 0 then
        local storeNum = player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.CHUANCHIMIYAO)
        local storeNum2 = math.floor(storeNum / 10)
        table.insert(attrList, { id = 11, value = 0.1 * storeNum })
        table.insert(attrList, { id = 56, value = 25 * storeNum2 })
    end
    if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.MOFAMIYAO) > 0 then
        local storeNum = player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.MOFAMIYAO)
        local storeNum2 = math.floor(storeNum / 10)
        table.insert(attrList, { id = 12, value = 0.1 * storeNum })
        table.insert(attrList, { id = 57, value = 25 * storeNum2 })
    end
    if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.GONGCHNEGMIYAO) > 0 then
        local storeNum = player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.GONGCHNEGMIYAO)
        local storeNum2 = math.floor(storeNum / 10)
        table.insert(attrList, { id = 13, value = 0.1 * storeNum })
        table.insert(attrList, { id = 58, value = 25 * storeNum2 })
    end
    if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.HUNLUANMIYAO) > 0 then
        local storeNum = player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.HUNLUANMIYAO)
        local storeNum2 = math.floor(storeNum / 10)
        table.insert(attrList, { id = 14, value = 0.1 * storeNum })
        table.insert(attrList, { id = 59, value = 25 * storeNum2 })
    end
    if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.HUANGSHIMIBAO) > 0 then
        table.insert(attrList, { id = 15, value = 150 })
        table.insert(attrList, { id = 17, value = 2 })
    end
    
    if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.TEYAOQINGJIAN) > 0 then
        table.insert(attrList, { id = 3, value = 50 })
        table.insert(attrList, { id = 1, value = 588 })
        table.insert(attrList, { id = 5, value = 5 })
    end
    if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.NENGLIANGHEXIN) > 0 then
        table.insert(attrList, { id = 57, value = 60 })
        table.insert(attrList, { id = 12, value = 3 })
        table.insert(attrList, { id = 2, value = 500 })
    end
    if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.QINGLINGJIAN) > 0 then
        table.insert(attrList, { id = 55, value = 65 })
        table.insert(attrList, { id = 1, value = 350 })
        table.insert(attrList, { id = 5, value = 3 })
    end
    if player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.SHENGTUSHIZI) > 0 then
        table.insert(attrList, { id = 59, value = 60 })
        table.insert(attrList, { id = 14, value = 3 })
        table.insert(attrList, { id = 32, value = 3 })
    end
    return attrList, skillList
end

return SurviveGamePlatformShop
