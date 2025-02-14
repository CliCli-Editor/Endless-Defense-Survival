local SurviveHelper = include "gameplay.level.logic.helper.SurviveHelper"
local SurviveGameAbyssShopUI = class("SurviveGameAbyssShopUI")

function SurviveGameAbyssShopUI:ctor(root)
    self._root = root
    self._ui   = y3.UIHelper.getUI("0523b950-8af4-4bfa-bc7f-d33ebebfd10b")
    self._bg   = y3.UIHelper.getUI("7b095060-dfdc-432a-a69a-441699b52980")
    self._bg:set_intercepts_operations(true)
    self._content                = y3.UIHelper.getUI("ae155230-5241-4acd-9bb8-56791fbf54e4")

    -- self._shopList = y3.UIHelper.getUI("2dc4f256-51f6-4a62-acaa-d6287a9a8238")

    self._shopCloseBtn           = y3.UIHelper.getUI("aaf1ed61-66c0-48cb-bd65-5d9b3544a26e")
    self._shopRefreshBtn         = y3.UIHelper.getUI("38ce84aa-0f2b-4635-b190-bdd5c76e4398")
    self._refreshText            = y3.UIHelper.getUI("df162654-b688-404f-8390-6269f91058fe")
    self._shopRefreshContentText = y3.UIHelper.getUI("5f558fa7-80f4-4b0d-a02b-349d2d57264a")
    self._next_BTN               = y3.UIHelper.getUI("87f9380c-a566-4dd3-bc3a-3585d0b5af05")
    self._previous_BTN           = y3.UIHelper.getUI("52099d16-298e-4231-9c8a-97588c8f879c")
    self._res_value_TEXT         = y3.UIHelper.getUI("569787a7-0975-4ad8-bede-48926f1a4eaa")
    self._refreshIconImg         = y3.UIHelper.getUI("9f8c5c47-3f96-4853-972a-613418f10631")
    self._refreshResValueText    = y3.UIHelper.getUI("df162654-b688-404f-8390-6269f91058fe")
    self._tip_TEXT               = y3.UIHelper.getUI("56735831-cb8c-4d3d-b8d5-e75ce28a327f")
    self._refreshBtnText         = y3.UIHelper.getUI("d0e6d830-926f-4749-aeba-f70650b8bc73")
    self._levelExpBar            = y3.UIHelper.getUI("8a9cf6ba-cd0f-4284-b420-de8ad2c14f69")
    self._levelExpText           = y3.UIHelper.getUI("8f1f0f18-2637-4c25-990a-7b3e76e19786")
    self._levelText              = y3.UIHelper.getUI("88e95e6b-e4b9-4ddd-b258-48d71832e871")

    self._tip_TEXT:set_text("1/1")
    self._refreshBtnText:set_text(y3.Lang.get("shuaxinheishi"))

    y3.gameApp:registerEvent(y3.EventConst.EVENT_SURVIVE_ABYSS_FLOOY_UPDATE,
        handler(self, self._onEventSurviveFloorUpdate))
    y3.gameApp:registerEvent(y3.EventConst.EVENT_SURVIVE_GAME_ABYSS_SHOP_REFRESH,
        handler(self, self._onEventSurviveGameAbyssShopRefresh))
    y3.gameApp:registerEvent(y3.EventConst.EVENT_SURVIVE_GAME_ABYSS_SHOP_BUY,
        handler(self, self._onEventSurviveGameAbyssShopBuy))
    y3.gameApp:registerEvent(y3.EventConst.EVENT_SURVIVE_RESOURCE_ADD_GOLD,
        handler(self, self._onEventResourceAddGold))
    y3.gameApp:registerEvent(y3.EventConst.EVENT_SURVIVE_REFRESH_DPS, handler(self, self._onEventRefreshDps))

    self:initShopUIList()
    self:updateList()
    self:updateTips()

    self._shopCloseBtn:add_local_event('左键-按下', handler(self, self._onShopCloseBtnClick))
    self._shopRefreshBtn:add_local_event('左键-按下', handler(self, self._onShopRefreshBtnClick))
    self._next_BTN:add_local_event('左键-按下', handler(self, self._onNextBtnClick))
    self._previous_BTN:add_local_event('左键-按下', handler(self, self._onPreviousBtnClick))
end

function SurviveGameAbyssShopUI:_onEventResourceAddGold(trg, player)
    if player:get_id() == y3.gameApp:getMyPlayerId() then
        if self._ui:is_visible() then
            self:updateTips()
            self:updateList()
        end
    end
end

function SurviveGameAbyssShopUI:_onEventRefreshDps(trg, playerId)
    if self._ui:is_visible() then
        self:updateTips()
        self:updateList()
    end
end

function SurviveGameAbyssShopUI:_onNextBtnClick(local_player)

end

function SurviveGameAbyssShopUI:_onPreviousBtnClick(local_player)

end

