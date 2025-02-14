local GlobalConfigHelper = require "gameplay.level.logic.helper.GlobalConfigHelper"
local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGameWikiUI = class("SurviveGameWikiUI", StaticUIBase)

local MAX_WEAPON_TYPE = 5

function SurviveGameWikiUI:ctor()
    local ui = y3.UIHelper.getUI("2372b717-88a5-4fc2-a208-0772025e5f9a")
    SurviveGameWikiUI.super.ctor(self, ui)

    self._exitBtn = y3.UIHelper.getUI("d5d85f5c-a111-4021-8bd7-5d2b89507990")
    self._exitBtn:add_local_event("左键-点击", handler(self, self._onBtnCloseClick))

    self._weaponListMap    = {}
    self._weaponListMap[1] = y3.UIHelper.getUI("4d0b122a-543d-423e-bc67-f1f6ec653d7d")
    self._weaponListMap[2] = y3.UIHelper.getUI("a1cc386a-c872-49e1-842a-b52e6ddc0f73")
    self._weaponListMap[3] = y3.UIHelper.getUI("6e7bed4e-0ab5-47b8-81ec-8b582bd5360c")
    self._weaponListMap[4] = y3.UIHelper.getUI("49d8019e-c965-4f62-821f-a16db9b49f6b")
    self._weaponListMap[5] = y3.UIHelper.getUI("bb592449-e2fa-44fe-b0e0-4ccdf009e83a")

    self._upgradeList      = y3.UIHelper.getUI("8f198a10-eb5d-46e1-a3f5-8f6f0e8e2778")
    self._upgradeList:set_visible(false)

    self._weaponGridCardsMap    = {}
    self._weaponGridCardsMap[1] = {}
    self._weaponGridCardsMap[2] = {}
    self._weaponGridCardsMap[3] = {}
    self._weaponGridCardsMap[4] = {}
    self._weaponGridCardsMap[5] = {}

    self._weaponCardList        = {}
    self._first                 = true
    self:_initUI()
end

function SurviveGameWikiUI:_onBtnCloseClick()
    self:setVisible(false)
end

function SurviveGameWikiUI:_initUI()
    for weaponType = 1, MAX_WEAPON_TYPE do
        local weaponList = self._weaponListMap[weaponType]
        self:_initWeaponList(weaponList, weaponType)
    end
    -- local curStageId = y3.userData:getMaxUnLockStageId()
    -- local unlockMap = GlobalConfigHelper.getAttackTypeUnlockMap()
    -- for weaponType = 1, MAX_WEAPON_TYPE do
    --     local weaponList = self._weaponListMap[weaponType]
    --     local unlockId = unlockMap[weaponType] or 0
    --     weaponList:set_visible(curStageId >= unlockId)
    -- end
end

function SurviveGameWikiUI:_initWeaponList(weaponList, weaponType)
    local def_type_IMG = weaponList:get_child("title._def_type_IMG")
    local title_TEXT = weaponList:get_child("title.title_TEXT")
    local weapon_GRID = weaponList:get_child("weapon_GRID")
    def_type_IMG:set_image(y3.SurviveConst.SKILLTYPE_ICON[weaponType])
    title_TEXT:set_text(y3.SurviveConst.DAMAGE_TYPE_NAME_MAP[weaponType])
    local weaponLogic = y3.gameApp:getLevel():getLogic("SurviveGameWeaponSave")
    local list = weaponLogic:getBookWeaponTypeList(weaponType)
    local weanponCards = self._weaponGridCardsMap[weaponType]
    local curStageId = y3.userData:getMaxUnLockStageId()
    for i = 1, #list do
        local card = weanponCards[i]
        if not card then
            card = include("gameplay.view.survive.save.SurviveGameWeaponBookCard").new(weapon_GRID, self)
            weanponCards[i] = card
            table.insert(self._weaponCardList, card)
        end
        card:updateSampleUI(list[i], curStageId)
    end
    if self._first then
        self._first = false
        self:onSelectWeaponCard(list[1])
    end
end

function SurviveGameWikiUI:onSelectWeaponCard(weaponId)
    for i = 1, #self._weaponCardList do
        self._weaponCardList[i]:updateSelect(weaponId)
    end
end

function SurviveGameWikiUI:toggleShow()
    self:setVisible(not self:isVisible())
end

return SurviveGameWikiUI
