local SignalManager = class("SignalManager")
local Signal = include("gameplay.signal.Signal")

function SignalManager:ctor()
    self._signalMaps = {}
    self._cacheId = 1
    self._curCacheId = nil
    self._cacheMap = {}
end

function SignalManager:add(id, listener, priority)
    return self:registerListener(id, listener, false, priority or 0)
end

function SignalManager:addOnce(id, listener, priority)
    return self:registerListener(id, listener, true, priority or 0)
end

function SignalManager:registerListener(id, listener, once, priority)
    local signal = self._signalMaps[id]
    if not signal then
        signal = Signal.new()
        self._signalMaps[id] = signal
    end
    local slot = signal:registerListener(listener, priority, once)
    if self._curCacheId then
        table.insert(self._cacheMap[self._curCacheId], slot)
    end
    return slot
end

function SignalManager:beginCache()
    self._curCacheId = self._cacheId
    self._cacheId = self._cacheId + 1
    self._cacheMap[self._curCacheId] = {}
    return self._curCacheId
end

function SignalManager:endCache()
    self._curCacheId = nil
end

function SignalManager:removeCache(id)
    local list = self._cacheMap[id] or {}
    for i = 1, #list do
        list[i]:remove()
    end
    self._cacheMap[id] = nil
end

function SignalManager:dispatch(id, ...)
    local signal = self._signalMaps[id]
    if signal then
        signal:dispatch(id, ...)
    end
end

return SignalManager
