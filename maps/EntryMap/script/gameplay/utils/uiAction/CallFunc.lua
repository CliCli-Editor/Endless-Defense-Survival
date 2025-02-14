local ActionBase = include("gameplay.utils.uiAction.ActionBase")
local CallFunc = class("CallFunc", ActionBase)

function CallFunc:ctor(ui, onComplete)
    self.onComplete = onComplete
    CallFunc.super.ctor(self, ui)
end

function CallFunc:tick(dt)
    if not self._start then
        return
    end
    if self.onComplete then
        self.onComplete()
    end
    self._start = false
    self._isDone = true
end

return CallFunc
