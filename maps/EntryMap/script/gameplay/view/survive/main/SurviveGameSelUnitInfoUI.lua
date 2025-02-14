local GlobalConfigHelper = require "gameplay.level.logic.helper.GlobalConfigHelper"
local SurviveGameSelUnitInfoUI = class("SurviveGameSelUnitInfoUI")

local TOWER_SHIELD_IMG = {
    ["me"] = 134223739,
    ["friend"] = 134223739,
    ["enemy"] = 134255446
}
local TOWER_NO_SHIELD_IMG = {
    ["me"] = 134231730,
    ["friend"] = 134231730,
    ["enemy"] = 134278702
}

local HP_IMG = {
    ["me"] = 134256279,
    ["friend"] = 134239641,
    ["enemy"] = 134220856
}

local UNIT_HOVER = {
    ["me"] = 134236731,
    ["friend"] = 134266567,
    ["enemy"] = 134237568
}

function SurviveGameSelUnitInfoUI:ctor(ui)
    self._ui = ui
    self._unitUI = y3.UIHelper.getUI("3c735e00-6a21-4172-a6d1-e4c41c19031b")
    self._tower_without_shieldUI = y3.UIHelper.getUI("030ba4e8-c4af-4b12-8340-1e6da2c6270b")
    self._tower_with_shieldUI = y3.UIHelper.getUI("f0646e69-6ead-48c3-8307-acaccb10028d")

    self._hero_without_shield = y3.UIHelper.getUI("fc026dc6-0af2-4cac-8414-c0516dddfa43")
    self._hero_with_shield = y3.UIHelper.getUI("6fecbfc9-1170-40c9-badc-a7b38b4cc9bd")
    self._hoverMap = {}
end

function SurviveGameSelUnitInfoUI:setVisible(visible)
    self._ui:set_visible(visible)
end

function SurviveGameSelUnitInfoUI:updateUI(unit)
    self._unitUI:set_visible(false)
    self._tower_with_shieldUI:set_visible(false)
    self._tower_without_shieldUI:set_visible(false)
    self._hero_with_shield:set_visible(false)
    self._hero_without_shield:set_visible(false)
    if unit:has_tag(y3.SurviveConst.STATE_PLAYER_TAG) then
        self:_updateTower(unit)
    elseif unit:has_tag(y3.SurviveConst.STATE_TAG_SOUL_ACTOR) then
        self:_updateHero(unit)
    else
        self:_updateUnit(unit)
    end
end

function SurviveGameSelUnitInfoUI:_hoverBuffList(buffList, unit)
    self._buffDatas = unit:get_buffs()
    local cells = buffList:get_childs()
    for i, buff in ipairs(cells) do
        if not self._hoverMap[buff] then
            self._hoverMap[buff] = true
            buff:add_local_event("鼠标-移入", function(local_player)
                local data = self._buffDatas[i]
                if data then
                    y3.gameApp:getLevel():getView("SurviveGameTip"):showUniversalTip({
                        title = data:get_name(),
                        desc = data:get_description()
                    })
                end
            end)
            buff:add_local_event("鼠标-移出", function(local_player)
                y3.gameApp:getLevel():getView("SurviveGameTip"):hideUniversalTip()
            end)
        end
    end
end

