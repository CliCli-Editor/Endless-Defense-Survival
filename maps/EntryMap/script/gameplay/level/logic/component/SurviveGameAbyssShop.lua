local GlobalConfigHelper = require "gameplay.level.logic.helper.GlobalConfigHelper"
local UserDataHelper = include "gameplay.level.logic.helper.UserDataHelper"
local SurviveHelper = include "gameplay.level.logic.helper.SurviveHelper"
local SurviveGameAbyssShop = class("SurviveGameAbyssShop")
local stage_abyss_shop = include("gameplay.config.stage_abyss_blackmarket")

local MAX_SLOT = 16

function SurviveGameAbyssShop:ctor(parent)
    self._parent = parent
    self:_initCfg()
    y3.gameApp:addTimerLoop(1, handler(self, self._onTimerRefreshShop))
end

function SurviveGameAbyssShop:_initCfg()
    local stageCfg = include("gameplay.config.stage_config").get(y3.userData:getCurStageId())
    assert(stageCfg, "can not find cfg in stage_config by id=" .. y3.userData:getCurStageId())
    self._shopLimit = {}
    local stage_abyss_shop_limits = string.split(stageCfg.stage_abyss_shop_limit, "|")
    assert(stage_abyss_shop_limits, "")
    for _, str in ipairs(stage_abyss_shop_limits) do
        local limits = string.split(str, "#")
        assert(limits, "")
        local itemType = tonumber(limits[1])
        local itemId = tonumber(limits[2])
        local limit = tonumber(limits[3])
        self._shopLimit[itemType .. "_" .. itemId] = limit
    end
    self._abyssShopList = {}
    local len = stage_abyss_shop.length()
    for i = 1, len do
        local cfg = stage_abyss_shop.indexOf(i)
        table.insert(self._abyssShopList, cfg)
    end
    local stage_blackmarket_level = include("gameplay.config.stage_blackmarket_level")
    self._shopLvMap = {}
    self._shopMaxLevel = 0
    local len = stage_blackmarket_level.length()
    for i = 1, len do
        local cfg = stage_blackmarket_level.indexOf(i)
        assert(cfg, "")
        self._shopLvMap[cfg.shop_blackmarket_level] = cfg
        if cfg.shop_blackmarket_level > self._shopMaxLevel then
            self._shopMaxLevel = cfg.shop_blackmarket_level
        end
    end
    self._diamondExp = GlobalConfigHelper.get(50)
    self._goldExp = GlobalConfigHelper.get(51)

    self._abyssShopBuyRecord = {}
    self._abyssShopData = {}
    self._chargeOpen = {}
    local allPlayers = y3.userData:getAllInPlayers()
    for _, playeData in ipairs(allPlayers) do
        local param = {}
        param.curShopId = self._abyssShopList[1].id
        param.shopDuration = 0 --stageCfg.stage_abyss_shop_open
        param.maxShopDuration = self._shopLvMap[1].shop_blackmarket_auto_refresh
        param.challengeCnt = 0
        param.open = false
        param.shops = {}
        param.shopLevel = 1
        param.shopExp = 0
        param.isOpened = false
        param.isRefresh = false
        self._abyssShopData[playeData:getId()] = param
        self._abyssShopBuyRecord[playeData:getId()] = {}
        self._chargeOpen[playeData:getId()] = true
    end
end

function SurviveGameAbyssShop:_onTimerRefreshShop(delay)
    local dt = delay:float()
    local allInPlayers = y3.userData:getAllInPlayers()
    for _, playerData in ipairs(allInPlayers) do
        self:_doPlayerRefreshShop(playerData, dt)
    end
end

function SurviveGameAbyssShop:closeShopCharge(playerId, close)
    self._chargeOpen[playerId] = not close
end

function SurviveGameAbyssShop:shopChargeIsOpen(playerId)
    return self._chargeOpen[playerId]
end

