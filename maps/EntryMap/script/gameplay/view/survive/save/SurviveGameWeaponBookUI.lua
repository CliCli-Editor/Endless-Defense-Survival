local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGameWeaponBookUI = class("SurviveGameWeaponBookUI", StaticUIBase)

local MAX_WEAPON_TYPE = 5

function SurviveGameWeaponBookUI:ctor()
    local ui = y3.UIHelper.getUI("f50c5ace-a3e6-46fc-9233-53361b0227b9")
    SurviveGameWeaponBookUI.super.ctor(self, ui)
    self._res_icon_IMG          = y3.UIHelper.getUI("f483d305-f8ba-41e2-8e1c-322750ebb271")
    self._res_value_TEXT        = y3.UIHelper.getUI("88bbd235-9be6-4640-9213-c2af9239b77f")
 
    self._weaponListMap         = {}
    self._weaponListMap[1]      = y3.UIHelper.getUI("4537bffd-07e2-4adf-99c6-8629d077535e")
    self._weaponListMap[2]      = y3.UIHelper.getUI("e4a5e45f-2bc7-454f-bc3c-f10059509c15")
    self._weaponListMap[3]      = y3.UIHelper.getUI("b88e3b60-636d-4e0f-99d3-38014914d3b0")
    self._weaponListMap[4]      = y3.UIHelper.getUI("b09c76c1-defc-4dcf-9122-1e6900a5b602")
    self._weaponListMap[5]      = y3.UIHelper.getUI("42d5b339-4898-4b98-b56a-3f21d363694a")

    self._weaponGridCardsMap    = {}
    self._weaponGridCardsMap[1] = {}
    self._weaponGridCardsMap[2] = {}
    self._weaponGridCardsMap[3] = {}
    self._weaponGridCardsMap[4] = {}
    self._weaponGridCardsMap[5] = {}

    self._weaponCardList        = {}

    self._rightUI               = include("gameplay.view.survive.save.SurviveGameWeaponBookRightUI").new()
    self._first                 = true
    self:_initUI()
end

function SurviveGameWeaponBookUI:_initUI()
    for weaponType = 1, MAX_WEAPON_TYPE do
        local weaponList = self._weaponListMap[weaponType]
        self:_initWeaponList(weaponList, weaponType)
    end
end

function SurviveGameWeaponBookUI:_initWeaponList(weaponList, weaponType)
    local def_type_IMG = weaponList:get_child("title._def_type_IMG")
    local title_TEXT = weaponList:get_child("title.title_TEXT")
    local weapon_GRID = weaponList:get_child("weapon_GRID")
    def_type_IMG:set_image(y3.SurviveConst.SKILLTYPE_ICON[weaponType])
    title_TEXT:set_text(y3.SurviveConst.DAMAGE_TYPE_NAME_MAP[weaponType])
    local weaponLogic = y3.gameApp:getLevel():getLogic("SurviveGameWeaponSave")
    local list = weaponLogic:getBookWeaponTypeList(weaponType)
    local weanponCards = self._weaponGridCardsMap[weaponType]
    for i = 1, #list do
        local card = weanponCards[i]
        if not card then
            card = include("gameplay.view.survive.save.SurviveGameWeaponBookCard").new(weapon_GRID, self)
            weanponCards[i] = card
            table.insert(self._weaponCardList, card)
        end
        card:updateUI(list[i])
    end
    if self._first then
        self._first = false
        self:onSelectWeaponCard(list[1])
    end
end

function SurviveGameWeaponBookUI:onSelectWeaponCard(weaponId)
    self._rightUI:updateUI(weaponId)
    for i = 1, #self._weaponCardList do
        self._weaponCardList[i]:updateSelect(weaponId)
    end
end

return SurviveGameWeaponBookUI
