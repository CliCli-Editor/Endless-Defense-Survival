local GameUtils = include "gameplay.utils.GameUtils"
local DropManager = class("DropManager")

function DropManager:ctor()
end

function DropManager:dropItem(id, point)
    local dropCfg = include("gameplay.config.drop").get(id)
    local rand = GameUtils.random(1, 100)
    if rand <= dropCfg.drop1_pro then
        local itemEx = y3.item.create_item(point, dropCfg.drop1)
        return itemEx
    elseif rand <= dropCfg.drop1_pro + dropCfg.drop2_pro then
        local itemEx = y3.item.create_item(point, dropCfg.drop2)
        return itemEx
    end
end

return DropManager
