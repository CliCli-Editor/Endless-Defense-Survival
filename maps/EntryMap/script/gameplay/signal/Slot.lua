local Slot = class("Slot")

function Slot:ctor(signal, priority)
    self._listener = nil
    self._once = false
    self._signal = signal
    self._priority = priority or 0
end

function Slot:addListener(listener, once)
    self._listener = listener
    self._once = once or false
end

function Slot:excute(...)
    if self._listener then
        self._listener(...)
    end
    if self._once then
        self:remove()
        self._listener = nil
    end
end

function Slot:getPriority()
    return self._priority
end

function Slot:remove()
    self._signal:remove(self)
end

return Slot
