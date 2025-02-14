local StaticUIBase = include("gameplay.base.StaticUIBase")
local StageSpeedUI = class("StageSpeedUI", StaticUIBase)

local SPEED_1 = 1.5
local SPEED_2 = 2

function StageSpeedUI:ctor()
    local ui = y3.UIHelper.getUI("ef111a6a-bc48-414a-b4c3-6542e64aa57e")
    StageSpeedUI.super.ctor(self, ui)
    self._speedUseUI = self._ui:get_child("stage_speed_change.use")
    self._speedIcon = self._ui:get_child("stage_speed_change.use.icon")
    self._speedChange = self._ui:get_child("stage_speed_change.change_speed_btn")
    self._speedText = self._ui:get_child("stage_speed_change._title_TEXT")

    self._curSpeed = SPEED_1

    self._speedUseUI:add_local_event("左键-点击", handler(self, self._onSpeedUseClick))
    self._speedChange:add_local_event("左键-点击", handler(self, self._onChangeSpeedClick))
    local curStageId = y3.userData:getCurStageId()
    local cfg = include("gameplay.config.stage_config").get(curStageId)
    assert(cfg, "stage config not found")
    self:setVisible(cfg.stage_type ~= y3.SurviveConst.STAGE_MODE_AFK)
end

function StageSpeedUI:_onSpeedUseClick()
    self._speedIcon:set_visible(not self._speedIcon:is_visible())
    if self._speedIcon:is_visible() then
        y3.game.set_game_speed(self._curSpeed)
    else
        y3.game.set_game_speed(1)
    end
end

function StageSpeedUI:_onChangeSpeedClick()
    if self._curSpeed == SPEED_1 then
        self._curSpeed = SPEED_2
    else
        self._curSpeed = SPEED_1
        self._speedText:set_text("1.5x")
    end
    self._speedText:set_text(y3.Lang.get("lang_stage_speed_text", { speed = self._curSpeed }))
    if self._speedIcon:is_visible() then
        y3.game.set_game_speed(self._curSpeed)
    end
end

return StageSpeedUI
