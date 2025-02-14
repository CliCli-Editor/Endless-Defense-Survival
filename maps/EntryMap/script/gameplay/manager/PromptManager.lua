local PromptManager = class("PromptManager")
local MoveTo = include("gameplay.utils.uiAction.MoveTo")
local FadeTo = include("gameplay.utils.uiAction.FadeTo")
local ScaleTo = include("gameplay.utils.uiAction.ScaleTo")
local Sequence = include("gameplay.utils.uiAction.Sequence")

function PromptManager:ctor()
    self._noticeList = {}
    self._timerNotice = y3.ctimer.loop(0.1, handler(self, self._onNoticeUpdate))
    self._initx = 605
end

function PromptManager:showTips(text)
    if not self._promptUI then
        self._promptUI = y3.UIHelper.getUI("2b1bbe91-b39b-4300-8155-5fb5ecaf413d")
    end
    local mini_warn_TEXT = self._promptUI:get_child("_mini_warn_TEXT")
    assert(mini_warn_TEXT, "")
    mini_warn_TEXT:set_text(text)
    self._promptUI:set_visible(true)
    self._promptUI:set_alpha(255)
    y3.UIActionMgr:stopAllActions(self._promptUI)
    local scale1 = ScaleTo.new(self._promptUI, { x = 1, y = 1 }, { x = 1.2, y = 1.2 }, 0.2)
    scale1:run(2)
    local scale2 = ScaleTo.new(self._promptUI, { x = 1.2, y = 1.2 }, { x = 1, y = 1 }, 0.2)
    scale2:run(1)
    local fade = FadeTo.new(self._promptUI, 255, 0, 2)
    fade:run(2)
    local seq = Sequence.new(function()
        self._promptUI:set_visible(false)
    end)
    seq:runAction(scale1, scale2, fade)
end

function PromptManager:showNotice2(id, param, iconId, noticeTime)
    if not self._noticeRoot then
        self._noticeRoot = y3.UIHelper.getUI("f6f7175c-0e84-4b16-a510-3f3d52a3ae82")
    end
    local player   = y3.player(y3.gameApp:getMyPlayerId())
    local noticeUI = y3.ui_prefab.create(player, y3.SurviveConst.PREFAB_MAP["notice"],
        self._noticeRoot)
    local text     = y3.Lang.getLang(id, param)
    local icon     = noticeUI:get_child("_noti_type")
    assert(icon, "")
    local contentText = noticeUI:get_child("_noti_value_TEXT")
    assert(contentText, "")
    local iconIdEx = iconId or 0
    if iconIdEx > 0 then
        icon:set_image(iconIdEx)
        icon:set_visible(true)
    else
        icon:set_visible(false)
    end
    contentText:set_text(text)
    local data = {}
    noticeUI:get_child(""):set_visible(true)
    data.ui = noticeUI:get_child("")
    data.notice_show_time = noticeTime or 1
    table.insert(self._noticeList, 1, data)
    self:_updateNoticeListPos()
    data.ui:set_pos(self._initx, 0)
    self:_noticeInsertAnim(data.ui)
end

function PromptManager:showNotice(id, param)
    local cfg = include("gameplay.config.stage_notice").get(id)
    assert(cfg, "")
    local times = tonumber(cfg.notice_args)
    if times then
        param.sec = times
        self:showNotice2(cfg.notice_content, param, cfg.icon, cfg.notice_show_time)
        y3.ctimer.loop_count(1, math.floor(times) - 1, function(timer, count)
            param.sec = times - count
            self:showNotice2(cfg.notice_content, param, cfg.icon, cfg.notice_show_time)
        end)
    else
        self:showNotice2(cfg.notice_content, param, cfg.icon, cfg.notice_show_time)
    end
end

function PromptManager:_noticeInsertAnim(noticeUI)
    y3.UIActionMgr:stopAllActions(noticeUI)
    local relativey = 0
    noticeUI:set_pos(self._initx, noticeUI:get_relative_y())
    noticeUI:set_alpha(0)
    local moveTox = include("gameplay.utils.uiAction.MoveToY").new(noticeUI,
        { x = 0, y = relativey - 20 }, { x = 0, y = relativey }, 0.4)
    moveTox:run(10)
    local fade = FadeTo.new(noticeUI, 0, 255, 0.4)
    fade:run(10)
    local spawn = include("gameplay.utils.uiAction.Spawn").new()
    spawn:runAction(fade, moveTox)
end

function PromptManager:_noticeRemoveAnim(noticeUI)
    y3.UIActionMgr:stopAllActions(noticeUI)
    noticeUI:set_pos(self._initx, noticeUI:get_relative_y())
    noticeUI:set_alpha(255)
    local fade = FadeTo.new(noticeUI, 255, 0, 0.4, function()
        noticeUI:remove()
    end)
    fade:run(4)
    local relativex = noticeUI:get_relative_x()
    local relativey = noticeUI:get_relative_y()
    local moveToy = include("gameplay.utils.uiAction.MoveTo").new(noticeUI,
        { x = relativex, y = relativey }, { x = relativex - 20, y = relativey + 20 }, 0.4)
    moveToy:run(4)
    local spawn = include("gameplay.utils.uiAction.Spawn").new()
    spawn:runAction(fade, moveToy)
end

function PromptManager:_updateNoticeListPos()
    local startx = 605
    local starty = 0
    for i = 1, #self._noticeList do
        local data = self._noticeList[i]
        local ui = data.ui
        local oldx = ui:get_relative_x()
        local oldy = ui:get_relative_y()
        local newx = startx
        local newy = starty
        if oldy ~= newy then
            y3.UIActionMgr:stopAllActions(ui)
            ui:set_pos(self._initx, oldy)
            ui:set_alpha(255)
            local moveTo = include("gameplay.utils.uiAction.MoveToY").new(ui, { x = oldx, y = oldy },
                { x = newx, y = newy }, 0.2)
            moveTo:runAction(1)
        end
        starty = starty + (ui:get_child("_noti_value_TEXT"):get_real_height() - 20)
    end
end

function PromptManager:_removeNotice(ui)
    for i = 1, #self._noticeList do
        local data = self._noticeList[i]
        if data.ui == ui then
            table.remove(self._noticeList, i)
            self:_noticeRemoveAnim(data.ui)
            break
        end
    end
end

function PromptManager:_onNoticeUpdate()
    self:_onCommonNotice()
end

function PromptManager:_onCommonNotice()
    local removeList = {}
    for i = 1, #self._noticeList do
        local data = self._noticeList[i]
        data.notice_show_time = data.notice_show_time - 0.1
        if data.notice_show_time <= 0 then
            table.insert(removeList, data)
        end
    end
    for i = 1, #removeList do
        local data = removeList[i]
        self:_removeNotice(data.ui)
    end
    if #removeList > 0 then
        self:_updateNoticeListPos()
    end
end

return PromptManager
