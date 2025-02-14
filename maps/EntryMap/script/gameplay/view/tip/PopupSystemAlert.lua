local UIBase = include("gameplay.base.UIBase")
local PopupSystemAlert = class("PopupSystemAlert", UIBase)

local AlertCount = 0

PopupSystemAlert.alertList = {}

function PopupSystemAlert:ctor(data)
    local parent = y3.ui.get_ui(y3.player(y3.gameApp:getMyPlayerId()), "global_doublecheck")
    PopupSystemAlert.super.ctor(self, parent, "global_double_check")
    self._parent = parent
    self._parent:set_visible(true)

    AlertCount = AlertCount + 1
    self._ui:set_intercepts_operations(true)

    self._title_text = self._ui:get_child("windows.title.title_TEXT")
    self._descr_text = self._ui:get_child("windows.descr_TEXT")

    self._confirmBtn = self._ui:get_child("windows.control.confirm_BTN")
    self._cancelBtn = self._ui:get_child("windows.control.cancel_BTN")
    self._confirmText = self._ui:get_child("windows.control.confirm_BTN.title_TEXT")
    self._cancelText = self._ui:get_child("windows.control.cancel_BTN.title_TEXT")
    self._confirmBtn:add_local_event("左键-点击", handler(self, self._onConfigmClick))
    self._cancelBtn:add_local_event("左键-点击", handler(self, self._onCancelClick))

    self._title_text:set_text(data.title or "")
    self._descr_text:set_text(data.desc or "")
    self._okCallback = data.okCallback or function(local_player) end
    self._cancelCallback = data.cancelCallback or function(local_player) end
end

function PopupSystemAlert:setConfirmBtnText(text)
    self._confirmText:set_text(text)
end

function PopupSystemAlert:onClose()
    AlertCount = AlertCount - 1
    if AlertCount <= 0 then
        self._parent:set_visible(false)
    end
end

function PopupSystemAlert:setCancelBtnText(text)
    self._cancelText:set_text(text)
end

function PopupSystemAlert:_onConfigmClick(local_player)
    local isRet = nil
    if self._okCallback then
        isRet = self._okCallback(local_player)
    end
    print("PopupSystemAlert:onConfigmClick", isRet)
    if not isRet then
        self:close()
    end
end

function PopupSystemAlert:_onCancelClick(local_player)
    local isRet = nil
    if self._cancelCallback then
        isRet = self._cancelCallback(local_player)
    end
    if not isRet then
        self:close()
    end
end

return PopupSystemAlert
