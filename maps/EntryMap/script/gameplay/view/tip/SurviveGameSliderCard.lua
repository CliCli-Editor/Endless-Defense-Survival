local UIBase = include("gameplay.base.UIBase")
local SurviveGameSliderCard = class("SurviveGameSliderCard", UIBase)

function SurviveGameSliderCard:ctor(parent)
    SurviveGameSliderCard.super.ctor(self, parent, y3.SurviveConst.PREFAB_MAP["noti_slider"])
    self._icon_IMG = self._ui:get_child("avatar._icon_IMG")
    self._frame_IMG = self._ui:get_child("avatar._frame_IMG")

    self._title_TEXT = self._ui:get_child("tips._title_TEXT")
    self._subtitle_TEXT = self._ui:get_child("tips._subtitle_TEXT")
    self._descr_TEXT = self._ui:get_child("tips._descr_TEXT")
end

function SurviveGameSliderCard:updateUI(data)
    local width = self._ui:get_width()
    self._data = data
    if data.type == y3.SurviveConst.DROP_TYPE_SAVE_ITEM then
        self:_showSaveItemTip()
    elseif data.type == y3.SurviveConst.DROP_TYPE_TREASURE then
        self:_showTreasureTip()
    elseif data.type == y3.SurviveConst.DROP_TYPE_WEANPON_EXP then
        self:_showWeanponExpTip()
    end
    -- self._ui:set_anim_opacity(0, 255, 1, 1)
    -- self._ui:set_anim_pos(-width, 125, width * 0.5, 125, 1, 1)
    -- y3.ltimer.wait(1, function(timer, count)
    --     self._ui:set_anim_opacity(255, 0, 1, 2)
    --     self._ui:set_anim_pos(width * 0.5, 125, -width, 125, 1, 2)
    -- end)
    -- y3.ltimer.wait(3, function(timer, count)
    --     self._ui:remove()
    -- end)

    local moveX = include("gameplay.utils.uiAction.MoveToX").new(self._ui, { x = width * 0.5 - 30, y = 0 },
        { x = width * 0.5 + 10, y = 0 },
        0.2)
    moveX:run(1)
    local fade = include("gameplay.utils.uiAction.FadeTo").new(self._ui, 0, 255, 0.2)
    fade:run(1)
    local spawn1 = include("gameplay.utils.uiAction.Spawn").new()
    spawn1:runPure(moveX, fade)

    local delay = include("gameplay.utils.uiAction.DelayTime").new(self._ui, 1.5)
    delay:run(1)

    local moveX2 = include("gameplay.utils.uiAction.MoveToX").new(self._ui, { x = width * 0.5 + 10, y = 0 },
        { x = width * 0.5 - 30, y = 0 }, 0.3)
    moveX2:run(2)
    local fade2 = include("gameplay.utils.uiAction.FadeTo").new(self._ui, 255, 0, 0.3)
    fade2:run(2)
    local spawn2 = include("gameplay.utils.uiAction.Spawn").new()
    spawn2:runPure(moveX2, fade2)

    local sequence = include("gameplay.utils.uiAction.Sequence").new(function()
        self._ui:remove()
    end)
    sequence:runAction(spawn1, delay, spawn2)
end

function SurviveGameSliderCard:_showSaveItemTip()
    local cfg = include("gameplay.config.save_item").get(self._data.value)
    if cfg then
        self._frame_IMG:set_image(y3.SurviveConst.ITEM_CLASS_MAP[cfg.item_quality] or y3.SurviveConst.ITEM_CLASS_MAP[2])
        self._icon_IMG:set_image(tonumber(cfg.item_icon))
        self._title_TEXT:set_text(cfg.item_name)
        self._subtitle_TEXT:set_text("x" .. (self._data.size or 0))
        self._descr_TEXT:set_text(cfg.item_desc_simple)
    end
end

function SurviveGameSliderCard:_showTreasureTip()
    local cfg = include("gameplay.config.treasure").get(self._data.value)
    if cfg then
        self._frame_IMG:set_image(y3.SurviveConst.ITEM_CLASS_MAP[cfg.quality] or y3.SurviveConst.ITEM_CLASS_MAP[2])
        self._icon_IMG:set_image(tonumber(cfg.icon))
        self._title_TEXT:set_text(cfg.name)
        self._subtitle_TEXT:set_text("")
        self._descr_TEXT:set_text(cfg.unlock_desc)
    end
end

function SurviveGameSliderCard:_showWeanponExpTip()
    local cfg = include("gameplay.config.config_skillData").get(tostring(self._data.value))
    if cfg then
        self._icon_IMG:set_image(tonumber(cfg.icon))
        self._title_TEXT:set_text(GameAPI.get_text_config('#-1265815702#lua'))
        self._subtitle_TEXT:set_text(cfg.name)
        self._descr_TEXT:set_text(GameAPI.get_text_config('#30000001#lua31') .. self._data.size)
    end
end

return SurviveGameSliderCard
