local StaticUIBase = include("gameplay.base.StaticUIBase")
local TaskMainUI = class("TaskMainUI", StaticUIBase)

function TaskMainUI:ctor()
    local ui = y3.UIHelper.getUI("60ae6a6b-342b-4f46-9a1a-fc17e5aaebfc")
    TaskMainUI.super.ctor(self, ui)
    self._taskQuestSample  = include("gameplay.view.survive.main.task.TaskQuestSampleUI").new()
    self._taskQuastDetails = include("gameplay.view.survive.main.task.TaskQuestDetailsUI").new()
end

return TaskMainUI
