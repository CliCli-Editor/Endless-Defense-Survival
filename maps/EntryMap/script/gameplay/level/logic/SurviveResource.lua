local LogicBase = include("gameplay.level.logic.LogicBase")
local SurviveResource = class("SurviveResource", LogicBase)

function SurviveResource:ctor(level)
    SurviveResource.super.ctor(self, level)
    y3.gameApp:addTimerLoop(1 / y3.GameConst.GAME_FPS, handler(self, self._refreshResource))

    self:_initData()
end

-- -@class EventParam.ET_ROLE_RESOURCE_CHANGED
-- -@field player Player # 玩家
-- -@field res_key py.RoleResKey # 玩家资源类型
-- -@field res_value integer # 玩家资源值
-- -@field res_value_delta number # 玩家资源变量值
function SurviveResource:_initData()
    local GlobalConfigHelper = include("gameplay.level.logic.helper.GlobalConfigHelper")
    local resource_config = include("gameplay.config.resource_config")
    local len = resource_config.length()
    self._resNameMap = {}
    for i = 1, len do
        local cfg = resource_config.indexOf(i)
        assert(cfg, "")
        self._resNameMap[cfg.resource_editor_name] = cfg.id
    end
    self._refreshMap = {}
    self._refreshDiamondMap = {}
    local players = y3.userData:getAllInPlayers()
    local goldAutoAddParams = string.split(GlobalConfigHelper.get(28), "#")
    assert(goldAutoAddParams, "goldAutoAddParams error")
    self._autoAddTime = tonumber(goldAutoAddParams[1])
    self._autoAddCount = tonumber(goldAutoAddParams[2])
    self._autoAddLimit = tonumber(goldAutoAddParams[3])
    for _, playerData in ipairs(players) do
        local param = {}
        param.addCount = GlobalConfigHelper.get(7)
        param.addInter = GlobalConfigHelper.get(8)
        param.totalDt = 0
        param.totalGoldAdd = 0
        param.totalDiamondAdd = 0
        param.autoAddTime = self._autoAddTime
        param.maxautoAddTime = self._autoAddTime
        param.autoAddCount = self._autoAddCount
        param.autoAddAddTime = 0
        self._refreshMap[playerData:getId()] = param
        local paramDia = { totalDt = 0, addInter = 1, lastFloat = 0 }
        self._refreshDiamondMap[playerData:getId()] = paramDia
        local player = playerData:getPlayer()
        player:event("玩家-属性变化", handler(self, self._handlerPlayerAttrChange))
    end
    self._signalResList = {}
    self._dispatchResList = {}
end

function SurviveResource:_handlerPlayerAttrChange(trg, data)
    local player = data.player
    local param = self._refreshMap[player:get_id()]
    local resId = 0
    if data.res_key == y3.const.PlayerAttr["gold"] then
        resId = self._resNameMap["gold"]
        if data.res_value_delta > 0 then
            param.totalGoldAdd = param.totalGoldAdd + data.res_value_delta
        end
        y3.Sugar.achievement():updateAchievement(player:get_id(), y3.SurviveConst.ACHIEVEMENT_REFRESH_TYPE_GOLD)
    elseif data.res_key == y3.const.PlayerAttr["diamond"] then
        resId = self._resNameMap["diamond"]
        if data.res_value_delta > 0 then
            param.totalDiamondAdd = param.totalDiamondAdd + data.res_value_delta
        end
        y3.Sugar.achievement():updateAchievement(player:get_id(), y3.SurviveConst.ACHIEVEMENT_REFRESH_TYPE_DIAMOND)
    end

    table.insert(self._signalResList, { player = player, resId = resId, resValueDelta = data.res_value_delta })
    table.insert(self._dispatchResList, { player = player, resId = resId, resValueDelta = data.res_value_delta })
    -- y3.SignalMgr:dispatch(y3.SignalConst.SIGNAL_PLAYER_UPDATE_COIN, player, resId, data.res_value_delta)
    -- y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SURVIVE_RESOURCE_ADD_GOLD, player)
end

function SurviveResource:getTotalGoldAdd(playerId)
    return self._refreshMap[playerId].totalGoldAdd
end

function SurviveResource:getTotalDiamondAdd(playerId)
    return self._refreshMap[playerId].totalDiamondAdd
end

function SurviveResource:_refreshResource(delay)
    if #self._signalResList > 0 then
        local param = table.remove(self._signalResList, 1)
        y3.SignalMgr:dispatch(y3.SignalConst.SIGNAL_PLAYER_UPDATE_COIN, param.player, param.resId, param.res_value_delta)
    end
    if #self._dispatchResList > 0 then
        local param = table.remove(self._dispatchResList, 1)
        y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SURVIVE_RESOURCE_ADD_GOLD, param.player)
    end
    --------------------------------------------------------
    if not self._level:isGameStart() then
        return
    end
    local gameStatus = y3.gameApp:getLevel():getLogic("SurviveGameStatus"):getGameStatus()
    if gameStatus == y3.SurviveConst.GAME_STATUS_READY then
        return
    end
    local players = y3.userData:getAllInPlayers()
    for _, playerData in ipairs(players) do
        self:_refreshPlayerResource(playerData, delay:float())
        self:_refreshPlayerResourceDiamond(playerData, delay:float())
    end
