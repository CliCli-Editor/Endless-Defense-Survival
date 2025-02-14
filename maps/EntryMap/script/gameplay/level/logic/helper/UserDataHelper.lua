local UserDataHelper = {}

function UserDataHelper.getResNum(playerId, type)
    local playerData = y3.userData:getPlayerData(playerId)
    local player = playerData:getPlayer()
    if type == y3.SurviveConst.RESOURCE_TYPE_GOLD then
        return player:get_attr("gold")
    elseif type == y3.SurviveConst.RESOURCE_TYPE_DIAMOND then
        return player:get_attr("diamond")
    end
    return 0
end

function UserDataHelper.useItem(playerId, itemId)
    local cfg = include("gameplay.config.item").get(itemId)
    if cfg then
        if cfg.item_use_type == 7 then
            local args = string.split(cfg.item_use_args, "|")
            assert(args, "")
            local randList = {}
            for i, arg in ipairs(args) do
                local param = string.split(arg, "#")
                assert(param, "")
                local data  = {}
                data.id     = tonumber(param[1])
                data.weight = tonumber(param[2])
                table.insert(randList, data)
            end
            local SurviveHelper = include("gameplay.level.logic.helper.SurviveHelper")
            local randata1 = SurviveHelper.getRandomDataByWeightList(randList)
            local surveveSkill = y3.gameApp:getLevel():getLogic("SurviveRefreshSkill")
            local randomCfg = surveveSkill:getRandomItemByPoolId(randata1.id)
            -- local randomCfg = include("gameplay.config.random_pool").get(randata1.id)
            -- assert(randomCfg, "random_pool can found by id=" .. randata1.id)
            if randomCfg.item_type == 1 or randomCfg.item_type == 2 then
                SurviveHelper.leanSkill({ playerId, randomCfg.random_pool_item })
                local getCfg = include("gameplay.config.config_skillData").get(tostring(randomCfg.random_pool_item))
                if getCfg then
                    local color = y3.ColorConst.QUALITY_COLOR_MAP[cfg.item_quality + 1] or
                        y3.ColorConst.QUALITY_COLOR_MAP[1]
                    local color2 = y3.ColorConst.QUALITY_COLOR_MAP[getCfg.class + 1] or
                        y3.ColorConst.QUALITY_COLOR_MAP[1]
                    y3.Sugar.localNotice(playerId, 52,
                        {
                            item_name = "#" .. color .. cfg.item_name .. "#ffffff",
                            resoult = "#" ..
                                color2 .. getCfg.name .. "#ffffff",
                            num = 1
                        })
                end
            else
                SurviveHelper.dropItem(playerId, randomCfg.random_pool_item)
                local getCfg = include("gameplay.config.item").get(randomCfg.random_pool_item)
                if getCfg then
                    local color = y3.ColorConst.QUALITY_COLOR_MAP[cfg.item_quality + 1] or
                        y3.ColorConst.QUALITY_COLOR_MAP[1]
                    local color2 = y3.ColorConst.QUALITY_COLOR_MAP[getCfg.item_quality + 1] or
                        y3.ColorConst.QUALITY_COLOR_MAP[1]
                    y3.Sugar.localNotice(playerId, 52,
                        {
                            item_name = "#" .. color .. cfg.item_name .. "#ffffff",
                            resoult = "#" ..
                                color2 .. cfg.item_name .. "#ffffff",
                            num = 1
                        })
                end
            end
        elseif cfg.item_use_type == 8 then
            local args = string.split(cfg.item_use_args, "|")
            -- print("args:", cfg.item_use_args)
            assert(args, "")
            local surveveSkill = y3.gameApp:getLevel():getLogic("SurviveRefreshSkill")
            local result = {}
            for i, arg in ipairs(args) do
                local poolId = tonumber(arg)
                local randomData = surveveSkill:_signalCardRefresh(poolId, playerId)
                table.insert(result, randomData)
            end
            local spawnEnemy = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy")
            spawnEnemy:getAbysChallenge():insertChallengeRecordData(playerId, result)
        end
    end
end

