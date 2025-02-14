local ActionBase = include("gameplay.utils.uiAction.ActionBase")
local MoveToX = class("MoveToX", ActionBase)

function MoveToX:ctor(ui, fromPos, toPos, duration, onComplete)
    self.fromPos = fromPos
    self.toPos = toPos
    self.duration = duration
    self.onComplete = onComplete
    MoveToX.super.ctor(self, ui)
end

function MoveToX:tick(dt)
    if not self._start then
        return
    end
    self._totalDt = self._totalDt + dt
    local progress = self._easeFunc(math.min(1, self._totalDt / self.duration))
    local x = self.fromPos.x + (self.toPos.x - self.fromPos.x) * progress
    local y = self._ui:get_relative_y()
    self._ui:set_pos(x, y)
    if self._totalDt >= self.duration then
        self._start = false
        self._isDone = true
        if self.onComplete then
            self.onComplete()
        end
    end
end

return MoveToX
