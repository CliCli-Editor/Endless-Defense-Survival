local ActorItemComponent = class("ActorItemComponent")
-- -@field event fun(self: Item, event: "物品-获得", callback: fun(trg: Trigger, data: EventParam.物品-获得)): Trigger
-- -@field event fun(self: Item, event: "物品-进入物品栏", callback: fun(trg: Trigger, data: EventParam.物品-进入物品栏)): Trigger
-- -@field event fun(self: Item, event: "物品-进入背包", callback: fun(trg: Trigger, data: EventParam.物品-进入背包)): Trigger
-- -@field event fun(self: Item, event: "物品-失去", callback: fun(trg: Trigger, data: EventParam.物品-失去)): Trigger
-- -@field event fun(self: Item, event: "物品-离开物品栏", callback: fun(trg: Trigger, data: EventParam.物品-离开物品栏)): Trigger
-- -@field event fun(self: Item, event: "物品-离开背包", callback: fun(trg: Trigger, data: EventParam.物品-离开背包)): Trigger
-- -@field event fun(self: Item, event: "物品-使用", callback: fun(trg: Trigger, data: EventParam.物品-使用)): Trigger
-- -@field event fun(self: Item, event: "物品-堆叠变化", callback: fun(trg: Trigger, data: EventParam.物品-堆叠变化)): Trigger
-- -@field event fun(self: Item, event: "物品-充能变化", callback: fun(trg: Trigger, data: EventParam.物品-充能变化)): Trigger
-- -@field event fun(self: Item, event: "物品-创建", callback: fun(trg: Trigger, data: EventParam.物品-创建)): Trigger
-- -@field event fun(self: Item, event: "物品-移除", callback: fun(trg: Trigger, data: EventParam.物品-移除)): Trigger
-- -@field event fun(self: Item, event: "物品-出售", callback: fun(trg: Trigger, data: EventParam.物品-出售)): Trigger
-- -@field event fun(self: Item, event: "物品-死亡", callback: fun(trg: Trigger, data: EventParam.物品-死亡)): Trigger
-- -@field event fun(self: Item, event: "物品-采集创建", callback: fun(trg: Trigger, data: EventParam.物品-采集创建)): Trigger

function ActorItemComponent:ctor(actor)
    self._actor = actor
    self._unit = self._actor:getUnit()
    self._triggerList = {}
    self:addTrigger(y3.game:event("物品-获得", function(trg, data)
        if self._unit == data.unit then
            self:_onItemGet(trg, data)
        end
    end))
    self:addTrigger(y3.game:event("物品-进入物品栏", function(trg, data)
        if self._unit == data.unit then
            self:_onItemEnterItemBar(trg, data)
        end
    end))
    self:addTrigger(y3.game:event("物品-进入背包", function(trg, data)
        if self._unit == data.unit then
            self:_onItemEnterBag(trg, data)
        end
    end))
    self:addTrigger(y3.game:event("物品-失去", function(trg, data)
        if self._unit == data.unit then
            self:_onItemLose(trg, data)
        end
    end))
    self:addTrigger(y3.game:event("物品-离开物品栏", function(trg, data)
        if self._unit == data.unit then
            self:_onItemLeaveItemBar(trg, data)
        end
    end))
    self:addTrigger(y3.game:event("物品-离开背包", function(trg, data)
        if self._unit == data.unit then
            self:_onItemLeaveBag(trg, data)
        end
    end))
    self:addTrigger(y3.game:event("物品-使用", function(trg, data)
        if self._unit == data.unit then
            self:_onItemUse(trg, data)
        end
    end))
    self:addTrigger(y3.game:event("物品-堆叠变化", function(trg, data)
        if self._unit == data.unit then
            self:_onItemStackChange(trg, data)
        end
    end))
    self:addTrigger(y3.game:event("物品-充能变化", function(trg, data)
        if self._unit == data.unit then
            self:_onItemChargeChange(trg, data)
        end
    end))
    self:addTrigger(y3.game:event("物品-移除", function(trg, data)
        if self._unit == data.item:get_owner() then
            self:_onItemRemove(trg, data)
        end
    end))
    self:addTrigger(y3.game:event("物品-出售", function(trg, data)
        if self._unit == data.buy_unit or self._unit == data.shop_unit then
            self:_onItemSell(trg, data)
        end
    end))
    self:addTrigger(y3.game:event("物品-死亡", function(trg, data)
        if self._unit == data.unit then
            self:_onItemDie(trg, data)
        end
    end))
    self:addTrigger(y3.game:event("物品-采集创建", function(trg, data)
        if self._unit == data.unit then
            self:_onItemCollectCreate(trg, data)
        end
    end))
end

function ActorItemComponent:_onItemGet(trg, data)
    local unit = data.unit
    local item = data.item
    local item_no = data.item_no
    y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SURVIVE_GET_ITEM, unit:get_owner_player():get_id())
end

function ActorItemComponent:_onItemEnterItemBar(trg, data)
    local unit = data.unit
    local item = data.item
    local item_no = data.item_no
end

function ActorItemComponent:_onItemEnterBag(trg, data)
    local unit = data.unit
    local item = data.item
    local item_no = data.item_no
end

function ActorItemComponent:_onItemLose(trg, data)
    local unit = data.unit
    local item = data.item
    local item_no = data.item_no
end

function ActorItemComponent:_onItemLeaveItemBar(trg, data)
    local unit = data.unit
    local item = data.item
    local item_no = data.item_no
end

function ActorItemComponent:_onItemLeaveBag(trg, data)
    local unit = data.unit
    local item = data.item
    local item_no = data.item_no
end

function ActorItemComponent:_onItemUse(trg, data)
    local unit = data.unit
    local item = data.item
    local item_no = data.item_no

    if item and item:kv_has("cfgId") then
     
    end
end

function ActorItemComponent:_onItemStackChange(trg, data)
    local unit = data.unit
    local item = data.item
    local item_no = data.item_no
    local delta_cnt = data.delta_cnt
end

function ActorItemComponent:_onItemChargeChange(trg, data)
    local unit = data.unit
    local item = data.item
    local item_no = data.item_no
    local delta_cnt = data.delta_cnt
end

function ActorItemComponent:_onItemRemove(trg, data)
    local item = data.item
end

function ActorItemComponent:_onItemSell(trg, data)
    local unit = data.unit
    local unit2 = data.unit2
    local item = data.item
    local buy_unit = data.buy_unit
    local shop_unit = data.shop_unit
end

function ActorItemComponent:_onItemDie(trg, data)
    local item = data.item
    local unit = data.unit
end

function ActorItemComponent:_onItemCollectCreate(trg, data)
    local item = data.item
    local destructible = data.item
    local unit = data.unit
    local ability = data.ability
end

function ActorItemComponent:addTrigger(trigger)
    -- table.insert(self._triggerList, trigger)
    self._unit:bindGC(trigger)
end

function ActorItemComponent:clear()
    for i = 1, #self._triggerList do
        self._triggerList[i]:remove()
    end
    self._triggerList = {}
end

return ActorItemComponent