function UserDataHelper.getItemDescs(itemCfg, item)
    local args = string.split(itemCfg.item_use_args, "|")
    assert(args, "")
    local itemMap = {}
    for i, arg in ipairs(args) do
        local params = string.split(arg, "#")
        itemMap[i] = params
    end
    local decs = itemCfg.item_tips_desc
    decs = string.gsub(decs, "{item_name}", itemCfg.item_name)
    if itemCfg.item_use_type == 1 then -- {item_name}使用后可获得技能{skill_name}
        local params = itemMap[1]
        local skillId = params[1]
        local skillCfg = include("gameplay.config.config_skillData").get(skillId)
        assert(skillCfg, "skillCfg is nil")
        decs = string.gsub(decs, "{skill_name}", skillCfg.name)
    elseif itemCfg.item_use_type == 2 then -- {item_name}获得后会被立即使用，使用后获得{coin_name}*{coin_num}
        local params = itemMap[1]
        local resId = tonumber(params[1])
        decs = string.gsub(decs, "{coin_name}", y3.SurviveConst.RESOURCE_TYPE_NAME_MAP[resId])
        decs = string.gsub(decs, "{coin_num}", params[2])
    elseif itemCfg.item_use_type == 3 then -- {item_name}使用后可开启1次{challenge_type_name}，已挑战:{challenge_type_count}
        local params = itemMap[1]
        local challengeType = tonumber(params[1])
        local challengeName = ""
        local spawnEnemy = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy")
        local challengeCnt = 0
        local GlobalConfigHelper = require "gameplay.level.logic.helper.GlobalConfigHelper"
        local nameMap = GlobalConfigHelper.getChallengeNameMap()
        if challengeType == y3.SurviveConst.STAGE_CHALLENGE_GOLD then
            challengeName = nameMap[y3.SurviveConst.STAGE_CHALLENGE_GOLD] or "" --y3.langCfg.get(17).str_content --"金币挑战"
            challengeCnt = spawnEnemy:getGoldChallenge():getChallengeIndex(y3.gameApp:getMyPlayerId())
        elseif challengeType == y3.SurviveConst.STAGE_CHALLENGE_DIAMOND then
            challengeName = nameMap[y3.SurviveConst.STAGE_CHALLENGE_DIAMOND] or
                "" --y3.langCfg.get(18).str_content --"钻石挑战"
            challengeCnt = spawnEnemy:getDiamondChallenge():getChallengeIndex(y3.gameApp:getMyPlayerId())
        elseif challengeType == y3.SurviveConst.STAGE_CHALLENGE_ITEM then
            challengeName = nameMap[y3.SurviveConst.STAGE_CHALLENGE_ITEM] or "" --y3.langCfg.get(19).str_content --"道具挑战"
        end
        decs = string.gsub(decs, "{challenge_type_name}", challengeName)
        decs = string.gsub(decs, "{challenge_type_count}", challengeCnt)
    elseif itemCfg.item_use_type == 4 then --  {item_name}使用后增加{prop_name}{prop_num}，持续时间{sec}秒
        local params = itemMap[1]
        local propId = tonumber(params[1]) or 1
        local propCfg = include("gameplay.config.attr").get(propId)
        assert(propCfg, "propCfg is nil by id=" .. propId)
        decs = string.gsub(decs, "{prop_name}", propCfg.attr_name)
        decs = string.gsub(decs, "{prop_num}", params and params[2] or "")
        decs = string.gsub(decs, "{sec}", params and params[3] or "")
    elseif itemCfg.item_use_type == 5 then -- {item_name}使用后增加{prop_name}{prop_num}
        local params = itemMap[1]
        local propId1 = tonumber(params[1]) or 1
        local propCfg1 = include("gameplay.config.attr").get(propId1)
        assert(propCfg1, "propCfg1 is nil by id=" .. propId1)
        decs = string.gsub(decs, "{prop_name}", propCfg1.attr_name)
        decs = string.gsub(decs, "{prop_num}", params[2])
    elseif itemCfg.item_use_type == 6 then -- {item_name}使用后增加{prop_name1}{prop_num1}，减少{prop_name2}{prop_num2}
        local params = itemMap[1]
        local propId1 = tonumber(params[1]) or 1
        local propCfg1 = include("gameplay.config.attr").get(propId1)
        assert(propCfg1, "propCfg1 is nil by id=" .. propId1)
        decs = string.gsub(decs, "{prop_name1}", propCfg1.attr_name)
        decs = string.gsub(decs, "{prop_num1}", params[2])

        params = itemMap[2]
        local propId2 = tonumber(params[1]) or 1
        local propCfg2 = include("gameplay.config.attr").get(propId2)
        assert(propCfg2, "propCfg2 is nil by id=" .. propId2)
        decs = string.gsub(decs, "{prop_name2}", propCfg2.attr_name)
        decs = string.gsub(decs, "{prop_num2}", params[2])
    elseif itemCfg.item_use_type == 7 then -- {item_name}使用后可进行一次3选1
    elseif itemCfg.item_use_type == 8 then --{item_name}使用后可进行一次3选1
    elseif itemCfg.item_use_type == 9 then -- {item_name}使用后{coin_name}随机获得{min}至{max}
        local params = itemMap[1]
        local resId = tonumber(params[1])
        decs = string.gsub(decs, "{coin_name}", y3.SurviveConst.RESOURCE_TYPE_NAME_MAP[resId])
        decs = string.gsub(decs, "{min}", params[2])
        decs = string.gsub(decs, "{max}", params[3])
    elseif itemCfg.item_use_type == 10 then --{item_name}使用后{prop_name}随机获得{min}至{max}
        local params = itemMap[1]
        local propId = tonumber(params[1]) or 1
        local propCfg = include("gameplay.config.attr").get(propId)
        assert(propCfg, "propCfg is nil by id=" .. propId)
        decs = string.gsub(decs, "{prop_name}", propCfg.attr_name)
        decs = string.gsub(decs, "{min}", params[2])
        decs = string.gsub(decs, "{max}", params[3])
    elseif itemCfg.item_use_type == 11 then --{item_name}使用后释放技能{skill_name}
        local params = itemMap[1]
        local skillId = params[1]
        local skillCfg = include("gameplay.config.config_skillData").get(skillId)
        assert(skillCfg, "skillCfg is nil")
        decs = string.gsub(decs, "{skill_name}", skillCfg.name)
    elseif itemCfg.item_use_type == 13 then
        local params = itemMap[1]
        local who = tonumber(params[1])
        local skillId = params[2]
        local skillCfg = include("gameplay.config.config_skillData").get(skillId)
        assert(skillCfg, "skillCfg is nil")
        local whoName = ""
        if who == 1 then
            whoName = y3.langCfg.get(60).str_content
        elseif who == 2 then
            whoName = y3.langCfg.get(61).str_content
        end
        local skillDesc = y3.userDataHelper.getSkillDesc(skillCfg)
        local item_loaded = ""
        if item then
            if item:kv_has("item_isused") then
                item_loaded = item:kv_load("item_isused", "string")
            end
        end
        decs = string.gsub(decs, "{who}", whoName)
        decs = string.gsub(decs, "{skillname}", skillCfg.name)
        decs = string.gsub(decs, "{skill_desc}", function()
            local value = string.gsub(skillDesc, "/%", "")
            return value
        end)
        decs = string.gsub(decs, "{state}", item_loaded)
    end
    return decs
