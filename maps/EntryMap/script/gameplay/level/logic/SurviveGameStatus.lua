local LogicBase = include("gameplay.level.logic.LogicBase")
local SurviveGameStatus = class("SurviveGameStatus", LogicBase)
local GlobalConfigHelper = include("gameplay.level.logic.helper.GlobalConfigHelper")

function SurviveGameStatus:ctor(level)
    SurviveGameStatus.super.ctor(self, level)
    self._status = y3.SurviveConst.GAME_STATUS_READY
    self._readyTime = GlobalConfigHelper.getGameReadyTime()
    y3.gameApp:addTimerLoop(1, handler(self, self._checkStatus))
    self._killRecord = {}
    self._totalGameTime = 0
    self._readyEndTotalTime = 0
    y3.ltimer.loop_frame(2, handler(self, self._loopcheckAttrs))
    y3.game:event("键盘-按下", y3.const.KeyboardKey['SPACE'], function(trg, data)
        local player = data.player
        local playerData = y3.userData:getPlayerData(player:get_id())
        local mainActor = playerData:getMainActor()
        if mainActor then
            y3.gameApp:moveCameraToPoint(player, mainActor:getPosition())
            player:select_unit(mainActor:getUnit())
        end
    end)
    local offsets = GlobalConfigHelper.getGameStartOffset()
    assert(offsets, "")
    local allPlayers = y3.userData:getAllInPlayers()
    self._fastStartCount = 0
    self._fastStartMap = {}
    self._playerSceneUI = {}
    -- 接收UI事件
    y3.game:event('界面-消息', '立即开始', function(trg, data)
        -- print("立即开始")
        local player = data.player
        if not self._fastStartMap[player] then
            self._fastStartCount = self._fastStartCount + 1
            self._fastStartMap[player] = true
            local playerNum = y3.userData:getPlayerCount()
            if self._fastStartCount >= playerNum then
                self._readyTime = 0.1
            end
            -- 51 {player_name}已准备，当前状态{ready}/{sum}，当所有玩家都准备时，可立即开始！
            y3.Sugar.NoticeAll(51,
                { player_name = player:get_name(), ready = self._fastStartCount, sum = playerNum })
        end
    end)
    for _, playerData in ipairs(allPlayers) do
        local player = playerData:getPlayer()
        local pointStart = y3.point.get_point_by_res_id(y3.userDataHelper.getPlayerSpawnPointId(player:get_id()))
        pointStart = pointStart:move(tonumber(offsets[1]), tonumber(offsets[2]), 0)
        local ui = y3.scene_ui.create_scene_ui_at_point("start_game", pointStart, 0, 300)
        if player:get_id() == y3.gameApp:getMyPlayerId() then
            ui:set_scene_ui_visible_distance(player, 10000)
        else
            ui:set_scene_ui_visible_distance(y3.player(y3.gameApp:getMyPlayerId()), 0)
        end
        self._playerSceneUI[player:get_id()] = ui
        local startBtn = ui:get_ui_comp_in_scene_ui(player, "start_BTN")
        startBtn:add_event('左键-点击', "立即开始", {
            custom = '自定义数据',
        })
    end
    self:_updateSceneUIProgress()
end

function SurviveGameStatus:_updateSceneUIProgress()
    local allPlayers = y3.userData:getAllInPlayers()
    for _, playerData in ipairs(allPlayers) do
        local player = playerData:getPlayer()
        local ui = self._playerSceneUI[player:get_id()]
        if self._readyTime > 0 then
            if ui then
                local progress = self._readyTime / GlobalConfigHelper.getGameReadyTime() * 100
                local progressUI = ui:get_ui_comp_in_scene_ui(player, "start_BTN.progress_BAR")
                progressUI:set_current_progress_bar_value(progress, 0.5)
            end
        else
            if ui then
                ui:remove_scene_ui()
                self._playerSceneUI[player:get_id()] = nil
            end
        end
    end
end

function SurviveGameStatus:_loopcheckAttrs()
    local allPlayers = y3.userData:getAllInPlayers()
    for _, playerData in ipairs(allPlayers) do
        local mainActor = playerData:getMainActor()
        if mainActor then
            local attrs = mainActor:getRecordAttrChanges()
            if #attrs > 0 then
                y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SURVIVE_ATTR_CHANGE,
                    playerData:getId(), attrs)
            end
            mainActor:clearRecordAttrChanges()
        end
    end
end

function SurviveGameStatus:updateStatus()
end

function SurviveGameStatus:_checkStatus(delay)
    if not self._level:isGameStart() then
        return
    end
    self._totalGameTime = self._totalGameTime + delay:float()
    if self._status == y3.SurviveConst.GAME_STATUS_READY then
        if self._readyTime > 0 then
            self._readyTime = self._readyTime - delay:float()
            -- PrintGame("准备倒计时:", self._readyTime)
            if self._readyTime > 0 then
                y3.G_PromptMgr:showNotice(1, { sec = math.floor(self._readyTime + 0.5) })
            end
            y3.gameApp:dispatchEvent(y3.EventConst.EVENT_READY_COUNT_DOWN)
            self:_updateSceneUIProgress()
        else
            self._status = y3.SurviveConst.GAME_STATUS_BATTLE
        end
    else
        self._readyEndTotalTime = self._readyEndTotalTime + delay:float()
    end
end

function SurviveGameStatus:getTotalGameTime()
    return self._totalGameTime
end

function SurviveGameStatus:getReadyEndTotalTime()
    return self._readyEndTotalTime
end

function SurviveGameStatus:isInBattle()
    return self._status == y3.SurviveConst.GAME_STATUS_BATTLE
end

function SurviveGameStatus:getGameStatus()
    return self._status
end

function SurviveGameStatus:addRecordKillNum(playerId)
    if not self._killRecord[playerId] then
        self._killRecord[playerId] = 0
    end
    self._killRecord[playerId] = self._killRecord[playerId] + 1
end

return SurviveGameStatus