function SurviveGameSelUnitInfoUI:_updateHero(unit)
    local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local mainActor = playerData:getMainActor()
    local mainUnit = mainActor:getUnit()
    local ownPlayerId = unit:get_owner_player():get_id()
    local ownPlayerData = y3.userData:getPlayerData(ownPlayerId)
    local ownActor = ownPlayerData:getMainActor()
    local ownUnit = ownActor:getUnit()

    local haveShield = ownUnit:get_attr(y3.const.UnitAttr['最大魔法']) > 0
    local towerUI = nil
    if haveShield then
        self._hero_with_shield:set_visible(true)
        self._hero_without_shield:set_visible(false)
        towerUI = self._hero_with_shield
        local shieldBar = towerUI:get_child("shield_BAR")
        local shieldText = towerUI:get_child("shield_BAR._shield_value_TEXT")
        local shield = ownUnit:get_attr(y3.const.UnitAttr['魔法'])
        local maxShield = ownUnit:get_attr(y3.const.UnitAttr['最大魔法'])
        shieldBar:set_current_progress_bar_value(shield / maxShield * 100)
        shieldText:set_text(math.floor(shield) .. "/" .. math.floor(maxShield))
    else
        self._hero_with_shield:set_visible(false)
        self._hero_without_shield:set_visible(true)
        towerUI = self._hero_without_shield
    end
    local hover = towerUI:get_child("hover")
    local owner = unit:get_owner_player()
    local unitNameText = towerUI:get_child("_unit_name_TEXT")
    local attr1Icon = towerUI:get_child("stat.1.icon")
    local attr2Icon = towerUI:get_child("stat.2.icon")
    local attr1Text = towerUI:get_child("stat.1._value_TEXT")
    local attr2Text = towerUI:get_child("stat.2._value_TEXT")
    local hpBar = towerUI:get_child("hp_BAR")
    local hpText = towerUI:get_child("hp_BAR._unit_hp_value_TEXT")
    local hpImg = towerUI:get_child("hp_BAR.progress_bar_img")
    local unit_BUFFLIST = towerUI:get_child("_unit_BUFFLIST")
    local towerIcon = towerUI:get_child("avatar.mask._tower_ICON")
    unit_BUFFLIST:set_buff_on_ui(unit)
    self:_hoverBuffList(unit_BUFFLIST, unit)
    unitNameText:set_text(unit:get_name())
    local atk = math.floor(unit:get_attr(y3.const.UnitAttr['物理攻击']))
    local def = math.floor(ownUnit:get_attr(y3.const.UnitAttr['物理防御']))
    local hp = math.floor(ownUnit:get_attr(y3.const.UnitAttr['生命']))
    local maxHp = math.floor(ownUnit:get_attr(y3.const.UnitAttr['最大生命']))
    attr1Text:set_text(atk)
    attr2Text:set_text(def)
    hpText:set_text(hp .. "/" .. maxHp)
    hpBar:set_current_progress_bar_value(hp / maxHp * 100)
    -- attr1Icon:set_image(134233872)
    -- attr2Icon:set_image(134242611)
    towerIcon:set_image(unit:get_icon())
    if unit:is_enemy(mainUnit) then
        if haveShield then
            hover:set_image(TOWER_SHIELD_IMG["enemy"])
        else
            hover:set_image(TOWER_NO_SHIELD_IMG["enemy"])
        end
        hpImg:set_image(HP_IMG["enemy"])
    else
        if unit:get_owner_player():get_id() == playerData:getId() then
            if haveShield then
                hover:set_image(TOWER_SHIELD_IMG["me"])
            else
                hover:set_image(TOWER_NO_SHIELD_IMG["me"])
            end
            hpImg:set_image(HP_IMG["me"])
        else
            if haveShield then
                hover:set_image(TOWER_SHIELD_IMG["friend"])
            else
                hover:set_image(TOWER_NO_SHIELD_IMG["friend"])
            end
            hpImg:set_image(HP_IMG["friend"])
        end
    end
end

function SurviveGameSelUnitInfoUI:_updateTower(unit)
    local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local mainActor = playerData:getMainActor()
    local mainUnit = mainActor:getUnit()
    local haveShield = unit:get_attr(y3.const.UnitAttr['最大魔法']) > 0
    local towerUI = nil
    if haveShield then
        self._tower_with_shieldUI:set_visible(true)
        self._tower_without_shieldUI:set_visible(false)
        towerUI = self._tower_with_shieldUI
        local shieldBar = towerUI:get_child("shield_BAR")
        local shieldText = towerUI:get_child("shield_BAR._shield_value_TEXT")
        local shield = unit:get_attr(y3.const.UnitAttr['魔法'])
        local maxShield = unit:get_attr(y3.const.UnitAttr['最大魔法'])
        shieldBar:set_current_progress_bar_value(shield / maxShield * 100)
        shieldText:set_text(math.floor(shield) .. "/" .. math.floor(maxShield))
    else
        self._tower_with_shieldUI:set_visible(false)
        self._tower_without_shieldUI:set_visible(true)
        towerUI = self._tower_without_shieldUI
    end
    local hover = towerUI:get_child("hover")
    local owner = unit:get_owner_player()
    local unitNameText = towerUI:get_child("_unit_name_TEXT")
    local attr1Icon = towerUI:get_child("stat.1.icon")
    local attr2Icon = towerUI:get_child("stat.2.icon")
    local attr1Text = towerUI:get_child("stat.1._value_TEXT")
    local attr2Text = towerUI:get_child("stat.2._value_TEXT")
    local hpBar = towerUI:get_child("hp_BAR")
    local hpText = towerUI:get_child("hp_BAR._unit_hp_value_TEXT")
    local hpImg = towerUI:get_child("hp_BAR.progress_bar_img")
    local unit_BUFFLIST = towerUI:get_child("_unit_BUFFLIST")
    local towerIcon = towerUI:get_child("avatar.mask._tower_ICON")
    unit_BUFFLIST:set_buff_on_ui(unit)
    self:_hoverBuffList(unit_BUFFLIST, unit)
    unitNameText:set_text(owner:get_name())
    local atk = math.floor(unit:get_attr(y3.const.UnitAttr['物理防御']))
    local def = math.floor(unit:get_attr(y3.const.UnitAttr['生命恢复']))
    local hp = math.floor(unit:get_attr(y3.const.UnitAttr['生命']))
    local maxHp = math.floor(unit:get_attr(y3.const.UnitAttr['最大生命']))
    attr1Text:set_text(atk)
    attr2Text:set_text(def)
    hpText:set_text(hp .. "/" .. maxHp)
    hpBar:set_current_progress_bar_value(hp / maxHp * 100)
    attr1Icon:set_image(134233872)
    attr2Icon:set_image(134242611)
    towerIcon:set_image(unit:get_icon())
    if unit:is_enemy(mainUnit) then
        if haveShield then
            hover:set_image(TOWER_SHIELD_IMG["enemy"])
        else
            hover:set_image(TOWER_NO_SHIELD_IMG["enemy"])
        end
        hpImg:set_image(HP_IMG["enemy"])
    else
        if unit:get_owner_player():get_id() == playerData:getId() then
            if haveShield then
                hover:set_image(TOWER_SHIELD_IMG["me"])
            else
                hover:set_image(TOWER_NO_SHIELD_IMG["me"])
            end
            hpImg:set_image(HP_IMG["me"])
        else
            if haveShield then
                hover:set_image(TOWER_SHIELD_IMG["friend"])
            else
                hover:set_image(TOWER_NO_SHIELD_IMG["friend"])
            end
            hpImg:set_image(HP_IMG["friend"])
        end
    end
