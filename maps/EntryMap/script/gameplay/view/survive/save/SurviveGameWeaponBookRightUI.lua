local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGameWeaponBookRightUI = class("SurviveGameWeaponBookRightUI", StaticUIBase)

function SurviveGameWeaponBookRightUI:ctor()
    local ui = y3.UIHelper.getUI("f0a633ca-92f4-4460-9e23-776bde4cc0a0")
    SurviveGameWeaponBookRightUI.super.ctor(self, ui)
    self._icon_IMG            = y3.UIHelper.getUI("e1df1abc-ef40-4285-a1b1-27df742bd3b9")
    self._level_TEXT          = y3.UIHelper.getUI("84d585db-1e9a-4ca2-8ede-4a0501af360f")
    self._title_TEXT          = y3.UIHelper.getUI("a2c63b1c-5a32-4d58-ae81-37d722add738")
    self._bindBtn             = y3.UIHelper.getUI("327728f7-c655-4659-aa52-3bc0e9710d88")
    self._bindLevel           = y3.UIHelper.getUI("a7897179-5012-46a6-9ca4-a47d72aca402")
    self._bindLocked          = y3.UIHelper.getUI("fae58ede-a955-4d7c-9de3-41d089fcd264")
    self._detailList          = y3.UIHelper.getUI("81e0c6ca-3f54-4f55-a0b3-17a5b7fac654")

    self._curLevelText        = y3.UIHelper.getUI("92df7326-8f69-466b-8f0a-d52f2c3d0383")
    self._nextLevelText       = y3.UIHelper.getUI("c0c8bd4a-c05d-4b76-9f77-7e51d99189c3")
    self._progress_BAR        = y3.UIHelper.getUI("f67f84c8-b3ab-48fd-ac16-161c4f8de121")
    self._current_exp_TEXT    = y3.UIHelper.getUI("6f5e7252-3191-4609-9337-9f086bff23b9")
    self._confirm_BTN         = y3.UIHelper.getUI("ac14e73a-37e2-4da1-a2ab-ba76a3a067f0")
    self._res_icon_IMG        = y3.UIHelper.getUI("21a3816e-159d-4ace-b60b-b007e62674d0")
    self._res_value_TEXT      = y3.UIHelper.getUI("f46f26d0-4726-42b6-aab7-3e432a468655")

    self._own_icon_img        = y3.UIHelper.getUI("f483d305-f8ba-41e2-8e1c-322750ebb271")
    self._own_res_value_Text  = y3.UIHelper.getUI("88bbd235-9be6-4640-9213-c2af9239b77f")
    self._own_icon_img2       = y3.UIHelper.getUI("bc7c78f1-af50-4c57-bcc6-d3c6df79e743")
    self._own_res_value_Text2 = y3.UIHelper.getUI("9e0bfe97-7163-4649-a858-ce46356c030e")

    self._subBtn              = y3.UIHelper.getUI("c8d885fe-c8c5-4c49-8c3f-812e1d349c02")
    self._addBtn              = y3.UIHelper.getUI("e1656e2c-9eac-45aa-adf4-364e9704575b")

    self._res                 = y3.UIHelper.getUI("6b0cb752-b64f-45e9-9394-bc8b5ec63ff0")

    self._confirm_BTN:add_local_event("左键-点击", handler(self, self._onConfirmClick))
    self._subBtn:add_local_event("左键-点击", handler(self, self._onSubClick))
    self._addBtn:add_local_event("左键-点击", handler(self, self._onAddClick))
    self._bindBtn:add_local_event("左键-点击", handler(self, self._onBindClick))

    self._bounsUI = include("gameplay.view.survive.save.SurviveGameWeaponBookResonanceUI").new()

    self._addLv = 1
    self._weaponId = 0
    y3.gameApp:registerEvent(y3.EventConst.EVENT_WEAPON_LV_SUCCESS, handler(self, self._onEventUpLvSuccess))

    self._icon_IMG:add_local_event("鼠标-移入", function()
        if self._cfg then
            y3.Sugar.tipRoot():showSkillTip({ cfg = self._cfg })
        end
    end)
    self._icon_IMG:add_local_event("鼠标-移出", function()
        y3.Sugar.tipRoot():hideSkillTip()
    end)

    self._res:add_local_event("鼠标-移入", function()
        if self._lvList then
            local lvCfg = self._lvList[1]
            local expItems = string.split(lvCfg.exp_item, "#")
            y3.Sugar.tipRoot():showUniversalTip({ type = tonumber(expItems[1]), value = tonumber(expItems[2]) })
        end
    end)
    self._res:add_local_event("鼠标-移出", function()
        y3.Sugar.tipRoot():hideUniversalTip()
    end)
    self._own_icon_img2:add_local_event("鼠标-移入", function()
        if self._lvList then
            local lvCfg = self._lvList[11]
            local expItems = string.split(lvCfg.exp_item, "#")
            y3.Sugar.tipRoot():showUniversalTip({ type = tonumber(expItems[1]), value = tonumber(expItems[2]) })
        end
    end)
    self._own_icon_img2:add_local_event("鼠标-移出", function()
        y3.Sugar.tipRoot():hideUniversalTip()
    end)
    self._own_res_value_Text2:add_local_event("鼠标-移入", function()
        if self._lvList then
            local lvCfg = self._lvList[11]
            local expItems = string.split(lvCfg.exp_item, "#")
            y3.Sugar.tipRoot():showUniversalTip({ type = tonumber(expItems[1]), value = tonumber(expItems[2]) })
        end
    end)
    self._own_res_value_Text2:add_local_event("鼠标-移出", function()
        y3.Sugar.tipRoot():hideUniversalTip()
    end)
