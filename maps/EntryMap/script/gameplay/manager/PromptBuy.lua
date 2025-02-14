local PromptBuy = class("PromptBuy")
local MoveTo = include("gameplay.utils.uiAction.MoveTo")
local FadeTo = include("gameplay.utils.uiAction.FadeTo")
local ScaleTo = include("gameplay.utils.uiAction.ScaleTo")
local Sequence = include("gameplay.utils.uiAction.Sequence")

function PromptBuy:ctor()
    self._noticeList = {}
    self._timerNotice = y3.ctimer.loop(0.1, handler(self, self._onNoticeUpdate))
    self._initx = 0
end

function PromptBuy:showNotice2(recordData, noticeTime)
    if not self._noticeRoot then
        self._noticeRoot = y3.UIHelper.getUI("0ea8e848-dd65-432d-828d-5b3833f0c6a3")
    end
    local noticeUI = include("gameplay.view.survive.main.autoBuy.ShopHelperBuyRecordCell").new(self._noticeRoot)
    noticeUI:updateUI(recordData)
    local data = {}
    noticeUI:setVisible(true)
    data.ui = noticeUI:getUI() -- noticeUI:get_child("")
    data.notice_show_time = noticeTime or 1
    table.insert(self._noticeList, 1, data)
    self:_updateNoticeListPos()
    data.ui:set_pos(self._initx, 0)
    self:_noticeInsertAnim(data.ui)
end

function PromptBuy:_noticeInsertAnim(noticeUI)
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

function PromptBuy:_noticeRemoveAnim(noticeUI)
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

function PromptBuy:_updateNoticeListPos()
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
        starty = starty + (ui:get_real_height())
    end
end

function PromptBuy:_removeNotice(ui)
    for i = 1, #self._noticeList do
        local data = self._noticeList[i]
        if data.ui == ui then
            table.remove(self._noticeList, i)
            self:_noticeRemoveAnim(data.ui)
            break
        end
    end
end

function PromptBuy:_onNoticeUpdate()
    self:_onCommonNotice()
end

function PromptBuy:_onCommonNotice()
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

return PromptBuy