function SurviveGameAbyssShop:_doPlayerRefreshShop(playerData, dt)
    local param = self._abyssShopData[playerData:getId()]
    if not param.isOpened then
        param.isOpened = y3.FuncCheck.checkFuncIsOpen(playerData:getId(), y3.FuncConst.FUNC_BLACKMARKET)
        return
    end
    param.shopDuration = param.shopDuration - dt
    if param.shopDuration <= 0 then
        param.shopDuration = param.maxShopDuration
        self:_challengeCntIncrement(playerData:getId())
    end
    local shops = param.shops
    for i = 1, 12 do
        local shopData = shops[i]
        -- log.info(self._chargeOpen[playerData:getId()])
        if shopData and shopData.needRecharge and self._chargeOpen[playerData:getId()] then
            if shopData.rechrageNum < shopData.rechrageMax then
                shopData.rechargeTime = shopData.rechargeTime + dt
                if shopData.rechargeTime >= self:getShopDataMaxRechargeTime(playerData, shopData) then
                    shopData.rechargeTime = 0
                    shopData.rechrageNum = shopData.rechrageNum + 1
                    local cfg = include("gameplay.config.item").get(shopData.itemId)
                    if cfg then
                        local colorStr = y3.ColorConst.QUALITY_COLOR_MAP[cfg.item_quality + 1] or
                            y3.ColorConst.QUALITY_COLOR_MAP[1]
                        y3.Sugar.localNotice(playerData:getId(), 31, { item = "#" .. colorStr .. cfg.item_name })
                    end
                    y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SURVIVE_ABYSS_SHOP_RECHARGE_ADD, playerData:getId())
                    y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SURVIVE_GAME_ABYSS_SHOP_REFRESH, playerData:getId())
                end
            end
        end
    end
end

function SurviveGameAbyssShop:_challengeCntIncrement(playerId)
    local param = self._abyssShopData[playerId]
    param.challengeCnt = 1
    param.open = true
    self:_refreshCards(playerId)
end

function SurviveGameAbyssShop:getShopParam(playerId)
    local param = self._abyssShopData[playerId]
    return param.shopDuration, param.maxShopDuration, param.challengeCnt, 0
end

function SurviveGameAbyssShop:getShopRefreshFloor(playerId)
    -- local param = self._abyssShopData[playerId]
    -- local floor = self._parent:getChallengeFloor(playerId)
    -- local shopCfg = stage_abyss_shop.get(param.curShopId)
    -- assert(shopCfg, "can not find cfg in stage_shop by id=" .. param.curShopId)
    -- local refreshFloor = floor - param.challengeCnt + shopCfg.abyss_floor_refresh_round
    return 0, 0
end

function SurviveGameAbyssShop:getShopItemDataRefreshPrice(playerId)
    local param = self._abyssShopData[playerId]
    local shopLv = param.shopLevel
    local lvCfg = self._shopLvMap[shopLv] or self._shopLvMap[self._shopMaxLevel]
    local prices = string.split(lvCfg.shop_blackmarket_refresh_price, "#")
    assert(prices, "")
    return tonumber(prices[2]), tonumber(prices[1])
end

function SurviveGameAbyssShop:getShopItemList(playerId)
    local param = self._abyssShopData[playerId]
    return param.shops
end

function SurviveGameAbyssShop:initiativeRefreshCards(playerId)
    local price, priceType = self:getShopItemDataRefreshPrice(playerId)
    if y3.surviveHelper.checkShopPrice(playerId, priceType, price) then
        local param = self._abyssShopData[playerId]
        param.shopDuration = param.maxShopDuration
        self:_refreshCards(playerId)
    else
        y3.Sugar.localTips(playerId, GameAPI.get_text_config('#-1288538949#lua'))
    end
end

function SurviveGameAbyssShop:getShopId(playerId)
    local floor = self._parent:getChallengeFloor(playerId)
    for i = 1, #self._abyssShopList do
        if floor <= self._abyssShopList[i].abyss_floor then
            return self._abyssShopList[i].id
        end
    end
    return self._abyssShopList[#self._abyssShopList].id
end

function SurviveGameAbyssShop:_refreshCards(playerId)
    local param = self._abyssShopData[playerId]
    local shopLv = param.shopLevel
    local lvCfg = self._shopLvMap[shopLv]
    local blocks = string.split(lvCfg.shop_blackmarket_refresh_block, "|")
    assert(blocks, "")
    local blockMap = {}
    for i = 1, #blocks do
        blockMap[tonumber(blocks[i])] = true
    end
    local oldShops = param.shops
    local resultSet = {}
    for i = 1, #self._abyssShopList do
        local cfg = self._abyssShopList[i]
        if cfg.abyss_shop_block_type == 1 then
            if param.isRefresh == false then
                self:_setShopBlock(cfg, resultSet)
            else
                resultSet[cfg.abyss_shop_block_id] = oldShops[cfg.abyss_shop_block_id]
            end
        elseif cfg.abyss_shop_block_type == 2 then
            if blockMap[cfg.abyss_shop_block_id] then
                self:_setShopBlock(cfg, resultSet)
            else
                resultSet[cfg.abyss_shop_block_id] = oldShops[cfg.abyss_shop_block_id]
            end
        end
    end
    local param = self._abyssShopData[playerId]
    param.shops = resultSet
    param.isRefresh = true
    y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SURVIVE_GAME_ABYSS_SHOP_REFRESH, playerId)
    return resultSet
end

