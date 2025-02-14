local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGameAbyssShopCard = class("SurviveGameAbyssShopCard", StaticUIBase)

local COLOR_MAP = {
    [1] = 134279904,
    [2] = 134251224,
    [3] = 134230518,
    [4] = 134220481,
    [5] = 134227025,
    [6] = 134229973
}
-- 134234281
function SurviveGameAbyssShopCard:ctor(ui)
    SurviveGameAbyssShopCard.super.ctor(self, ui)
    self._shop_item_bg_img = self._ui:get_child("content.bg")
    self._shop_item_frame_img = self._ui:get_child("content.avatar.bg")
    self._shop_item_image_img = self._ui:get_child("content.avatar._icon_IMG")
    self._shop_item_name_text = self._ui:get_child("content._title_TEXT")
    self._stocks_TEXT = self._ui:get_child("content.avatar._stocks_TEXT")

    self._shop_item_price_icon_img = self._ui:get_child("price._res_icon_IMG")
    self._shop_item_price_text = self._ui:get_child("price._price_TEXT")

    self._lock = self._ui:get_child("lock")
    self._lockText = self._ui:get_child("lock._title_TEXT")

    self._content = self._ui:get_child("content")
    self._price = self._ui:get_child("price")

    self._shop_item_bg_img:add_local_event("鼠标-移入", function(local_player)
        if self._data then
            if self._item_type == 1 or self._item_type == 2 then
                y3.gameApp:getLevel():getView("SurviveGameTip"):showSkillTip({ cfg = self._cfg })
            elseif self._item_type == 3 then
                y3.gameApp:getLevel():getView("SurviveGameTip"):showItemTip(self._cfg.id)
            end
        end
    end)
    self._shop_item_bg_img:add_local_event("鼠标-移出", function(local_player)
        if self._item_type == 1 or self._item_type == 2 then
            y3.gameApp:getLevel():getView("SurviveGameTip"):hideSkillTip()
        elseif self._item_type == 3 then
            y3.gameApp:getLevel():getView("SurviveGameTip"):hideItemTip()
        end
    end)
end

function SurviveGameAbyssShopCard:updateEmpty()
    self._content:set_visible(false)
    self._price:set_visible(false)
    self._lock:set_visible(false)
end

function SurviveGameAbyssShopCard:updateUI(data)
    self._content:set_visible(true)
    self._price:set_visible(true)
    self._lock:set_visible(false)
    self._data = data
    -- local random = include("gameplay.config.random_pool").get(data.id)
    -- assert(random, "xxxx")
    self._item_type = self._data.type
    if self._data.type == 1 or self._data.type == 2 then
        local skillCfg = include("gameplay.config.config_skillData").get(tostring(data.itemId))
        assert(skillCfg, "xxxx")
        self._cfg = skillCfg
        self._shop_item_frame_img:set_image(COLOR_MAP[skillCfg.class + 1])
        self._shop_item_name_text:set_text(skillCfg.name)
        self._shop_item_image_img:set_image(tonumber(skillCfg.icon))
        if data.buy then
            self._stocks_TEXT:set_text(y3.langCfg.get(14).str_content)
        else
            if data.needRecharge then
                self._stocks_TEXT:set_text(data.rechrageNum .. "/" .. data.rechrageMax)
            else
                self._stocks_TEXT:set_text("")
            end
        end
    elseif self._data.type == 3 then
        local itemCfg = include("gameplay.config.item").get(data.itemId)
        assert(itemCfg, "xxxx")
        self._cfg = itemCfg
        self._shop_item_frame_img:set_image(COLOR_MAP[itemCfg.item_quality + 1] or COLOR_MAP[1])
        self._shop_item_name_text:set_text(itemCfg.item_name)
        self._shop_item_image_img:set_image(tonumber(itemCfg.item_icon))
        if data.buy then
            self._stocks_TEXT:set_text(y3.langCfg.get(14).str_content)
        else
            if data.needRecharge then
                self._stocks_TEXT:set_text(data.rechrageNum .. "/" .. data.rechrageMax)
            else
                self._stocks_TEXT:set_text("")
            end
        end
    end
    local abyssChallenge = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy"):getAbysChallenge()
    local price, priceType = abyssChallenge:getShop():getShopDataPrice(data)
    self._shop_item_price_icon_img:set_image(y3.surviveHelper.getResIcon(priceType))
    local curDiamond = y3.surviveHelper.getResNum(y3.gameApp:getMyPlayerId(), priceType)
    if curDiamond >= price then
        self._shop_item_price_text:set_text_color_hex("ffffff", 255)
        self._shop_item_price_text:set_text(price)
    else
        self._shop_item_price_text:set_text_color_hex("d0513c", 255)
        self._shop_item_price_text:set_text(price)
    end
    if data.needRecharge then
        self._lock:set_visible(true)
        local chargeOpen = abyssChallenge:getShop():shopChargeIsOpen(y3.gameApp:getMyPlayerId())

        local rechargeTime = abyssChallenge:getShop():getShopDataRemainTime(y3.gameApp:getMyPlayerId(), data) --data.maxRechargeTime - data.rechargeTime
        self._lockText:set_text(string.format("%d:%02d", math.floor(rechargeTime / 60), math.floor(rechargeTime % 60)))
    end
end

return SurviveGameAbyssShopCard
