local UIBase                      = include("gameplay.base.UIBase")
local SurviveGamePlatformShopCard = class("SurviveGamePlatformShopCard", UIBase)

function SurviveGamePlatformShopCard:ctor(parent, root)
    self._root = root
    SurviveGamePlatformShopCard.super.ctor(self, parent, y3.SurviveConst.PREFAB_MAP["main_mall"])
    self._bg = self._ui:get_child("bg")
    self._unlock = self._ui:get_child("unlock")
    self._unlockTitle = self._ui:get_child("unlock._title_TEXT")
    self._frame = self._ui:get_child("avatar.frame")
    self._icon_IMG = self._ui:get_child("avatar._icon_IMG")
    self._title_TEXT = self._ui:get_child("_title_TEXT")

    self._bg:add_local_event("左键-点击", handler(self, self._onCardClick))
end

function SurviveGamePlatformShopCard:updateUI(cfg)
    self._cfg = cfg
    local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local player = playerData:getPlayer()
    local storeNum = player:get_store_item_number(cfg.skuType)
    local isUnlock = storeNum > 0
    self._unlock:set_visible(isUnlock)
    if cfg.stack > 0 then
        if storeNum > 0 then
            self._title_TEXT:set_text(cfg.name .. "x" .. storeNum)
        else
            self._title_TEXT:set_text(cfg.name)
        end
    else
        self._title_TEXT:set_text(cfg.name)
    end
    self._icon_IMG:set_image(tonumber(cfg.icon))
    self._frame:set_image(y3.SurviveConst.ITEM_CLASS_MAP[cfg.class + 1] or y3.SurviveConst.ITEM_CLASS_MAP[1])
end

function SurviveGamePlatformShopCard:updateSelect(key)

end

function SurviveGamePlatformShopCard:_onCardClick(local_player)
    print("SurviveGamePlatformShopCard:_onCardClick")
    self._root:onSelectCard(self._cfg.key)
end

return SurviveGamePlatformShopCard
