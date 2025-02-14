local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGameAllAttrUI = class("SurviveGameAllAttrUI", StaticUIBase)

local MAX_TYPE = 5
local MAX_POS = 2

function SurviveGameAllAttrUI:ctor()
    local ui = y3.UIHelper.getUI("1474e877-00dc-4973-8d70-a9f536c2db10")
    SurviveGameAllAttrUI.super.ctor(self, ui)
    self._main = y3.UIHelper.getUI("6da413a9-73f5-4ba6-b62c-3378b138e2b7")
    self:_initUI()
    self:_initCfg()
    self._hoverMap = {}
    y3.gameApp:registerEvent(y3.EventConst.EVENT_SURVIVE_ATTR_CHANGE, handler(self, self._onEventUpdateAttrs))
end

function SurviveGameAllAttrUI:_initUI()
    local attrList = {
        "54de63d1-ce47-4708-8285-16699509553e",
        "56985eaf-57bd-493a-9313-5f92c7d7bf4a",
        "022ec093-6098-4f81-9241-e79c89c18bb4",
        "a1180a68-e69b-4a79-b028-20c13fb15fca",
        "a50b939f-aefc-4396-ab21-ddb687faf984"
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

function SurviveGameAllAttrUI:_initCfg()
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

function SurviveGameAllAttrUI:toggleShow()
    self:show(not self:isVisible())
end

function SurviveGameAllAttrUI:show(visible)
    self:setVisible(visible)
    if visible then
        self:_updateAll()
    end
end

function SurviveGameAllAttrUI:_hoverAttrTip(ui, cfg)
    if not self._hoverMap[ui] then
        self._hoverMap[ui] = 1
        ui:add_local_event("鼠标-移入", function()
            y3.Sugar.tipRoot():showUniversalTip({ title = "", desc = cfg.desc })
        end)
        ui:add_local_event("鼠标-移出", function()
            y3.Sugar.tipRoot():hideUniversalTip()
        end)
    end
end

function SurviveGameAllAttrUI:_updateAll()
    local attr = include("gameplay.config.attr")
    local len = attr.length()
    local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local mainActor = playerData:getMainActor()
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
                        self:_hoverAttrTip(ui, cfg)
                        local attr_title_TEXT = ui:get_child("_attr_title_TEXT")
                        local attr_value_TEXT = ui:get_child("_attr_value_TEXT")
                        attr_value_TEXT:set_text_color_hex("e3cfa6", 255)
                        attr_title_TEXT:set_text(cfg.attr_name)
                        if cfg.show_type == 1 then
                            local baseValue = "#e3cfa6" .. math.floor(mainActor:getAttrPureValue1(cfg.id))
                            local zenyiValue = "#0fd121+" .. math.floor(mainActor:getAttrPureValue2(cfg.id))
                            attr_value_TEXT:set_text(baseValue .. " " .. zenyiValue)
                        elseif cfg.show_type == 2 then
                            local baseValue = "#e3cfa6" ..
                                string.format("%.2f", mainActor:getAttrPureValue1(cfg.id)) .. "%"
                            local zenyiValue = "#0fd121+" ..
                                string.format("%.2f", mainActor:getAttrPureValue2(cfg.id)) .. "%"
                            attr_value_TEXT:set_text(baseValue .. " " .. zenyiValue)
                        end
                    end
                end
            end
        end
    end
end

function SurviveGameAllAttrUI:_updateAttrs(attrs)
    local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local mainActor = playerData:getMainActor()
    for i = 1, #attrs do
        local y3Name = attrs[i]
        local params = self._nameAttr[y3Name]
        if params then
            local bigType = params[1]
            local smallType = params[2]
            local slotValue = params[3]
            local cfg = params[4]
            if self._uiAttrMap[bigType] then
                if self._uiAttrMap[bigType][smallType] then
                    local ui = self._uiAttrMap[bigType][smallType][slotValue]
                    if ui then
                        local attr_title_TEXT = ui:get_child("_attr_title_TEXT")
                        local attr_value_TEXT = ui:get_child("_attr_value_TEXT")
                        attr_title_TEXT:set_text(cfg.attr_name)
                        if cfg.show_type == 1 then
                            local baseValue = "#e3cfa6" .. math.floor(mainActor:getAttrPureValue1(cfg.id))
                            local zenyiValue = "#0fd121+" .. math.floor(mainActor:getAttrPureValue2(cfg.id))
                            attr_value_TEXT:set_text(baseValue .. " " .. zenyiValue)
                        elseif cfg.show_type == 2 then
                            local baseValue = "#e3cfa6" ..
                                string.format("%.2f", mainActor:getAttrPureValue1(cfg.id)) .. "%"
                            local zenyiValue = "#0fd121+" ..
                                string.format("%.2f", mainActor:getAttrPureValue2(cfg.id)) .. "%"
                            attr_value_TEXT:set_text(baseValue .. " " .. zenyiValue)
                        end
                    end
                end
            end
        end
    end
end

function SurviveGameAllAttrUI:_onEventUpdateAttrs(event, playerId, attrs)
    if playerId == y3.gameApp:getMyPlayerId() then
        if self:isVisible() then
            print("SurviveGameAllAttrUI:_onEventUpdateAttrs", playerId, attrs)
            self:_updateAttrs(attrs)
        end
    end
end

return SurviveGameAllAttrUI
