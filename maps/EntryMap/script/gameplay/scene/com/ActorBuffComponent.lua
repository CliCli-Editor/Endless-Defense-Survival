local ActorBuffComponent = class("ActorBuffComponent")

-- -@field event fun(self: Unit, event: "效果-获得", callback: fun(trg: Trigger, data: EventParam.效果-获得)): Trigger
-- -@field event fun(self: Unit, event: "效果-失去", callback: fun(trg: Trigger, data: EventParam.效果-失去)): Trigger
-- -@field event fun(self: Unit, event: "效果-心跳", callback: fun(trg: Trigger, data: EventParam.效果-心跳)): Trigger
-- -@field event fun(self: Unit, event: "效果-叠加", callback: fun(trg: Trigger, data: EventParam.效果-叠加)): Trigger
-- -@field event fun(self: Unit, event: "效果-层数变化", callback: fun(trg: Trigger, data: EventParam.效果-层数变化)): Trigger
-- -@field event fun(self: Unit, event: "效果-即将获得", callback: fun(trg: Trigger, data: EventParam.效果-即将获得)): Trigger
-- -@field event fun(self: Unit, event: "效果-覆盖", callback: fun(trg: Trigger, data: EventParam.效果-覆盖)): Trigger
function ActorBuffComponent:ctor(actor)
    self._actor = actor
    self._unit = self._actor:getUnit()
    -- self:addTrigger(self._unit:event("效果-获得", self._onEffectGet))
    -- self:addTrigger(self._unit:event("效果-失去", self._onEffectLost))
    -- self:addTrigger(self._unit:event("效果-心跳", self._onEffectHeartBeat))
    -- self:addTrigger(self._unit:event("效果-叠加", self._onEffectStack))
    -- self:addTrigger(self._unit:event("效果-层数变化", self._onEffectLayerChange))
    -- self:addTrigger(self._unit:event("效果-即将获得", self._onEffectWillGet))
    -- self:addTrigger(self._unit:event("效果-覆盖", self._onEffectCover))
    self._triggerList = {}
end

function ActorBuffComponent:_onEffectGet(trg, data)

end

function ActorBuffComponent:_onEffectLost(trg, data)

end

function ActorBuffComponent:_onEffectHeartBeat(trg, data)

end

function ActorBuffComponent:_onEffectStack(trg, data)

end

function ActorBuffComponent:_onEffectLayerChange(trg, data)

end

function ActorBuffComponent:_onEffectWillGet(trg, data)

end

function ActorBuffComponent:_onEffectCover(trg, data)

end

function ActorBuffComponent:addTrigger(trigger)
    -- table.insert(self._triggerList, trigger)
    self._unit:bindGC(trigger)
end

function ActorBuffComponent:clear()
    for i = 1, #self._triggerList do
        self._triggerList[i]:remove()
    end
    self._triggerList = {}
end

return ActorBuffComponent
