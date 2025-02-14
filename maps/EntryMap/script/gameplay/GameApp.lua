local GameConst = include "gameplay.const.GameConst"
local GameApp   = class("GameApp")


function GameApp:ctor()
    self._my_playerId = 1
    y3.config.sync.mouse = true
    self._frameCount = 0
    self._hookTimers = {}
    self._triggerList = {}
    self._recordTriggers = {}
    self._updateFuncMap = {}
    self._localTimers = {}
    self._localTimerId = 1
    self._localTimerRemoveList = {}
    self._easKey = self:getEasKeyStr()
    self._easIv = self:getEasKeyStr()
    self._gameMode = 0
    self._gameSubMode = 0
    self._mouseWorldPos = {}
    self._mouseScreenPos = {}
    self._localMousePos = { x = 0, y = 0 }
    self._pause = false

    self._isShowDamageText = true
    self._isShowEffect = true
end

function GameApp:setShowDamageText(show)
    self._isShowDamageText = show
end

function GameApp:setShowEffect(show)
    self._isShowEffect = show
end

function GameApp:isShowDamageText()
    return self._isShowDamageText
end

function GameApp:isShowEffect()
    return self._isShowEffect
end

function GameApp:isPause()
    return self._pause
end

function GameApp:setPause(pause)
    self._pause = pause
    if self._pause then
        y3.game.enable_soft_pause()
    else
        y3.game.resume_soft_pause()
    end
end

function GameApp:getEasKeyStr()
    local peplenish = "3256974563214569"
    return peplenish
end

function GameApp:encryptString(str)
    local result = y3.aes.encrypt(self._easKey, self._easIv, tostring(str))
    result = y3.base64.encode(result)
    return result
end

function GameApp:isArchiveDataExists(archiveData, encryptedKey)
    if not archiveData or not encryptedKey then
        return false
    end

    if archiveData[encryptedKey] then
        return true
    end

    local correctivedKey = string.gsub(encryptedKey, "=", ":")
    if archiveData[correctivedKey] then
        return true
    end

    return false
end

function GameApp:getArchiveData(archiveData, encryptedKey)
    if not archiveData or not encryptedKey then
        return nil
    end

    if archiveData[encryptedKey] then
        return archiveData[encryptedKey]
    end

    local correctivedKey = string.gsub(encryptedKey, "=", ":")
    if archiveData[correctivedKey] then
        return archiveData[correctivedKey]
    end

    return nil
end

function GameApp:decryptString(str)
    local result = string.gsub(str, ":", "=")
    result = y3.base64.decode(result)
    result = y3.aes.decrypt(self._easKey, self._easIv, result)
    return result
end

function GameApp:getLocalTimerId()
    local tempId = self._localTimerId
    self._localTimerId = self._localTimerId + 1
    return tempId
end

function GameApp:addUpdateFunc(obj)
    table.insert(self._updateFuncMap, obj)
end

function GameApp:removeUpdateFunc(objxx)
    for i, obj in ipairs(self._updateFuncMap) do
        if obj == objxx then
            table.remove(self._updateFuncMap, i)
            break
        end
    end
end

function GameApp:setGameMode(gameMode)
    self._gameMode = gameMode
end

function GameApp:setSubGameMode(gameSubMode)
    self._gameSubMode = gameSubMode
end

function GameApp:_initWindow(player)
    y3.game.toggle_day_night_time(false)
end

function GameApp:addTrigger(trigger)
    table.insert(self._triggerList, trigger)
end

function GameApp:onSave()
    self._level:onSave()
end

function GameApp:clear()
    for i = 1, #self._triggerList do
        self._triggerList[i]:remove()
    end
    self._triggerList = {}
    self._mainTimer:remove()
    self._mainTimer = nil
    for i, timer in ipairs(self._hookTimers) do
        if timer and y3.class.isValid(timer) then
            timer:remove()
        end
    end
    self._hookTimers = {}
    if self._level then
        self._level:clear()
        self._level = nil
    end
    for i, trigger in ipairs(self._recordTriggers) do
        if trigger and y3.class.isValid(trigger) then
            trigger:remove()
            trigger = nil
        end
    end
    -- y3.Permanent:clear()
    self._recordTriggers = {}
    self._updateFuncMap = {}
    self._localTimers = {}
end

function GameApp:onHookTimer(timer)
    table.insert(self._hookTimers, timer)
end

