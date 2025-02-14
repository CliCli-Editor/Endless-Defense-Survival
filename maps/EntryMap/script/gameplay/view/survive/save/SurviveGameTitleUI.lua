local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGameTitleUI = class("SurviveGameTitleUI", StaticUIBase)

function SurviveGameTitleUI:ctor()
    local ui = y3.UIHelper.getUI("19115380-736c-4864-8730-a1bddd6a29e5")
    SurviveGameTitleUI.super.ctor(self, ui)
    self._prefix_LIST = y3.UIHelper.getUI("f25d1398-efb3-46b1-a994-848aedfb2a83")
    self._prefixAttr = y3.UIHelper.getUI("bd85b569-3179-4810-a686-e25ed53c7831")

    self._connect_LIST = y3.UIHelper.getUI("e15ea07d-12e6-4e33-8b2a-658f187a38f3")
    self._connectAttr = y3.UIHelper.getUI("1cf9f36c-2726-4866-b3e7-f5cd63b0d1f3")

    self._suffix_LIST = y3.UIHelper.getUI("2470e497-3ade-485d-a840-2bcb35424d5d")
    self._suffixAttr = y3.UIHelper.getUI("f776e175-f040-4f19-8f29-0c2b94394bcc")

    self._rightUI = include("gameplay.view.survive.save.SurviveGameTitleRightUI").new(self)

    self._attrUIMap = {
        [1] = self._prefixAttr,
        [2] = self._connectAttr,
        [3] = self._suffixAttr
    }

    self._titleCellMap = {}
    self._selectTitleMap = {}
    self:_initCfg()
    self:_initUI()
    self:_updateTitleAttr(self._prefixAttr, self._titleMap[1][1])
    self:_updateTitleAttr(self._connectAttr, self._titleMap[2][1])
    self:_updateTitleAttr(self._suffixAttr, self._titleMap[3][1])
    y3.gameApp:registerEvent(y3.EventConst.EVENT_EQUIP_TITLE_SUCCESS, handler(self, self._onEventEquipTitleSuccess))
end

function SurviveGameTitleUI:onUpdate()
    local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    self:_initUI()
    if self._titleMap[1] then
        self:onSelectTtile(self._prefix_LIST, playerData:getPreTitleId() or self._titleMap[1][1].id)
    end
    if self._titleMap[2] then
        self:onSelectTtile(self._connect_LIST, playerData:getConnectTitleId() or self._titleMap[2][1].id)
    end
    if self._titleMap[3] then
        self:onSelectTtile(self._suffix_LIST, playerData:getSuffixTtileId() or self._titleMap[3][1].id)
    end
end

function SurviveGameTitleUI:_initCfg()
    local title = include("gameplay.config.title")
    local len = title.length()
    self._titleMap = {}
    for i = 1, len do
        local cfg = title.indexOf(i)
        assert(cfg, "")
        if not self._titleMap[cfg.type] then
            self._titleMap[cfg.type] = {}
        end
        table.insert(self._titleMap[cfg.type], cfg)
    end
end

function SurviveGameTitleUI:_onEventEquipTitleSuccess()
    self:_initUI()
    self:_updateBottomAttrUI()
end

function SurviveGameTitleUI:_updateBottomAttrUI()
    local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    if self._titleMap[1] then
        self:updateAttrUI(playerData:getPreTitleId() or self._titleMap[1][1].id)
    end
    if self._titleMap[2] then
        self:updateAttrUI(playerData:getConnectTitleId() or self._titleMap[2][1].id)
    end
    if self._titleMap[3] then
        self:updateAttrUI(playerData:getSuffixTtileId() or self._titleMap[3][1].id)
    end
end

function SurviveGameTitleUI:_initUI()
    self:_updateTitleList(self._prefix_LIST, self._titleMap[1])
    self:_updateTitleList(self._connect_LIST, self._titleMap[2])
    self:_updateTitleList(self._suffix_LIST, self._titleMap[3])
end

function SurviveGameTitleUI:_updateTitleList(listUI, list)
    local cardList = self._titleCellMap[listUI] or {}
    self._titleCellMap[listUI] = cardList
    for i = 1, #list do
        local card = cardList[i]
        if not card then
            card = include("gameplay.view.survive.save.SurviveGameTitleCell").new(listUI)
            cardList[i] = card
        end
        card:updateUI(list[i], self)
    end
end

function SurviveGameTitleUI:onSelectTtile(parent, titleId)
    self._selectTitleMap[parent] = titleId
    local list = self._titleCellMap[parent]
    for _, cell in pairs(list) do
        cell:updateSelect(titleId)
    end
    local cfg = include("gameplay.config.title").get(titleId)
    if cfg then
        self._rightUI:updateUI(cfg)
        if self._attrUIMap[cfg.type] then
            local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
            local titleCfg = nil
            if cfg.type == 1 then
                titleCfg = include("gameplay.config.title").get(playerData:getPreTitleId())
            elseif cfg.type == 2 then
                titleCfg = include("gameplay.config.title").get(playerData:getConnectTitleId())
            elseif cfg.type == 3 then
                titleCfg = include("gameplay.config.title").get(playerData:getSuffixTtileId())
            end
            self:_updateTitleAttr(self._attrUIMap[cfg.type], titleCfg)
        end
    end
end

function SurviveGameTitleUI:updateAttrUI(titleId)
    local cfg = include("gameplay.config.title").get(titleId)
    if cfg then
        if self._attrUIMap[cfg.type] then
            local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
            local titleCfg = nil
            if cfg.type == 1 then
                titleCfg = include("gameplay.config.title").get(playerData:getPreTitleId())
            elseif cfg.type == 2 then
                titleCfg = include("gameplay.config.title").get(playerData:getConnectTitleId())
            elseif cfg.type == 3 then
                 titleCfg = include("gameplay.config.title").get(playerData:getSuffixTtileId())
            end
            self:_updateTitleAttr(self._attrUIMap[cfg.type], titleCfg)
        end
    end
end

function SurviveGameTitleUI:getAllTtileText()
    local title1 = self._selectTitleMap[self._prefix_LIST] or 0
    local title2 = self._selectTitleMap[self._connect_LIST] or 0
    local title3 = self._selectTitleMap[self._suffix_LIST] or 0
    local cfg1 = include("gameplay.config.title").get(title1)
    local cfg2 = include("gameplay.config.title").get(title2)
    local cfg3 = include("gameplay.config.title").get(title3)
    local text = ""
    if cfg1 then
        text = cfg1.name
    end
    if cfg2 then
        text = text .. "" .. cfg2.name
    end
    if cfg3 then
        text = text .. "" .. cfg3.name
    end
    return text
end

function SurviveGameTitleUI:_updateTitleAttr(attrUI, cfg)
    if not cfg then
        return
    end
    local attrList = y3.userDataHelper.getAttrListByPack(cfg.equip_attr_pack)
    local childs = attrUI:get_childs()
    for index, child in ipairs(childs) do
        local attrData = attrList[index]
        if attrData then
            child:set_visible(true)
            child:get_child("_attr_name_TEXT"):set_text(attrData.name)
            if attrData.showType == 1 then
                child:get_child("_attr_value_TEXT"):set_text("+" .. attrData.value)
            else
                child:get_child("_attr_value_TEXT"):set_text("+" .. attrData.value .. "%")
            end
        else
            child:set_visible(false)
        end
    end
end

return SurviveGameTitleUI
