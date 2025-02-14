local StaticUIBase = include("gameplay.base.StaticUIBase")
local ShopHerperBuyUI = class("ShopHerperBuyUI", StaticUIBase)
local ShopHelperBuySettingCell = include("gameplay.view.survive.main.autoBuy.ShopHelperBuySettingCell")

local MAX_HELPER_TYPE = 4

function ShopHerperBuyUI:ctor()
    local ui = y3.UIHelper.getUI("fb06f6b5-4378-45e3-81c3-ec206e47682f")
    ShopHerperBuyUI.super.ctor(self, ui)
    self._shop_help_btn = y3.UIHelper.getUI("ed25dbe0-adab-4d65-85b2-467c8ebbea58")
    self._shop_help_btn:add_local_event("左键-点击", handler(self, self._onShopHelpClick))

    self._shopHelperOpenBtn = y3.UIHelper.getUI("4c4efa7f-9845-49f3-8453-e7db068b300d")
    self._shopHelperOpenBtn:add_local_event("左键-点击", handler(self, self._onSwitchHelperClick))

    self._shopHelpAutoRefreshBtn = y3.UIHelper.getUI("e304c148-5d0b-4758-b6a3-c92cba35b0eb")
    self._shopHelpAutoRefreshBtn:add_local_event("左键-点击", handler(self, self._onAutoRefreshClick))

    self._exitBtn = y3.UIHelper.getUI("0be8fa24-9c99-4e12-9ec6-9a7f8afd974c")
    self._exitBtn:add_local_event("左键-点击", handler(self, self._onCloseClick))

    self._helperBuy = include("gameplay.view.survive.main.autoBuy.ShopHelperBuy").new()
    self._shop_helper_List = y3.UIHelper.getUI("7c9be452-aa80-4c20-88a2-24e415ebda75")

    self._shop_help_record_List = y3.UIHelper.getUI("255be73e-0475-4685-a843-535614413e9c")
    self._recordCells = {}

    y3.gameApp:registerEvent(y3.EventConst.EVENT_SURVIVE_REFRESH_SKILl,
        handler(self, self._onEventRefreshSkill))
    y3.gameApp:registerEvent(y3.EventConst.EVENT_SHOP_HELPER_OPEN_SUCCESS, handler(self, self._onEventOpenSuccess))
    y3.gameApp:registerEvent(y3.EventConst.EVENT_REMOVE_LABEL_SORT_SUCCESS, handler(self, self._onEventLabelUpdate))
    y3.gameApp:registerEvent(y3.EventConst.EVENT_INSERT_LABEL_SORT_SUCCESS, handler(self, self._onEventLabelUpdate))
    y3.gameApp:registerEvent(y3.EventConst.EVENT_SHOP_HELPER_AUTO_SUCCESS, handler(self, self._onEventAutoSuccess))

    self:_initSkillMap()
    self:_delayAutoBuy()
    self:_initUI()
    self._totalCheckDt = 0
    y3.ctimer.loop(1, handler(self, self._checkAutoBuy))
end

function ShopHerperBuyUI:_initSkillMap()
    local config_skillData = include("gameplay.config.config_skillData")
    local len = config_skillData.length()
    self._labelSkikkMap = {}
    for i = 1, len do
        local cfg = config_skillData.indexOf(i)
        assert(cfg, "")
        local shop_helper_lables = string.split(cfg.shop_helper_lable, "|")
        assert(shop_helper_lables, "")
        for i = 1, #shop_helper_lables do
            local param = string.split(shop_helper_lables[i], "#")
            assert(param, "")
            for j = 1, #param do
                local label = tonumber(param[j])
                if label and label then
                    if not self._labelSkikkMap[label] then
                        self._labelSkikkMap[label] = {}
                    end
                    table.insert(self._labelSkikkMap[label], cfg)
                end
            end
        end
    end
end

function ShopHerperBuyUI:getLabelTips(label)
    local list = self._labelSkikkMap[label] or {}
    local descTips = ""
    for i = 1, #list do
        descTips = descTips .. list[i].name .. "\n"
    end
    return descTips
end

function ShopHerperBuyUI:_delayAutoBuy()
    y3.ctimer.wait(0.1, function(timer, count, local_player)
        self:_onEventRefreshSkill(nil, local_player:get_id(), true)
    end)
end

