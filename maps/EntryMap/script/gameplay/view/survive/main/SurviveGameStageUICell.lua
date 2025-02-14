local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGameStageUICell = class("SurviveGameStageUICell", StaticUIBase)

local SELECT_IMG = 134276998
local UNSELECT_IMG = 134246211

function SurviveGameStageUICell:ctor(ui, parent)
    self._parent = parent
    SurviveGameStageUICell.super.ctor(self, ui)
    self._bg_BTN = self._ui:get_child("bg_BTN")
    self._level_name_TEXT = self._ui:get_child("_level_name_TEXT")
    self._starsList = self._ui:get_child("stars_LIST")

    self._bg_BTN:add_local_event("左键-点击", handler(self, self._onStageCellClick))
    self._bg_BTN:add_local_event("鼠标-移入", function()
        if self._cfg.stage_open_state == 1 then
            if not self._isUnlock then
                local requeCfg = include("gameplay.config.stage_config").get(self._cfg.stage_unlock_require)
                if requeCfg then
                    y3.Sugar.tipRoot():showUniversalTip({ title = "", desc = GameAPI.get_text_config('#-1726741032#lua') .. requeCfg.stage_name .. "" })
                end
            end
        else
            y3.Sugar.tipRoot():showUniversalTip({ title = "", desc = y3.langCfg.get(67).str_content })
        end
    end)
    self._bg_BTN:add_local_event("鼠标-移出", function()
        y3.Sugar.tipRoot():hideUniversalTip()
    end)
end

function SurviveGameStageUICell:updateUI(cfg, index, collect)
    self._index = index
    self._cfg = cfg
    self._level_name_TEXT:set_text(cfg.stage_name)
    local stagePass = y3.gameApp:getLevel():getLogic("SurviveGameStagePass")
    local isUnLock = stagePass:getStageIsUnLock(cfg.id)
    self._isUnlock = isUnLock
    self._bg_BTN:set_button_enable(isUnLock)
    if cfg.stage_open_state == 1 then
        self._bg_BTN:set_button_enable(isUnLock)
    else
        self._bg_BTN:set_button_enable(false)
    end
    if collect then
        self._starsList:set_visible(true)
        local achievemnt = y3.gameApp:getLevel():getLogic("SurviveGameAchievement")
        local starNum = achievemnt:getAchievementConditionValue(y3.gameApp:getMyPlayerId(), collect.id, 1)
        local starUIs = self._starsList:get_childs()
        for i, starUI in ipairs(starUIs) do
            if i <= starNum then
                starUI:set_visible(true)
            else
                starUI:set_visible(false)
            end
        end
    else
        self._starsList:set_visible(false)
    end
end

function SurviveGameStageUICell:updateSelect(index)
    self._bg_BTN:set_image(index == self._index and SELECT_IMG or UNSELECT_IMG)
end

function SurviveGameStageUICell:_onStageCellClick(local_player)
    self._parent:onStageSelectIndex(self._index) -- call parent's method
end

return SurviveGameStageUICell
