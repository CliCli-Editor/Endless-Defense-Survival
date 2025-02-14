y3.eca.def "加密数据"
    :with_param("value", "any")
    :with_return("加密后数据", "string")
    :call(function(value)
        return y3.gameApp:encryptString(value)
    end)

y3.eca.def "解密为字符串"
    :with_param("value", "string")
    :with_return("解密后数据", "string")
    :call(function(value)
        return y3.gameApp:decryptString(value)
    end)

y3.eca.def "解密为数字"
    :with_param("value", "string")
    :with_return("解密后数据", "number")
    :call(function(value)
        return tonumber(y3.gameApp:decryptString(value))
    end)

y3.eca.def "加密数据_加法"
    :with_param("value1", "string")
    :with_param("value2", "number")
    :with_return("加密后数据", "string")
    :call(function(value1, value2)
        local retValue = y3.gameApp:decryptString(value1)
        retValue = tonumber(retValue) + value2
        return y3.gameApp:encryptString(retValue)
    end)

y3.eca.def "加密数据_减法"
    :with_param("value1", "string")
    :with_param("value2", "number")
    :with_return("加密后数据", "string")
    :call(function(value1, value2)
        local retValue = y3.gameApp:decryptString(value1)
        retValue = tonumber(retValue) - value2
        return y3.gameApp:encryptString(retValue)
    end)

y3.eca.def "加密数据_乘法"
    :with_param("value1", "string")
    :with_param("value2", "number")
    :with_return("加密后数据", "string")
    :call(function(value1, value2)
        local retValue = y3.gameApp:decryptString(value1)
        retValue = tonumber(retValue) * value2
        return y3.gameApp:encryptString(retValue)
    end)

y3.eca.def "加密数据_除法"
    :with_param("value1", "string")
    :with_param("value2", "number")
    :with_return("加密后数据", "string")
    :call(function(value1, value2)
        local retValue = y3.gameApp:decryptString(value1)
        retValue = tonumber(retValue) / value2
        return y3.gameApp:encryptString(retValue)
    end)

y3.eca.def "重新开始游戏" --- 预研功能
    :call(function()
        y3.gameApp:restart()
    end)

y3.eca.def "获取技能卡池"
    :with_param("参数表", "table")
    :with_return("技能表", "table")
--- 参数是一个一维表，第一个槽位是stage_shop的id,第二个槽位是玩家id
--- 返回值是多维表格，每一项是random_pool的id，通过这个id获取技能的id和价格
--- @param params table
--- @return table ---------- 多维表返回 每行的技能
    :call(function(params)
        --- param[1]  -- 传递stage_shop的id
        --- param[2]  -- 传递玩家id
        local skills = y3.gameApp:getLevel():getLogic("SurviveRefreshSkill"):forstinitiativeRefreshCards(params)
        return skills
    end)

y3.eca.def "玩家学习技能"
    :with_param("参数", "table") -- 参数是一个一维表params[1]玩家id ， params[2]skill表里的技能id
    :call(function(params)
        local SurviveHelper = include("gameplay.level.logic.helper.SurviveHelper")
        SurviveHelper.leanSkill(params)
    end)

y3.eca.def "智能获取攻击单位"
    :with_param("参数", "table") -- 参数是一个一维表params[1]塔单位， params[2]技能配置id
    :with_return("攻击单位", "Unit")
    :call(function(params)
        local SurviveHelper = include("gameplay.level.logic.helper.SurviveHelper")
        return SurviveHelper.getAttackEnemy(params[1], params[2])
    end)

y3.eca.def "创建玩家主塔"
    :with_param("参数", "table") -- 参数是一个一维表params[1]玩家id
    :with_return("玩家主塔", "Unit")
    :call(function(params)
        local playerId = params[1]
        local unit = y3.gameApp:getLevel():createPlayerUnit(playerId)
        return unit
    end)

y3.eca.def "设置游戏主模式"
    :with_param("参数", "table") -- 参数是一个一维表params[1]游戏模式
    :call(function(params)
        local gameMode = params[1]
        y3.gameApp:setGameMode(gameMode)
    end)

y3.eca.def "设置游戏子模式"
    :with_param("参数", "table") -- 参数是一个一维表params[1]游戏子模式
    :call(function(params)
        local subGameMode = params[1]
        y3.gameApp:setSubGameMode(subGameMode)
    end)

-- 这种写法的params不会转成lua的对象，要自己手动转
Bind["计算伤害"] = function (params)
    local SurviveHelper = include("gameplay.level.logic.helper.SurviveHelper")
    return SurviveHelper.calculateDamage(params)
end

y3.eca.def "创建怪物"
    :with_param("参数", "table") -- 参数是一个一维表params[1]怪物配置id,params[2]创建者单位,params[3]创建点
    :with_return("怪物", "Unit")
    :call(function(params)
        local SurviveHelper = include("gameplay.level.logic.helper.SurviveHelper")
        return SurviveHelper.createMonster(params)
    end)

y3.eca.def "获取技能类型数量"
    :with_param("参数", "table") -- 参数是一个一维表params[1]技能类型
    :with_return("技能数量", "number")
    :call(function(params)
    end)

