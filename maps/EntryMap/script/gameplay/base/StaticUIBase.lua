local StaticUIBase = class("StaticUIBase")

function StaticUIBase:ctor(ui)
    self._triggerList = {}
    self._ui = ui
end

function StaticUIBase:addTrigger(trg)
    table.insert(self._triggerList, trg)
end

function StaticUIBase:clear()
    for i = 1, #self._triggerList do
        self._triggerList[i]:remove()
    end
    self._triggerList = {}
end

function StaticUIBase:getName()
    return self.__cname
end

function StaticUIBase:setVisible(visible)
    self._ui:set_visible(visible)
end

function StaticUIBase:isVisible()
    return self._ui:is_visible()
end

function StaticUIBase:close()
    self:clear()
    self:setVisible(false)
    self:onClose()
end

function StaticUIBase:onClose()

end

return StaticUIBase
