local BaseData = include("gameplay.base.BaseData")
local ItemData = class("ItemData", BaseData)

local shcema = {}
ItemData.schema = shcema

function ItemData:ctor()
    ItemData.super.ctor(self)
    self._items = {}
end

return ItemData
