local GlobalConfigHelper = include "gameplay.level.logic.helper.GlobalConfigHelper"
local SurviveHelper = include "gameplay.level.logic.helper.SurviveHelper"
local SurviveSkillPoolUI = class("SurviveSkillPoolUI")
local SurviveSkillCard = include("gameplay.view.survive.main.SurviveSkillCard")

function SurviveSkillPoolUI:ctor(ui, root)
    self._ui = ui
    self._root = root
    self._bg = y3.UIHelper.getUI("5716cc4e-7070-45c1-b647-a5f766e6275d")
    -- self._bg:set_intercepts_operations(true)
    self._shop = y3.UIHelper.getUI("7570720b-2568-4310-b191-5724bb4819fb")
    self._shopRefresh = y3.UIHelper.getUI("8e335963-e5d1-48ad-ba1a-9a458ac88d44")
    self._btnRefresh = y3.UIHelper.getUI("85182a92-c8f2-419e-9134-30aea0d2bacc")
    self._labelRefreshTime = y3.UIHelper.getUI("c64c5f78-1f72-452c-80a5-573837f53abc")
    self._labelRefreshHint = y3.UIHelper.getUI("ba2d94f6-4dd6-43a3-a78b-909a4150e8ba")
    self._goldValueText = y3.UIHelper.getUI("8e749bc4-f8ef-4a3b-9dc6-52fc293ffb31")
    self._goldIncomeText = y3.UIHelper.getUI("22d686b3-4535-4d47-a4d2-7921db641fd1")

    self._shopRefreshBar = y3.UIHelper.getUI("5dccf20a-c3b1-4553-bbaa-b074648118bc")
    self._shopRefreshBar:set_current_progress_bar_value(0)

    self._consume      = y3.UIHelper.getUI("dbbf067c-3b38-43e9-99dd-1efb53bac4e3")
    self._consumeText  = y3.UIHelper.getUI("be9d03ba-d7b7-4751-b6b1-3e0e84902b37")

    self._towerBtn     = y3.UIHelper.getUI("a8121877-7745-49ca-af3b-eace8b2a3d84")
    self._towerIcon    = y3.UIHelper.getUI("eb0ffc30-47c5-47a8-988a-4e4554b01e30")
    self._towerName    = y3.UIHelper.getUI("90a32db9-fa77-4cb0-a87e-a42947ae3452")

    self._shopLevelBtn = y3.UIHelper.getUI("209e779b-abcf-4ce6-94af-1622e8c15fed")
    self._shopLevel    = y3.UIHelper.getUI("21fe6c3b-aa2d-4ef8-ab74-5569faff1982")

    self._shopLevel:add_local_event("鼠标-移入", function(local_player)
        local refreshSkill = y3.gameApp:getLevel():getLogic("SurviveRefreshSkill")
        local shopLevel, shopExp, nextExp, cfg = refreshSkill:getShopLevelParam(y3.gameApp:getMyPlayerId())
        if cfg then
            y3.Sugar.tipRoot():showUniversalTip({ title = GameAPI.get_text_config('#30000001#lua06'), desc = cfg.tips })
        end
    end)
    self._shopLevel:add_local_event("鼠标-移出", function(local_player)
        y3.Sugar.tipRoot():hideUniversalTip()
    end)

    self._btnRefresh:add_local_event("左键-点击", handler(self, self._onBtnRefreshClick))
    self._towerBtn:add_local_event("左键-点击", handler(self, self._onTowerBtnClick))
    self:_initCards()
    self:_handlerKuaijieKey()
    self:updateDetail()

    y3.gameApp:registerEvent(y3.EventConst.EVENT_SURVIVE_REFRESH_SKILl_UPDATE_TIME,
        handler(self, self._onEventRefreshTime))
    y3.gameApp:registerEvent(y3.EventConst.EVENT_SURVIVE_RESOURCE_ADD_GOLD, handler(self, self._onEventAddGold))
    y3.gameApp:registerEvent(y3.EventConst.EVENT_SHOP_EXP_ADD, handler(self, self._onEventShopExpAdd))
    self:_onEventAddGold(nil, y3.player(y3.gameApp:getMyPlayerId()))
    self:updateShopExp()
    self._shopLevelBtn:add_local_event('左键-点击', handler(self, self._onShopLevelBtnClick))
end

function SurviveSkillPoolUI:updateDetail()
    local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local mainActor = playerData:getMainActor()
    if mainActor then
        local mainUnit = mainActor:getUnit()
        local towerId = playerData:getSkinTower()
        local cfg = include("gameplay.config.stage_tower").get(towerId)
        self._towerName:set_text(cfg.tower_name)
        y3.ctimer.wait(0.5, function(timer, count, local_player)
            self._towerIcon:set_image(mainActor:getHeroIcon())
        end)
    end
end

function SurviveSkillPoolUI:_initCards()
    self._skillCards = {}
    local cards      = self:getSkillCards()
    for i, card in ipairs(cards) do
        self._skillCards[i] = SurviveSkillCard.new(card, i)
        local childs = card:get_childs()
        childs[1]:add_local_event("左键-点击", function(local_player)
            self:_onCardClick(i, local_player)
        end)
    end