function SurviveGameAbyssShop:_setShopBlock(cfg, resultSet)
    local data = {}
    local abyss_shop_item = string.split(cfg.abyss_shop_item, "#")
    assert(abyss_shop_item, "")
    if cfg.abyss_shop_block_type == 1 then
        data.type = 3
        data.itemId = tonumber(abyss_shop_item[1]) or 0
        data.itemSize = tonumber(abyss_shop_item[2]) or 0
        data.price = -1
        data.priceType = 0
    else
        local abyss_shop_item_random_pools = string.split(cfg.abyss_shop_item_random_pool, "|")
        assert(abyss_shop_item_random_pools, "")
        local randList = {}
        for i = 1, #abyss_shop_item_random_pools do
            local param = string.split(abyss_shop_item_random_pools[i], "#")
            assert(param, "")
            local poolId = tonumber(param[1])
            local weight = tonumber(param[2])
            local data   = {}
            data.poolId  = poolId
            data.weight  = weight
            table.insert(randList, data)
        end
        local randData = y3.surviveHelper.getRandomDataByWeightList(randList)
        local refreshSkill = y3.gameApp:getLevel():getLogic("SurviveRefreshSkill")
        local randItem = refreshSkill:getRandomItemByPoolId(randData.poolId)
        data.type = randItem.item_type
        data.itemId = randItem.random_pool_item
        data.itemSize = 1
        data.priceType = randItem.price_type
        data.price = randItem.price
    end
    data.buy = false
    if cfg.abyss_shop_block_recharge > 0 then
        data.needRecharge = true
    else
        data.needRecharge = false
    end
    data.rechargeTime = 0 --cfg.abyss_shop_block_recharge
    data.maxRechargeTime = cfg.abyss_shop_block_recharge
    if cfg.abyss_shop_default_inventory > 0 then
        data.rechrageNum = cfg.abyss_shop_default_inventory
    else
        data.rechrageNum = 0
    end
    data.rechrageMax = cfg.abyss_shop_block_recharge_max_num
    data.buyLimit = cfg.abyss_shop_block_buy_max_num
    data.buyCount = 0
    local priceDatas = self:parsePrice(cfg.abyss_shop_block_buy_base_price)
    data.priceDatas = priceDatas
    resultSet[cfg.abyss_shop_block_id] = data
    -- table.insert(resultSet, data)
end

function SurviveGameAbyssShop:getShopDataPrice(data)
    if data.priceType > 0 then
        return data.price, data.priceType
    end
    local buyCount = data.buyCount + 1
    local priceDatas = data.priceDatas
    local lastCount = 0
    for i = 1, #priceDatas do
        local priceData = priceDatas[i]
        if buyCount <= priceData.limitCount then
            return priceData.priceValue + (buyCount - lastCount) * priceData.priceAdd, priceData.priceType
        else
            lastCount = priceData.limitCount
        end
    end
    return priceDatas[1].priceValue, priceDatas[1].priceType
end

function SurviveGameAbyssShop:parsePrice(abyss_shop_block_buy_base_price)
    local priceDatas = string.split(abyss_shop_block_buy_base_price, "|")
    assert(priceDatas, "")
    local reuslt = {}
    for i, priceData in ipairs(priceDatas) do
        local price = string.split(priceData, "#")
        assert(price, "")
        local limitCount = tonumber(price[1])
        local priceType = tonumber(price[2])
        local priceValue = tonumber(price[3])
        local priceAdd = tonumber(price[4])
        table.insert(reuslt, {
            limitCount = limitCount,
            priceType = priceType,
            priceValue = priceValue,
            priceAdd = priceAdd
        })
    end
    return reuslt
end

function SurviveGameAbyssShop:buyAbyssShop(playerId, slot, buyTimes)
    local playerData = y3.userData:getPlayerData(playerId)
    local mainActor = playerData:getMainActor()
    if mainActor:isDieFianl() then
        y3.Sugar.localTips(playerId, y3.langCfg.get(68).str_content)
        return
    end
    local param = self._abyssShopData[playerId]
    local data = param.shops[slot]
    local buyTims = buyTimes or 1
    local haveSuccess = false
    for i = 1, buyTims do
        local ret = self:_pureBuyShopItem(playerId, data)
        if ret then
            haveSuccess = true
        end
        if not ret then
            break
        end
    end
    if haveSuccess then
        y3.Sugar.localTips(playerId, GameAPI.get_text_config('#-1417518221#lua'))
        y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SURVIVE_GAME_ABYSS_SHOP_BUY, playerId)
    end
end

