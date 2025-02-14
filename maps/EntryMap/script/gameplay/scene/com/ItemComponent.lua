local ItemComponent = class("ItemComponent")

function ItemComponent:ctor(unit)
    self._unit = unit
    self._unit:event()
end

return ItemComponent
