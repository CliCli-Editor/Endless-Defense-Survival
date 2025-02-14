local ActionBase = include("gameplay.utils.uiAction.ActionBase")
local ScaleTo = class("ScaleTo", ActionBase)

function ScaleTo:ctor(ui, fromScale, toScale, duration, onComplete)
    self.fromScale = fromScale
    self.toScale = toScale
    self.duration = duration
    self.onComplete = onComplete
    ScaleTo.super.ctor(self, ui)
end

function ScaleTo:tick(dt)
    if not self._start then
        return
    end
    self._totalDt = self._totalDt + dt
    local progress = self._easeFunc(math.min(1, self._totalDt / self.duration))
    local scalex = self.fromScale.x + (self.toScale.x - self.fromScale.x) * progress
    local scaley = self.fromScale.y + (self.toScale.y - self.fromScale.y) * progress
    self._ui:set_widget_absolute_scale(scalex, scaley)
    if self._totalDt >= self.duration then
        self._isDone = true
        self._start = false
        if self.onComplete then
            self.onComplete()
        end
    end
end

return ScaleTo
