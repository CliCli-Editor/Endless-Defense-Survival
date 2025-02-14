local ShopHelperBuy = class("ShopHelperBuy")

function ShopHelperBuy:ctor()
    local gameCourse = y3.gameApp:getLevel():getLogic("SurviveGameCourse")
    self._isOpen = gameCourse:isShopHelperOpen(y3.gameApp:getMyPlayerId())
    self._isAuto = gameCourse:isShopHelperAutoRefresh(y3.gameApp:getMyPlayerId())
    self:_initCfg()
end

function ShopHelperBuy:isOpen()
    return self._isOpen
end

function ShopHelperBuy:setOpen(isOpen)
    self._isOpen = isOpen
end

function ShopHelperBuy:isAuto()
    return self._isAuto
end

function ShopHelperBuy:setAuto(isAuto)
    self._isAuto = isAuto
end

function ShopHelperBuy:_initCfg()
    local stage_shop_helper_lable = include("gameplay.config.stage_shop_helper_lable")
    local len = stage_shop_helper_lable.length()
    self._labelTypeMap = {}
    for i = 1, len do
        local cfg = stage_shop_helper_lable.indexOf(i)
        assert(cfg, "")
        if not self._labelTypeMap[cfg.shop_helper_lable_type] then
            self._labelTypeMap[cfg.shop_helper_lable_type] = {}
        end
        table.insert(self._labelTypeMap[cfg.shop_helper_lable_type], cfg)
    end
end

function ShopHelperBuy:getHelperTypeList(helperType)
    return self._labelTypeMap[helperType] or {}
end

function ShopHelperBuy:getDefaultLabelSortList()
    local gameCourse = y3.gameApp:getLevel():getLogic("SurviveGameCourse")
    local recordSorts = gameCourse:getShopHelperWeanponSort(y3.gameApp:getMyPlayerId())
    return recordSorts
end

function ShopHelperBuy:getCollectLabelIndex(labelType, label)
    if labelType == 1 then
        return self:getLebelSortIndex(label, self:getDefaultLabelSortList())
    elseif labelType == 2 then
        return self:getLebelSortIndex(label, self:getDefaultLabelAddSortList())
    elseif labelType == 3 then
        return self:getLebelSortIndex(label, self:getDefaultLabelOtherAddSortList())
    elseif labelType == 4 then
        return self:getQualitySortIndex(label, self:getDeafultQualitySortList())
    end
    return 0
end

function ShopHelperBuy:getDefaultLabelAddSortList()
    local gameCourse = y3.gameApp:getLevel():getLogic("SurviveGameCourse")
    local recordSorts = gameCourse:getShopHelperWeanponAddSort(y3.gameApp:getMyPlayerId())
    return recordSorts
end

function ShopHelperBuy:getDefaultLabelOtherAddSortList()
    local gameCourse = y3.gameApp:getLevel():getLogic("SurviveGameCourse")
    local recordSorts = gameCourse:getShopHelperWeaponOtherAddSort(y3.gameApp:getMyPlayerId())
    return recordSorts
end

function ShopHelperBuy:getDeafultQualitySortList()
    local gameCourse = y3.gameApp:getLevel():getLogic("SurviveGameCourse")
    local recordSorts = gameCourse:getShopHelperWeaponQualitySort(y3.gameApp:getMyPlayerId())
    return recordSorts
end

function ShopHelperBuy:getLebelSortIndex(label, sortList)
    -- print(label)
    -- dump_all(sortList)
    local retIndex = 0
    for i = 1, #sortList do
        if sortList[i] > 0 then
            retIndex = retIndex + 1
            if sortList[i] == label then
                return retIndex
            end
        end
    end
    return 0
end

function ShopHelperBuy:getQualitySortIndex(quality, sortList)
    local retIndex = 0
    for i = 1, #sortList do
        if sortList[i] > 0 then
            retIndex = retIndex + 1
            if sortList[i] == quality then
                return retIndex
            end
        end
    end
    return 0
end

function ShopHelperBuy:getLabelIndexScore(sortIndex)
    local cfg = include("gameplay.config.stage_shop_lable_score").get(sortIndex)
    if cfg then
        return cfg.shop_helper_lable_score
    end
    return 0
end