end

function SurviveGameWeaponBookRightUI:_onEventUpLvSuccess(trg, weaponId)
    if self._weaponId == weaponId then
        self._addLv = 1
        self:updateUI(weaponId)
    end
end

function SurviveGameWeaponBookRightUI:_onSubClick()
    self._addLv = math.max(1, self._addLv - 1)
    self:_updateSub()
end

function SurviveGameWeaponBookRightUI:_onAddClick()
    self._addLv = math.min(self._maxLv - self._weaponLevel, self._addLv + 1)
    if self._addLv == 0 then
        self._addLv = 1
    end
    self:_updateSub()
end

function SurviveGameWeaponBookRightUI:_onBindClick()
    self._bounsUI:show(true)
end

function SurviveGameWeaponBookRightUI:updateUI(weaponId)
    local cfg = include("gameplay.config.config_skillData").get(tostring(weaponId))
    if not cfg then
        return
    end
    self._cfg = cfg
    if weaponId ~= self._weaponId then
        self._addLv = 1
    end
    self._weaponId = weaponId
    local weaponSave = y3.gameApp:getLevel():getLogic("SurviveGameWeaponSave")
    local bounsLv = weaponSave:getWeaponResonanceLevel(y3.gameApp:getMyPlayerId())
    self._bindLevel:set_text(bounsLv .. "")
    local lvList = weaponSave:getWeanponLvList(weaponId)
    self._icon_IMG:set_image(tonumber(cfg.icon))
    self._title_TEXT:set_text(cfg.name)
    self._title_TEXT:set_text_color_hex(
        y3.ColorConst.QUALITY_COLOR_MAP[cfg.class + 1] or y3.ColorConst.QUALITY_COLOR_MAP[1], 255)
    local weaponLevel = weaponSave:getWeaponLevel(y3.gameApp:getMyPlayerId(), weaponId)
    self._level_TEXT:set_text(weaponLevel .. "")

    self._weaponLevel = weaponLevel
    self._lvList = lvList
    if weaponLevel < 10 then
        self._maxLv = 10
    else
        self._maxLv = lvList[#lvList].level
    end
    self:_updateDetailList(lvList)
    self:_updateSub()
end

function SurviveGameWeaponBookRightUI:getMaxExp()
    local lvList = self._lvList
    local weaponLevel = self._weaponLevel
    local maxExp = 0
    for i = 1, self._addLv do
        local lvCfg = lvList[weaponLevel + i]
        if lvCfg then
            maxExp = maxExp + lvCfg.exp_cost
        end
    end
    return maxExp
end

function SurviveGameWeaponBookRightUI:_updateSub()
    local weaponSave = y3.gameApp:getLevel():getLogic("SurviveGameWeaponSave")
    local lvList = self._lvList
    local weaponId = self._weaponId
    local weaponLevel = self._weaponLevel
    self._curLevelText:set_text(weaponLevel .. "")
    self._nextLevelText:set_text(math.min(self._maxLv, (weaponLevel + self._addLv)) .. "")
    local lvCfg = lvList[weaponLevel + self._addLv]
    self._subBtn:set_button_enable(self._addLv > 1)
    self._addBtn:set_button_enable(self._addLv < (self._maxLv - weaponLevel))
    if lvCfg then
        local curHaveNum = y3.userDataHelper.getSaveItemNum(y3.gameApp:getMyPlayerId(), lvCfg.exp_item)
        local maxExp = self:getMaxExp()
        local curExp = weaponSave:getWeaponExp(y3.gameApp:getMyPlayerId(), weaponId)
        local pro = curExp / maxExp * 100
        self._progress_BAR:set_current_progress_bar_value(pro)
        self._current_exp_TEXT:set_text(curExp .. "/" .. maxExp)
        local costExp = math.max(0, maxExp - curExp)
        self._res_value_TEXT:set_text(costExp .. "")
        if curHaveNum >= costExp then
            self._res_value_TEXT:set_text_color_hex(y3.ColorConst.TIPS_COLOR_MAP["lvse"], 255)
        else
            self._res_value_TEXT:set_text_color_hex(y3.ColorConst.TIPS_COLOR_MAP["hongse"], 255)
        end
        local expItems = string.split(lvCfg.exp_item, "#")
        assert(expItems, "")
        local cfg = include("gameplay.config.save_item").get(tonumber(expItems[2]))
        assert(cfg, "")
        self._res_icon_IMG:set_image(tonumber(cfg.item_icon))
    else
        self._res_value_TEXT:set_text("0")
        self._progress_BAR:set_current_progress_bar_value(100)
        self._current_exp_TEXT:set_text(GameAPI.get_text_config('#1292806940#lua'))
    end
    local expItems = string.split(lvList[1].exp_item, "#")
    assert(expItems, "")
    local cfg = include("gameplay.config.save_item").get(tonumber(expItems[2]))
    if cfg then
        self._own_icon_img:set_image(tonumber(cfg.item_icon))
        local curHaveNum = y3.userDataHelper.getSaveItemNum(y3.gameApp:getMyPlayerId(), lvList[1].exp_item)
        self._own_res_value_Text:set_text(curHaveNum .. "")
    end
    local expItems = string.split(lvList[11].exp_item, "#")
    assert(expItems, "")
    local cfg = include("gameplay.config.save_item").get(tonumber(expItems[2]))
    if cfg then
        self._own_icon_img2:set_image(tonumber(cfg.item_icon))
        local curHaveNum = y3.userDataHelper.getSaveItemNum(y3.gameApp:getMyPlayerId(), lvList[11].exp_item)
        self._own_res_value_Text2:set_text(curHaveNum .. "")
    end
end

function SurviveGameWeaponBookRightUI:_updateDetailList(lvList)
    local level = self._weaponLevel
    local lvChilds = self._detailList:get_childs()
    for i, child in ipairs(lvChilds) do
        if lvList[i] then
            child:set_visible(true)
            local lvCfg = lvList[i]
            local effectStr = y3.userDataHelper.getWeaponEffectText(lvCfg.weapon_effect)
            local attrStr = y3.userDataHelper.getAttrConcatStr(lvCfg.attr_pack)
            local lockStr = ""
            if level >= lvCfg.level then
                lockStr = "#" .. y3.ColorConst.TIPS_COLOR_MAP["lvse"] .. "Lv." .. lvCfg.level
            else
                lockStr = "#ffffff" .. "Lv." .. lvCfg.level
            end
            if effectStr ~= "" then
                lockStr = lockStr .. effectStr
            end
            if attrStr ~= "" then
                lockStr = lockStr .. "，" .. attrStr
            end
            child:set_text(lockStr)
        else
            child:set_visible(false)
        end
    end
end

function SurviveGameWeaponBookRightUI:_onConfirmClick(local_player)
    y3.SyncMgr:sync(y3.SyncConst.SYNC_WEAPON_UPGRADE, { weaponId = self._weaponId, addLv = self._addLv })
end

return SurviveGameWeaponBookRightUI