function SurviveGameAbyssShopUI:initShopUIList()
    self._shopCards = {}
    local childs = self._content:get_childs()
    local index = 1
    for _, child in ipairs(childs) do
        local cells = child:get_childs()
        for _, cell in ipairs(cells) do
            local idx = index
            self._shopCards[index] = include("gameplay.view.survive.main.SurviveGameAbyssShopCard").new(cell)
            cell:add_local_event('左键-点击', function()
                self:_onCardClick(idx)
            end)
            cell:add_local_event('右键-点击', function()
                self:_onCardRightClick(idx)
            end)
            index = index + 1
        end
    end
end

function SurviveGameAbyssShopUI:_onShopCloseBtnClick(local_player)
    self:show(false)
end

function SurviveGameAbyssShopUI:show(viis)
    if viis then
        local abyssChallenge = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy"):getAbysChallenge()
        local abyssShop = abyssChallenge:getShop()
        local time, maxtime, cnt = abyssShop:getShopParam(y3.gameApp:getMyPlayerId())
        if cnt == 0 then
            local min = math.floor(time / 60)
            local sec = math.floor(time % 60)
            y3.Sugar.localTips(y3.gameApp:getMyPlayerId(),
                y3.Lang.getLang(y3.langCfg.get(10).str_content, { min = min, sec = sec }))
            return
        end
    end
    self._ui:set_visible(viis)
    if viis then
        self:updateList()
        self:updateTips()
    end
end

function SurviveGameAbyssShopUI:isVisible()
    return self._ui:is_visible()
end

function SurviveGameAbyssShopUI:_onShopRefreshBtnClick(local_player)
    y3.SyncMgr:sync(y3.SyncConst.SYNC_SURVIVE_REFRESH_ABYSS_SHOP, {})
end

function SurviveGameAbyssShopUI:_onEventSurviveFloorUpdate(trg, playerId)
    if y3.gameApp:getMyPlayerId() == playerId then
        self:updateTips()
    end
end

function SurviveGameAbyssShopUI:_onEventSurviveGameAbyssShopRefresh(trg, playerId)
    if y3.gameApp:getMyPlayerId() == playerId then
        self:updateList()
    end
end

function SurviveGameAbyssShopUI:_onEventSurviveGameAbyssShopBuy(trg, playerId)
    print("SurviveGameAbyssShopUI:_onEventSurviveGameAbyssShopBuy", playerId)
    if y3.gameApp:getMyPlayerId() == playerId then
        self:updateList()
    end
end

function SurviveGameAbyssShopUI:updateList()
    local playerId = y3.gameApp:getMyPlayerId()
    local abyssChallenge = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy"):getAbysChallenge()
    local abyssShop = abyssChallenge:getShop()
    local itemList = abyssShop:getShopItemList(playerId)
    local shopLv = abyssShop:getCurShopLv(playerId)
    local curExp = abyssShop:getCurShopExp(playerId)
    local maxExp = abyssShop:getMaxExp(playerId)
    self._levelText:set_text(shopLv)
    if maxExp > 0 then
        local pro = curExp / maxExp * 100
        self._levelExpBar:set_current_progress_bar_value(pro)
        self._levelExpText:set_text(curExp .. "/" .. maxExp)
    else
        self._levelExpBar:set_current_progress_bar_value(100)
        self._levelExpText:set_text(GameAPI.get_text_config('#1292806940#lua'))
    end
    for i = 1, #self._shopCards do
        local card = self._shopCards[i]
        local item = itemList[i]
        card:setVisible(true)
        if item and item.itemId and item.itemId > 0 then
            card:updateUI(item)
        else
            card:updateEmpty()
            -- card:setVisible(false)
        end
    end
end

function SurviveGameAbyssShopUI:updateTips()
    local playerId = y3.gameApp:getMyPlayerId()
    local abyssChallenge = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy"):getAbysChallenge()
    local abyssShop = abyssChallenge:getShop()
    local refreshPrice, priceType = abyssShop:getShopItemDataRefreshPrice(playerId)
    local time, maxtime, cnt = abyssShop:getShopParam(y3.gameApp:getMyPlayerId())
    local timeStr = string.format("%d:%02d", math.floor(time / 60), math.floor(time % 60))
    self._shopRefreshContentText:set_text(y3.Lang.getLang(y3.langCfg.get(24).str_content, { time = timeStr }))
    local curDiamond = y3.surviveHelper.getResNum(playerId, priceType)
    self._res_value_TEXT:set_text("" .. math.floor(curDiamond))
    self._refreshResValueText:set_text(refreshPrice)
    self._refreshIconImg:set_image(y3.surviveHelper.getResIcon(priceType))
end

function SurviveGameAbyssShopUI:_onCardClick(index)
    y3.SyncMgr:sync(y3.SyncConst.SYNC_SURVIVE_ABYSS_SHOP_BUY, { slot = index })
end

function SurviveGameAbyssShopUI:_onCardRightClick(index)
    y3.SyncMgr:sync(y3.SyncConst.SYNC_SURVIVE_ABYSS_SHOP_BUY, { slot = index, buyTimes = 10 })
end

return SurviveGameAbyssShopUI
