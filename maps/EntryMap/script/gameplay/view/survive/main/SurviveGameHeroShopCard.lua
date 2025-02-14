local UserDataHelper = include "gameplay.level.logic.helper.UserDataHelper"
local UIBase = include("gameplay.base.UIBase")
local SurviveGameHeroShopCard = class("SurviveGameHeroShopCard", UIBase)

function SurviveGameHeroShopCard:ctor(parent)
    SurviveGameHeroShopCard.super.ctor(self, parent, y3.SurviveConst.PREFAB_MAP["windows_hero_tech"])

    self._title_TEXT = self._ui:get_child("root.title_TEXT")
    self._bg_btn = self._ui:get_child("root.main.bg_BTN")
    self._tech_icon_IMG = self._ui:get_child("root.main.mask._tech_icon_IMG")
    self._level_TEXT = self._ui:get_child("root.main._level_TEXT")
    self._value_TEXT = self._ui:get_child("root.price._value_TEXT")
    self._price_icon_img = self._ui:get_child("root.price._res_icon_IMG")
    self._refresh_ANIM = self._ui:get_child("root.refresh_ANIM")
    self._lock = self._ui:get_child("root.lock")
    self._lockText = self._ui:get_child("root.lock._title_TEXT")

    self._bg_btn:add_local_event("左键-点击", handler(self, self._onBtnBuyClick))

    self._bg_btn:add_local_event("鼠标-移入", function()
        if self._data then
            local heroShop = y3.gameApp:getLevel():getLogic("SurviveGameHeroShop")
            local skillId  = heroShop:getShopDataSkillId(y3.gameApp:getMyPlayerId(), self._data)
            if skillId then
                -- print(skillId)
                local skillCfg = include("gameplay.config.config_skillData").get(tostring(skillId))
                local titleStr = self._data.cfg.not_ .. "(lv." .. self._data.level .. ")"
                local maxStr = ""
                if self._data.cfg.max_level > 0 then
                    maxStr = "最多可升" .. self._data.cfg.max_level .. "级"
                else
                    maxStr = "无等级限制"
                end
                local skillDesc = y3.userDataHelper.getSkillDesc(skillCfg) .. "\n\n" .. maxStr
                y3.Sugar.tipRoot():showUniversalTip({ title = titleStr, desc = skillDesc })
            end
        end
    end)
    self._bg_btn:add_local_event("鼠标-移出", function()
        y3.Sugar.tipRoot():hideUniversalTip()
    end)
end

function SurviveGameHeroShopCard:updateUI(data, slot, round)
    self._slot = slot
    self._round = round
    if self._data ~= data then
        self._refresh_ANIM:set_visible(true)
        self._refresh_ANIM:play_ui_sequence(false, 0.01)
    end
    self._data     = data
    local heroShop = y3.gameApp:getLevel():getLogic("SurviveGameHeroShop")
    local skillId  = heroShop:getShopDataSkillId(y3.gameApp:getMyPlayerId(), self._data)
    local skillCfg = include("gameplay.config.config_skillData").get(tostring(skillId))
    if skillCfg then
        self._tech_icon_IMG:set_image(tonumber(skillCfg.icon))
    end
    self._title_TEXT:set_text(data.cfg.not_)
    local isUnlock = heroShop:shopSlotIsUnlock(y3.gameApp:getMyPlayerId(), self._slot)
    local isMax = data.cfg.max_level > 0 and (data.level >= data.cfg.max_level) or false
    if isMax then
        self._level_TEXT:set_text("lv.max")
        self._value_TEXT:set_text(GameAPI.get_text_config('#1292806940#lua'))
        self._value_TEXT:set_text_color_hex("ffffff", 255)
        self._bg_btn:set_button_enable(false)
    else
        self._level_TEXT:set_text("lv." .. tostring(data.level))
        local priType, priSize = heroShop:getShopPrice(data)
        local diamond = y3.surviveHelper.getResNum(y3.gameApp:getMyPlayerId(), priType)
        self._price_icon_img:set_image(y3.surviveHelper.getResIcon(priType))
        if diamond >= priSize then
            self._bg_btn:set_button_enable(true)
            self._value_TEXT:set_text_color_hex("ffffff", 255)
        else
            self._bg_btn:set_button_enable(false)
            self._value_TEXT:set_text_color_hex("d0513c", 255)
        end
        self._value_TEXT:set_text(priSize)
    end
    self._lock:set_visible(not isUnlock)
    if not isUnlock then
        local unslot = self._data.cfg.unlock_slot
        self._value_TEXT:set_text_color_hex("ffffff", 255)
        self._bg_btn:set_button_enable(false)
        self._lockText:set_text(GameAPI.get_text_config('#30000001#lua22') .. unslot .. GameAPI.get_text_config('#30000001#lua23'))
    end
end

function SurviveGameHeroShopCard:_onBtnBuyClick(local_player)
    y3.SyncMgr:sync(y3.SyncConst.SYNC_BUY_HERO_SHOP_ITEM, { slot = self._slot, round = self._round })
end

return SurviveGameHeroShopCard
