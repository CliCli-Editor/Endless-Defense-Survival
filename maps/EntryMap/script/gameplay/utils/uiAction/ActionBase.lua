local GameUtils = require "gameplay.utils.GameUtils"
local ActionBase = class("ActionBase")

function ActionBase:ctor(ui)
    self._ui = ui
    self._isDone = false
    self._start = false
    self._totalDt = 0
end

function ActionBase:getUI()
    return self._ui
end

function ActionBase:stop()
    self._start = false
    self._isDone = true
end

function ActionBase:runAction(easeType)
    self:run(easeType)
    y3.UIActionMgr:addUIAction(self)
    self:tick(0)
end

function ActionBase:run(easeType)
    self._start = true
    self._easeType = easeType
    self._totalDt = 0
    self._easeFunc = GameUtils.easeMap[easeType]
end

function ActionBase:resetDt()
    self._totalDt = 0
    self._start = true
    self._isDone = false
end

function ActionBase:tick(dt)
end

function ActionBase:isDone()
    return self._isDone
end

return ActionBase
