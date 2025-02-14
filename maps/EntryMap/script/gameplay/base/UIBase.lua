local UIBase = class("UIBase")
local UIHelper = include("gameplay.utils.UIHelper")

function UIBase:ctor(parent, resName)
    self._triggerList = {}
    self._uiPrefab = y3.ui_prefab.create(y3.player(y3.gameApp:getMyPlayerId()), resName, parent)
    self._ui = self._uiPrefab:get_child("")
end

function UIBase:getUI()
    return self._ui
end

function UIBase:addTrigger(trg)
    table.insert(self._triggerList, trg)
end

function UIBase:clear()
    for i = 1, #self._triggerList do
        self._triggerList[i]:remove()
    end
    self._triggerList = {}
end

function UIBase:getName()
    return self.__cname
end

function UIBase:setVisible(visible)
    self._ui:set_visible(visible)
end

function UIBase:close()
    self:clear()
    self._uiPrefab:remove()
    self:onClose()
    self = nil
end

function UIBase:onClose()

end

return UIBase
