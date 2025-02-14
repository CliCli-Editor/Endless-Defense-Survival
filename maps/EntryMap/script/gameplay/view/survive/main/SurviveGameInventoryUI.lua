local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGameInventoryUI = class("SurviveGameInventoryUI", StaticUIBase)

local SKILL_NORMAL_BG = 134232005
local SKILL_SELECT_BG = 134226491

local TOWER_COLLECT_NROMAL = 134245195
local TOWER_COLLECT_SELECT = 134225969

local HERO_COLLECT_NROMAL = 134230431
local HERO_COLLECT_SELECT = 134263535

local LIGHT_IMG = 134274707
local NORMAL_IMG = 134233360

function SurviveGameInventoryUI:ctor()
    local ui = y3.UIHelper.getUI("a6bd7d61-0b28-4725-8402-ce38e34962bb")
    SurviveGameInventoryUI.super.ctor(self, ui)
    self._inventory_GRID = y3.UIHelper.getUI("053c0fa4-b0cc-4235-a3a7-cd0de951b2dd")
    self._tower_LIST = y3.UIHelper.getUI("f4f85a96-62eb-4a8f-8824-5251a896ec92")
    self._hero_LIST = y3.UIHelper.getUI("9c5148b6-5a6d-4cb1-a177-72df03303cee")

    self._tower_LIST2 = y3.UIHelper.getUI("40da52b2-145f-4cb8-b744-8faa83719b1e")
    self._hero_LIST2 = y3.UIHelper.getUI("47b31a65-5cd4-4344-a142-d0ee17a496f1")

    self._towerSkillPanel = y3.UIHelper.getUI("bdcf8cf2-5274-4409-abf1-7b42a907442b")
    self._heroSkillPanel = y3.UIHelper.getUI("16ded927-609c-40f6-97c7-a6dce6deac46")

    self._hecheng_BTN = y3.UIHelper.getUI("9f1fb5d6-6500-4ea8-9a51-05efd5892e75")
    self._sell_BTN = y3.UIHelper.getUI("05066f31-9096-47a3-b8c2-53153ec8e6d7")

    self._exitBtn = y3.UIHelper.getUI("29444fbc-bd91-48ed-ba54-1bc79c114c5f")
    self._exitBtn:add_local_event("左键-点击", handler(self, self._onBtnCloseClick))

    self._towerPanalImg = y3.UIHelper.getUI("17166fec-88f3-4900-8c31-c246372b86ab")
    self._heroPanelImg = y3.UIHelper.getUI("96e8b2b0-c2a1-4c5c-8c00-2cdd87068172")

    self:_initUI()
    self._hecheng_BTN:set_visible(false)
    self._sell_BTN:set_visible(false)
    self._hecheng_BTN:add_local_event("左键-点击", handler(self, self._onBtnHechengClick))
    self._sell_BTN:add_local_event("左键-点击", handler(self, self._onBtnSellClick))

    local playerData  = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local mainActor   = playerData:getMainActor()
    local abis        = playerData:getMainActor():getUnit():get_abilities_by_type(y3.const.AbilityType.COMMON)
    local abis2       = playerData:getMainActor():getUnit():get_abilities_by_type(y3.const.AbilityType.HERO)
    self._towerSkill1 = y3.UIHelper.getUI("74faee8b-a1c4-40c5-ab54-ae4620717f26")
    self._towerSkill2 = y3.UIHelper.getUI("1226da8e-53cd-419b-a412-a8d52a1bc2a9")
    self._towerSkill3 = y3.UIHelper.getUI("45b39b3a-1da4-4b1f-a07f-43594b746f25")
    self._towerSkill1:bind_unit(mainActor:getUnit())
    self._towerSkill2:bind_unit(mainActor:getUnit())
    self._towerSkill1:bind_ability(abis[1])
    if abis[2] then
        self._towerSkill2:set_visible(true)
        self._towerSkill2:bind_ability(abis[2])
    else
        self._towerSkill2:set_visible(false)
    end
    if abis2[1] then
        self._towerSkill3:set_visible(true)
        self._towerSkill3:bind_ability(abis2[1])
    else
        self._towerSkill3:set_visible(false)
    end
    self:_handlerCommonSkillTip(self._towerSkill1, 1, true, y3.const.AbilityType.COMMON)
    self:_handlerCommonSkillTip(self._towerSkill2, 2, true, y3.const.AbilityType.COMMON)
    self:_handlerCommonSkillTip(self._towerSkill3, 1, true, y3.const.AbilityType.HERO)

    local souldActor = mainActor:getSoulHeroActor()
    self._heroSkill1 = y3.UIHelper.getUI("17585ffd-450a-4627-88d0-4a14f8051bac")
    self._heroSkill2 = y3.UIHelper.getUI("f479bfe8-7280-41d0-95df-8fbb9d31377e")
    self._heroSkill3 = y3.UIHelper.getUI("7a422072-0f11-4652-92c6-94382db6a5bb")
    self._heroSkill1:bind_unit(souldActor:getUnit())
    self._heroSkill2:bind_unit(souldActor:getUnit())
    self._heroSkill3:bind_unit(souldActor:getUnit())
    self._heroSkill2:set_visible(false)
    self:_handlerCommonSkillTip(self._heroSkill1, 1, false, y3.const.AbilityType.HERO)
    self:_handlerCommonSkillTip(self._heroSkill2, 2, false, y3.const.AbilityType.HERO)
    self:_handlerCommonSkillTip(self._heroSkill3, 3, false, y3.const.AbilityType.HERO)
    y3.gameApp:registerEvent(y3.EventConst.HERO_SOUL_ADD_SKILL, handler(self, self._onEventHeroSoulAddSkill))
    y3.gameApp:registerEvent(y3.EventConst.EVENT_SURVIVE_SELECT_UNIT, handler(self, self._onEventSelectUnit))
    self:_onEventHeroSoulAddSkill(1, y3.gameApp:getMyPlayerId())
    y3.ctimer.wait(0.1, function(timer, count, local_player)
        self:_onEventSelectUnit(true, local_player, local_player:get_selecting_unit())
    end)