function ShopHerperBuyUI:_onEventOpenSuccess(trg, playerId, isOpen)
    if playerId == y3.gameApp:getMyPlayerId() then
        self._helperBuy:setOpen(isOpen)
        self._shopHelperOpenBtn:get_child("icon"):set_visible(self._helperBuy:isOpen())
        self._shop_help_btn:get_child("highlight_EFF"):set_visible(self._helperBuy:isOpen())
        if isOpen then
            self:_justAutoBuy()
        end
    end
end

function ShopHerperBuyUI:_onEventAutoSuccess(trg, playerId, isAuto)
    if playerId == y3.gameApp:getMyPlayerId() then
        self._helperBuy:setAuto(isAuto)
        self._shopHelpAutoRefreshBtn:get_child("icon"):set_visible(self._helperBuy:isAuto())
    end
end

function ShopHerperBuyUI:_onEventLabelUpdate(trg, playerId)
    if playerId == y3.gameApp:getMyPlayerId() then
        self:refreshHelperCells()
    end
end

function ShopHerperBuyUI:_onShopHelpClick()
    self:setVisible(true)
end

function ShopHerperBuyUI:_onSwitchHelperClick()
    log.info("switch helper")
    y3.SyncMgr:sync(y3.SyncConst.SYNC_SHOP_HELPER_OPEN, { isOpen = not self._helperBuy:isOpen() })
end

function ShopHerperBuyUI:_onAutoRefreshClick()
    y3.SyncMgr:sync(y3.SyncConst.SYNC_SHOP_AUTO_REFRESH, { isAuto = not self._helperBuy:isAuto() })
end

function ShopHerperBuyUI:_initUI()
    self._shopHelperOpenBtn:get_child("icon"):set_visible(self._helperBuy:isOpen())
    self._shopHelpAutoRefreshBtn:get_child("icon"):set_visible(self._helperBuy:isAuto())
    self._shop_help_btn:get_child("highlight_EFF"):set_visible(self._helperBuy:isOpen())
    self._helperCells = {}
    local childs = self._shop_helper_List:get_childs()
    for helperType = 1, MAX_HELPER_TYPE do
        local child = childs[helperType]
        local list = self._helperBuy:getHelperTypeList(helperType)
        for i = 1, #list do
            local cell = ShopHelperBuySettingCell.new(child:get_child("weapon_GRID"), self)
            cell:updateUI(list[i], self._helperBuy)
            table.insert(self._helperCells, cell)
        end
    end
end

function ShopHerperBuyUI:refreshHelperCells()
    for i = 1, #self._helperCells do
        self._helperCells[i]:refresh()
    end
end

function ShopHerperBuyUI:_onCloseClick()
    self:setVisible(false)
    self:_justAutoBuy()
end

function ShopHerperBuyUI:_onEventRefreshSkill(trg, playerId, isAnim)
    if playerId == y3.gameApp:getMyPlayerId() then
        if isAnim then
            self._totalCheckDt = 0
            y3.ctimer.wait(1, function(timer, count, local_player)
                self:_justAutoBuy()
            end)
        end
    end
end

function ShopHerperBuyUI:_checkAutoBuy(timer, count, local_player)
    self._totalCheckDt = self._totalCheckDt + 1
    if self._totalCheckDt >= 3 then
        self._totalCheckDt = 0
        if self._helperBuy:isAuto() then
            self:_justAutoBuy()
        end
    end
end

function ShopHerperBuyUI:_justAutoBuy()
    self._totalCheckDt = 0
    local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local skillPools = playerData:getRandomPools()
    self._helperBuy:autoBuy(skillPools)
    y3.ctimer.wait(0.3, function(timer, count, local_player)
        self:_updateRecord()
    end)
end

function ShopHerperBuyUI:_updateRecord()
    local refreshSkill = y3.gameApp:getLevel():getLogic("SurviveRefreshSkill")
    local recordList = refreshSkill:getAutoBuyList(y3.gameApp:getMyPlayerId())
    for i = 1, #recordList do
        local cell = self._recordCells[i]
        if not cell then
            cell = include("gameplay.view.survive.main.autoBuy.ShopHelperBuyRecordCell").new(self._shop_help_record_List)
            self._recordCells[i] = cell
        end
        cell:updateUI(recordList[i])
    end
end

return ShopHerperBuyUI
