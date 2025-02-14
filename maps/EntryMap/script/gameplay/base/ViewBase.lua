local ViewBase = class("ViewBase")

--
-- resource = {
--     traverse = { "test.testCom", "test.testCom2" },
--     eventMap = {
--             name = '_attr',
--             eventName = '左键-点击',
--             eventCall = 'funcName',
--             type = 1  1.事件,2.刷新
--         }
--     }
-- }
function ViewBase:ctor(name, resource)
    self._hud = New 'LocalUILogic' (name)
    self._resource = resource or { traverse = {}, eventMap = {} }
    self._hud:on_init('', handler(self, self._onInit))
    self._triggerList = {}
end

function ViewBase:addTrigger(trg)
    table.insert(self._triggerList, trg)
end

function ViewBase:clear()
    for i = 1, #self._triggerList do
        self._triggerList[i]:remove()
    end
    self._triggerList = {}
end

function ViewBase:getName()
    return self.__cname
end

function ViewBase:_onInit(ui, local_player)
    self._main = ui
    self._childTraverse = {}
    local mainChilds = self._main:get_childs()
    for i = 1, #mainChilds do
        local childName = mainChilds[i]:get_name()
        local index = string.find(childName, '_')
        if index and index == 1 then
            self[childName] = mainChilds[i]
            self._childTraverse[childName] = ""
        end
    end
    local traverse = self._resource.traverse
    for i = 1, #traverse do
        local traUi = self._main:get_child(traverse[i])
        local childs = traUi:get_childs()
        for j = 1, #childs do
            local childName = childs[j]:get_name()
            local index = string.find(childName, '_')
            if index and index == 1 then
                self[childName] = childs[j]
                self._childTraverse[childName] = traverse[i] .. "."
            end
        end
    end
    local eventMap = self._resource.eventMap
    for i = 1, #eventMap do
        local eventData = eventMap[i]
        local traverseName = self._childTraverse[eventData.name]
        if eventData.type == 1 then
            if eventData.eventName then
                self._hud:on_event(traverseName .. eventData.name, eventData.eventName,
                    handler(self, self[eventData.eventCall]))
            else
                self._hud:on_event(traverseName .. eventData.name, '左键-点击',
                    handler(self, self[eventData.eventCall]))
            end
        else
            self._hud:on_refresh(traverseName .. eventData.name, handler(self, self[eventData.eventCall]))
        end
    end
    if self._cacheVisible ~= nil then
        self._main:set_visible(self._cacheVisible)
        self._cacheVisible = nil
    end
    self:onInit()
end

function ViewBase:setVisible(visible)
    if self._main then
        self._main:set_visible(visible)
    else
        self._cacheVisible = visible
    end
end

function ViewBase:onInit()
end

return ViewBase
