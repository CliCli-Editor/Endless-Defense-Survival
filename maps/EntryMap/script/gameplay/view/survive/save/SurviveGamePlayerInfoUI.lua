local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGamePlayerInfoUI = class("SurviveGamePlayerInfoUI", StaticUIBase)

local MAX_TYPE = 5
local MAX_POS = 2


function SurviveGamePlayerInfoUI:ctor()
    local ui = y3.UIHelper.getUI("9e2369f9-7f45-4c47-9fb3-037fe808cfde")
    SurviveGamePlayerInfoUI.super.ctor(self, ui)
    self._tab = y3.UIHelper.getUI("769a5121-5b40-4704-87cf-c07897b5ebbd")
    self._content = y3.UIHelper.getUI("e4902433-7d0c-451e-a2db-498cf56318e6")

    self._attrMainUI = y3.UIHelper.getUI("2a39045f-9436-4721-80bc-cab737004a0d")

    self._courseFilter = y3.UIHelper.getUI("3738a29e-2ec0-4019-aba3-13e461b24343")
    self._courseGrid = y3.UIHelper.getUI("f71cd760-c6cd-44d0-8049-1198fa488abb")

    self._courseUI = include("gameplay.view.survive.save.SurviveGameCourseUI").new()
    self._powerText = y3.UIHelper.getUI("1068ef8f-7116-41ce-9ace-fb5cef35cf8d")

    self:_initCfg()
    self:_initUI()
    self:_onTabClick(1)
    self:_updateAll()
end

function SurviveGamePlayerInfoUI:onUpdate()
    self:_updateAll()
end

function SurviveGamePlayerInfoUI:_initUI()
    local tabChilds = self._tab:get_childs()
    self._tabBtns = {}
    for i, child in ipairs(tabChilds) do
        local index = tonumber(child:get_name())
        if index then
            self._tabBtns[index] = child
            child:add_local_event("左键-点击", function(local_player)
                self:_onTabClick(index)
            end)
        end
    end
    self:_initAttrUI()
end

function SurviveGamePlayerInfoUI:_initFilter()
    local filterChilds = self._courseFilter:get_childs()
    self._courseFilterBtns = {}
    for i = 1, #filterChilds do
        local btn = filterChilds[i]:get_childs()[1]
        table.insert(self._courseFilterBtns, btn)
        btn:add_local_event("左键-点击", function(local_player)
            self:_onClickCourseAchiFilter(i)
        end)
    end
end

function SurviveGamePlayerInfoUI:_onClickCourseAchiFilter(index)
    for i = 1, #self._courseFilterBtns do
        self._courseFilterBtns[i]:set_image(i == index and 134278900 or 134227385)
    end
end

function SurviveGamePlayerInfoUI:_onTabClick(index)
    for i = 1, #self._tabBtns do
        self._tabBtns[i]:set_image(index == i and 134237413 or 134274921)
    end
    local childs = self._content:get_childs()
    for i = 1, #childs do
        childs[i]:set_visible(index == i)
    end
end

function SurviveGamePlayerInfoUI:_initAttrUI()
    local attrList = {
        "2bc9d555-9427-4ff9-b88d-e81216bbd5d7",
        "0bf0dddb-1459-4027-b831-e1bd589db15c",
        "9d403c86-d4a4-4c88-9790-d07568ad63a0",
        "83030a35-2fd8-473d-a835-7e8dc93f79a4",
        "aeece0ac-9080-4f03-9765-4e0cb149ede3"
    }
    self._uiAttrMap = {}
    for bigType = 1, MAX_TYPE do
        local bigUI = y3.UIHelper.getUI(attrList[bigType]) -- self._main:get_child("" .. i)
        assert(bigUI, "")
        if not self._uiAttrMap[bigType] then
            self._uiAttrMap[bigType] = {}
        end
        for smallType = 1, MAX_POS do
            local smallUI = bigUI:get_child("" .. smallType)
            assert(smallUI, "")
            if not self._uiAttrMap[bigType][smallType] then
                self._uiAttrMap[bigType][smallType] = {}
            end
            local childs = smallUI:get_child("value_LIST"):get_childs()
            for slot, child in ipairs(childs) do
                self._uiAttrMap[bigType][smallType][slot] = child
            end
        end
    end
end

function SurviveGamePlayerInfoUI:_initCfg()
    local attr = include("gameplay.config.attr")
    local len = attr.length()
    self._attrMap = {}
    self._nameAttr = {}
    for i = 1, len do
        local cfg = attr.indexOf(i)
        assert(cfg)
        if cfg.show_slot ~= "" then
            local fenleis = string.split(cfg.show_slot, "#")
            assert(fenleis)
            local bigType = tonumber(fenleis[1]) or 0
            local smallType = tonumber(fenleis[2]) or 0
            local slotValue = tonumber(fenleis[3]) or 0
            local attrKey = y3.const.UnitAttr[cfg.y3_name]
            if attrKey then
                self._nameAttr[attrKey] = { bigType, smallType, slotValue, cfg }
            end
            if not self._attrMap[bigType] then
                self._attrMap[bigType] = {}
            end
            if not self._attrMap[bigType][smallType] then
                self._attrMap[bigType][smallType] = {}
            end
            self._attrMap[bigType][smallType][slotValue] = cfg
        end
    end
end

function SurviveGamePlayerInfoUI:_updateAll()
    local attr = include("gameplay.config.attr")
    local len = attr.length()
    local attrMap = y3.userDataHelper.getAllSaveAttr(y3.gameApp:getMyPlayerId())
    local attrPower = y3.userDataHelper.getAttrPower(attrMap)
    self._powerText:set_text(math.floor(attrPower) .. "")
    for i = 1, len do
        local cfg = attr.indexOf(i)
        assert(cfg)
        if cfg.show_slot ~= "" then
            local fenleis = string.split(cfg.show_slot, "#")
            assert(fenleis)
            local bigType = tonumber(fenleis[1]) or 0
            local smallType = tonumber(fenleis[2]) or 0
            local slotValue = tonumber(fenleis[3]) or 0
            if self._uiAttrMap[bigType] then
                if self._uiAttrMap[bigType][smallType] then
                    local ui = self._uiAttrMap[bigType][smallType][slotValue]
                    if ui then
                        local attr_title_TEXT = ui:get_child("_attr_title_TEXT")
                        local attr_value_TEXT = ui:get_child("_attr_value_TEXT")
                        attr_value_TEXT:set_text_color_hex("e3cfa6", 255)
                        attr_title_TEXT:set_text(cfg.attr_name)
                        if cfg.show_type == 1 then
                            local baseValue = "#e3cfa6" .. math.floor(attrMap[cfg.id] or 0)
                            attr_value_TEXT:set_text(baseValue)
                        elseif cfg.show_type == 2 then
                            local baseValue = "#e3cfa6" .. string.format("%.2f", attrMap[cfg.id] or 0) .. "%"
                            attr_value_TEXT:set_text(baseValue)
                        end
                    end
                end
            end
        end
    end
end

return SurviveGamePlayerInfoUI
