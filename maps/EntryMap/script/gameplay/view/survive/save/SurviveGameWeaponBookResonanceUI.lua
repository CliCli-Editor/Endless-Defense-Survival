local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGameWeaponBookResonanceUI = class("SurviveGameWeaponBookResonanceUI", StaticUIBase)

local MAX_WEAPON_TYPE = 5

local COLOR_MAP = {
    [1] = { "e8a060" },
    [2] = { "c8a23c", },
    [3] = { "85b0ff" },
    [4] = { "ff6767" },
    [5] = { "58ce5e" }
}

function SurviveGameWeaponBookResonanceUI:ctor()
    local ui = y3.UIHelper.getUI("669fba93-3387-4203-8936-5e4ef7ca48a1")
    SurviveGameWeaponBookResonanceUI.super.ctor(self, ui)
    self._weapon1 = y3.UIHelper.getUI("6c3087ea-cdc0-48b8-8b7c-55cf7ed493bf")
    self._weapon2 = y3.UIHelper.getUI("c1b029c1-9524-4e5e-b9b5-a7664df670d2")
    self._weapon3 = y3.UIHelper.getUI("837a89f7-50bc-413a-a64a-237fbf7cfbfa")
    self._weapon4 = y3.UIHelper.getUI("575b64a9-b21c-484d-9bc2-b9d1dbc1d732")
    self._weapon5 = y3.UIHelper.getUI("7c297bbe-2b11-4e67-b783-9359ae98b883")

    self._bg = y3.UIHelper.getUI("c36f9f6a-18bc-4ba3-b217-9fbbf75a0395")

    self._core = y3.UIHelper.getUI("72e2ffe6-93d2-47af-ab36-deccde4f3b54")

    self._descr_TEXT = y3.UIHelper.getUI("4d5d5ca0-e24d-4622-ba64-400eae4201fe")

    self._bg:add_local_event("左键-点击", function(local_player)
        self:show(false)
    end)
end

function SurviveGameWeaponBookResonanceUI:show(visible)
    self._ui:set_visible(visible)
    if visible then
        self:_updateUI()
    end
end

function SurviveGameWeaponBookResonanceUI:_updateUI()
    local weaponSave = y3.gameApp:getLevel():getLogic("SurviveGameWeaponSave")
    for WeaponType = 1, MAX_WEAPON_TYPE do
        self["_weapon" .. WeaponType]:get_child("_title_TEXT"):set_text_color_hex(COLOR_MAP[WeaponType][1], 255)
        self["_weapon" .. WeaponType]:get_child("_descr_TEXT"):set_text_color_hex(COLOR_MAP[WeaponType][1], 255)
        self["_weapon" .. WeaponType]:get_child("_title_TEXT"):set_text(y3.SurviveConst.DAMAGE_TYPE_NAME_MAP2
            [WeaponType])
        self["_weapon" .. WeaponType]:get_child("_descr_TEXT"):set_text(weaponSave:getWeanponTypeAllLevel(
            y3.gameApp:getMyPlayerId(), WeaponType))
    end
    local bounsLv = weaponSave:getWeaponResonanceLevel(y3.gameApp:getMyPlayerId())
    self._core:get_child("_descr_TEXT"):set_text(bounsLv)
    local attrMap = weaponSave:getResonanceLevelAttr(y3.gameApp:getMyPlayerId())
    local valueStr = string.format("%.2f", attrMap[1].value)
    self._descr_TEXT:set_text(GameAPI.get_text_config('#30000001#lua30') .. attrMap[1].name .. " +" .. valueStr .. "%")
end

return SurviveGameWeaponBookResonanceUI