end

function SurviveGameInventoryUI:_handlerCommonSkillTip(skillUI, index, isTower, abilityType)
    skillUI:add_local_event("鼠标-移入", function(local_player)
        local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
        local actor      = nil
        if isTower then
            actor = playerData:getMainActor()
        else
            actor = playerData:getMainActor():getSoulHeroActor()
        end
        local abis = actor:getUnit():get_abilities_by_type(abilityType)
        if abis[index] then
            local abilityKey = abis[index]:get_key()
            print(abilityKey)
            local cfg = include("gameplay.config.config_skillData").get(tostring(abilityKey))
            if cfg then
                y3.gameApp:getLevel():getView("SurviveGameTip"):showSkillTip({ cfg = cfg })
            end
        end
    end)
    skillUI:add_local_event("鼠标-移出", function(local_player)
        y3.gameApp:getLevel():getView("SurviveGameTip"):hideSkillTip({})
    end)
end

function SurviveGameInventoryUI:_onEventHeroSoulAddSkill(id, playerId)
    if playerId == y3.gameApp:getMyPlayerId() then
        local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
        local mainActor  = playerData:getMainActor()
        local souldActor = mainActor:getSoulHeroActor()
        local abis       = souldActor:getUnit():get_abilities_by_type(y3.const.AbilityType.HERO)
        if abis[1] then
            self._heroSkill1:set_visible(true)
            self._heroSkill1:bind_ability(abis[1])
        else
            self._heroSkill1:set_visible(false)
        end
        if abis[2] then
            self._heroSkill2:set_visible(false)
            self._heroSkill2:bind_ability(abis[2])
        else
            self._heroSkill2:set_visible(false)
        end
        if abis[3] then
            self._heroSkill3:set_visible(true)
            self._heroSkill3:bind_ability(abis[3])
        else
            self._heroSkill3:set_visible(false)
        end
    end
end

function SurviveGameInventoryUI:_onEventSelectUnit(trg, player, isSelect)
    y3.player.with_local(function(local_player)
        if player:get_id() == local_player:get_id() then
            if isSelect then
                local selUnit = local_player:get_selecting_unit()
                if selUnit then
                    if selUnit:get_owner_player() == local_player then
                        if selUnit:has_tag(y3.SurviveConst.STATE_TAG_SOUL_ACTOR) then
                            self:_setChildsBg(self._towerSkillPanel, SKILL_NORMAL_BG)
                            self:_setChildsBg(self._heroSkillPanel, SKILL_SELECT_BG)
                            self:_setChildsBg(self._tower_LIST2, TOWER_COLLECT_NROMAL)
                            self:_setChildsBg(self._hero_LIST2, HERO_COLLECT_SELECT)
                            self._towerPanalImg:set_image(NORMAL_IMG)
                            self._heroPanelImg:set_image(LIGHT_IMG)
                            return
                        elseif selUnit:has_tag(y3.SurviveConst.STATE_PLAYER_TAG) then
                            self:_setChildsBg(self._towerSkillPanel, SKILL_SELECT_BG)
                            self:_setChildsBg(self._heroSkillPanel, SKILL_NORMAL_BG)
                            self:_setChildsBg(self._tower_LIST2, TOWER_COLLECT_SELECT)
                            self:_setChildsBg(self._hero_LIST2, HERO_COLLECT_NROMAL)
                            self._towerPanalImg:set_image(LIGHT_IMG)
                            self._heroPanelImg:set_image(NORMAL_IMG)
                            return
                        end
                    end
                end
            end
            self:_setChildsBg(self._towerSkillPanel, SKILL_NORMAL_BG)
            self:_setChildsBg(self._heroSkillPanel, SKILL_NORMAL_BG)
            self:_setChildsBg(self._tower_LIST2, TOWER_COLLECT_NROMAL)
            self:_setChildsBg(self._hero_LIST2, HERO_COLLECT_NROMAL)
        end
    end)
end

function SurviveGameInventoryUI:_setChildsBg(parent, bgId)
    local childs = parent:get_childs()
    for i, child in ipairs(childs) do
        child:get_child("bg"):set_image(bgId)
    end
