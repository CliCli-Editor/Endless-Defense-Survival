local UIBase = include("gameplay.base.UIBase")
local CommonBuffIcon = class("CommonBuffIcon", UIBase)

function CommonBuffIcon:ctor(parent)
    CommonBuffIcon.super.ctor(self, parent, y3.SurviveConst.PREFAB_MAP["buffCustom"])
    self.buff_grond_frame = self._ui:get_child("buff_grond_frame")
    self.buff_icon_img = self._ui:get_child("buff_icon_img")
    self.buff_time_progress = self._ui:get_child("buff_time_progress")
    self.buff_time_progress_bad = self._ui:get_child("buff_time_progress_bad")
    self.buff_icon_black = self._ui:get_child("buff_icon_black")
    self.buff_stack_label = self._ui:get_child("buff_stack_label")
    self.buff_time_progress_bad:set_visible(false)
    self.buff_icon_img:add_local_event("鼠标-移入", function()
        if self.buff then
            y3.Sugar.tipRoot():showUniversalTip({ title = self.buff:get_name(), desc = self.buff:get_description() })
        end
    end)
    self.buff_icon_img:add_local_event("鼠标-移出", function()
        y3.Sugar.tipRoot():hideUniversalTip()
    end)
    self._ui:set_widget_absolute_scale(0.6, 0.6)
end

---comment
---@param buff Buff
function CommonBuffIcon:updateUI(buff)
    self.buff = buff
    self.buff_icon_img:set_visible(true)
    self.buff_icon_img:set_image(y3.buff.get_icon_by_key(buff:get_key()))
    self.buff_stack_label:set_text(tostring(buff:get_stack()))
    self.buff_time_progress:set_visible(buff:get_time() > 0)
    self.buff_time_progress_bad:set_visible(buff:get_buff_effect_type() == y3.const.ModifierEffectType['NEGATIVE'])
    self:updateTime()
end

function CommonBuffIcon:updateTime()
    local progress = self.buff:get_time() / (self.buff:get_passed_time() + self.buff:get_time())
    self.buff_time_progress:set_current_progress_bar_value(progress * 100)
    self.buff_time_progress_bad:set_current_progress_bar_value(progress * 100)
end

return CommonBuffIcon