end

function SurviveSkillPoolUI:_handlerKuaijieKey()
    -- y3.game:event("本地-键盘-按下", y3.const.KeyboardKey['Q'], function(trg, data)
    --     self:_onCardClick(1, data.player)
    -- end)
    -- y3.game:event("本地-键盘-按下", y3.const.KeyboardKey['W'], function(trg, data)
    --     self:_onCardClick(2, data.player)
    -- end)
    -- y3.game:event("本地-键盘-按下", y3.const.KeyboardKey['E'], function(trg, data)
    --     self:_onCardClick(3, data.player)
    -- end)
    -- y3.game:event("本地-键盘-按下", y3.const.KeyboardKey['R'], function(trg, data)
    --     self:_onCardClick(4, data.player)
    -- end)
    -- y3.game:event("本地-键盘-按下", y3.const.KeyboardKey['A'], function(trg, data)
    --     self:_onCardClick(5, data.player)
    -- end)
    -- y3.game:event("本地-键盘-按下", y3.const.KeyboardKey['S'], function(trg, data)
    --     self:_onCardClick(6, data.player)
    -- end)
    -- y3.game:event("本地-键盘-按下", y3.const.KeyboardKey['D'], function(trg, data)
    --     self:_onCardClick(7, data.player)
    -- end)
    -- y3.game:event("本地-键盘-抬起", y3.const.KeyboardKey['G'], function(trg, data)
    --     self:_onBtnRefreshClick(data.player)
    -- end)
    -- y3.game:event("本地-键盘-抬起", y3.const.KeyboardKey['R'], function(trg, data)
    --     print("本地-键盘-抬起")
    --     self:_onShopLevelBtnClick(data.player)
    -- end)
end

function SurviveSkillPoolUI:getSkillCards()
    -- local mainCells = self._shop:get_childs()
    local weapon = y3.UIHelper.getUI("5e22ee0e-1603-42c3-93d9-3efaae94fbdf")
    local mainCells = weapon:get_childs()
    local cards = {}
    for _, mainCell in ipairs(mainCells) do
        table.insert(cards, mainCell)
    end
    local upgrade = y3.UIHelper.getUI("9e3da085-fc68-4d02-a908-c5f9b12bf755")
    local mainCells = upgrade:get_childs()
    for _, mainCell in ipairs(mainCells) do
        table.insert(cards, mainCell)
    end
    return cards
end

function SurviveSkillPoolUI:_onEventRefreshTime(trg)
    y3.player.with_local(function(local_player)
        local refreshSkill = y3.gameApp:getLevel():getLogic("SurviveRefreshSkill")
        local time = refreshSkill:getRefresfSkillTime(local_player:get_id())
        local maxTime = refreshSkill:getRefresfMaxSkillTime(local_player:get_id())
        local isStop = refreshSkill:isStopAutoRefresh()
        if isStop == false then
            time = math.min(time, maxTime)
            self._shopRefreshBar:set_visible(true)
            self._shopRefreshBar:set_current_progress_bar_value(100 - time / maxTime * 100, 0.5)
            self._labelRefreshTime:set_text(y3.Lang.getLang(y3.langCfg.get(25).str_content, { sec = math.floor(time) }))
        else
            self._shopRefreshBar:set_visible(false)
            self._labelRefreshTime:set_text(y3.langCfg.get(36).str_content)
        end
        -- self._labelRefreshTime:set_text("将在" .. math.floor(time) .. "秒内强制刷新")
    end)
end

function SurviveSkillPoolUI:_onEventAddGold(trg, player)
    y3.player.with_local(function(local_player)
        if local_player:get_id() == player:get_id() then
            local surviveResource = y3.gameApp:getLevel():getLogic("SurviveResource")
            local addCountFinal = surviveResource:getGoldAddSpeed(local_player:get_id())
            local gold = math.floor(local_player:get_attr("gold"))
            self._goldValueText:set_text(gold)
            local closeAddGold = surviveResource:getAddGoldClose()
            if closeAddGold then
                self._goldIncomeText:set_text(y3.langCfg.get(26).str_content)
            else
                self._goldIncomeText:set_text("+" .. addCountFinal .. GameAPI.get_text_config('#30000001#lua02'))
            end
            local refreshSkill = y3.gameApp:getLevel():getLogic("SurviveRefreshSkill")
            local curPrice = refreshSkill:getCurShopUpPrice(y3.gameApp:getMyPlayerId())
            if curPrice > 0 then
                self._shopLevel:get_child("shop_upgrade.res._res_value_TEXT"):set_text(curPrice .. GameAPI.get_text_config('#30000001#lua01'))
            else
                self._shopLevel:get_child("shop_upgrade.res._res_value_TEXT"):set_text(GameAPI.get_text_config('#-1063413419#lua'))
            end
            local diamond = local_player:get_attr("diamond")
            if diamond >= curPrice then
                self._shopLevel:get_child("shop_upgrade.res._res_value_TEXT"):set_text_color_hex("ffffff", 255)
            else
                self._shopLevel:get_child("shop_upgrade.res._res_value_TEXT"):set_text_color_hex("ff8181", 255)
            end
        end
    end)
