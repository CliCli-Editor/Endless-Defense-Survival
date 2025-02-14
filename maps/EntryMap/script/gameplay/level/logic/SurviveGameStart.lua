local LogicBase = include("gameplay.level.logic.LogicBase")
local SurviveGameStart = class("SurviveGameStart", LogicBase)

local AUTO_TIME = 10

function SurviveGameStart:ctor(level)
    SurviveGameStart.super.ctor(self, level)

    local stage_config = include("gameplay.config.stage_config")
    local len = stage_config.length()
    self._stageList = {}
    for i = 1, len do
        local cfg = stage_config.indexOf(i)
        if cfg.stage_type > 0 then
            table.insert(self._stageList, cfg)
        end
    end
    self._enterTime = 0
    self._startTime = 0
    self._autoTime = AUTO_TIME
    self._timerDefault = y3.gameApp:addTimerLoop(1, handler(self, self._onDefaultLogic))
    y3.game:event("键盘-按下", y3.const.KeyboardKey['SPACE'], handler(self, self._onSpacePressed))
    y3.game:event('鼠标-按下', y3.const.MouseKey['LEFT'], handler(self, self._onSpacePressed))
end

function SurviveGameStart:_onSpacePressed(trg, data)
    local player = data.player
    local roomMasterPlayerData = y3.userData:getRoomMasterPlayerData()
    if roomMasterPlayerData:getId() == player:get_id() then
        if not self._level:isGameStart() then
            y3.gameApp:getLevel():onReadyStart()
        end
    end
end

function SurviveGameStart:_onDefaultLogic(delay)
    local delay = delay:float()
    if self._enterTime > 0 then
        self._enterTime = self._enterTime - delay
        -- print(self._enterTime)
        if self._enterTime <= 0 then
            y3.gameApp:getLevel():onEnterStart()
        end
        y3.gameApp:dispatchEvent(y3.EventConst.EVENT_UPDATE_ENTER_TIME)
    end
    if self._startTime > 0 then
        self._startTime = self._startTime - delay
        if self._startTime <= 0 then
            y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SHOW_HUD)
        end
    end
end

function SurviveGameStart:startTimeEnter()
    self._enterTime = 5
end

function SurviveGameStart:getEnterTime()
    return self._enterTime
end

function SurviveGameStart:startTimeStart()
    self._startTime = 3
end

function SurviveGameStart:clearAutoStart()
end

return SurviveGameStart
