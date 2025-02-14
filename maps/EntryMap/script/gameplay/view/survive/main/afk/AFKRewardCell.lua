local UIBase = include("gameplay.base.UIBase")
local AFKRewardCell = class("AFKRewardCell", UIBase)

function AFKRewardCell:ctor(parent)
    AFKRewardCell.super.ctor(self, parent, "AFKReward")

    self._reward_img = self._ui:get_child("reward_panel.reward_img")
    self._reward_txt = self._ui:get_child("reward_panel.reward_txt")

    self._reward_img:add_local_event("鼠标-移入", function()
        y3.Sugar.tipRoot():showUniversalTip(self._data)
    end)
    self._reward_img:add_local_event("鼠标-移出", function()
        y3.Sugar.tipRoot():hideUniversalTip()
    end)
end

function AFKRewardCell:updateUI(data)
    self._data = data
    local typeItem = data.type
    local valueItem = data.value
    if typeItem == y3.SurviveConst.DROP_TYPE_SAVE_ITEM then
        local cfg = include("gameplay.config.save_item").get(valueItem)
        assert(cfg)
        self._reward_img:set_image(tonumber(cfg.item_icon))
    elseif typeItem == y3.SurviveConst.DROP_TYPE_TREASURE then

    elseif typeItem == y3.SurviveConst.DROP_TYPE_TITLE then

    elseif typeItem == y3.SurviveConst.DROP_TYPE_STAGE_TOWER then

    elseif typeItem == y3.SurviveConst.DROP_TYPE_HERO_SKIN then


    elseif typeItem == y3.SurviveConst.DROP_TYPE_TOWER_SKIN then

    end
    self._reward_txt:set_text("x" .. data.size)
end

return AFKRewardCell
