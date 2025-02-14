local StaticUIBase = include("gameplay.base.StaticUIBase")
local TaskQuestSampleUI = class("TaskQuestSampleUI", StaticUIBase)

function TaskQuestSampleUI:ctor()
    local ui = y3.UIHelper.getUI("60ae6a6b-342b-4f46-9a1a-fc17e5aaebfc")
    TaskQuestSampleUI.super.ctor(self, ui)
    self._title_TEXT = self._ui:get_child("title_TEXT")
    self._quest_sample_desc_txt = y3.UIHelper.getUI("79aeca36-4bf6-4a26-a4ee-cc6685ed548d")
    self._quest_sample_time_txt = y3.UIHelper.getUI("86945a36-8644-491d-8d11-bef7008e00a7")
    self._task_reward_list = y3.UIHelper.getUI("acfa3acf-b09a-4843-b8a1-aa18f94edaf5")

    self:setVisible(false)

    y3.gameApp:registerEvent(y3.EventConst.EVENT_TASK_RECEIVE, handler(self, self._onEventTaskReceive))
    y3.gameApp:registerEvent(y3.EventConst.EVENT_TASK_FINISH_SUCCESS, handler(self, self._onEventTaskFinishSuccess))
    y3.gameApp:registerEvent(y3.EventConst.EVENT_TASK_FINISH_FAILED, handler(self, self._onEventTaskFinishFailed))

    y3.ctimer.loop(0.5, handler(self, self._updateTime))
end

function TaskQuestSampleUI:_updateTime()
    if self._taskData then
        if self._taskData.taskTime == -1 then
            self._quest_sample_time_txt:set_text(y3.Lang.get("lang_task_time_shengyu_no",
                { time = self._taskData.taskTime }))
        else
            self._quest_sample_time_txt:set_text(y3.Lang.get("lang_task_time_shengyu", { time = self._taskData.taskTime }))
        end
        self:_updateDesc(self._taskData)
    end
end

function TaskQuestSampleUI:_updateUI(needEffect)
    local taskSystem = y3.gameApp:getLevel():getLogic("SurviveGameTaskSyetem")
    local taskData = taskSystem:getTaskDataByType(y3.gameApp:getMyPlayerId(), 4)
    y3.UIActionMgr:stopAllActions(self._ui)
    if taskData then
        self._taskData = taskData
        self:setVisible(true)
        self:_updateTime()
        self:_updateItemCell()
    else
        self._taskData = nil
        if self:isVisible() then
            local delay = include("gameplay.utils.uiAction.DelayTime").new(self._ui, 0.3, function()
                self:setVisible(false)
            end)
            delay:runAction()
        end
    end
end

function TaskQuestSampleUI:_updateItemCell()
    if self._taskData then
        local taskCfg = include("gameplay.config.stage_task").get(self._taskData.taskId)
        assert(taskCfg)
        local childs = self._task_reward_list:get_childs()
        local task_rewards = string.split(taskCfg.task_reward, "|")
        assert(task_rewards, "")
        for i = 1, #task_rewards do
            local rewardParams = string.split(task_rewards[i], "#")
            assert(rewardParams, "")
            local child = childs[i]
            if child then
                child:get_child("item.item_icon_img"):set_image(y3.surviveHelper.getResIcon(tonumber(rewardParams[2])))
                child:get_child("item.item_number_txt"):set_text(y3.gameUtils.convertText3(tonumber(rewardParams[3])))
            end
        end
    end
end

function TaskQuestSampleUI:_updateDesc(taskData)
    local taskSystem = y3.gameApp:getLevel():getLogic("SurviveGameTaskSyetem")
    local descList = taskSystem:getTaskDesc(taskData)
    local allDesc = ""
    for i = 1, #descList do
        allDesc = allDesc .. descList[i] .. "\n"
    end
    self._quest_sample_desc_txt:set_text(allDesc)
end

function TaskQuestSampleUI:_onEventTaskReceive(trg, data)
    local taskId = data.task_id
    local taskCfg = include("gameplay.config.stage_task").get(taskId)
    log.info("TaskQuestSampleUI:_onEventTaskReceive", taskId)
    if taskCfg and taskCfg.task_type == 4 then
        self:_updateUI()
    end
end

function TaskQuestSampleUI:_onEventTaskFinishSuccess(trg, data)
    local taskId = data.task_id
    local taskCfg = include("gameplay.config.stage_task").get(taskId)
    log.info("TaskQuestSampleUI:_onEventTaskFinishSuccess", taskId)
    if taskCfg and taskCfg.task_type == 4 then
        self:_updateUI(true)
    end
end

function TaskQuestSampleUI:_onEventTaskFinishFailed(trg, data)
    local taskId = data.task_id
    local taskCfg = include("gameplay.config.stage_task").get(taskId)
    log.info("TaskQuestSampleUI:_onEventTaskFinishFailed", taskId)
    if taskCfg and taskCfg.task_type == 4 then
        self:_updateUI()
    end
end

return TaskQuestSampleUI
