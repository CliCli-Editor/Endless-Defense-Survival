local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGameTechnologyUI = class("SurviveGameTechnologyUI", StaticUIBase)

function SurviveGameTechnologyUI:ctor(root)
    self._root = root
    local ui = y3.UIHelper.getUI("f33a012d-626f-47bf-8971-4a26a3ae744a")
    SurviveGameTechnologyUI.super.ctor(self, ui)

    self._techBtns = {}
    self._shop_tech = y3.UIHelper.getUI("9ef9e44d-349d-4719-a0b4-b8bd16caa6b1")
    self._techBtns[y3.SurviveConst.STAGE_TECH_WEAPON_ADD_GOLD] =
        y3.UIHelper.getUI("8bac5951-9557-42e5-bd22-42d48b1ef857")

    self._techBtns[y3.SurviveConst.STAGE_TECH_WEAPON_ADD_GOLD]:add_local_event("左键-点击", function()
        self:_onTechClick(y3.SurviveConst.STAGE_TECH_WEAPON_ADD_GOLD)
    end)
    y3.gameApp:registerEvent(y3.EventConst.EVENT_TECH_UPGRADE_SUCCESS, handler(self, self._onTechUpgradeSuccess))
    y3.gameApp:registerEvent(y3.EventConst.EVENT_SURVIVE_RESOURCE_ADD_GOLD, handler(self, self._onEventAddGold))
    self:updateUI()
    self:_onEventAddGold(nil, y3.player(y3.gameApp:getMyPlayerId()))
    self:_handlerKuaijieKey()
end

function SurviveGameTechnologyUI:_handlerKuaijieKey()
    -- y3.game:event("本地-键盘-抬起", y3.const.KeyboardKey['T'], function(trg, data)
    --     self:_onTechClick(y3.SurviveConst.STAGE_TECH_WEAPON_ADD_GOLD)
    -- end)
end

function SurviveGameTechnologyUI:_onEventAddGold(trg, player)
    y3.player.with_local(function(local_player)
        if local_player:get_id() == player:get_id() then
            local technology = y3.gameApp:getLevel():getLogic("SurviveGameTechnology")
            local price = technology:getTechnologyPrice(y3.gameApp:getMyPlayerId(),
                y3.SurviveConst.STAGE_TECH_WEAPON_ADD_GOLD)
            -- self._shop_tech:get_child("shop_tech.shop_tech_upgrade.res._res_value_TEXT"):set_text(price)
            local priceUI = y3.UIHelper.getUI("68a16573-e5e0-4102-b3d0-e0383205df24")
            if price > 0 then
                priceUI:set_text(price .. GameAPI.get_text_config('#30000001#lua01'))
            else
                priceUI:set_text(GameAPI.get_text_config('#-1063413419#lua'))
            end
            local diamond = local_player:get_attr("diamond")
            if diamond >= price then
                priceUI:set_text_color_hex("ffffff", 255)
            else
                priceUI:set_text_color_hex("ff8181", 255)
            end
        end
    end)
end

function SurviveGameTechnologyUI:_onTechUpgradeSuccess(id, playerId)
    if playerId == y3.gameApp:getMyPlayerId() then
        self:updateUI()
    end
end

function SurviveGameTechnologyUI:updateUI()
    for techType = 1, y3.SurviveConst.MAX_STAGE_TEACH_NUM do
        local btn = self._techBtns[techType]
        if btn then
            self:_updateGoldTech()
        end
    end
end

function SurviveGameTechnologyUI:_updateGoldTech()
    local technology = y3.gameApp:getLevel():getLogic("SurviveGameTechnology")
    -- local name       = technology:getTenchName(y3.SurviveConst.STAGE_TECH_WEAPON_ADD_GOLD)
    local level      = technology:getTechnologyLevel(y3.gameApp:getMyPlayerId(),
        y3.SurviveConst.STAGE_TECH_WEAPON_ADD_GOLD)
    self._shop_tech:get_child("shop_tech_level.shop_level_value._shop_level_value_TEXT"):set_text(level)
    local price = technology:getTechnologyPrice(y3.gameApp:getMyPlayerId(), y3.SurviveConst.STAGE_TECH_WEAPON_ADD_GOLD)
    -- self._shop_tech:get_child("shop_tech.shop_tech_upgrade.res._res_value_TEXT"):set_text(price)
    local priceUI = y3.UIHelper.getUI("68a16573-e5e0-4102-b3d0-e0383205df24")
    if price > 0 then
        priceUI:set_text(price .. GameAPI.get_text_config('#30000001#lua01'))
    else
        priceUI:set_text(GameAPI.get_text_config('#-1063413419#lua'))
    end
end

function SurviveGameTechnologyUI:_onTechClick(techType)
    y3.SyncMgr:sync(y3.SyncConst.SYNC_SURVIVE_TECH_UPGRADE, { techType = techType })
end

return SurviveGameTechnologyUI
