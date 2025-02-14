local UIBase = include("gameplay.base.UIBase")
local ShopHelperBuyRecordCell = class("ShopHelperBuyRecordCell", UIBase)

local CLASS_MAP = {
    [1] = 134254956,
    [2] = 134238523,
    [3] = 134228669,
    [4] = 134221522,
    [5] = 134278758,
}

function ShopHelperBuyRecordCell:ctor(parent)
    ShopHelperBuyRecordCell.super.ctor(self, parent, y3.SurviveConst.PREFAB_MAP["shop_help_record"])
    self._frame_IMG = self._ui:get_child("avatar._frame_IMG")
    self._icon_IMG = self._ui:get_child("avatar._icon_IMG")
    self._descr_TEXT = self._ui:get_child("tips._descr_TEXT")
    self._time_TEXT = self._ui:get_child("tips._time_TEXT")

    self._icon_IMG:add_local_event("鼠标-移入", function()
        y3.Sugar.tipRoot():showSkillTip({ cfg = self._skillCfg })
    end)
    self._icon_IMG:add_local_event("鼠标-移出", function()
        y3.Sugar.tipRoot():hideSkillTip()
    end)
end

function ShopHelperBuyRecordCell:updateUI(data)
    local skillid = data.skillId
    local min = math.floor(data.time / 60)
    local sec = math.floor(data.time % 60)
    local timestr = string.format("%d:%02d", min, sec) --y3.gameUtils.getCurrentDate2Str(data.time)
    local skillCfg = include("gameplay.config.config_skillData").get(tostring(skillid))
    assert(skillCfg, "skillCfg is nil")
    self._skillCfg = skillCfg
    self._frame_IMG:set_image(CLASS_MAP[skillCfg.class])
    self._icon_IMG:set_image(tonumber(skillCfg.icon))
    self._descr_TEXT:set_text(skillCfg.name)
    self._time_TEXT:set_text(timestr)
end

return ShopHelperBuyRecordCell
