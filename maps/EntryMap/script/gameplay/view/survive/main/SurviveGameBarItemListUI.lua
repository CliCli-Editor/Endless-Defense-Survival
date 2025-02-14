local SurviveGameBarItemListUI = class("SurviveGameBarItemListUI")

function SurviveGameBarItemListUI:ctor()
    self._ui = y3.UIHelper.getUI("b62f424a-1eb4-45ec-bf7f-246617c61d9c")
    self._ui:set_visible(true)
    self._itemList = y3.UIHelper.getUI("40da52b2-145f-4cb8-b744-8faa83719b1e")
    self._itemCards = {}
    y3.gameApp:registerEvent(y3.EventConst.EVENT_SURVIVE_GET_ITEM, handler(self, self._onEventGetItem))
    self:_updateList()
end

function SurviveGameBarItemListUI:_onEventGetItem(trg, playerId)
    print("SurviveGameBarItemListUI:_onEventGetItem")
    if playerId == y3.gameApp:getMyPlayerId() then
        self:_updateList()
    end
end

function SurviveGameBarItemListUI:_updateList()
    -- local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    -- local mainActor = playerData:getMainActor()
    -- local mainUnit = mainActor:getUnit()
    -- local groups = mainUnit:get_all_items()
    -- local items = groups:pick()
    -- local cells = self._itemList:get_childs()
    -- local index = 1
    -- for i = 1, #cells do
    --     local item = items[index]
    --     if item then
    --         print("item", item:get_stack())
    --     end
    --     if item and item:get_stack() > 0 then
    --         index = index + 1
    --         local card = self._itemCards[i]
    --         if not card then
    --             card = include("gameplay.view.survive.main.SurviveGameBarItem").new(cells[i]:get_child("equip_slot"))
    --             self._itemCards[i] = card
    --         end
    --         cells[i]:get_child("equip_slot"):set_visible(true)
    --         card:updateUI(item, mainUnit)
    --     else
    --         cells[i]:get_child("equip_slot"):set_visible(false)
    --     end
    -- end
end

return SurviveGameBarItemListUI
