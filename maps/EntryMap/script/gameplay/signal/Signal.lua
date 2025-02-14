local Signal = class("Signal")
local SlotList = include("gameplay.signal.SlotList")
local Slot = include("gameplay.signal.Slot")

function Signal:ctor()
    self._slots = SlotList.new()
end

function Signal:registerListener(listener, priority, once)
    local slot = Slot.new(self, priority)
    slot:addListener(listener, once)
    self._slots:insert(slot)
    return slot
end

function Signal:dispatch(...)
    self._slots:excute(...)
end

function Signal:remove(slot)
    self._slots:remove(slot)
end

return Signal
