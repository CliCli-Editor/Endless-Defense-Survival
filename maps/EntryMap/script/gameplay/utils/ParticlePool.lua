local ParticlePool = class("ParticlePool")

function ParticlePool:ctor(parKey, maxSize)
    self._maxSize = maxSize or 200
    self._parKey = parKey
end

return ParticlePool