end

function SurviveGameInventoryUI:_initUI()
    local playeData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local mainActor = playeData:getMainActor()
    if mainActor then
        local soulActor  = mainActor:getSoulHeroActor()
        local mainUnit   = mainActor:getUnit()
        local soulUnit   = soulActor:getUnit()

        local inventorys = self._inventory_GRID:get_childs()
        for i, inventory in ipairs(inventorys) do
            inventory:get_child("item"):bind_unit(mainUnit)
            inventory:get_child("item"):set_ui_unit_slot(mainUnit, y3.const.ShiftSlotType['背包栏'], i - 1)
            self:_hoverItem(inventory:get_child("item"), y3.const.ShiftSlotType['背包栏'], i - 1, true)
        end
        local towerChilds = self._tower_LIST:get_childs()
        for i, tower in ipairs(towerChilds) do
            tower:get_child("item"):bind_unit(mainUnit)
            tower:get_child("item"):set_ui_unit_slot(mainUnit, y3.const.ShiftSlotType['物品栏'], i - 1)
            self:_hoverItem(tower:get_child("item"), y3.const.ShiftSlotType['物品栏'], i - 1, true)
        end
        local heroChilds = self._hero_LIST:get_childs()
        for i, hero in ipairs(heroChilds) do
            hero:get_child("item"):bind_unit(soulUnit)
            hero:get_child("item"):set_ui_unit_slot(soulUnit, y3.const.ShiftSlotType['物品栏'], i - 1)
            self:_hoverItem(hero:get_child("item"), y3.const.ShiftSlotType['物品栏'], i - 1, false)
        end

        local heroChilds = self._tower_LIST2:get_childs()
        for i, hero in ipairs(heroChilds) do
            hero:get_child("equip_slot"):bind_unit(mainUnit)
            hero:get_child("equip_slot"):set_ui_unit_slot(mainUnit, y3.const.ShiftSlotType['物品栏'], i - 1)
            self:_hoverItem(hero:get_child("equip_slot"), y3.const.ShiftSlotType['物品栏'], i - 1, true, true)
        end

        local heroChilds = self._hero_LIST2:get_childs()
        for i, hero in ipairs(heroChilds) do
            hero:get_child("equip_slot"):bind_unit(soulUnit)
            hero:get_child("equip_slot"):set_ui_unit_slot(soulUnit, y3.const.ShiftSlotType['物品栏'], i - 1)
            self:_hoverItem(hero:get_child("equip_slot"), y3.const.ShiftSlotType['物品栏'], i - 1, false)
        end
    end
end

function SurviveGameInventoryUI:_hoverItem(itemUi, slotType, slot, isTower, highlight)
    itemUi:add_local_event("鼠标-移入", function(local_player)
        local playeData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
        local mainActor = playeData:getMainActor()
        if mainActor then
            local soulActor = mainActor:getSoulHeroActor()
            local mainUnit  = mainActor:getUnit()
            local soulUnit  = soulActor:getUnit()
            if isTower then
                local item = mainUnit:get_item_by_slot(slotType, slot + 1)
                if item then
                    local cfgId = item:get_key()
                    y3.gameApp:getLevel():getView("SurviveGameTip"):showItemTip(cfgId)
                    if highlight then
                        -- print("highlight")
                        local itemCfg = include("gameplay.config.item").get(cfgId)
                        if itemCfg then
                            -- print(itemCfg.item_hold_args)
                            local holdArgs = string.split(itemCfg.item_hold_args, "#")
                            local skillId = tonumber(holdArgs[2]) or 0
                            local skillCfg = include("gameplay.config.config_skillData").get(tostring(skillId))
                            if skillCfg then
                                -- print(skillCfg.skill_icon_highlight)
                                y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SKIL_TOTAL_HIGHLIGHT,
                                    y3.gameApp:getMyPlayerId(),
                                    skillCfg.skill_icon_highlight)
                            end
                        end
                    end
                end
            else
                local item = soulUnit:get_item_by_slot(slotType, slot + 1)
                if item then
                    local cfgId = item:get_key()
                    y3.gameApp:getLevel():getView("SurviveGameTip"):showItemTip(cfgId, item)
                end
            end
        end
    end)
    itemUi:add_local_event("鼠标-移出", function(local_player)
        if highlight then
            y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SKIL_TOTAL_HIDE_HIGHLIGHT, y3.gameApp:getMyPlayerId())
        end
        y3.gameApp:getLevel():getView("SurviveGameTip"):hideItemTip()
    end)
end

function SurviveGameInventoryUI:toggleShow()
    self:setVisible(not self:isVisible())
end

function SurviveGameInventoryUI:_onBtnCloseClick()
    self:setVisible(false)
end

function SurviveGameInventoryUI:_onBtnHechengClick()
    y3.SyncMgr:sync(y3.SyncConst.SYNC_HECHENG_PKG_ITEM, {})
end

function SurviveGameInventoryUI:_onBtnSellClick()
    y3.SyncMgr:sync(y3.SyncConst.SYNC_SELLITEM_PKG_ONEKEY, {})
end

return SurviveGameInventoryUI
