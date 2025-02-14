local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGameTaskUI = class("SurviveGameTaskUI", StaticUIBase)

function SurviveGameTaskUI:ctor()
    local ui = y3.UIHelper.getUI("bc16bde6-417c-4fc6-902c-b5ed0a28469d")
    SurviveGameTaskUI.super.ctor(self, ui)
    local localUi = y3.UIHelper.getUI("76680d13-7851-49b3-bbec-f4e221445151")
    self._ui:set_absolute_pos(localUi:get_absolute_x(), localUi:get_absolute_y())
    self._exit_BTN = self._ui:get_child("_title_TEXT.exit_BTN")
    self._title_TEXT = self._ui:get_child("_title_TEXT")
    self._descr_TEXT = self._ui:get_child("_descr_TEXT")
    self._progress_BAR = self._ui:get_child("bar.progress_BAR")

    self._curTaskId = 0
    -- self._exit_BTN:set_visible(false)
    self._exit_BTN:add_local_event("左键-点击", handler(self, self._onExitBtnClick))
    y3.gameApp:registerEvent(y3.EventConst.EVENT_SURVIVE_REFRESH_DPS, handler(self, self._onEventRefreshDps))
end

function SurviveGameTaskUI:_onExitBtnClick(local_player)
    self:setVisible(false)
end

function SurviveGameTaskUI:_onEventRefreshDps(trg)
    self:updateUI()
end

function SurviveGameTaskUI:updateUI()
    local taskSystem = y3.gameApp:getLevel():getLogic("SurviveGameTaskSyetem")
    local taskData = taskSystem:getTaskDataByType(y3.gameApp:getMyPlayerId(), 3)
    if taskData then
        if self._curTaskId ~= taskData.taskId then
            self:setVisible(true)
        end
        self._curTaskId = taskData.taskId
        local cfg = include("gameplay.config.stage_task").get(taskData.taskId)
        if cfg then
            self._title_TEXT:set_text(cfg.task_title)
            self._descr_TEXT:set_text(cfg.task_desc)
            local conMap = taskData.conMap
            for _, condData in pairs(conMap) do
                local maxPro   = tonumber(condData.params[3]) or 0
                local progress = condData.progress
                if maxPro > 0 then
                    self._progress_BAR:set_current_progress_bar_value(progress / maxPro * 100)
                else
                    self._progress_BAR:set_current_progress_bar_value(100)
                end
            end
        end
    else
        self:setVisible(false)
    end
end

return SurviveGameTaskUI
