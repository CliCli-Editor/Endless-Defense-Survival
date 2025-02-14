local LogicBase = include("gameplay.level.logic.LogicBase")
local SurviveGameTechnology = class("SurviveGameTechnology", LogicBase)

function SurviveGameTechnology:ctor(level)
    SurviveGameTechnology.super.ctor(self, level)
    self:_initData()
end

function SurviveGameTechnology:_initData()
    local stage_diamond_technology = include("gameplay.config.stage_diamond_technology")
    self._playerTechnology = {}
    local len = stage_diamond_technology.length()
    self._tenchnologyMap = {}
    self._tenchNameMap = {}
    for i = 1, len do
        local cfg = stage_diamond_technology.indexOf(i)
        assert(cfg, "")
        if not self._tenchnologyMap[cfg.tech_type] then
            self._tenchnologyMap[cfg.tech_type] = {}
            self._tenchNameMap[cfg.tech_type] = cfg.tech_name
        end
        table.insert(self._tenchnologyMap[cfg.tech_type], cfg)
    end
    local allPlayers = y3.userData:getAllInPlayers()
    for _, playerData in ipairs(allPlayers) do
        local param = {}
        for techType = 1, y3.SurviveConst.MAX_STAGE_TEACH_NUM do
            param[techType] = { level = 0 }
        end
        self._playerTechnology[playerData:getId()] = param
    end
end

function SurviveGameTechnology:getTenchName(techType)
    return self._tenchNameMap[techType] or ""
end

function SurviveGameTechnology:getTechnologyLevel(playerId, techType)
    local playerTechnology = self._playerTechnology[playerId]
    local param = playerTechnology[techType]
    return param.level or 0
end

function SurviveGameTechnology:getTechnologyPrice(playerId, techType)
    local playerTechnology = self._playerTechnology[playerId]
    local techs = self._tenchnologyMap[techType]
    local maxLevel = techs[#techs].tech_level
    local param = playerTechnology[techType]
    local level = param.level
    local nextLevel = math.min(maxLevel, level + 1)
    if level == nextLevel then
        return 0
    end
    local cfg = techs[nextLevel]
    local costParams = string.split(cfg.tech_cost, "#")
    assert(costParams, "")
    local costNum = tonumber(costParams[3])
    return costNum
end

function SurviveGameTechnology:upgradeTechnology(playerId, techType)
    local playerTechnology = self._playerTechnology[playerId]
    local techs = self._tenchnologyMap[techType]
    local maxLevel = techs[#techs].tech_level
    local param = playerTechnology[techType]
    local level = param.level
    local nextLevel = math.min(maxLevel, level + 1)
    if level == nextLevel then
        y3.Sugar.localTips(playerId, GameAPI.get_text_config('#-1328678191#lua'))
    else
        -- print(playerId, "升级", techType, "到", nextLevel)
        local cfg = techs[nextLevel]
        local costParams = string.split(cfg.tech_cost, "#")
        assert(costParams, "")
        local haveNum = y3.userDataHelper.getHaveItemInGame(playerId, cfg.tech_cost)
        local costNum = tonumber(costParams[3])
        if haveNum >= costNum then
            local playerData = y3.userData:getPlayerData(playerId)
            local mainActor = playerData:getMainActor()
            mainActor:addPureAttr(cfg.tech_effect)
            param.level = nextLevel
            y3.userDataHelper.costItemInGame(playerId, cfg.tech_cost, costNum)
            y3.Sugar.localTips(playerId, GameAPI.get_text_config('#-784991155#lua'))
            y3.gameApp:dispatchEvent(y3.EventConst.EVENT_TECH_UPGRADE_SUCCESS, playerId)
        else
            y3.Sugar.localTips(playerId, GameAPI.get_text_config('#-1487604607#lua'))
        end
    end
end

return SurviveGameTechnology