end

function SurviveGameSelUnitInfoUI:_updateUnit(unit)
    local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local mainActor = playerData:getMainActor()
    local mainUnit = mainActor:getUnit()
    local towerUI = self._unitUI
    towerUI:set_visible(true)
    local hover = towerUI:get_child("hover")
    local unitNameText = towerUI:get_child("_unit_name_TEXT")
    local attr1Icon = towerUI:get_child("stat.1.icon")
    local attr2Icon = towerUI:get_child("stat.2.icon")
    local attr1Text = towerUI:get_child("stat.1._value_TEXT")
    local attr2Text = towerUI:get_child("stat.2._value_TEXT")
    local hpBar = towerUI:get_child("hp_BAR")
    local hpText = towerUI:get_child("hp_BAR._unit_hp_value_TEXT")
    local hpImg = towerUI:get_child("hp_BAR.progress_bar_img")
    local typeIcon = towerUI:get_child("avatar.def_type._def_type_ICON")
    local unit_BUFFLIST = towerUI:get_child("_unit_BUFFLIST")
    local towerIcon = towerUI:get_child("avatar.mask._tower_ICON")
    unit_BUFFLIST:set_buff_on_ui(unit)
    self:_hoverBuffList(unit_BUFFLIST, unit)
    unitNameText:set_text(unit:get_name())
    local atk = math.floor(unit:get_attr(y3.const.UnitAttr['物理攻击']))
    local def = math.floor(unit:get_attr(y3.const.UnitAttr['物理防御']))
    local hp = math.floor(unit:get_attr(y3.const.UnitAttr['生命']))
    local maxHp = math.floor(unit:get_attr(y3.const.UnitAttr['最大生命']))
    attr1Text:set_text(atk)
    attr2Text:set_text(def)
    hpText:set_text(hp .. "/" .. maxHp)
    hpBar:set_current_progress_bar_value(hp / maxHp * 100)
    towerIcon:set_image(unit:get_icon())
    if unit:get_owner_player():get_id() == playerData:getId() then
        hover:set_image(UNIT_HOVER["me"])
        hpImg:set_image(HP_IMG["me"])
    else
        if unit:is_enemy(mainUnit) then
            hover:set_image(UNIT_HOVER["enemy"])
            hpImg:set_image(HP_IMG["enemy"])
        else
            hover:set_image(UNIT_HOVER["friend"])
            hpImg:set_image(HP_IMG["friend"])
        end
    end
    if unit:kv_has("cfgId") then
        local cfgId = unit:kv_load("cfgId", "integer")
        local cfg = include("gameplay.config.monster").get(cfgId)
        assert(cfg, "monster cfg not found:" .. cfgId)
        unitNameText:set_text(cfg.monster_name)
        local iconMap = GlobalConfigHelper.getArmorIconMap()
        typeIcon:set_image(iconMap[cfg.armor_type] or 0)
    end
end

return SurviveGameSelUnitInfoUI