y3.eca.def "集火范围"
    :with_param("参数", "table") -- 参数是一个一维表params[1]点 params[2]范围 params[3]玩家id params[4]集火时间
    :call(function(params)
        local spawnEnemy = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy")
        spawnEnemy:firePoint(params)
    end)

y3.eca.def "金币挑战"
    :with_param("参数", "table") -- 参数是一个一维表params[1]玩家id params[2]挑战类型
    :call(function(params)
        local spawnEnemy = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy")
        local playerId = params[1]
        local challengeType = params[2]
        -- print("金币挑战", playerId, challengeType)
        if challengeType == 1 then
            local stageChallenge = spawnEnemy:getGoldChallenge()
            stageChallenge:startStageChallenge(playerId)
        elseif challengeType == 2 then
            local goldChallenge = spawnEnemy:getDiamondChallenge()
            goldChallenge:startStageChallenge(playerId)
        elseif challengeType == 3 then
            local diamondChallenge = spawnEnemy:getItemChallenge()
            diamondChallenge:startStageChallenge(playerId)
        end
    end)

y3.eca.def "显示提示"
    :with_param("参数", "table") --params[1]玩家id, params[2]提示文本
    :call(function(params)
        local playerId = params[1]
        local text = params[2]
        y3.Sugar.localNotice(playerId, 33, { content = text })
    end)

y3.eca.def "特殊宝箱使用"
    :with_param("参数", "table") --params[1]玩家id, params[2]道具id
    :call(function(params)
        local playerId = params[1]
        local itemId = params[2]
        -- print("特殊宝箱使用", playerId, itemId)
        local UserDataHelper = include("gameplay.level.logic.helper.UserDataHelper")
        UserDataHelper.useItem(playerId, itemId)
    end)

y3.eca.def "游戏结算"
    :with_param("参数", "table") --params[1]玩家id
    :call(function(params)
        local playerId = params[1]
        local spawnEnemy = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy")
        spawnEnemy:gameResult(playerId)
    end)

y3.eca.def "获取关卡id"
    :with_param("参数", "table") --params[1]玩家id
    :with_return("关卡id", "number")
    :call(function(params)
        local playerId = params[1]
        local stageId = y3.userData:getCurStageId() --y3.gameApp:getLevel():getStageId()
        return stageId
    end)

y3.eca.def "获取玩家列表"
    :with_return("玩家列表", "table")
    :call(function()
        local playerList = {}
        local allInPlayers = y3.gameApp:getAllInPlayers()
        for _, playerData in pairs(allInPlayers) do
            table.insert(playerList, playerData:getId())
        end
        return playerList
    end)

y3.eca.def "点击npc"
    :with_param("参数", "table") --params[1]玩家id, params[2]npcid
    :call(function(params)
        local playerId = params[1]
        local npcId = params[2]
        -- print("点击npc", playerId, npcId)
        local spawnEnemy = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy")
        if not spawnEnemy:playerIsInFightBoss(playerId) then
            -- print("玩家不在战斗中", playerId)
            y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SURVIVE_SHOW_NPC_INFO, playerId, npcId)
        end
    end)

Bind["纯计算伤害"] = function (params)
    local SurviveHelper = include("gameplay.level.logic.helper.SurviveHelper")
    return SurviveHelper.calculateDamagePure(params)
end

y3.eca.def "学习随机技能"
    :with_param("参数", "table") -- 参数是一个一维表params[1]玩家id ,param[2]技能池字符串
    :call(function(params)
        local playerId = params[1]
        local poolStr = params[2]
        local SurviveHelper = include("gameplay.level.logic.helper.SurviveHelper")
        SurviveHelper.learnRandomSkill(playerId, poolStr)
    end)

y3.eca.def "玩家获取物品"
    :with_param("参数", "table") -- 参数是一个一维表params[1]玩家id ,param[2]物品id
    :call(function(params)
        -- dump_all(params)
        local playerId = params[1]
        local itemId =  tonumber(params[2])
        -- print("玩家获取物品", playerId, itemId)
        local SurviveHelper = include("gameplay.level.logic.helper.SurviveHelper")
        SurviveHelper.dropItem(playerId, itemId)
    end)

y3.eca.def "获取当前深渊剩余"
    :with_param("参数", "table") -- 参数是一个一维表params[1]玩家id
    :with_return("剩余", "number")
    :call(function(params)
        local playerId = params[1]
        local spawnEnemy = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy")
        local abyssChallenge = spawnEnemy:getAbysChallenge()
        return abyssChallenge:getChallengeRemainMonsterNum(playerId)
    end)

y3.eca.def "获取深渊层数"
    :with_param("参数", "table") -- 参数是一个一维表params[1]玩家id
    :with_return("层数", "number")
    :call(function(params)
        local playerId = params[1]
        -- print(playerId)
        local spawnEnemy = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy")
        local abyssChallenge = spawnEnemy:getAbysChallenge()
        return abyssChallenge:getChallengeFloor(playerId)
    end)
