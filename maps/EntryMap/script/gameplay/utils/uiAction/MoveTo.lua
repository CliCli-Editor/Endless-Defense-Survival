local ActionBase = include("gameplay.utils.uiAction.ActionBase")
local MoveTo = class("MoveTo", ActionBase)

function MoveTo:ctor(ui, fromPos, toPos, duration, onComplete)
    self.fromPos = fromPos
    self.toPos = toPos
    self.duration = duration
    self.onComplete = onComplete
    MoveTo.super.ctor(self, ui)
end

function MoveTo:tick(dt)
    if not self._start then
        return
    end
    self._totalDt = self._totalDt + dt
    local progress = self._easeFunc(math.min(1, self._totalDt / self.duration))
    local x = self.fromPos.x + (self.toPos.x - self.fromPos.x) * progress
    local y = self.fromPos.y + (self.toPos.y - self.fromPos.y) * progress
    self._ui:set_pos(x, y)
    if self._totalDt >= self.duration then
        self._start = false
        self._isDone = true
        if self.onComplete then
            self.onComplete()
        end
    end
end

return MoveTo