end

function SurviveResource:getGoldAddSpeed(playerId)
    local param = self._refreshMap[playerId]
    local playerData = y3.userData:getPlayerData(playerId)
    local mainActor = playerData:getMainActor()
    if mainActor then
        local goldAdd = mainActor:getUnit():get_attr("金币成长")
        local addRatio = mainActor:getUnit():get_attr("金币成长加成(%)") / 100
        local addCount = math.floor((param.addCount + goldAdd) * (1 + addRatio))
        return addCount
    end
    return 0
end

function SurviveResource:getAddGoldClose()
    return self._addGoldClose
end

function SurviveResource:closeAutoAddGold(close)
    self._addGoldClose = close
    if self._addGoldClose then
        y3.Sugar.localNotice(y3.gameApp:getMyPlayerId(), 21, {})
    end
    local allInPlayers = y3.userData:getAllInPlayers()
    for _, playerData in ipairs(allInPlayers) do
        local player = playerData:getPlayer()
        y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SURVIVE_RESOURCE_ADD_GOLD, player)
    end
end

-- y3.ui.create_floating_text(y3.get_point_offset_vector(y3.unit.get_lua_unit_from_py(y3.call_any_api_2('get_trigger_list_variable_unit_entity', 'HERO', 1)):get_point(),180.0,300.0),
--"get_gold",'+50',y3.player_group.get_all_players())
-- end)
function SurviveResource:_refreshPlayerResource(playerData, dt)
    if self._addGoldClose then
        return
    end
    local param = self._refreshMap[playerData:getId()]
    param.totalDt = param.totalDt + dt
    if param.totalDt >= param.addInter then
        local mainActor = playerData:getMainActor()
        if mainActor and not mainActor:isDieFianl() then
            local mainUnit = mainActor:getUnit()
            local income_close = 0
            if mainUnit:kv_has("income_close") then
                income_close = mainUnit:kv_load("income_close", "integer")
            end
            if income_close <= 0 then
                local goldAdd = mainActor:getUnit():get_attr("金币成长")
                local addRatio = mainActor:getUnit():get_attr("金币成长加成(%)") / 100
                param.totalDt = param.totalDt - param.addInter
                local addCount = math.floor((param.addCount + goldAdd) * (1 + addRatio))
                local player = playerData:getPlayer()
                local gold = player:get_attr("gold")
                gold = gold + addCount
                player:set("gold", gold)
                y3.ui.create_floating_text2(mainActor:getUnit():get_point():move(100, -200, 0), "get_gold",
                    '+' .. addCount,
                    y3.const.FloatTextJumpType['金币跳字'], y3.player_group.get_all_players())
            end
            param.totalDt = 0
        end
    end
    param.autoAddTime = param.autoAddTime - dt
    if param.autoAddTime <= 0 and param.autoAddAddTime < self._autoAddLimit then
        param.autoAddTime = param.maxautoAddTime
        param.addCount = param.addCount + param.autoAddCount
        param.autoAddAddTime = param.autoAddAddTime + 1
    end
end

function SurviveResource:_refreshPlayerResourceDiamond(playerData, dt)
    if self._addGoldClose then
        return
    end
    local param = self._refreshDiamondMap[playerData:getId()]
    param.totalDt = param.totalDt + dt
    if param.totalDt >= 0.1 then
        local mainActor = playerData:getMainActor()
        if param.lastFloat > 0 then
            y3.ui.create_floating_text2(mainActor:getUnit():get_point():move(100, -200, 0), "1264248026",
                '+' .. param.lastFloat,
                y3.const.FloatTextJumpType['金币跳字'], y3.player_group.get_all_players())
            param.lastFloat = 0
        end
    end
    if param.totalDt >= param.addInter then
        local mainActor = playerData:getMainActor()
        if mainActor and not mainActor:isDieFianl() then
            local goldAdd = mainActor:getUnit():get_attr("魂石成长")
            -- local addRatio = mainActor:getUnit():get_attr("金币成长加成(%)") / 100
            param.totalDt = param.totalDt - param.addInter
            local addCount = math.floor((goldAdd))
            local player = playerData:getPlayer()
            local gold = player:get_attr("diamond")
            gold = gold + addCount
            player:set("diamond", gold)
            param.totalDt = 0
            param.lastFloat = addCount
        end
    end
end

return SurviveResource
