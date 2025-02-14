local SurviveHelper = {}
local Vector = include("gameplay.utils.Vector")

function SurviveHelper.spawnWeaponPoints(result, randius, height)
    for angle = 0, 360, 30 do
        local dirx = math.cos(angle / 180 * math.pi) * randius
        local diry = math.sin(angle / 180 * math.pi) * randius
        table.insert(result, { x = dirx, y = diry, z = height, use = false })
    end
end

function SurviveHelper.getRandomSpawnPoints(point, radius, angle, nums)
    local GlobalConfigHelper = include "gameplay.level.logic.helper.GlobalConfigHelper"
    local contents = string.split(GlobalConfigHelper.get(6), "|")
    local ranRangex = tonumber(contents[1])
    local ranRangey = tonumber(contents[2])
    local dirx = math.cos(angle / 180 * math.pi)
    local diry = math.sin(angle / 180 * math.pi)
    local dir = Vector.new(dirx, diry)
    local curPos = Vector.new(point:get_x(), point:get_y())
    local tarPos = curPos:add(dir:multiply(radius))
    -- local area = --y3.area.create_rectangle_area(y3.point.create(tarPos.x, tarPos.y, point:get_z()), 500, 500)
    local result = {}
    for i = 1, nums do
        local ranx = math.random(-ranRangex, ranRangex)
        local randy = math.random(-ranRangey, ranRangey)
        table.insert(result, y3.point.create(tarPos.x + ranx, tarPos.y + randy, point:get_z()))
    end
    return result
end

function SurviveHelper.getSpawnMonsterNums()
    local spawnNumMap = {
        { num = 1, pro = 10 },
        { num = 2, pro = 2 },
        { num = 3, pro = 1 },
        { num = 4, pro = 1 },
        { num = 6, pro = 1 },
    }
    local allPro = 0
    for i = 1, #spawnNumMap do
        allPro = allPro + spawnNumMap[i].pro
    end
    local pro = math.random(1, allPro)
    local lastPro = 0
    for i = 1, #spawnNumMap do
        local data = spawnNumMap[i]
        if pro > lastPro and pro <= lastPro + data.pro then
            return data.num
        end
        lastPro = lastPro + data.pro
    end
    return spawnNumMap[1].num
end

function SurviveHelper.initMonsterMap()
    SurviveHelper.monsterMap = {}
    local monster = include("gameplay.config.monster")
    local len = monster.length()
    for i = 1, len do
        local cfg = monster.indexOf(i)
        if not SurviveHelper.monsterMap[cfg.type] then
            SurviveHelper.monsterMap[cfg.type] = {}
        end
        table.insert(SurviveHelper.monsterMap[cfg.type], cfg)
    end
end