end

function UserDataHelper.dropRes(playerId, resId, num)
    local resCfg = include("gameplay.config.resource_config").get(resId)
    assert(resCfg, "resCfg is nil by id=" .. resId)
    local playerData = y3.userData:getPlayerData(playerId)
    local player = playerData:getPlayer()
    if resCfg.resource_editor_name ~= "" then
        local curNum = player:get_attr(resCfg.resource_editor_name)
        player:set(resCfg.resource_editor_name, curNum + num)
    end
end

function UserDataHelper.getResName(resId)
    local resCfg = include("gameplay.config.resource_config").get(resId)
    assert(resCfg, "resCfg is nil by id=" .. resId)
    return resCfg.resource_name
end

function UserDataHelper.dropRandomItem(playerId, itemCfg)
    local SurviveHelper = include "gameplay.level.logic.helper.SurviveHelper"
    if itemCfg.item_type == 1 or itemCfg.item_type == 2 then
        SurviveHelper.leanSkill({ playerId, itemCfg.random_pool_item })
    elseif itemCfg.item_type == 3 then
        SurviveHelper.dropItem(playerId, itemCfg.random_pool_item)
    end
end

function UserDataHelper.getAttrListByPack(attrPackId)
    local cfg = include("gameplay.config.attr_pack").get(attrPackId)
    if not cfg then
        return {}
    end
    local attrs = string.split(cfg.attr, "|")
    assert(attrs)
    local result = {}
    for _, attr in ipairs(attrs) do
        local params = string.split(attr, "#")
        assert(params)
        local attrId = tonumber(params[1])
        local attrCfg = include("gameplay.config.attr").get(attrId)
        assert(attrCfg)
        local attrValue = tonumber(params[2])
        table.insert(result, {
            id = attrCfg.id,
            name = attrCfg.attr_name,
            value = attrValue,
            showType = attrCfg
                .show_type
        })
    end
    return result
end

function UserDataHelper.getStageReward(cfg)
    local show_rewards = string.split(cfg.show_reward, "|")
    assert(show_rewards, "")
    local result = {}
    for i, reward in ipairs(show_rewards) do
        local params = string.split(reward, "#")
        assert(params, "")
        local type = tonumber(params[1])
        local value = tonumber(params[2])
        local size = tonumber(params[3])
        if type and value and size then
            local data = {}
            data.type = type
            data.value = value
            data.size = size
            data.tag = tonumber(params[4])
            table.insert(result, data)
        end
    end
    return result
end

function UserDataHelper.getAttrConcatStr(attrPackId)
    local attrList = UserDataHelper.getAttrListByPack(attrPackId)
    local result = ""
    for i, attr in ipairs(attrList) do
        if i > 1 then
            result = result .. "\n"
        end
        if attr.showType == 1 then
            result = result .. attr.name .. "+" .. attr.value
        else
            result = result .. attr.name .. "+" .. attr.value .. "%"
        end
    end
    return result
end

function UserDataHelper.towerIsUnLock(playerId, cfg)
    local gameCourse = y3.gameApp:getLevel():getLogic("SurviveGameCourse")
    return gameCourse:stageTowerIsUnlock(playerId, cfg.id)
end

function UserDataHelper.getTreasureDesc(treasureId)
    local cfg = include("gameplay.config.treasure").get(treasureId)
    if cfg then
        local desc = GameAPI.get_text_config('#1966779588#lua')
        local attr_pack = cfg.attr_pack
        local attrDesc = UserDataHelper.getAttrConcatStr(attr_pack)
        desc = desc .. attrDesc .. "\n"
        desc = desc .. GameAPI.get_text_config('#-1106332483#lua')
        desc = desc .. "" .. cfg.max_level .. GameAPI.get_text_config('#30000001#lua09')
        desc = desc .. GameAPI.get_text_config('#-547725355#lua')
        desc = desc .. "" .. cfg.unlock_desc .. "\n"
        return desc
    end
    return ""
end

function UserDataHelper.getCollectStarDesc(cfg)
    -- ①②③④
    local params = string.split(cfg.desc, "|")
    assert(params, "")
    local desc = ""
    desc = desc .. "①" .. params[1] .. "\n"
    desc = desc .. "②" .. params[2] .. "\n"
    desc = desc .. "③" .. params[3] .. "\n"
    desc = desc .. "④" .. params[4] .. "\n\n"

    desc = desc .. GameAPI.get_text_config('#-1905700716#lua')
    desc = desc .. GameAPI.get_text_config('#215736538#lua')
    desc = desc .. GameAPI.get_text_config('#-914596902#lua')
    desc = desc .. GameAPI.get_text_config('#-875158146#lua')
    return desc
end

function UserDataHelper.getValue(value)
    if value == "" then
        return value
    end
    if tonumber(value) then
        return tonumber(value)
    else
        -- print("SurviveGameSkillTip:getValue", value)
        local attrPack = include("gameplay.config.attr_pack").get(value)
        if not attrPack then
            return value
        end
        local attrs = string.split(attrPack.attr, "|")
        local params = string.split(attrs[1], "#")
        return tonumber(params[2])
    end
end

