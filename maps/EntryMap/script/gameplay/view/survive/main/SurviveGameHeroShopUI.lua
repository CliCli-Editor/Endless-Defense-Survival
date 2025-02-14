local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGameHeroShopUI = class("SurviveGameHeroShopUI", StaticUIBase)

function SurviveGameHeroShopUI:ctor()
    local ui = y3.UIHelper.getUI("1651d44b-9269-47a9-a041-0243b6509a82")
    SurviveGameHeroShopUI.super.ctor(self, ui)
    self._closeBtn = y3.UIHelper.getUI("39a19d8c-ed08-4553-b7b1-5f3d1571e0f5")
    self._titleText = y3.UIHelper.getUI("91e6fe9e-19eb-4df9-970e-8a8895caa09e")
    self._levelText = y3.UIHelper.getUI("7e6a8fa6-a5fa-4eb4-83cd-feb813178736")
    self._tipText = y3.UIHelper.getUI("256ac14b-ab6e-425b-94a4-24dc61e49a35")
    self._contentGrid = y3.UIHelper.getUI("505b2502-f43e-4c98-b599-4e3382ad4ee4")

    self._eventRoot = y3.UIHelper.getUI("14100aab-ffbf-4cbc-945b-e9a360f80de8")
    self._eventBtn = y3.UIHelper.getUI("7d04b190-e050-4f5a-92b5-704697f9ac55")

    self._levelExpBar = y3.UIHelper.getUI("f50b1f4b-2529-4881-b4cb-0929ad70b1f6")
    self._levelExpText = y3.UIHelper.getUI("1428c45b-faaa-413c-992d-50ee001b6b9f")
    self._shopBtnLvText = y3.UIHelper.getUI("58c4f8bd-e40e-4c1e-9c4a-4ea37fe8854b")

    self._eventRoot:set_visible(y3.FuncCheck.checkFuncIsOpen(y3.gameApp:getMyPlayerId(), y3.FuncConst.FUNC_TOWERSOULTECH))

    self._control = y3.UIHelper.getUI("6e2873ca-a3cc-4f59-8142-4224e429dc42")

    self._tech_up_stageBtn = y3.UIHelper.getUI("2b14c07e-cbbf-41ac-8ad8-fab06a411210")

    y3.gameApp:registerEvent(y3.EventConst.EVENT_REFRESH_HERO_SHOP, handler(self, self._onRefreshHeroShop))
    y3.gameApp:registerEvent(y3.EventConst.EVENT_SURVIVE_RESOURCE_ADD_GOLD,
        handler(self, self._onEventResourceAddGold))
    y3.gameApp:registerEvent(y3.EventConst.EVENT_FUNC_CHECK_UPDATE, handler(self, self._onEventFuncCheckUpdate))
    self._eventBtn:add_local_event("左键-点击", handler(self, self._onEventBtnClick))
    self._closeBtn:add_local_event("左键-点击", handler(self, self._onCloseBtnClick))
    self._tech_up_stageBtn:add_local_event("左键-点击", handler(self, self._onTechUpStageBtnClick))
    -- self:_initTab()
    self._curRound = 1
    self._shopCards = {}
    self:_onTabClick(1)
    self:updateUI()
end

function SurviveGameHeroShopUI:_onTechUpStageBtnClick(local_player)
    y3.SyncMgr:sync(y3.SyncConst.SYNC_SHOP_UP_STAGE, {})
end

function SurviveGameHeroShopUI:updateTabBtn()
    -- for i = 1, #self._tabBtns do
    --     local child = self._tabBtns[i]
    --     local heroShop = y3.gameApp:getLevel():getLogic("SurviveGameHeroShop")
    --     local isUnlock = heroShop:isUnlockShop(y3.gameApp:getMyPlayerId(), i)
    --     child:set_button_enable(isUnlock)
    -- end
end

