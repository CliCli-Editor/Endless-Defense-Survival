local ActionBase = include("gameplay.utils.uiAction.ActionBase")
local Spawn = class("Spawn", ActionBase)

function Spawn:ctor(onComplete)
    self.onComplete = onComplete
    self._actions = {}
    Spawn.super.ctor(self)
end

function Spawn:getUI()
    if self._actions[1] then
        return self._actions[1]:getUI()
    end
end

function Spawn:runAction(...)
    self._actions = table.pack(...)
    self._curIndex = 1
    Spawn.super.runAction(self)
end

function Spawn:runPure(...)
    self._actions = table.pack(...)
    self._curIndex = 1
    self:run(1)
end

function Spawn:tick(dt)
    if not self._start then
        return
    end
    local isAllDone = true
    for i = 1, #self._actions do
        self._actions[i]:tick(dt)
        if not self._actions[i]:isDone() then
            isAllDone = false
        end
    end
    if isAllDone then
        if self.onComplete then
            self.onComplete()
        end
        self._isDone = true
        self._start = false
    end
end

return Spawn
