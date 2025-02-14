local ActionBase = include("gameplay.utils.uiAction.ActionBase")
local FadeTo = class("FadeTo", ActionBase)

function FadeTo:ctor(ui, fromAlpha, toAlpha, duration, onComplete)
    self.fromAlpha = fromAlpha
    self.toAlpha = toAlpha
    self.duration = duration
    self.onComplete = onComplete
    FadeTo.super.ctor(self, ui)
end

function FadeTo:tick(dt)
    if not self._start then
        return
    end
    self._totalDt = self._totalDt + dt
    local progress = self._easeFunc(math.min(1, self._totalDt / self.duration))
    local alpha = self.fromAlpha + (self.toAlpha - self.fromAlpha) * progress
    self._ui:set_alpha(alpha)
    if self._totalDt >= self.duration then
        self._start = false
        self._isDone = true
        if self.onComplete then
            self.onComplete()
        end
    end
end

return FadeTo
