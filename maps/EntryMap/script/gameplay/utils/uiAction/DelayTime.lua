local ActionBase = include("gameplay.utils.uiAction.ActionBase")
local DelayTime = class("DelayTime", ActionBase)

function DelayTime:ctor(ui, duration, onComplete)
    self.duration = duration
    self.onComplete = onComplete
    DelayTime.super.ctor(self, ui)
end

function DelayTime:tick(dt)
    if not self._start then
        return
    end
    self.duration = self.duration - dt
    if self.duration <= 0 then
        self._start = false
        self._isDone = true
        if self.onComplete then
            self.onComplete()
        end
    end
end

return DelayTime
