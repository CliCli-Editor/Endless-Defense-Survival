local ActionBase = include("gameplay.utils.uiAction.ActionBase")
local Loop = class("Loop", ActionBase)

function Loop:ctor(onComplete)
    self.onComplete = onComplete
    Loop.super.ctor(self)
end

function Loop:runAction(action)
    self._action = action
    Loop.super.runAction(self)
end

function Loop:getUI()
    if self._action then
        return self._action:getUI()
    end
end

function Loop:tick(dt)
    if not self._start then
        return
    end
    self._action:tick(dt)
    if self._action:isDone() then
        self._action:resetDt()
    end
end

return Loop
