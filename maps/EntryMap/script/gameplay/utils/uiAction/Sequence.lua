local ActionBase = include("gameplay.utils.uiAction.ActionBase")
local Sequence = class("Sequence", ActionBase)

function Sequence:ctor(onComplete)
    self.onComplete = onComplete
    self._actions = {}
    Sequence.super.ctor(self)
end

function Sequence:runAction(...)
    self._actions = table.pack(...)
    self._curIndex = 1
    Sequence.super.runAction(self)
end

function Sequence:runPure(...)
    self._actions = table.pack(...)
    self._curIndex = 1
    self:run(1)
end

function Sequence:getUI()
    if self._actions[1] then
        return self._actions[1]:getUI()
    end
end

function Sequence:tick(dt)
    if not self._start then
        return
    end
    local curAction = self._actions[self._curIndex]
    if not curAction then
        if self.onComplete then
            self.onComplete()
        end
        self._isDone = true
        self._start = false
        return
    end
    curAction:tick(dt)
    if curAction:isDone() then
        self._curIndex = self._curIndex + 1
    end
end

return Sequence
