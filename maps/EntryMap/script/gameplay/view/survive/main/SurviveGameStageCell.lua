local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGameStageCell = class("SurviveGameStageCell", StaticUIBase)

function SurviveGameStageCell:ctor(ui)
    SurviveGameStageCell.super.ctor(self, ui)
end

return SurviveGameStageCell