function UserDataHelper.getSkillDesc(skillCfg)
    if not skillCfg then
        return ""
    end
    if skillCfg.ability_type ~= "" then
        local types = string.split(skillCfg.ability_type, "|")
        local descrs = string.split(skillCfg.descr, "|")
        local values = string.split(skillCfg.value, "|")
        assert(types, "")
        assert(descrs, "")
        assert(values, "")
        local retDesc = ""
        for i = 1, 2 do
            if types[i] then
                local params = string.split(types[i], "#")
                assert(params, "")
                local desc = descrs[i] or ""
                desc = string.gsub(desc, "({%a+[0-9]})", function(s)
                    local lenStr = string.len(s)
                    if string.find(s, "pvalue") then
                        local e = UserDataHelper.getValue(values[tonumber(string.sub(s, 8, 8))])
                        return string.format("%.1f", (e * 100)) .. "%"
                    elseif string.find(s, "value") then
                        local e = UserDataHelper.getValue(values[tonumber(string.sub(s, 7, 7))])
                        return e .. ""
                    end
                    return s
                end)
                retDesc = retDesc .. desc .. "\n"
            end
        end
        return retDesc
    else
        return skillCfg.descr
    end
end

function UserDataHelper.getSaveDataEncryptConcat(...)
    local args = { ... }
    local str = ""
    for i, arg in ipairs(args) do
        str = str .. tostring(arg) .. "|"
    end
    local ret = y3.gameApp:encryptString(str)
    return ret
end

function UserDataHelper.getSaveDataDecryptConcat(encryptStr)
    if type(encryptStr) ~= "string" then
        return ""
    end
    if encryptStr == "" then
        return ""
    end
    local str = y3.gameApp:decryptString(encryptStr)
    local saveData = string.split(str, "|")
    return saveData
end

function UserDataHelper.getSaveDataEncryptConcatPro(data)
    local str = ""
    for key, value in pairs(data) do
        str = str .. tostring(key) .. "#" .. tostring(value) .. "#" .. type(value) .. "|"
    end
    local ret = y3.gameApp:encryptString(str)
    return ret
end

function UserDataHelper.getSaveDataDecryptConcatPro(encryptStr)
    if type(encryptStr) ~= "string" then
        return {}
    end
    if encryptStr == "" then
        return {}
    end
    local str = y3.gameApp:decryptString(encryptStr)
    local valueList = string.split(str, "|")
    if not valueList then
        return {}
    end
    local retData = {}
    for i, value in ipairs(valueList) do
        local key, value, valueType = string.match(value, "([^#]+)#([^#]+)#([^#]+)")
        if valueType == "number" then
            value = tonumber(value)
        elseif valueType == "boolean" then
            value = value == "true"
        elseif valueType == "string" then
            value = tostring(value)
        end
        if key then
            retData[key] = value
        end
    end
    return retData
end

function UserDataHelper.dropSaveItem2(playerId, typeItem, valueItem, sizeItem)
    if typeItem == y3.SurviveConst.DROP_TYPE_SAVE_ITEM then
        local cfg = include("gameplay.config.save_item").get(valueItem)
        -- print("UserDataHelper.dropSaveItem", cfg.item_type, valueItem, sizeItem)
        if cfg.item_type == 2 then -- 战令经验道具
            -- print("掉落战灵道具")
            local gameBattlePass = y3.gameApp:getLevel():getLogic("SurviveGameBattlePass")
            gameBattlePass:addExp(y3.player(playerId), tonumber(cfg.item_args), sizeItem)
        else
            local saveItemLogic = y3.gameApp:getLevel():getLogic("SurviveGameSaveItem")
            saveItemLogic:dropSaveItem(playerId, valueItem, sizeItem)
        end
    elseif typeItem == y3.SurviveConst.DROP_TYPE_TREASURE then
        local treasureDropLogic = y3.gameApp:getLevel():getLogic("SurviveGameTreasureDrop")
        for i = 1, sizeItem do
            treasureDropLogic:dropPureTreasure(playerId, valueItem)
        end
    elseif typeItem == y3.SurviveConst.DROP_TYPE_TITLE then
        local stageTitleLogic = y3.gameApp:getLevel():getLogic("SurviveGameAchievementTitle")
        stageTitleLogic:dropTitle(playerId, valueItem)
    elseif typeItem == y3.SurviveConst.DROP_TYPE_STAGE_TOWER then
        local gameCourse = y3.gameApp:getLevel():getLogic("SurviveGameCourse")
        gameCourse:dropStageTower(playerId, valueItem)
    elseif typeItem == y3.SurviveConst.DROP_TYPE_HERO_SKIN then
        local gameCourse = y3.gameApp:getLevel():getLogic("SurviveGameCourse")
        gameCourse:dropHeroSkin(playerId, valueItem)
    elseif typeItem == y3.SurviveConst.DROP_TYPE_ATTR_PACK then
        log.error("属性包不走存档，通过解锁统计")
    elseif typeItem == y3.SurviveConst.DROP_TYPE_TOWER_SKIN then
        local gameCourse = y3.gameApp:getLevel():getLogic("SurviveGameCourse")
        gameCourse:dropTowerSkin(playerId, valueItem)
    end
end

