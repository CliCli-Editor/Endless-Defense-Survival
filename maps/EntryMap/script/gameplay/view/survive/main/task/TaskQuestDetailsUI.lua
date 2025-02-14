local StaticUIBase = include("gameplay.base.StaticUIBase")
local TaskQuestDetailsUI = class("TaskQuestDetailsUI", StaticUIBase)

function TaskQuestDetailsUI:ctor()
    local ui = y3.UIHelper.getUI("62e634f9-8192-4f66-a62d-7911876b592c")
    TaskQuestDetailsUI.super.ctor(self, ui)
    self:setVisible(false)
end

return TaskQuestDetailsUI