function GameApp:onHookTrigger(trigger)
    table.insert(self._recordTriggers, trigger)
end

function GameApp:_registerEvent()
    self:addTrigger(y3.game:event('鼠标-按下', y3.const.MouseKey['LEFT'], handler(self, self._onMouseDown)))
    self:addTrigger(y3.game:event('鼠标-抬起', y3.const.MouseKey['LEFT'], handler(self, self._onMouseUp)))
    self:addTrigger(y3.game:event('鼠标-按下', y3.const.MouseKey['RIGHT'], handler(self, self._onMouseRightDown)))
    self:addTrigger(y3.game:event('鼠标-抬起', y3.const.MouseKey['RIGHT'], handler(self, self._onMouseRightUp)))
    self:addTrigger(y3.game:event('鼠标-移动', handler(self, self._onMouseMove)))
    self:addTrigger(y3.game:event('选中-单位', handler(self, self._onSelectUnit)))
    self:addTrigger(y3.game:event('选中-单位组', handler(self, self._onSelectUnitGroup)))
    self:addTrigger(y3.game:event("本地-鼠标-移动", handler(self, self._onLocalMouseMove)))
    self._mainTimer = y3.ltimer.loop_frame(1, handler(self, self._mainLoop))
end

function GameApp:moveCameraToPoint(player, point, time)
    local newPoint = point:move(0, 0, 0)
    y3.camera.set_distance(player, 5600, 1 / 30)
    y3.ltimer.wait(2 / 30, function(timer, count)
        y3.eca.call('设定可视范围', player, newPoint)
    end)
end

function GameApp:removeTimer(id)
    for i, data in ipairs(self._localTimers) do
        if data.id == id then
            data.valid = false
            break
        end
    end
end

function GameApp:_realRemoveTimer(id)
    for i, data in ipairs(self._localTimers) do
        if data.id == id then
            table.remove(self._localTimers, i)
            break
        end
    end
end

function GameApp:addTimer(delay, callback)
    local data = {}
    data.id = self:getLocalTimerId()
    data.delay = Fix32(delay)
    data.dt = Fix32(0)
    data.callback = callback
    data.valid = true
    data.loopCount = 1
    table.insert(self._localTimers, data)
    return data.id
end

function GameApp:addTimerLoop(delay, callback)
    local data = {}
    data.id = self:getLocalTimerId()
    data.delay = Fix32(delay)
    data.dt = Fix32(0)
    data.callback = callback
    data.valid = true
    data.loopCount = -1
    table.insert(self._localTimers, data)
    return data.id
end

function GameApp:addTimerCount(delay, count, callback)
    local data = {}
    data.id = self:getLocalTimerId()
    data.delay = Fix32(delay)
    data.dt = Fix32(0)
    data.callback = callback
    data.valid = true
    data.loopCount = count
    table.insert(self._localTimers, data)
    return data.id
end

function GameApp:_mainLoop(timer, count)
    
    local deltatime = Fix32(1 / y3.GameConst.GAME_FPS)
    y3.ActionMgr:update(deltatime)
    for i, obj in ipairs(self._updateFuncMap) do
        obj:updateLoop(1)
    end
    for i, data in ipairs(self._localTimers) do
        if data.valid then
            data.dt = data.dt + deltatime
            if data.dt >= data.delay then
                data.dt = data.dt - data.delay
                data.callback(data.delay)
                if data.loopCount > 0 then
                    data.loopCount = data.loopCount - 1
                    if data.loopCount == 0 then
                        data.valid = false
                    end
                end
            end
        end
        if data.valid == false then
            table.insert(self._localTimerRemoveList, data)
        end
    end
    for i, data in ipairs(self._localTimerRemoveList) do
        self:_realRemoveTimer(data.id)
    end
    self._localTimerRemoveList = {}
end

function GameApp:run()
    -- print("关卡Id:", GameAPI.get_current_level())
    y3.game.set_game_speed(1)
    self:_registerEvent()
    self:_initWindow()
    self:initLevelMap()
end

function GameApp:getAllRealPlayers()
    local playerGroup = y3.player_group.get_all_players()
    local players = playerGroup:pick()
    local result = {}
    for i, player in ipairs(players) do
        if not y3.GameConst.INVALID_ROLE[player:get_id()] then
            table.insert(result, player)
        end
    end
    return result
end