function UserDataHelper.dropSaveItem(playerId, rewardStr, addRatio)
    if rewardStr == "" then
        return
    end
    local params = string.split(rewardStr, "#")
    if not params then
        return
    end
    local typeItem = tonumber(params[1])
    local valueItem = tonumber(params[2])
    local sizeItem = tonumber(params[3])
    if addRatio then
        sizeItem = math.floor(sizeItem + sizeItem * addRatio)
    end
    if typeItem == y3.SurviveConst.DROP_TYPE_SAVE_ITEM then
        local cfg = include("gameplay.config.save_item").get(valueItem)
        -- print("UserDataHelper.dropSaveItem", cfg.item_type, valueItem, sizeItem)
        if cfg.item_type == 2 then -- 战令经验道具
            -- print("掉落战灵道具")
            local gameBattlePass = y3.gameApp:getLevel():getLogic("SurviveGameBattlePass")
            gameBattlePass:addExp(y3.player(playerId), tonumber(cfg.item_args), sizeItem)
        else
            local saveItemLogic = y3.gameApp:getLevel():getLogic("SurviveGameSaveItem")
            saveItemLogic:dropSaveItem(playerId, valueItem, sizeItem)
        end
    elseif typeItem == y3.SurviveConst.DROP_TYPE_TREASURE then
        local treasureDropLogic = y3.gameApp:getLevel():getLogic("SurviveGameTreasureDrop")
        for i = 1, sizeItem do
            treasureDropLogic:dropPureTreasure(playerId, valueItem)
        end
    elseif typeItem == y3.SurviveConst.DROP_TYPE_TITLE then
        local stageTitleLogic = y3.gameApp:getLevel():getLogic("SurviveGameAchievementTitle")
        stageTitleLogic:dropTitle(playerId, valueItem)
    elseif typeItem == y3.SurviveConst.DROP_TYPE_STAGE_TOWER then
        local gameCourse = y3.gameApp:getLevel():getLogic("SurviveGameCourse")
        gameCourse:dropStageTower(playerId, valueItem)
    elseif typeItem == y3.SurviveConst.DROP_TYPE_HERO_SKIN then
        local gameCourse = y3.gameApp:getLevel():getLogic("SurviveGameCourse")
        gameCourse:dropHeroSkin(playerId, valueItem)
    elseif typeItem == y3.SurviveConst.DROP_TYPE_ATTR_PACK then
        log.error("属性包不走存档，通过解锁统计")
    elseif typeItem == y3.SurviveConst.DROP_TYPE_TOWER_SKIN then
        local gameCourse = y3.gameApp:getLevel():getLogic("SurviveGameCourse")
        gameCourse:dropTowerSkin(playerId, valueItem)
    end
end

function UserDataHelper.getSaveItemNum(playerId, rewardStr)
    if rewardStr == "" then
        return 0
    end
    local params = string.split(rewardStr, "#")
    if not params then
        return 0
    end
    local typeItem = tonumber(params[1])
    local valueItem = tonumber(params[2])
    if typeItem == y3.SurviveConst.DROP_TYPE_SAVE_ITEM then
        local saveItemLogic = y3.gameApp:getLevel():getLogic("SurviveGameSaveItem")
        return saveItemLogic:getSaveItemNum(playerId, valueItem)
    elseif typeItem == y3.SurviveConst.DROP_TYPE_TREASURE then
        return 0
    end
end

function UserDataHelper.getAchievementBigDesc(playerId)
    local GlobalConfigHelper = include("gameplay.level.logic.helper.GlobalConfigHelper")
    local achievement = y3.gameApp:getLevel():getLogic("SurviveGameAchievement")
    local totalPoint = achievement:getTotalAchievementPoint(playerId)
    local pointParams = string.split(GlobalConfigHelper.get(36), "/")
    assert(pointParams, "")
    local titleDesc = GameAPI.get_text_config('#30000001#lua14') .. totalPoint
    local desc = GameAPI.get_text_config('#614378821#lua')
    desc = desc .. GameAPI.get_text_config('#-1820468351#lua') .. pointParams[1] .. GameAPI.get_text_config('#30000001#lua10')
    desc = desc .. GameAPI.get_text_config('#-1048723304#lua') .. pointParams[2] .. GameAPI.get_text_config('#30000001#lua10')
    desc = desc .. GameAPI.get_text_config('#1897601487#lua') .. pointParams[3] .. GameAPI.get_text_config('#30000001#lua10')
    desc = desc .. GameAPI.get_text_config('#540491319#lua') .. pointParams[4] .. GameAPI.get_text_config('#30000001#lua10')
    return titleDesc, desc
end

function UserDataHelper.getAchievementPassDesc(playerId, cfg)
    local achievement = y3.gameApp:getLevel():getLogic("SurviveGameAchievement")
    local isUnlock = achievement:achievementIsUnLock(playerId, cfg)
    local titleText = isUnlock and cfg.name .. GameAPI.get_text_config('#30000001#lua11') or cfg.name .. GameAPI.get_text_config('#30000001#lua12')
    local desc = GameAPI.get_text_config('#844377056#lua')
    desc = desc .. cfg.desc .. "\n\n"
    desc = desc .. GameAPI.get_text_config('#1734328062#lua')
    local rewardItems = string.split(cfg.reward_item, "#")
    assert(rewardItems, "")
    local rewardType = tonumber(rewardItems[1]) or 0
    local rewardValue = tonumber(rewardItems[2]) or 0
    local rewardSize = tonumber(rewardItems[3]) or 0
    local typeCfg = include("gameplay.config.itemtype_manage").get(rewardType)
    if typeCfg then
        local cfgTemplate = include("gameplay.config." .. typeCfg.type_table)
        if cfgTemplate then
            local temCfg = cfgTemplate.get(rewardValue)
            if temCfg then
                desc = desc .. temCfg.item_name .. "+" .. rewardSize .. "\n"
            end
        end
    end
    local reward_attr_packs = string.split(cfg.reward_attr_pack, "|")
    assert(reward_attr_packs, "")
    -- dump_all(reward_attr_packs)
    for _, reward_attr_pack in ipairs(reward_attr_packs) do
        -- print(reward_attr_pack)
        local attrList = UserDataHelper.getAttrListByPack(reward_attr_pack)
        -- dump_all(attrList)
        for i, attr in ipairs(attrList) do
            if attr.showType == 1 then
                desc = desc .. attr.name .. "+" .. attr.value .. "\n"
            else
                desc = desc .. attr.name .. "+" .. attr.value .. "%\n"
            end
        end
    end
    return titleText, desc
