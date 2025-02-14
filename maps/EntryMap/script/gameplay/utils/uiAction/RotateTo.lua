local ActionBase = include("gameplay.utils.uiAction.ActionBase")
local RotateTo = class("RotateTo", ActionBase)

function RotateTo:ctor(ui, fromRot, toRot, duration, onComplete)
    self.fromRot = fromRot
    self.toRot = toRot
    self.duration = duration
    self.onComplete = onComplete
    RotateTo.super.ctor(self, ui)
end

function RotateTo:tick(dt)
    if not self._start then
        return
    end
    self._totalDt = self._totalDt + dt
    local progress = self._easeFunc(math.min(1, self._totalDt / self.duration))
    local rot = self.fromRot + (self.toRot - self.fromRot) * progress
    self._ui:set_widget_relative_rotation(rot)
    if progress >= 1 then
        self._start = false
        self._isDone = true
        if self.onComplete then
            self.onComplete()
        end
    end
end

return RotateTo
