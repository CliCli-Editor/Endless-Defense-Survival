local FuncCheckHelper = {}

function FuncCheckHelper._initCfg()
    if not FuncCheckHelper._cfgMap then
        FuncCheckHelper._cfgMap = {}
        local stage_funcation_unlock = include("gameplay.config.stage_funcation_unlock")
        local len = stage_funcation_unlock.length()
        for i = 1, len do
            local cfg = stage_funcation_unlock.indexOf(i)
            assert(cfg, "")
            FuncCheckHelper._cfgMap[cfg.stage_funcation] = cfg
        end
    end
end

function FuncCheckHelper.checkFuncIsOpen(playerId, funcId)
    FuncCheckHelper._initCfg()
    local checkFunc = FuncCheckHelper["_check_" .. funcId]
    if checkFunc then
        local cfg = FuncCheckHelper._cfgMap[funcId]
        return checkFunc(playerId, cfg)
    end
    return false
end

function FuncCheckHelper.checkCommonFunc(playerId, cfg)
    local stage_funcation_unlocks = string.split(cfg.stage_funcation_unlock, "#")
    assert(stage_funcation_unlocks, "")
    local checkId = tonumber(stage_funcation_unlocks[1])
    local checkParam = tonumber(stage_funcation_unlocks[2])
    if checkId == 1 then -- 深渊层数判断
        local abyssChallenge = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy"):getAbysChallenge()
        local curFloor = abyssChallenge:getChallengeFloor(playerId)
        return curFloor >= checkParam
    elseif checkId == 2 then -- 商店等级判断
        local refreshSkill = y3.gameApp:getLevel():getLogic("SurviveRefreshSkill")
        local shopLevel = refreshSkill:getShopLevelParam(playerId)
        return shopLevel >= checkParam
    elseif checkId == 3 then
        local spawnEnemy = y3.gameApp:getLevel():getLogic("SurviveGameStatus")
        local totalDt = spawnEnemy:getReadyEndTotalTime()
        return totalDt >= checkParam
    end
    return false
end

function FuncCheckHelper._check_blackmarket(playerId, cfg)
    return FuncCheckHelper.checkCommonFunc(playerId, cfg)
end

function FuncCheckHelper._check_towersoulTech(playerId, cfg)
    return FuncCheckHelper.checkCommonFunc(playerId, cfg)
end

function FuncCheckHelper._check_abyss(playerId, cfg)
    return FuncCheckHelper.checkCommonFunc(playerId, cfg)
end

return FuncCheckHelper