end

function UserDataHelper.getWeaponEffectText(weapon_effect)
    if weapon_effect == "" then
        return ""
    end
    local effects = string.split(weapon_effect, "#")
    assert(effects, "")
    local effectId    = tonumber(effects[1])
    local effectValue = tonumber(effects[2])
    if effectId == y3.SurviveConst.WEAPON_SPEED then
        return GameAPI.get_text_config('#30000001#lua13') .. effectValue .. "%"
    else
        return GameAPI.get_text_config('#30000001#lua13') .. effectValue
    end
end

function UserDataHelper.getAttrPackConcatStr(packId)
    if packId == "" then
        return
    end
    local attrList = UserDataHelper.getAttrListByPack(packId)
    local result = ""
    for i, attr in ipairs(attrList) do
        if i > 1 then
            result = result .. "，"
        end
        if attr.showType == 1 then
            result = result .. attr.name .. "+" .. attr.value
        else
            result = result .. attr.name .. "+" .. attr.value .. "%"
        end
    end
end

function UserDataHelper.getHaveItemInGame(playerId, str)
    local params = string.split(str, "#")
    assert(params, "")
    local typeInGame = tonumber(params[1])
    local valueInGame = tonumber(params[2])
    -- print("UserDataHelper.getHaveItemInGame", typeInGame, valueInGame)
    if typeInGame == 1 then
        local resCfg = include("gameplay.config.resource_config").get(valueInGame)
        assert(resCfg, "can not found cfg in resource_config by id=" .. valueInGame)
        local playerData = y3.userData:getPlayerData(playerId)
        local player = playerData:getPlayer()
        local haveNum = player:get_attr(resCfg.resource_editor_name)
        return haveNum
    elseif typeInGame == 2 then

    end
    return 0
end

function UserDataHelper.costItemInGame(playerId, str, costNum)
    local params = string.split(str, "#")
    assert(params, "")
    local typeInGame = tonumber(params[1])
    local valueInGame = tonumber(params[2])
    if typeInGame == 1 then
        local resCfg = include("gameplay.config.resource_config").get(valueInGame)
        assert(resCfg, "can not found cfg in resource_config by id=" .. valueInGame)
        local playerData = y3.userData:getPlayerData(playerId)
        local player = playerData:getPlayer()
        local haveNum = player:get_attr(resCfg.resource_editor_name)
        local finalNum = math.max(0, haveNum - costNum)
        player:set(resCfg.resource_editor_name, finalNum)
    elseif typeInGame == 2 then

    end
end

function UserDataHelper.getStageWaveMonsterDrop(stageWaveCfg)
    local monster_drop_item = string.split(stageWaveCfg.monster_drop_item, "|")
    assert(monster_drop_item, "")
    local limitNum = tonumber(monster_drop_item[1])
    local randList = {}
    for i = 2, #monster_drop_item do
        local params = string.split(monster_drop_item[i], "#")
        assert(params, "")
        local itemId = tonumber(params[1])
        local size = tonumber(params[2])
        local weight = tonumber(params[3])
        local data = {}
        data.itemId = itemId
        data.size = size
        data.weight = weight
        table.insert(randList, data)
    end
    return limitNum, randList
end

function UserDataHelper.getStageSpecDrop(playerId, cfg)
    local special_rewards = string.split(cfg.special_reward, "|")
    local result = {}
    assert(special_rewards, "")
    for i, special_reward in ipairs(special_rewards) do
        local params = string.split(special_reward, "#")
        assert(params, "")
        local type = tonumber(params[1])
        local value = tonumber(params[2])
        local size = tonumber(params[3])
        local tag = tonumber(params[4])
        local logicType = tonumber(params[5])
        if type and value and size then
            local data = {}
            data.type = type
            data.value = value
            data.size = size
            data.tag = tag
            if logicType == 1 then -- 首通
                local stagePass = y3.gameApp:getLevel():getLogic("SurviveGameStagePass")
                local passCount = stagePass:getTodayPassCountAll(playerId)
                if passCount <= 0 then
                    table.insert(result, data)
                end
            end
        end
    end
    return result
end

function UserDataHelper.mergeAwards(dropAwards)
    local mergeMap = {}
    for i = 1, #dropAwards do
        local data = dropAwards[i]
        local key = data.type .. "_" .. data.value .. (data.tag and data.tag or "")
        if data.type == y3.SurviveConst.DROP_TYPE_WEANPON_EXP then
            key = data.type .. "_"
        end
        if mergeMap[key] then
            mergeMap[key].size = mergeMap[key].size + data.size
        else
            mergeMap[key] = clone(data)
        end
    end
    local list = {}
    for key, data in pairs(mergeMap) do
        table.insert(list, data)
    end
    return list
end

function UserDataHelper.mergeAwards2(dropAwards)
    local mergeMap = {}
    for i = 1, #dropAwards do
        local data = dropAwards[i]
        local key = data.type .. "_" .. data.value .. (data.tag and data.tag or "")
        if mergeMap[key] then
            mergeMap[key].size = mergeMap[key].size + data.size
        else
            mergeMap[key] = clone(data)
        end
    end
    local list = {}
    for key, data in pairs(mergeMap) do
        table.insert(list, data)
    end
    return list
end