function SurviveGameAbyssShop:getShopDataMaxRechargeTime(playerData, data)
    -- (T-challengetime_reduce)*(1-challengetime_reduce_pre/100)
    local mainActor = playerData:getMainActor()
    local mainUnit = mainActor:getUnit()
    local challengetime_reduce = 0
    local challengetime_reduce_pre = 0
    if mainUnit:kv_has("challengetime_reduce") then
        challengetime_reduce = mainUnit:kv_load("challengetime_reduce", "number")
    end
    if mainUnit:kv_has("challengetime_reduce_pre") then
        challengetime_reduce_pre = mainUnit:kv_load("challengetime_reduce_pre", "number")
    end
    local maxRechargeTime = data.maxRechargeTime
    local maxreduceTime = (maxRechargeTime - challengetime_reduce) * (1 - challengetime_reduce_pre / 100)
    return maxreduceTime
end

function SurviveGameAbyssShop:getShopDataRemainTime(playerId, data)
    local playerData = y3.userData:getPlayerData(playerId)
    local remainTime = self:getShopDataMaxRechargeTime(playerData, data) - data.rechargeTime
    return remainTime
end

function SurviveGameAbyssShop:_pureBuyShopItem(playerId, data)
    local isRet = false
    if data and not data.buy then
        -- local isCan = SurviveHelper.checkCanDropItem(playerId, data.itemId)
        -- if not isCan then
        --     y3.Sugar.localTips(playerId, y3.langCfg.get(16).str_content)
        --     return
        -- end
        if data.needRecharge then
            if data.rechrageNum <= 0 then
                local remainTime = self:getShopDataRemainTime(playerId, data)
                y3.Sugar.localTips(playerId,
                    y3.Lang.getLang(y3.langCfg.get(23).str_content, { time = math.floor(remainTime) }))
                return
            end
        end
        if data.buyLimit > 0 then
            if data.buyCount >= data.buyLimit then
                y3.Sugar.localTips(playerId, y3.langCfg.get(14).str_content)
                return
            end
        end
        local price, priceType = self:getShopDataPrice(data)
        if SurviveHelper.checkShopPrice(playerId, priceType, price) then
            if priceType == y3.SurviveConst.RESOURCE_TYPE_DIAMOND then
                self:addShopExp(playerId, price * self._diamondExp)
            elseif priceType == y3.SurviveConst.RESOURCE_TYPE_GOLD then
                self:addShopExp(playerId, price * self._goldExp)
            end
            data.buyCount = data.buyCount + 1
            if data.needRecharge then
                data.rechrageNum = math.max(0, data.rechrageNum - 1)
            end
            if data.buyLimit > 0 then
                data.buy = data.buyCount >= data.buyLimit
                if data.buy then
                    data.needRecharge = false
                end
            end
            for i = 1, data.itemSize do
                if data.type == 3 then
                    SurviveHelper.dropItem(playerId, data.itemId)
                elseif data.type == 1 or data.type == 2 then
                    SurviveHelper.leanSkill({ playerId, data.itemId })
                end
            end
            isRet = true
        else
            y3.Sugar.localTips(playerId, y3.langCfg.get(19).str_content)
        end
    else
        if data then
            y3.Sugar.localTips(playerId, y3.Lang.getLang(y3.langCfg.get(37).str_content, { num = data.buyLimit }))
        end
    end
    return isRet
end

------------------------------------------------------
function SurviveGameAbyssShop:addShopExp(playerId, exp)
    local param = self._abyssShopData[playerId]
    local shopLv = param.shopLevel
    local lvCfg = self._shopLvMap[shopLv]
    if not lvCfg then
        return
    end
    if lvCfg.shop_blackmarket_next_level_exp <= 0 then
        return
    end
    local shopExp = param.shopExp + exp
    if shopExp >= lvCfg.shop_blackmarket_next_level_exp then
        shopLv = shopLv + 1
        shopExp = shopExp - lvCfg.shop_blackmarket_next_level_exp
        local lvCfg2 = self._shopLvMap[shopLv] or self._shopLvMap[self._shopMaxLevel]
        param.maxShopDuration = lvCfg2.shop_blackmarket_auto_refresh
    end
    param.shopExp = shopExp
    param.shopLevel = shopLv
end

function SurviveGameAbyssShop:getMaxExp(playerId)
    local param = self._abyssShopData[playerId]
    local shopLv = param.shopLevel
    local lvCfg = self._shopLvMap[shopLv]
    if not lvCfg then
        return 0
    end
    return lvCfg.shop_blackmarket_next_level_exp
end

function SurviveGameAbyssShop:getCurShopExp(playerId)
    local param = self._abyssShopData[playerId]
    return math.floor(param.shopExp)
end

function SurviveGameAbyssShop:getCurShopLv(playerId)
    local param = self._abyssShopData[playerId]
    return param.shopLevel
end

return SurviveGameAbyssShop