end

function SurviveSkillPoolUI:_onEventShopExpAdd(trg, playerId)
    if playerId == y3.gameApp:getMyPlayerId() then
        self:updateShopExp()
    end
end

function SurviveSkillPoolUI:updateShopExp()
    local refreshSkill = y3.gameApp:getLevel():getLogic("SurviveRefreshSkill")
    local shopLevel, shopExp, nextExp = refreshSkill:getShopLevelParam(y3.gameApp:getMyPlayerId())
    if nextExp > 0 then
        self._shopLevel:get_child("shop_level.shop_level_BAR"):set_current_progress_bar_value(shopExp / nextExp * 100)
        self._shopLevel:get_child("shop_level.shop_level_BAR._shop_exp_TEXT"):set_text(shopExp .. "/" .. nextExp)
    else
        self._shopLevel:get_child("shop_level.shop_level_BAR"):set_current_progress_bar_value(100)
        self._shopLevel:get_child("shop_level.shop_level_BAR._shop_exp_TEXT"):set_text(GameAPI.get_text_config('#1292806940#lua'))
    end
    self._shopLevel:get_child("shop_level.shop_level_value._shop_level_value_TEXT"):set_text(shopLevel)
    local curPrice = refreshSkill:getCurShopUpPrice(y3.gameApp:getMyPlayerId())
    if curPrice > 0 then
        self._shopLevel:get_child("shop_upgrade.res._res_value_TEXT"):set_text(curPrice .. GameAPI.get_text_config('#30000001#lua01'))
    else
        self._shopLevel:get_child("shop_upgrade.res._res_value_TEXT"):set_text(GameAPI.get_text_config('#-1063413419#lua'))
    end
end

function SurviveSkillPoolUI:updateUI(playerData, isAnim)
    local skillPools = playerData:getRandomPools()
    self._skillList = {}
    local cards = self._skillCards
    for i, card in ipairs(cards) do
        local skillPool = skillPools[i] or {}
        local skillCfg, price = SurviveHelper.getSkillCfgAndPriceByRandomPoolId(skillPool.id)
        if skillCfg then
            local state = playerData:getRandomPoolState(i)
            local gold = playerData:getPlayer():get_attr("gold")
            self._skillList[i] = {
                cfg = skillCfg,
                price = price,
                poolId = skillPool.id,
                mult = skillPool.mult,
                state =
                    state,
                slot = i
            }
            card:updateUI(self._skillList[i], gold, i)
            card:setVisible(true)
            if isAnim then
                card:playAnim()
            end
        else
            card:setVisible(false)
        end
    end
    local freeCount, costCount, maxFreeCount, maxCostCount, costGold =
        y3.gameApp:getLevel():getLogic("SurviveRefreshSkill"):getRefreshCount(playerData:getId())
    if freeCount > 0 then
        self._labelRefreshHint:set_text(GameAPI.get_text_config('#2080032895#lua'))
        if maxFreeCount > 0 then
        else
        end
        self._consume:set_visible(false)
    else
        self._consume:set_visible(true)
        self._consumeText:set_text("" .. costGold)
        if maxCostCount > 0 then
            self._labelRefreshHint:set_text(GameAPI.get_text_config('#30000001#lua03') .. costCount .. GameAPI.get_text_config('#30000001#lua04'))
        else
            self._labelRefreshHint:set_text("")
        end
    end
end

---comment
---@param i any
---@param local_player Player
function SurviveSkillPoolUI:_onCardClick(i, local_player)
    if y3.gameApp:isPause() then
        return
    end
    if self._skillList[i] then
        y3.SyncMgr:sync(y3.SyncConst.SYNC_SURVIVE_LEARN_SKILL,
            {
                skillId = self._skillList[i].cfg.id,
                price = self._skillList[i].price,
                poolId = self._skillList[i].poolId,
                slot = self._skillList[i].slot
            })
    end
end

function SurviveSkillPoolUI:_onBtnRefreshClick(local_player)
    if y3.gameApp:isPause() then
        return
    end
    y3.SyncMgr:sync(y3.SyncConst.SYNC_REFRESH_SKILL_POOL, {})
end

function SurviveSkillPoolUI:_onTowerBtnClick(local_player)
    local playerData = y3.userData:getPlayerData(local_player:get_id())
    local mainActor = playerData:getMainActor()
    if mainActor then
        y3.gameApp:moveCameraToPoint(local_player, mainActor:getPosition())
    end
end

function SurviveSkillPoolUI:_onShopLevelBtnClick(local_player)
    y3.SyncMgr:sync(y3.SyncConst.SYNC_BUY_SHOP_EXP, {})
end

return SurviveSkillPoolUI