function GameApp:initLevelMap()
    local levelMap = include("gameplay.level.init")
    local mapName = y3.LevelMgr:getCurLevelName()
    -- print("当前地图:", mapName)
    local levelClass = levelMap["project_tatata"]
    if levelClass then
        self._level = levelClass.new()
    end
end

function GameApp:getLevel()
    return self._level
end

function GameApp:getGameLogic()
    return self._level:getGameLogic()
end

function GameApp:restart()
    -- -@class HttpRequestOptions
    -- -@field post? boolean # post 请求还是 get 请求
    -- -@field port? integer # 端口号
    -- -@field timeout? number # 超时时间，默认为2秒
    -- -@field headers? table # 请求头
    GameAPI.request_switch_level(GameAPI.get_current_level())
    -- y3.game:request_url("https://kk.yigenta.game/version?gameId=yigenta", "", function(body)
    --     if body == nil then
    --         y3.player.with_local(function(local_player)
    --             log.info("网络请求失败，请重进游戏")
    --             y3.game.end_player_game(local_player, "", false)
    --         end)
    --     elseif body == GAME_VERSION then
    --         GameAPI.request_switch_level(GameAPI.get_current_level())
    --     else
    --         y3.player.with_local(function(local_player)
    --             log.info("游戏版本不匹配，请更新游戏")
    --             y3.game.end_player_game(local_player, "", false)
    --         end)
    --     end
    -- end, { post = true, timeout = 2, port = 6688 })
end

function GameApp:registerEvent(eventId, callback)
    local triger = y3.game:get_event_manager():event(eventId, nil, callback)
    return triger
end

function GameApp:dispatchEvent(eventId, ...)
    local args = { ... }
    xpcall(function(...)
        y3.game:get_event_manager():dispatch(eventId, nil, table.unpack(args))
    end, __G__TRACKBACK__)
end

function GameApp:dispatchLocalEvent(playerId, eventId, ...)
    local args = { ... }
    xpcall(function(...)
        y3.player.with_local(function(local_player)
            if playerId == local_player:get_id() then
                y3.game:get_event_manager():dispatch(eventId, nil, table.unpack(args))
            end
        end)
    end, __G__TRACKBACK__)
end

function GameApp:_onMouseDown(trg, data)
    self._isclick = true
    y3.game:get_event_manager():dispatch(y3.EventConst.EVENT_MOUSE_DOWN, trg, data)
end

function GameApp:_onMouseUp(trg, data)
    self._isclick = false
    y3.game:get_event_manager():dispatch(y3.EventConst.EVENT_MOUSE_UP, trg, data)
end

function GameApp:_onMouseRightDown(trg, data)
    y3.game:get_event_manager():dispatch(y3.EventConst.EVENT_MOUSE_RIGHT_DOWN, trg, data)
end

function GameApp:_onMouseRightUp(trg, data)
    y3.game:get_event_manager():dispatch(y3.EventConst.EVENT_MOUSE_RIGHT_UP, trg, data)
end

function GameApp:_onMouseMove(trg, data)
    local player = data.player
    local world_pos = data.pointing_world_pos
    local screen_x = data.tar_x
    local screen_y = data.tar_y
    self._mouseWorldPos[player:get_id()] = world_pos
    self._mouseScreenPos[player:get_id()] = { x = screen_x, y = screen_y }
    y3.game:get_event_manager():dispatch(y3.EventConst.EVENT_MOUSE_MOVE, trg, data)
end

function GameApp:getMouseScreenPos(playerId)
    return self._mouseScreenPos[playerId] or { x = 0, y = 0 }
end

function GameApp:_onSelectUnit(trg, data)
    if data.player:get_id() == self:getMyPlayerId() then
        y3.game:get_event_manager():dispatch(y3.EventConst.EVENT_SELECT_UNIT, trg, data)
    end
end

function GameApp:_onSelectUnitGroup(trg, data)
    if data.player:get_id() == self:getMyPlayerId() then
    end
end

function GameApp:_onLocalMouseMove(trg, data)
    self._localMousePos = { x = data.tar_x, y = data.tar_y }
end

function GameApp:getLocalMousePos()
    return self._localMousePos
end

function GameApp:getLocalMousePosUnpack()
    return self._localMousePos.x, self._localMousePos.y
end

function GameApp:getMainUnit()
    return self._level:getMainUnit()
end

function GameApp:getMyPlayerId()
    return self._my_playerId
end

function GameApp:setMyPlayerId(id)
    self._my_playerId = id
end

return GameApp