function UserDataHelper.getMyPlayerWeaponExpTip()
    local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local dropAwards = playerData:getRecordDrop()
    local list = UserDataHelper.mergeAwards2(dropAwards)
    local desc = ""
    for i = 1, #list do
        local award = list[i]
        if award.type == y3.SurviveConst.DROP_TYPE_WEANPON_EXP then
            local cfg = include("gameplay.config.config_skillData").get(tostring(award.value))
            if cfg then
                desc = desc .. cfg.name .. " " .. award.size .. "\n"
            end
        end
    end
    return desc
end

function UserDataHelper.getStageBoss(stageId)
    local list = {}
    local stage_archive_boss = include("gameplay.config.stage_archive_boss")
    local len = stage_archive_boss.length()
    for i = 1, len do
        local stage_boss = stage_archive_boss.indexOf(i)
        if stage_boss and stage_boss.stage_id == stageId then
            table.insert(list, stage_boss)
        end
    end
    return list
end

function UserDataHelper.getArchieveBossAward(cfg)
    local stage_archive_boss_rewards = string.split(cfg.stage_archive_boss_reward, "|")
    assert(stage_archive_boss_rewards, "")
    local list = {}
    for i, stage_archive_boss_reward in ipairs(stage_archive_boss_rewards) do
        local params = string.split(stage_archive_boss_reward, "#")
        assert(params, "")
        local type = tonumber(params[1])
        local value = tonumber(params[2])
        local size = tonumber(params[3])
        local data = {}
        data.type = type
        data.value = value
        data.size = size
        table.insert(list, data)
    end
    return list
end

function UserDataHelper.recordAttrPackAttr(attrMap, attrPackList)
    for i = 1, #attrPackList do
        local packId = attrPackList[i]
        local attrList = UserDataHelper.getAttrListByPack(packId)
        for i, attr in ipairs(attrList) do
            if not attrMap[attr.id] then
                attrMap[attr.id] = 0
            end
            attrMap[attr.id] = attrMap[attr.id] + attr.value
        end
    end
end

function UserDataHelper.recordAttrPackAttr2(attrMap, attrList)
    for i, attr in ipairs(attrList) do
        if not attrMap[attr.id] then
            attrMap[attr.id] = 0
        end
        attrMap[attr.id] = attrMap[attr.id] + attr.value
    end
end

function UserDataHelper.getAllSaveAttr(playerId)
    local playerData = y3.userData:getPlayerData(playerId)
    local achievement = y3.gameApp:getLevel():getLogic("SurviveGameAchievement")
    local treasure = y3.gameApp:getLevel():getLogic("SurviveGameTreasure")
    local weaponSave = y3.gameApp:getLevel():getLogic("SurviveGameWeaponSave")
    local attrMap = {}
    local attrPackList1 = achievement:getAchievementAttrList(playerData)
    UserDataHelper.recordAttrPackAttr(attrMap, attrPackList1)
    local attrPackList2 = treasure:getTreasureAttrList(playerData)
    UserDataHelper.recordAttrPackAttr(attrMap, attrPackList2)
    local attrPackList3 = weaponSave:getWeaponAttrList(playerData)
    UserDataHelper.recordAttrPackAttr(attrMap, attrPackList3)
    local achieveTitle = y3.gameApp:getLevel():getLogic("SurviveGameAchievementTitle")
    local attrPackList4 = achieveTitle:getAttrPackList(playerId)
    UserDataHelper.recordAttrPackAttr(attrMap, attrPackList4)
    local gameBattlePass = y3.gameApp:getLevel():getLogic("SurviveGameBattlePass")
    local attrPackList5 = gameBattlePass:getActivedAttrList(playerId)
    UserDataHelper.recordAttrPackAttr(attrMap, attrPackList5)
    local gameCourse = y3.gameApp:getLevel():getLogic("SurviveGameCourse")
    local attrPackList6 = gameCourse:getTowerSkinAttrList(playerId)
    UserDataHelper.recordAttrPackAttr(attrMap, attrPackList6)

    local gameplatformShop = y3.gameApp:getLevel():getLogic("SurviveGamePlatformShop")
    local attrList = gameplatformShop:getPlatformShopAttrList(playerId)
    UserDataHelper.recordAttrPackAttr2(attrMap, attrList)
    return attrMap
end

function UserDataHelper.getAttrPower(attrMap)
    local attr = include("gameplay.config.attr")
    local len = attr.length()
    local attrpower = 0
    for i = 1, len do
        local attrCfg = attr.indexOf(i)
        assert(attrCfg, "")
        if attrCfg.power > 0 then
            local value = attrMap[attrCfg.id] or 0
            if value > 0 then
                value = (value) * attrCfg.power
                attrpower = attrpower + value
            end
        end
    end
    return attrpower
end

function UserDataHelper.unloadMaxPower(playerId)
    local playerData = y3.userData:getPlayerData(playerId)
    local attrMap = y3.userDataHelper.getAllSaveAttr(playerId)
    local attrPower = math.floor(y3.userDataHelper.getAttrPower(attrMap))
    y3.save_data.save_integer(playerData:getPlayer(), y3.userData:getSaveSlot("maxPower"), attrPower)
end

function UserDataHelper.unloadPassValue(playerId)
    local playerData = y3.userData:getPlayerData(playerId)
    local curStageId = y3.userData:getCurStageId()
    local curCfg = include("gameplay.config.stage_config").get(curStageId)
    if curCfg and curCfg.stage_type == 1 then
        -- 难度id*100000-通关时间秒数	
        local spawnEnemy = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy")
        local totalTime = spawnEnemy:getTotalDt()
        local passValue = math.floor(curCfg.id * 100000 - totalTime)
        y3.player.with_local(function(local_player)
            if local_player:get_id() == playerId then
                local player = playerData:getPlayer()
                local rank = player:get_rank_num(y3.userData:getSaveSlot("passValue"))
                local rankValue = GameAPI.get_archive_rank_player_archive_value(y3.userData:getSaveSlot("passValue"),
                    rank)
                if passValue > rankValue then
                    y3.save_data.save_integer(playerData:getPlayer(), y3.userData:getSaveSlot("passValue"), passValue)
                end
            end
        end)
    end