function SurviveGameHeroShopUI:_initTab()
    -- self._tabBtns = {}
    -- local childs = self._control:get_childs()
    -- for i = 1, #childs do
    --     local child = childs[i]

    --     table.insert(self._tabBtns, child)
    --     child:add_local_event("左键-点击", function(local_player)
    --         self:_onTabClick(i)
    --     end)
    -- end
end

function SurviveGameHeroShopUI:_onTabClick(index)
    -- self._curRound = index
    -- self:updateUI()
end

function SurviveGameHeroShopUI:hideAllCard()
    for i = 1, #self._shopCards do
        self._shopCards[i]:setVisible(false)
    end
end

function SurviveGameHeroShopUI:_onEventResourceAddGold(trg, player)
    if player:get_id() == y3.gameApp:getMyPlayerId() then
        if self:isVisible() then
            self:updateUI()
        end
    end
end

function SurviveGameHeroShopUI:_onEventFuncCheckUpdate(trg, playerId, funcId)
    if playerId == y3.gameApp:getMyPlayerId() then
        if funcId == y3.FuncConst.FUNC_TOWERSOULTECH then
            self._eventRoot:set_visible(y3.FuncCheck.checkFuncIsOpen(playerId, funcId))
        end
    end
end

function SurviveGameHeroShopUI:updateUI()
    self:updateTabBtn()
    local heroShop = y3.gameApp:getLevel():getLogic("SurviveGameHeroShop")
    local upStage = heroShop:getCurUpStage(y3.gameApp:getMyPlayerId())
    local isExpMax = heroShop:isShopExpMax(y3.gameApp:getMyPlayerId())
    local shopList = heroShop:getShopList(y3.gameApp:getMyPlayerId())
    self:hideAllCard()
    local data = shopList[1]
    self._tipText:set_text(data.cfg.round_desc)
    self._levelText:set_text(upStage)
    self._shopBtnLvText:set_text("lv." .. upStage)
    local curExp = heroShop:getCurShopExp(y3.gameApp:getMyPlayerId())
    local maxExp = heroShop:getCurShopUpMaxExp(y3.gameApp:getMyPlayerId())
    if maxExp > 0 then
        local pro = curExp / maxExp * 100
        self._levelExpBar:set_current_progress_bar_value(pro)
        self._levelExpText:set_text(string.format("%d/%d", curExp, maxExp))
    else
        self._levelExpBar:set_current_progress_bar_value(100)
        self._levelExpText:set_text(GameAPI.get_text_config('#1292806940#lua'))
    end
    self._tech_up_stageBtn:set_button_enable(isExpMax)
    self._tech_up_stageBtn:get_child("highlight_EFF"):set_visible(isExpMax)
    local isChallenging = heroShop:getIsUpStageChallenging(y3.gameApp:getMyPlayerId())
    if isChallenging then
        self._tech_up_stageBtn:set_button_enable(false)
        self._tech_up_stageBtn:get_child("highlight_EFF"):set_visible(false)
        self._tech_up_stageBtn:get_child("title_TEXT"):set_text(GameAPI.get_text_config('#1276285439#lua'))
    else
        self._tech_up_stageBtn:get_child("title_TEXT"):set_text(GameAPI.get_text_config('#907069329#lua'))
    end

    for i = 1, #shopList do
        local card = self._shopCards[i]
        if not card then
            card = include("gameplay.view.survive.main.SurviveGameHeroShopCard").new(self._contentGrid)
            self._shopCards[i] = card
        end
        card:setVisible(true)
        card:updateUI(shopList[i], i)
    end
end

function SurviveGameHeroShopUI:_onRefreshHeroShop(trg, playerId)
    if playerId == y3.gameApp:getMyPlayerId() then
        self:updateUI()
    end
end

function SurviveGameHeroShopUI:_onEventBtnClick()
    local isVisible = self:isVisible()
    self:setVisible(not isVisible)
    if not isVisible then
        self._eventRoot:get_child("new"):set_visible(false)
        self:updateUI()
    end
end

function SurviveGameHeroShopUI:_onCloseBtnClick()
    self:setVisible(false)
end

return SurviveGameHeroShopUI