function ShopHelperBuy:getQualityIndexScore(sortIndex)
    local cfg = include("gameplay.config.stage_shop_lable_score").get(sortIndex)
    if cfg then
        return cfg.shop_helper_quality_score
    end
    return 0
end

function ShopHelperBuy:getSkillSortScore(skillCfg)
    local shop_helper_lables = string.split(skillCfg.shop_helper_lable, "|")
    assert(shop_helper_lables, "")
    local totalScore = 0
    for i = 1, #shop_helper_lables do
        local param = shop_helper_lables[i]
        if i == 1 then --武器购买标签
            local weaponLabel = tonumber(param)
            if weaponLabel and weaponLabel > 0 then
                local lableTypeIndex = self:getLebelSortIndex(weaponLabel, self:getDefaultLabelSortList())
                local lableTypeScore = self:getLabelIndexScore(lableTypeIndex)
                totalScore = totalScore + lableTypeScore
            end
        elseif i == 2 then --伤害加成购买标签组
            local damageAddLabels = string.split(param, "#")
            assert(damageAddLabels, "")
            for j = 1, #damageAddLabels do
                local damageAddLabel = tonumber(damageAddLabels[j])
                if damageAddLabel and damageAddLabel > 0 then
                    local lableTypeIndex = self:getLebelSortIndex(damageAddLabel, self:getDefaultLabelAddSortList())
                    local lableTypeScore = self:getLabelIndexScore(lableTypeIndex)
                    totalScore = totalScore + lableTypeScore
                end
            end
        elseif i == 3 then --其他加成购买标签组
            local skillAddLabels = string.split(param, "#")
            assert(skillAddLabels, "")
            for j = 1, #skillAddLabels do
                local skillAddLabel = tonumber(skillAddLabels[j])
                if skillAddLabel and skillAddLabel > 0 then
                    local lableTypeIndex = self:getLebelSortIndex(skillAddLabel, self:getDefaultLabelOtherAddSortList())
                    local lableTypeScore = self:getLabelIndexScore(lableTypeIndex)
                    totalScore = totalScore + lableTypeScore
                end
            end
        end
    end
    local qualityIndex = self:getQualitySortIndex(skillCfg.class, self:getDeafultQualitySortList())
    local qualityScore = self:getQualityIndexScore(qualityIndex)
    totalScore = totalScore * qualityScore
    return totalScore
end

function ShopHelperBuy:autoBuy(shopList)
    if not self._isOpen then
        return false
    end
    local result = {}
    local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    for i = 1, 8 do
        local skillPool = shopList[i]
        local state = playerData:getRandomPoolState(i)
        if skillPool and state == 0 then
            local skillCfg, price = y3.surviveHelper.getSkillCfgAndPriceByRandomPoolId(skillPool.id)
            local score = self:getSkillSortScore(skillCfg)
            if score > 0 then
                table.insert(result, { poolId = skillPool.id, cfg = skillCfg, price = price, score = score, slot = i })
            end
        end
    end
    log.info("//////////////////////////////////////")
    if #result > 0 then
        table.sort(result, function(a, b)
            return a.score > b.score
        end)
        for i = 1, #result do
            log.info("auto buy skill", result[i].cfg.name, result[i].score)
            y3.SyncMgr:sync(y3.SyncConst.SYNC_SURVIVE_LEARN_SKILL,
                {
                    skillId = result[i].cfg.id,
                    price = result[i].price,
                    poolId = result[i].poolId,
                    slot = result[i].slot,
                    autoBuy = true,
                })
        end
    else
        if self._isAuto then
            log.info("auto refresh skill pool")
            local refreshSkill = y3.gameApp:getLevel():getLogic("SurviveRefreshSkill")
            local freeCount, costCount, maxFreeCount, maxCostCount, costGold =
                refreshSkill:getRefreshCount(playerData:getId())
            if freeCount > 0 then
                y3.SyncMgr:sync(y3.SyncConst.SYNC_REFRESH_SKILL_POOL, {})
            else
                if costCount > 0 or maxCostCount < 0 then
                    local player = playerData:getPlayer()
                    local gold = player:get_attr("gold")
                    if gold >= costGold then
                        y3.SyncMgr:sync(y3.SyncConst.SYNC_REFRESH_SKILL_POOL, {})
                    end
                end
            end
        end
    end
end

return ShopHelperBuy