end

function UserDataHelper.has_store_item(player, store_key)
    local storeNum = player:get_store_item_number(store_key)
    -- print(storeNum)
    -- y3.Sugar.localNotice2(player:get_id(), store_key .. " " .. storeNum, {})
    return player:get_store_item_number(store_key) > 0
end

-- SurviveConst.DROP_TYPE_SAVE_ITEM                    = 1
-- SurviveConst.DROP_TYPE_TREASURE                     = 2
-- SurviveConst.DROP_TYPE_TITLE                        = 3
-- SurviveConst.DROP_TYPE_STAGE_TOWER                  = 4
-- SurviveConst.DROP_TYPE_HERO_SKIN                    = 5
-- SurviveConst.DROP_TYPE_ATTR_PACK                    = 6
-- SurviveConst.DROP_TYPE_TOWER_SKIN                   = 7
function UserDataHelper.getCommonItemParam(itemStr)
    local param = string.split(itemStr, "#")
    assert(param, "")
    local itemtype = tonumber(param[1])
    local itemvalue = tonumber(param[2])
    local itemsize = tonumber(param[3])
    local retData = { name = "", size = itemsize, value = itemvalue, type = itemtype }
    if itemtype == y3.SurviveConst.DROP_TYPE_SAVE_ITEM then
        local cfg = include("gameplay.config.save_item").get(itemvalue)
        if cfg then
            retData.name = cfg.item_name
        end
    elseif itemtype == y3.SurviveConst.DROP_TYPE_TREASURE then
        local cfg = include("gameplay.config.treasure").get(itemvalue)
        if cfg then
            retData.name = cfg.name
        end
    elseif itemtype == y3.SurviveConst.DROP_TYPE_TITLE then
        local cfg = include("gameplay.config.title").get(itemvalue)
        if cfg then
            retData.name = cfg.name
        end
    elseif itemtype == y3.SurviveConst.DROP_TYPE_STAGE_TOWER then
        local cfg = include("gameplay.config.stage_tower").get(itemvalue)
        if cfg then
            retData.name = cfg.tower_name
        end
    elseif itemtype == y3.SurviveConst.DROP_TYPE_HERO_SKIN then
        local cfg = include("gameplay.config.hero").get(itemvalue)
        if cfg then
            retData.name = cfg.name
        end
    elseif itemtype == y3.SurviveConst.DROP_TYPE_ATTR_PACK then
    elseif itemtype == y3.SurviveConst.DROP_TYPE_TOWER_SKIN then
        local cfg = include("gameplay.config.stage_tower_skin").get(itemvalue)
        if cfg then
            retData.name = cfg.tower_skin_name
        end
    end
    return retData
end

function UserDataHelper.uploadTrackingDataInit(playerId)
    local player = y3.player(playerId)
    -- print("UserDataHelper.uploadTrackingDataInit", playerId)
    player:upload_tracking_data("gamemode_init", 1)
end

function UserDataHelper.uploadTrackingDataStart(playerId)
    local player = y3.player(playerId)
    local curStageId = y3.userData:getCurStageId()
    local cfg = include("gameplay.config.stage_config").get(curStageId)
    if cfg then
        -- print("UserDataHelper.uploadTrackingDataStart", playerId, curStageId, cfg.stage_type, cfg.id)
        player:upload_tracking_data("gamemode_" .. cfg.stage_type .. "_" .. cfg.id .. "_start", 1)
    end
end

function UserDataHelper.uploadTrackingDataWin(playerId)
    local player = y3.player(playerId)
    local curStageId = y3.userData:getCurStageId()
    local cfg = include("gameplay.config.stage_config").get(curStageId)
    if cfg then
        local curTime = y3.game.get_current_server_time().timestamp
        -- print("UserDataHelper.uploadTrackingDataWin", playerId, curStageId, cfg.stage_type, cfg.id, curTime)
        player:upload_tracking_data("gamemode_" .. cfg.stage_type .. "_" .. cfg.id .. "_win_" .. curTime, 1)
    end
end

function UserDataHelper.uploadTrackingDataLose(playerId)
    local player = y3.player(playerId)
    local curStageId = y3.userData:getCurStageId()
    local cfg = include("gameplay.config.stage_config").get(curStageId)
    if cfg then
        local curTime = y3.game.get_current_server_time().timestamp
        -- print("UserDataHelper.uploadTrackingDataLose", playerId, curStageId, cfg.stage_type, cfg.id, curTime)
        player:upload_tracking_data("gamemode_" .. cfg.stage_type .. "_" .. cfg.id .. "_lose" .. curTime, 1)
    end
end

---comment
---@param playerId any
---@return integer
function UserDataHelper.getPlayerSpawnPointId(playerId)
    local curStageId = y3.userData:getCurStageId()
    local cfg = include("gameplay.config.stage_config").get(curStageId)
    assert(cfg, "can not found cfg in stage_config by id=" .. curStageId)
    local modeCfg = include("gameplay.config.stage_mode").get(cfg.stage_type)
    assert(modeCfg, "can not found cfg in stage_mode by id=" .. cfg.stage_type)
    local player_born_points = string.split(modeCfg.player_born_points, "|")
    assert(player_born_points, "")
    return tonumber(player_born_points[playerId])
end

return UserDataHelper
