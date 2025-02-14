local SlotList = class("SlotList")

function SlotList:ctor()
    self._head = nil
end

function SlotList:insert(slot)
    if not self._head then
        self._head = {}
        self._head.node = slot
        self._head.next = nil
        return
    end

    local linkNode = {}
    linkNode.node = slot
    linkNode.next = nil

    local prevNode = self._head
    local currentNode = self._head

    local isInsert = false
    while currentNode do
        if slot:getPriority() > currentNode.node:getPriority() then
            if currentNode == self._head then
                self._head = linkNode
            else
                prevNode.next = linkNode
            end
            linkNode.next = currentNode
            isInsert = true
        end
        prevNode = currentNode
        currentNode = currentNode.next
    end

    if not isInsert then
        prevNode.next = linkNode
    end
end

function SlotList:remove(slot)
    local prevNode = self._head
    local currentNode = self._head

    while currentNode do
        if currentNode.node == slot then
            if currentNode == self._head then
                self._head = currentNode.next
                currentNode = nil
            else
                prevNode.next = currentNode.next
                currentNode = nil
            end
            break
        end
        prevNode = currentNode
        currentNode = currentNode.next
    end
end

function SlotList:excute(...)
    local currentNode = self._head
    while currentNode do
        currentNode.node:excute(...)
        currentNode = currentNode.next
    end
end

function SlotList:isEmpty()
    return self._head == nil
end

return SlotList