function SurviveHelper.getSpawnMonsterId()
    if not SurviveHelper.monsterMap then
        SurviveHelper.initMonsterMap()
    end
    local spanMap = {
        { type = "infantry", pro = 5 },
        { type = "bandit",   pro = 9 },
        { type = "robber",   pro = 5 },
        { type = "knight",   pro = 5 },
        { type = "archer",   pro = 5 },
    }
    local allPro = 0
    for i = 1, #spanMap do
        allPro = allPro + spanMap[i].pro
    end
    local pro = math.random(1, allPro)
    local lastPro = 0
    for i = 1, #spanMap do
        local data = spanMap[i]
        if pro > lastPro and pro <= lastPro + data.pro then
            local monsters = SurviveHelper.monsterMap[data.type]
            local index = math.random(1, #monsters)
            return monsters[index]
        end
        lastPro = lastPro + data.pro
    end
    local monsters = SurviveHelper.monsterMap[spanMap[1].type]
    local index = math.random(1, #monsters)
    return monsters[index]
end

function SurviveHelper.getGoldMonsterCfg()
    local cfg = include("gameplay.config.monster").get(7)
    return cfg
end

function SurviveHelper.find300RangeEnemy(playerId)
    return y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy"):findArea300Enemy(playerId)
end

function SurviveHelper.find300_to_600RangeEnemy(playerId)
    return y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy"):findArea300_to_600Enemy(playerId)
end

function SurviveHelper.find_600_to_900RangeEnemy(playerId)
    return y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy"):findArea600_to_900Enemy(playerId)
end

function SurviveHelper.find_900_to_1200RangeEnemy(playerId)
    return y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy"):findArea900_to_1200Enemy(playerId)
end

function SurviveHelper.getMonsterCfgById(id)
    local cfg = include("gameplay.config.monster").get(id)
    return cfg
end

function SurviveHelper.initStageCfg()
    local stage_wave = include("gameplay.config.stage_wave")
    local len = stage_wave.length()
    SurviveHelper.stageWaveMap = {}
    for i = 1, len do
        local cfg = stage_wave.indexOf(i)
        if not SurviveHelper.stageWaveMap[cfg.stage_id] then
            SurviveHelper.stageWaveMap[cfg.stage_id] = {}
        end
        table.insert(SurviveHelper.stageWaveMap[cfg.stage_id], cfg)
    end
end

function SurviveHelper.getStageWaveCfg(stageId)
    return SurviveHelper.stageWaveMap[stageId] or {}
end

function SurviveHelper.initMonsterModelPool()
    local wave_monster_model_random_pool = include("gameplay.config.wave_monster_model_random_pool")
    local len = wave_monster_model_random_pool.length()
    SurviveHelper.monsterModelPool = {}
    for i = 1, len do
        local cfg = wave_monster_model_random_pool.indexOf(i)
        if not SurviveHelper.monsterModelPool[cfg.pool_id] then
            SurviveHelper.monsterModelPool[cfg.pool_id] = {}
        end
        table.insert(SurviveHelper.monsterModelPool[cfg.pool_id], cfg)
    end
end

function SurviveHelper.getMonsterModelByPoolId(poolId)
    local list = SurviveHelper.monsterModelPool[poolId] or {}
    local allPro = 0
    for i, cfg in ipairs(list) do
        allPro = allPro + cfg.weight
    end
    local pro = math.random(1, allPro)
    local lastPro = 0
    for i, cfg in ipairs(list) do
        if pro > lastPro and pro <= lastPro + cfg.weight then
            return cfg.model
        end
        lastPro = lastPro + cfg.weight
    end
    return list[1].model
end

function SurviveHelper.initWaveMonsterNumberPool()
    local wave_monster_number_random_pool = include("gameplay.config.wave_monster_number_random_pool")
    local len = wave_monster_number_random_pool.length()
    SurviveHelper.monsterNumberPool = {}
    for i = 1, len do
        local cfg = wave_monster_number_random_pool.indexOf(i)
        if not SurviveHelper.monsterNumberPool[cfg.pool_id] then
            SurviveHelper.monsterNumberPool[cfg.pool_id] = {}
        end
        table.insert(SurviveHelper.monsterNumberPool[cfg.pool_id], cfg)
    end
end

function SurviveHelper.getMonsterNumByPoolId(poolId)
    if poolId <= 0 then
        return 1
    end
    local list = SurviveHelper.monsterNumberPool[poolId] or {}
    assert(#list > 0, "can not found ramdom num pool by id=" .. poolId)
    local allPro = 0
    for i, cfg in ipairs(list) do
        allPro = allPro + cfg.weight
    end
    local pro = math.random(1, allPro)
    local lastPro = 0
    for i, cfg in ipairs(list) do
        if pro > lastPro and pro <= lastPro + cfg.weight then
            return cfg.number
        end
        lastPro = lastPro + cfg.weight
    end
    return list[1].number
end

function SurviveHelper.initMonsterTypePool()
    local wave_monster_type_random_pool = include("gameplay.config.wave_monster_type_random_pool")
    local len = wave_monster_type_random_pool.length()
    SurviveHelper.monsterTypePool = {}
    for i = 1, len do
        local cfg = wave_monster_type_random_pool.indexOf(i)
        if not SurviveHelper.monsterTypePool[cfg.pool_id] then
            SurviveHelper.monsterTypePool[cfg.pool_id] = {}
        end
        table.insert(SurviveHelper.monsterTypePool[cfg.pool_id], cfg)
    end
end

function SurviveHelper.getMonsterTypeByPoolId(poolId)
    -- log.info(" SurviveHelper.getMonsterTypeByPoolId ", poolId)
    local list = SurviveHelper.monsterTypePool[poolId] or {}
    local allPro = 0
    for i, cfg in ipairs(list) do
        allPro = allPro + cfg.weight
    end
    local pro = math.random(1, allPro)
    local lastPro = 0
    for i, cfg in ipairs(list) do
        if pro > lastPro and pro <= lastPro + cfg.weight then
            return cfg.monster_id
        end
        lastPro = lastPro + cfg.weight
    end
    return list[1].monster_id
end

function SurviveHelper.getRandomDataByWeightList(randDataList)
    local allPro = 0
    for i = 1, #randDataList do
        allPro = allPro + randDataList[i].weight
    end
    if allPro == 0 then
        return randDataList[1]
    end
    local pro = math.random(1, allPro)
    local lastPro = 0
    for i = 1, #randDataList do
        if pro > lastPro and pro <= lastPro + randDataList[i].weight then
            return randDataList[i]
        end
        lastPro = lastPro + randDataList[i].weight
    end
    return randDataList[1]
end

function SurviveHelper.getRandomItemByWeightList(randDataList)
    local allPro = 0
    for i = 1, #randDataList do
        allPro = allPro + randDataList[i].random_pool_item_weight
    end
    if allPro == 0 then
        return randDataList[1]
    end
    local pro = math.random(1, allPro)
    local lastPro = 0
    for i = 1, #randDataList do
        if pro > lastPro and pro <= lastPro + randDataList[i].random_pool_item_weight then
            return randDataList[i]
        end
        lastPro = lastPro + randDataList[i].random_pool_item_weight
    end
    return randDataList[1]
end

---comment
---@param actorUnitId py.UnitID
---@param skillId integer
---@return Unit?
function SurviveHelper.getAttackEnemy(actorUnitId, skillId)
    assert(actorUnitId, "not found actorUnitId")
    assert(skillId, "not found skillId")
    local cfg = include("gameplay.config.config_skillData").get(tostring(skillId))
    assert(cfg, "not found cfg in skill by id=" .. skillId)
    local actorUnit = y3.unit.get_by_id(actorUnitId)
    assert(actorUnit, "not found actorUnit by id=" .. actorUnitId)
    local list = {}
    local spawnEnemy = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy")
    local tagRange = ""
    if cfg.range == y3.SurviveConst.RANGE_300 then
        local list300 = spawnEnemy:findArea300Enemy(actorUnit:get_owner_player():get_id())
        tagRange = y3.SurviveConst.TAG_AREA_300
        list = list300
    elseif cfg.range == y3.SurviveConst.RANGE_600 then
        local list600 = spawnEnemy:findArea300_to_600Enemy(actorUnit:get_owner():get_id())
        tagRange = y3.SurviveConst.TAG_AREA_600
        if #list600 > 0 then
            list = list600
        else
            local list300 = spawnEnemy:findArea300Enemy(actorUnit:get_owner_player():get_id())
            list = list300
        end
    elseif cfg.range == y3.SurviveConst.RANGE_900 then
        local list900 = spawnEnemy:findArea600_to_900Enemy(actorUnit:get_owner():get_id())
        tagRange = y3.SurviveConst.TAG_AREA_900
        if #list900 > 0 then
            list = list900
        else
            local list600 = spawnEnemy:findArea300_to_600Enemy(actorUnit:get_owner():get_id())
            if #list600 > 0 then
                list = list600
            else
                local list300 = spawnEnemy:findArea300Enemy(actorUnit:get_owner_player():get_id())
                list = list300
            end
        end
    elseif cfg.range == y3.SurviveConst.RANGE_1200 then
        local list1200 = spawnEnemy:findArea900_to_1200Enemy(actorUnit:get_owner():get_id())
        tagRange = y3.SurviveConst.TAG_AREA_1200
        if #list1200 > 0 then
            list = list1200
        else
            local list900 = spawnEnemy:findArea600_to_900Enemy(actorUnit:get_owner():get_id())
            if #list900 > 0 then
                list = list900
            else
                local list600 = spawnEnemy:findArea300_to_600Enemy(actorUnit:get_owner():get_id())
                if #list600 > 0 then
                    list = list600
                else
                    local list300 = spawnEnemy:findArea300Enemy(actorUnit:get_owner_player():get_id())
                    list = list300
                end
            end
        end
        if #list <= 0 then
            list = spawnEnemy:findArea1200Enemy(actorUnit:get_owner_player():get_id())
        end
    end
    local fireList = spawnEnemy:getFirePointList(actorUnit:get_owner_player():get_id())
    if #fireList > 0 then
        local retFireList = {}
        for i, fireUnit in ipairs(fireList) do
            if fireUnit:has_tag(tagRange) then
                table.insert(retFireList, fireUnit)
            end
        end
        if #retFireList > 0 then
            list = retFireList
        end
    end
    if #list == 0 then
        return
    end
    -- print("---------------------------------------------------")
    local priTargets = string.split(cfg.target_pri, "|")
    local hitList = {}
    for i = 1, #priTargets do
        local tag = tonumber(priTargets[i])
        if tag then
            hitList[#hitList + 1] = { tag = tag }
        end
    end
    local hitEnemy = nil
    local hitNoDyingEnemy = nil
    local checkList = list
    local filterList = list
    for i, hitData in ipairs(hitList) do
        if #filterList > 0 then
            checkList = filterList
            filterList = {}
        end
        for j, unit in ipairs(checkList) do
            if unit:is_alive() then
                if not hitEnemy then
                    hitEnemy = unit
                end
                -- if (not hitNoDyingEnemy) and (not unit:has_tag("dying")) then
                --     hitNoDyingEnemy = unit
                -- end
                if hitData.tag < y3.SurviveConst.PRIOITY_TYPE_6 then
                    -- print(unit:get_armor_type(), hitData.tag)
                    if unit:get_armor_type() == y3.SurviveConst.PRIOITY_ARMOR_MAP[hitData.tag] then
                        -- print(unit:get_armor_type(), y3.SurviveConst.PRIOITY_ARMOR_MAP[hitData.tag])
                        table.insert(filterList, unit)
                    end
                else
                    if not unit:has_buff_by_key(y3.SurviveConst.PRIOITY_BUFF_MAP[hitData.tag]) then
                        -- print("has buff", y3.SurviveConst.PRIOITY_BUFF_MAP[hitData.tag])
                        table.insert(filterList, unit)
                    end
                end
            end
        end
    end
    local retList = checkList
    if filterList and #filterList > 0 then
        retList = filterList
    end
    local isSet1 = false
    local isSet2 = false
    local finalList = {}
    local finalList2 = {}
    for i = 1, #retList do
        if retList[i]:is_alive() then
            -- if not retList[i]:has_tag("dying") then
            --     isSet1 = true
            --     table.insert(finalList, retList[i])
            -- end
            -- isSet2 = true
            if not hitEnemy then
                hitEnemy = retList[i]
            end
            table.insert(finalList2, retList[i])
        end
    end
    if #finalList > 0 then
        local retIndex = math.random(1, #finalList)
        return finalList[retIndex]
    end
    if #finalList2 > 0 then
        local retIndex = math.random(1, #finalList2)
        return finalList2[retIndex]
    end
    return hitEnemy
end

local DAMAGETYPE_RESTRAINT_MAP = {
    [y3.SurviveConst.DAMAGE_TYPE_1] = { { armor = y3.SurviveConst.ARMOR_TYPE_ZHONG, rate = 1 } },
    [y3.SurviveConst.DAMAGE_TYPE_2] = { { armor = y3.SurviveConst.ARMOR_TYPE_QING, rate = 1 } },
    [y3.SurviveConst.DAMAGE_TYPE_3] = { { armor = y3.SurviveConst.ARMOR_TYPE_ZZHONG, rate = 1 } },
    [y3.SurviveConst.DAMAGE_TYPE_4] = { { armor = y3.SurviveConst.ARMOR_TYPE_JIAQIANG, rate = 1 } },
    [y3.SurviveConst.DAMAGE_TYPE_5] = {
        { armor = y3.SurviveConst.ARMOR_TYPE_WU,       rate1 = -0.5, rate2 = 1, isfloat = true },
        { armor = y3.SurviveConst.ARMOR_TYPE_ZHONG,    rate1 = -0.5, rate2 = 1, isfloat = true },
        { armor = y3.SurviveConst.ARMOR_TYPE_QING,     rate1 = -0.5, rate2 = 1, isfloat = true },
        { armor = y3.SurviveConst.ARMOR_TYPE_ZZHONG,   rate1 = -0.5, rate2 = 1, isfloat = true },
        { armor = y3.SurviveConst.ARMOR_TYPE_JIAQIANG, rate1 = -0.5, rate2 = 1, isfloat = true }
    },
}

function SurviveHelper.calculateDamagePure(params)
    local sourceunitId = params[1]
    local targetunitId = params[2]
    local damageType   = params[3]
    local attackType   = params[4]
    local isText       = params[5]
    local value        = params[6]
    ---@diagnostic disable-next-line: undefined-field
    local damageValue  = type(value) == "userdata" and value:float() or value
    local ability      = params[7]
    -----------------------------------------------------------------
    local sourceUnit   = y3.unit.get_by_id(sourceunitId)
    assert(sourceUnit, "not found sourceUnit by id=" .. sourceunitId)
    local targetUnit = y3.unit.get_by_id(targetunitId)
    assert(targetUnit, "not found targetUnit by id=" .. targetunitId)
    -- local ability = nil
    -- if abilityId then
    --     ability = y3.ability.get_by_handle(abilityId)
    -- end
    local abilityKey = 0
    if ability then
        abilityKey = ability:api_get_ability_id()
    end

    -- if not SurviveHelper._spawnEnemy then
    --     SurviveHelper._spawnEnemy = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy")
    -- end
    -- local spawnEnemy = SurviveHelper._spawnEnemy
    -- local recordDamage = spawnEnemy:getRecordSkillDamage(sourceunitId, damageType, attackType, abilityKey, targetunitId)
    -- if recordDamage then
    --     return recordDamage.damageValue, recordDamage.jumpWord
    -- end

    local targetHuJia    = targetUnit:get_attr("物理防御")
    local sourceChuantou = sourceUnit:get_attr("物理穿透")
    -- print("targetHuJia", targetHuJia, "sourceChuantou", sourceChuantou)
    -- 防御减免率=（护甲-穿透）*0.05/（1+0.05*（护甲-穿透））
    --------------------------------------------------------
    local defenseRate    = 0
    if targetHuJia - sourceChuantou >= 0 then
        defenseRate = (targetHuJia - sourceChuantou) * 0.05 / (1 + 0.05 * (targetHuJia - sourceChuantou))
    else --防御减免率=1-0.99^(护甲-穿透)    结果为负值，实际效果为增伤
        local tempp = 0.99 ^ (targetHuJia - sourceChuantou)
        -- print("tempp", tempp)
        defenseRate = 1 - tempp
        -- print("defenseRate", defenseRate)
    end
    ---------------------------------------------------
    local targetArmorType = targetUnit:get_armor_type()
    local armorTypeRestraintRate = 0
    local kezhiList = DAMAGETYPE_RESTRAINT_MAP[damageType] or {}
    local jumpWord = false
    for i, kezhi in ipairs(kezhiList) do
        if kezhi.armor == targetArmorType then
            jumpWord = true
            if kezhi.isfloat then
                armorTypeRestraintRate = math.random(math.floor(kezhi.rate1 * 100), math.floor(kezhi.rate2 * 100)) / 100
            else
                armorTypeRestraintRate = kezhi.rate
            end
            break
        end
    end
    local labelRates = {}
    ----------------------------------------------------
    if damageType == y3.SurviveConst.DAMAGE_TYPE_1 then
        labelRates[#labelRates + 1] = { sourceUnit:get_attr("普通伤害加成") / 100, GameAPI.get_text_config('#30000001#lua56') }
    elseif damageType == y3.SurviveConst.DAMAGE_TYPE_2 then
        labelRates[#labelRates + 1] = { sourceUnit:get_attr("穿刺伤害加成") / 100, GameAPI.get_text_config('#30000001#lua59') }
    elseif damageType == y3.SurviveConst.DAMAGE_TYPE_3 then
        labelRates[#labelRates + 1] = { sourceUnit:get_attr("魔法伤害加成") / 100, GameAPI.get_text_config('#30000001#lua43') }
    elseif damageType == y3.SurviveConst.DAMAGE_TYPE_4 then
        labelRates[#labelRates + 1] = { sourceUnit:get_attr("攻城伤害加成") / 100, GameAPI.get_text_config('#30000001#lua53') }
    elseif damageType == y3.SurviveConst.DAMAGE_TYPE_5 then
        labelRates[#labelRates + 1] = { sourceUnit:get_attr("混乱伤害加成") / 100, GameAPI.get_text_config('#30000001#lua70') }
    end
    -----------------------------------------------------
    -------------------------------------------------------
    local labelRates2 = {}
    if targetUnit:has_buff_by_key(1000002) then -- 眩晕
        labelRates2[#labelRates2 + 1] = { sourceUnit:get_attr("眩晕目标伤害提升") / 100, GameAPI.get_text_config('#30000001#lua64') }
    end
    if targetUnit:has_buff_by_key(1000004) then -- 中毒
        labelRates2[#labelRates2 + 1] = { sourceUnit:get_attr("中毒目标伤害提升") / 100, GameAPI.get_text_config('#30000001#lua66') }
    end
    if attackType == y3.SurviveConst.LABEL_1 then
        labelRates2[#labelRates2 + 1] = { sourceUnit:get_attr("火焰伤害加成") / 100, GameAPI.get_text_config('#30000001#lua51') }
    elseif attackType == y3.SurviveConst.LABEL_2 then
        labelRates2[#labelRates2 + 1] = { sourceUnit:get_attr("尖刺伤害加成(%)") / 100, GameAPI.get_text_config('#30000001#lua57') }
    elseif attackType == y3.SurviveConst.LABEL_3 then
        labelRates2[#labelRates2 + 1] = { sourceUnit:get_attr("冰霜伤害加成") / 100, GameAPI.get_text_config('#30000001#lua65') }
    elseif attackType == y3.SurviveConst.LABEL_4 then
        labelRates2[#labelRates2 + 1] = { sourceUnit:get_attr("中毒伤害提升") / 100, GameAPI.get_text_config('#30000001#lua54') }
    elseif attackType == 5 then -- 特殊
        labelRates2[#labelRates2 + 1] = { sourceUnit:get_attr("尖刺伤害加成(%)") / 100, GameAPI.get_text_config('#30000001#lua57') }
        labelRates2[#labelRates2 + 1] = { sourceUnit:get_attr("火焰伤害加成") / 100, GameAPI.get_text_config('#30000001#lua51') }
    end
    local skillCfg = include("gameplay.config.config_skillData").get(tostring(abilityKey))
    if skillCfg then
        local atkTargets = string.split(skillCfg.atk_target, "|")
        assert(atkTargets, "not found atkTargets")
        for i = 1, #atkTargets do
            local tag = tonumber(atkTargets[i])
            if tag then
                if tag == 1 then     --单体
                    labelRates2[#labelRates2 + 1] = { sourceUnit:get_attr("单体伤害提升") / 100, GameAPI.get_text_config('#30000001#lua63') }
                elseif tag == 2 then --弹幕
                    labelRates2[#labelRates2 + 1] = { sourceUnit:get_attr("弹幕伤害提升") / 100, GameAPI.get_text_config('#30000001#lua47') }
                elseif tag == 3 then -- 溅射
                    labelRates2[#labelRates2 + 1] = { sourceUnit:get_attr("溅射武器伤害加成") / 100, GameAPI.get_text_config('#30000001#lua60') }
                elseif tag == 4 then -- 冲击波
                    labelRates2[#labelRates2 + 1] = { sourceUnit:get_attr("波浪武器伤害加成") / 100, GameAPI.get_text_config('#30000001#lua55') }
                elseif tag == 5 then -- 弹射
                    labelRates2[#labelRates2 + 1] = { sourceUnit:get_attr("弹射伤害提升") / 100, GameAPI.get_text_config('#30000001#lua41') }
                elseif tag == 6 then -- 自身周围
                    labelRates2[#labelRates2 + 1] = { sourceUnit:get_attr("环绕武器伤害加成(%)") / 100, GameAPI.get_text_config('#30000001#lua52') }
                elseif tag == 7 then -- 环绕
                end
            end
        end
        if skillCfg.range == y3.SurviveConst.RANGE_300 then
            labelRates2[#labelRates2 + 1] = { sourceUnit:get_attr("450武器提升") / 100, GameAPI.get_text_config('#30000001#lua62') }
        elseif skillCfg.range == y3.SurviveConst.RANGE_600 then
            labelRates2[#labelRates2 + 1] = { sourceUnit:get_attr("900武器提升") / 100, GameAPI.get_text_config('#30000001#lua44') }
        elseif skillCfg.range == y3.SurviveConst.RANGE_900 then
            labelRates2[#labelRates2 + 1] = { sourceUnit:get_attr("1350武器提升") / 100, GameAPI.get_text_config('#30000001#lua45') }
        elseif skillCfg.range == y3.SurviveConst.RANGE_1200 then
            labelRates2[#labelRates2 + 1] = { sourceUnit:get_attr("1800武器提升") / 100, GameAPI.get_text_config('#30000001#lua50') }
        end
        if skillCfg.class == 1 then
            labelRates2[#labelRates2 + 1] = { sourceUnit:get_attr("普通品质伤害提升(%)") / 100, GameAPI.get_text_config('#30000001#lua42') }
        elseif skillCfg.class == 2 then
            labelRates2[#labelRates2 + 1] = { sourceUnit:get_attr("不凡品质伤害提升(%)") / 100, GameAPI.get_text_config('#30000001#lua46') }
        elseif skillCfg.class == 3 then
            labelRates2[#labelRates2 + 1] = { sourceUnit:get_attr("稀有品质伤害提升(%)") / 100, GameAPI.get_text_config('#30000001#lua61') }
        elseif skillCfg.class == 4 then
            labelRates2[#labelRates2 + 1] = { sourceUnit:get_attr("史诗品质伤害提升(%)") / 100, GameAPI.get_text_config('#30000001#lua49') }
        end
    end
    ----------------------------------------------------------------
    local finalRate = sourceUnit:get_attr("伤害加成") / 100
    local fianlJianmian = targetUnit:get_attr("受伤减免") / 100
    local fixJianmian = targetUnit:get_attr("固定伤害减免")
    -- print("defenseRate", defenseRate, "armorTypeRestraintRate", armorTypeRestraintRate, "finalRate", finalRate,
    --     "fianlJianmian", fianlJianmian, "fixJianmian", fixJianmian)
    -- dump_all(labelRates)
    damageValue = damageValue * (1 - defenseRate) * (1 + armorTypeRestraintRate)
    for i = 1, #labelRates do
        damageValue = damageValue * (1 + labelRates[i][1])
    end

    local labelRate2Value = 0
    for i = 1, #labelRates2 do
        labelRate2Value = labelRate2Value + labelRates2[i][1]
    end
    damageValue = damageValue * (1 + labelRate2Value)

    damageValue = damageValue * (1 + finalRate - fianlJianmian)
    damageValue = damageValue - fixJianmian
    if damageValue < 0 then
        damageValue = 0
    end
    -- spawnEnemy:recordSkillDamage(sourceunitId, damageType, attackType, abilityKey, targetunitId, damageValue, jumpWord)
    return damageValue, jumpWord
end

local global_has_kv_any = GlobalAPI.api_has_kv_any
local get_kv_float = GameAPI.get_kv_pair_value_float
function SurviveHelper.calculateDamageReal(params)
    local sourceunitId = params[1]
    local targetunitId = params[2]
    local damageType   = params[3] or 0
    local attackType   = params[4] or 0
    local isText       = params[5]
    local value        = params[6]
    ---@diagnostic disable-next-line: undefined-field
    local damageValue  = type(value) == "userdata" and value:float() or value
    local ability      = params[7]
    local textType     = params[8]
    if not sourceunitId then
        log.warn("sourceunitId is nil")
        return damageValue
    end
    local sourceUnit = y3.unit.get_by_id(sourceunitId)
    if not sourceUnit then
        log.warn("not found sourceUnit by id=" .. sourceunitId)
        return damageValue
    end
    local targetUnit = y3.unit.get_by_id(targetunitId)
    -- if targetunitId == 0 then
    --     log.warn("targetunitId is 0")
    --     return damageValue
    -- end
    if not targetUnit then
        log.warn("not found targetUnit by id=" .. targetunitId)
        return damageValue
    end
    if not y3.class.isValid(targetUnit) then
        log.warn("targetUnit is not valid")
        return damageValue
    end
    -- local ability = nil
    -- if abilityId then
    --     ability = y3.ability.get_by_handle(abilityId)
    -- end
    local jumpWord = false
    damageValue, jumpWord = SurviveHelper.calculateDamagePure(params)

    local abilityKey = 0
    if ability then
        abilityKey = ability:api_get_ability_id()
        local check_key = "dmg_upgrade" .. abilityKey
        if global_has_kv_any(sourceUnit.handle, check_key) then
            local dmg_upgrade = get_kv_float(sourceUnit.handle, check_key):float()
            damageValue = damageValue * (1 + dmg_upgrade / 100)
        end
    end

    local criticalRate = sourceUnit:get_attr("暴击率")
    local ranRate = math.random(100, 10100) / 100 - 1
    if ranRate <= criticalRate then --产生暴击
        local criticalValue = sourceUnit:get_attr("暴击伤害") / 100
        damageValue = damageValue * criticalValue
    end
    if attackType == y3.SurviveConst.LABEL_2 then
        targetUnit:add_tag(y3.SurviveConst.STATE_TAG_JIANCHI)
    end
    if SurviveHelper.isShowDamageText == nil then
        SurviveHelper.isShowDamageText = y3.Sugar.gameCourse():isShowDamageText()
    end
    if SurviveHelper.isShowDamageText then
    else
        isText = false
    end
    if isText then
        if textType == "1855118333" then
            jumpWord = true
        end
        sourceUnit:damage({
            target = targetUnit,
            type = y3.const.DamageTypeMap['真实'],
            ---@diagnostic disable-next-line: missing-fields
            ability = {handle = ability},
            damage = damageValue,
            text_type = jumpWord and textType or "1264248026",
            attacktype = damageType
        })
    else
        sourceUnit:damage({
            target = targetUnit,
            type = y3.const.DamageTypeMap['真实'],
            ---@diagnostic disable-next-line: missing-fields
            ability = {handle = ability},
            damage = damageValue,
            attacktype = damageType
        })
    end
    return damageValue
end

function SurviveHelper.calculateDamage(params)
    return SurviveHelper.calculateDamageReal(params)
end

--- comment
--- @param unit Unit
--- @param tag string
--- @return boolean
function SurviveHelper.hasTagBuffInUnit(unit, tag)
    local buffs = unit:get_buffs()
    for i, buff in ipairs(buffs) do
        if buff:has_tag(tag) then
            return true
        end
    end
    return false
end

function SurviveHelper.getSkillCfgAndPriceByRandomPoolId(poolId)
    local ranCfg = include("gameplay.config.random_pool").get(poolId)
    if not ranCfg then
        return
    end
    if ranCfg.item_type == 1 or ranCfg.item_type == 2 then
        local skillCfg = include("gameplay.config.config_skillData").get(tostring(ranCfg.random_pool_item))
        -- assert(skillCfg, "not found skill by id=" .. ranCfg.random_pool_item)
        return skillCfg, ranCfg.price
    end
end

function SurviveHelper.leanSkill(params)
    local playerId = params[1]
    local skillId = params[2]
    -- print("leanSkill", playerId, skillId)
    local playerData = y3.userData:getPlayerData(playerId)
    local mainActor = playerData:getMainActor()
    if mainActor then
        mainActor:learnSkill(skillId)
    end
end

function SurviveHelper.createMonster(params)
    local spawnEnemy = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy")
    if spawnEnemy then
        local monsterId = params[1]
        local whoUnitId = params[2] or 0
        local point = params[3] or y3.point.create(0, 0, 0)
        return spawnEnemy:spawnEnemyFast(monsterId, whoUnitId, point)
    end
end

function SurviveHelper.checkShopPrice(playerId, type, price)
    local playerData = y3.userData:getPlayerData(playerId)
    local player = playerData:getPlayer()
    if type == y3.SurviveConst.RESOURCE_TYPE_GOLD then
        local gold = player:get_attr("gold")
        if gold >= price then
            gold = gold - price
            player:set("gold", gold)
            return true
        else
            return false
        end
    elseif type == y3.SurviveConst.RESOURCE_TYPE_DIAMOND then
        local gold = player:get_attr("diamond")
        if gold >= price then
            gold = gold - price
            player:set("diamond", gold)
            return true
        else
            return false
        end
    end
    return false
end

function SurviveHelper.dropItem(playerId, itemId)
    -- print(playerId, itemId)
    -- print(type(itemId))
    local playerData = y3.userData:getPlayerData(playerId)
    local mainActor = playerData:getMainActor()
    local mainUnit = mainActor:getUnit()
    local cfg = include("gameplay.config.item").get(itemId)
    assert(cfg, "can not find cfg in item by id=" .. itemId)
    local item = y3.item.create_item(mainUnit:get_point():move(math.random(200, 300), math.random(0, 300), 0),
        cfg.editor_item_id, playerData:getPlayer())
    item:set_name(cfg.item_name)
    item:kv_save("cfgId", cfg.id)
    if cfg.item_prefer_give_to == 1 then
        mainUnit:shift_item(item, y3.const.ShiftSlotType['物品栏'])
    else
        local soulActor = mainActor:getSoulHeroActor()
        soulActor:getUnit():shift_item(item, y3.const.ShiftSlotType['物品栏'])
    end
    -- print("dropItem " .. itemId)
    if cfg then
        local color = y3.ColorConst.QUALITY_COLOR_MAP[cfg.item_quality + 1] or y3.ColorConst.QUALITY_COLOR_MAP[1]
        y3.Sugar.localNotice(playerId, 16,
            { item_name = "#" .. color .. cfg.item_name .. "#ffffff" })
    end
    if cfg.item_use_when_get == 1 then
        -- print("立即使用")
        mainUnit:use_item(item)
    end
    y3.SignalMgr:dispatch(y3.SignalConst.SIGNAL_UPDATE_ITEM, playerData:getPlayer(), itemId, 1)
end

function SurviveHelper.addItemTo(playerId, itemId, slotType)
    local playerData = y3.userData:getPlayerData(playerId)
    local mainActor = playerData:getMainActor()
    local mainUnit = mainActor:getUnit()
    local cfg = include("gameplay.config.item").get(itemId)
    assert(cfg, "can not find cfg in item by id=" .. itemId)
    local item = y3.item.create_item(mainUnit:get_point(), cfg.editor_item_id, playerData:getPlayer())
    item:set_name(cfg.item_name)
    item:kv_save("cfgId", cfg.id)
    mainUnit:shift_item(item, slotType)
    return item
end

function SurviveHelper.dropItemInScene(playerId, itemId, point)
    local playerData = y3.userData:getPlayerData(playerId)
    local cfg = include("gameplay.config.item").get(itemId)
    assert(cfg, "can not find cfg in item by id=" .. itemId)
    local item = y3.item.create_item(point, cfg.editor_item_id, playerData:getPlayer())
    item:set_name(cfg.item_name)
    item:kv_save("cfgId", cfg.id)
    -- print(point)
end

function SurviveHelper.checkCanDropItem(playerId, itemId)
    local playerData = y3.userData:getPlayerData(playerId)
    local mainActor = playerData:getMainActor()
    local mainUnit = mainActor:getUnit()
    local cfg = include("gameplay.config.item").get(itemId)
    assert(cfg, "can not find cfg in item by id=" .. itemId)
    local capacity = mainUnit:get_slot_capacity(y3.const.SlotType['BAR'])
    if capacity > 0 then
        return true
    end
    local num = mainUnit:get_item_type_number_of_unit(cfg.editor_item_id)
    if num == 0 then
        return false
    end
    local maximum_stacking = math.floor(y3.object.item[cfg.editor_item_id].data.maximum_stacking)
    local yuNum = num % maximum_stacking
    return yuNum > 0
end

function SurviveHelper.randItemUse(playerId, randomCfg)
    if randomCfg.item_type == 1 or randomCfg.item_type == 2 then
        SurviveHelper.leanSkill({ playerId, randomCfg.random_pool_item })
    else
        SurviveHelper.dropItem(playerId, randomCfg.random_pool_item)
    end
end

function SurviveHelper.learnRandomSkill(playerId, poolStr)
    local pools = string.split(poolStr, "|")
    local randList = {}
    for i, poolId in ipairs(pools) do
        local params = string.split(poolId, "#")
        local id = tonumber(params[1])
        local weight = tonumber(params[2])
        local data = {}
        data.id = id
        data.weight = weight
        table.insert(randList, data)
    end
    local randData = SurviveHelper.getRandomDataByWeightList(randList)
    local resSkill = y3.gameApp:getLevel():getLogic("SurviveRefreshSkill")
    local ranItem = resSkill:getRandomItemByPoolIdMini(randData.id)
    if ranItem then
        SurviveHelper.randItemUse(playerId, ranItem)
    end
end

function SurviveHelper.getSkillDmgStr(playerId, cfg, damageType)
    local playerData = y3.userData:getPlayerData(playerId)
    local mainActor = playerData:getMainActor()
    if mainActor then
        local attrId = y3.SurviveConst.WEAPON_DMG_ATTR_MAP[damageType] or 0
        if attrId > 0 then
            local allValue = mainActor:getAttrPureValue(3)
            local attrValue = mainActor:getAttrPureValue(attrId)
            return "#ffffff" ..
                math.floor(cfg.dmg) .. "#0fd121(+" .. math.ceil((allValue + attrValue) * cfg.dmg_modify) .. ")"
        else
            return "#ffffff" .. math.floor(cfg.dmg)
        end
    end
    return "#ffffff" .. math.floor(cfg.dmg)
end

function SurviveHelper.getResNum(playerId, resId)
    local cfg = include("gameplay.config.resource_config").get(resId)
    if cfg then
        local playerData = y3.userData:getPlayerData(playerId)
        local player = playerData:getPlayer()
        return player:get_attr(cfg.resource_editor_name)
    end
    return 0
end

function SurviveHelper.getResIcon(resid)
    local cfg = include("gameplay.config.resource_config").get(resid)
    if cfg then
        return cfg.resource_img
    end
    return 0
end

return SurviveHelper
