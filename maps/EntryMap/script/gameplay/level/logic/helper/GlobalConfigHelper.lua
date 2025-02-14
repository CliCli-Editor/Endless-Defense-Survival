local GlobalConfigHelper = {}
local global_config = include("gameplay.config.global_config")

function GlobalConfigHelper.get(id)
    local cfg = global_config.get(id)
    assert(cfg, "GlobalConfigHelper.get: Invalid config id " .. id)
    if tonumber(cfg.value) then
        return tonumber(cfg.value)
    end
    return cfg.value
end

function GlobalConfigHelper.getGameReadyTime()
    return tonumber(global_config.get(1).value)
end

function GlobalConfigHelper.getArmorIconMap()
    local iconMap = {}
    local params = string.split(GlobalConfigHelper.get(17), "|")
    for i, param in ipairs(params) do
        local values = string.split(param, "#")
        iconMap[tonumber(values[1])] = tonumber(values[2])
    end
    return iconMap
end

function GlobalConfigHelper.getSkillTopIconMap()
    local iconMap = {}
    local params = string.split(GlobalConfigHelper.get(30), "|")
    for i, param in ipairs(params) do
        local values = string.split(param, "#")
        iconMap[tonumber(values[1])] = tonumber(values[2])
    end
    return iconMap
end

function GlobalConfigHelper.getSkillRangeMap()
    local iconMap = {}
    local params = string.split(GlobalConfigHelper.get(29), "|")

    for i, param in ipairs(params) do
        local values = string.split(param, "#")
        iconMap[tonumber(values[1])] = values[2]
    end
    return iconMap
end

function GlobalConfigHelper.getTexingColor()
    local iconMap = {}
    local params = string.split(GlobalConfigHelper.get(29), "|")

    for i, param in ipairs(params) do
        local values = string.split(param, "#")
        iconMap[tonumber(values[1])] = values[2]
    end
    return iconMap
end

function GlobalConfigHelper.getChallengeNameMap()
    local iconMap = {}
    local params = string.split(GlobalConfigHelper.get(39), "|")
    assert(params, "")
    for i, param in ipairs(params) do
        local values = string.split(param, "#")
        assert(values, "")
        iconMap[tonumber(values[1])] = values[2]
    end
    return iconMap
end

function GlobalConfigHelper.getWeaponClassPowerRatioMap()
    local ratioMap = {}
    local params = string.split(GlobalConfigHelper.get(42), "|")
    assert(params, "")
    ratioMap[1] = tonumber(params[1])
    ratioMap[2] = tonumber(params[2])
    ratioMap[3] = tonumber(params[3])
    ratioMap[4] = tonumber(params[4])
    return ratioMap
end

function GlobalConfigHelper.getShopBuyExpMap()
    local expMap = {}
    local params = string.split(GlobalConfigHelper.get(44), "|")
    assert(params, "")
    for i, param in ipairs(params) do
        local values = string.split(param, "#")
        assert(values, "")
        expMap[tonumber(values[1])] = tonumber(values[2])
    end
    return expMap
end

function GlobalConfigHelper.getSaveChallengeTypeNameMap()
    local expMap = {}
    local params = string.split(GlobalConfigHelper.get(46), "|")
    assert(params, "")
    for i, param in ipairs(params) do
        local values = string.split(param, "#")
        assert(values, "")
        table.insert(expMap, { filtertype = tonumber(values[1]), name = values[2] })
        -- expMap[tonumber(values[1])] = (values[2])
    end
    return expMap
end

function GlobalConfigHelper.getSaveChallengeTypeNameMap2()
    local expMap = {}
    local params = string.split(GlobalConfigHelper.get(62), "|")
    assert(params, "")
    for i, param in ipairs(params) do
        local values = string.split(param, "#")
        assert(values, "")
        table.insert(expMap, { filtertype = tonumber(values[1]), name = values[2] })
        -- expMap[tonumber(values[1])] = (values[2])
    end
    return expMap
end

function GlobalConfigHelper.getAttackTypeUnlockMap()
    local expMap = {}
    local params = string.split(GlobalConfigHelper.get(47), "|")
    assert(params, "")
    for i, param in ipairs(params) do
        local values = string.split(param, "#")
        assert(values, "")
        expMap[tonumber(values[1])] = tonumber(values[2])
    end
    return expMap
end

function GlobalConfigHelper.getHeroShopLvExpMap()
    local expMap = {}
    local params = string.split(GlobalConfigHelper.get(49), "|")
    assert(params, "")
    for i, param in ipairs(params) do
        expMap[i] = tonumber(param)
    end
    return expMap
end

function GlobalConfigHelper.getStagePhaseMap()
    local curStageConfig = include("gameplay.config.stage_config").get(y3.userData:getCurStageId())
    assert(curStageConfig, "GlobalConfigHelper.getGameStartOffset: Invalid stage id " .. y3.userData:getCurStageId())
    local curModeCfg = include("gameplay.config.stage_mode").get(curStageConfig.stage_type)
    assert(curModeCfg, "GlobalConfigHelper.getGameStartOffset: Invalid stage mode " .. curStageConfig.stage_type)
    local phaseMap = string.split(curModeCfg.mode_phase_show_args, "|")
    assert(phaseMap, "")
    local savePhaseMap = {}
    for i = 1, #phaseMap do
        local params = string.split(phaseMap[i], "#")
        assert(params, "")
        for j = 1, #params do
            savePhaseMap[tonumber(params[j])] = i
        end
    end
    return savePhaseMap, #phaseMap
end

function GlobalConfigHelper.getGameStartOffset()
    local curStageConfig = include("gameplay.config.stage_config").get(y3.userData:getCurStageId())
    assert(curStageConfig, "GlobalConfigHelper.getGameStartOffset: Invalid stage id " .. y3.userData:getCurStageId())
    local curModeCfg = include("gameplay.config.stage_mode").get(curStageConfig.stage_type)
    assert(curModeCfg, "GlobalConfigHelper.getGameStartOffset: Invalid stage mode " .. curStageConfig.stage_type)
    return string.split(curModeCfg.mode_start_phase_button_pos, "|")
end

function GlobalConfigHelper.getMonsterNumColorMap()
    local expMap = {}
    local params = string.split(GlobalConfigHelper.get(61), "|")
    assert(params, "")
    for i, param in ipairs(params) do
        local values = string.split(param, "#")
        assert(values, "")
        table.insert(expMap, { percent = tonumber(values[1]), color = values[2] })
    end
    return expMap
end

function GlobalConfigHelper.getAchievementPassFilterText()
    local expMap = {}
    local params = string.split(GlobalConfigHelper.get(63), "|")
    assert(params, "")
    for i, param in ipairs(params) do
        local values = string.split(param, "#")
        assert(values, "")
        table.insert(expMap, { filter = tonumber(values[1]), name = values[2] })
    end
    return expMap
end

function GlobalConfigHelper.getMonsterTypeNameMap()
    local expMap = {}
    local params = string.split(GlobalConfigHelper.get(64), "|")
    assert(params, "")
    for i, param in ipairs(params) do
        log.info("param", param)
        local values = string.split(param, "#")
        assert(values, "")
        expMap[tonumber(values[1])] = values[2]
    end
    return expMap
end

function GlobalConfigHelper.getSkillTypeNameMap()
    local expMap = {}
    local params = string.split(GlobalConfigHelper.get(65), "|")
    assert(params, "")
    for i, param in ipairs(params) do
        local values = string.split(param, "#")
        assert(values, "")
        expMap[tonumber(values[1])] = values[2]
    end
    return expMap
end

return GlobalConfigHelper
