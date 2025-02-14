local Action = include "gameplay.action.Action"
local ActionManager = class("ActionManager")

function ActionManager:ctor()
    self._actionEntry = {}
    self._keyList = {}
end

function ActionManager:getAction(owner)
    local action = Action.new(owner)
    action:setManager(self)
    self:addAcion(action)
    return action
end

function ActionManager:removeActionByOwner(owner)
    self:removeKey(owner)
end

function ActionManager:addAcion(action)
    local owner = action:getOwner()
    if not self._actionEntry[owner] then
        self._actionEntry[owner] = {}
        table.insert(self._keyList, owner)
    end
    table.insert(self._actionEntry[owner], action)
end

function ActionManager:removeAcion(action)
    local list = self._actionEntry[action:getOwner()]
    if list then
        for i, v in ipairs(list) do
            if v == action then
                table.remove(list, i)
                break
            end
        end
        if #list == 0 then
            self:removeKey(action:getOwner())
        end
    end
end

function ActionManager:removeKey(obj)
    for i, v in ipairs(self._keyList) do
        if v == obj then
            table.remove(self._keyList, i)
            break
        end
    end
    self._actionEntry[obj] = nil
end

-- @param dt: fix32 deltatime
function ActionManager:update(dt)
    local removeList = {}
    for i, owner in ipairs(self._keyList) do
        if y3.class.isValid(owner) then
            local list = self._actionEntry[owner]
            for j, action in ipairs(list) do
                action:update(dt)
            end
        else
            table.insert(removeList, owner)
        end
    end
    for i, obj in ipairs(removeList) do
        self:removeKey(obj)
    end
end

return ActionManager
