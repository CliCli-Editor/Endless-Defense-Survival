local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGameTowerSkinUI = class("SurviveGameTowerSkinUI", StaticUIBase)

function SurviveGameTowerSkinUI:ctor()
    local ui = y3.UIHelper.getUI("1abb096d-89f2-482c-a7fa-32f936b48330")
    SurviveGameTowerSkinUI.super.ctor(self, ui)

    self._skin_GRID = y3.UIHelper.getUI("59d89ce8-7380-4d96-8edb-073f0ff1e2a6")
    self._skinName = y3.UIHelper.getUI("7a621f77-5412-4b69-a664-db22ff139db4")
    self._skin_MOD = y3.UIHelper.getUI("e8d062a4-3aaf-41ad-9352-7a3e91b87ce1")
    local detailUI = y3.UIHelper.getUI("287252ca-245c-456c-b4ea-1503f0b65b26")
    self._detailUI = include("gameplay.view.survive.save.dressUp.SurviveGameTowerSkinDetailUI").new(detailUI)

    self._skinCards = {}
    y3.gameApp:registerEvent(y3.EventConst.EVENT_EQUIP_TOWER_SKIN_SUCCESS, handler(self, self._onEventEquipSkinSuccess))
    self:_initUI()
end

function SurviveGameTowerSkinUI:_onEventEquipSkinSuccess(id, playerId, skinId)
    print("SurviveGameTowerSkinUI:_onEventEquipSkinSuccess", id, playerId, skinId)
    if playerId == y3.gameApp:getMyPlayerId() then
        self:onUpdate()
    end
end

function SurviveGameTowerSkinUI:_initUI()
    local stage_tower_skin = include("gameplay.config.stage_tower_skin")
    local len = stage_tower_skin.length()
    self._skinList = {}
    for i = 1, len do
        local cfg = stage_tower_skin.indexOf(i)
        table.insert(self._skinList, cfg)
    end
    for i = 1, #self._skinList do
        local card = self._skinCards[i]
        if not card then
            card = include("gameplay.view.survive.save.dressUp.SurviveGameTowerSkinCard").new(self._skin_GRID, self)
            self._skinCards[i] = card
        end
        card:updateUI(self._skinList[i])
    end
    self:onSelectSkin(self._skinList[1].id)
end

function SurviveGameTowerSkinUI:onUpdate()
    self:onSelectSkin(self._selectId)
end

function SurviveGameTowerSkinUI:onSelectSkin(selectId)
    self._selectId = selectId
    for i = 1, #self._skinCards do
        self._skinCards[i]:updateSelect(selectId)
    end
    local cfg = include("gameplay.config.stage_tower_skin").get(selectId)
    if cfg then
        self._skinName:set_text(cfg.tower_skin_name)
        self._skin_MOD:set_ui_model_id(cfg.tower_skin_model_id)
        self._detailUI:updateUI(cfg)
    end
end

return SurviveGameTowerSkinUI
