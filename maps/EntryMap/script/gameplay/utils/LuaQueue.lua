List = {}

function List.new()
    return {first = 0, last = -1}
end

function List.pushFront(list, value)
    local first = list.first - 1
    list.first = first
    list[first] = value
end

function List.pushBack(list, value)
    local last = list.last + 1
    list.last = last
    list[last] = value
end

function List.popFront(list)
    local first = list.first
    if first > list.last then
        error("List is empty")
    end
    local value = list[first]
    list[first] = nil
    list.first = first + 1
    return value
end

function List.popBack(list)
    local last = list.last
    if list.first > last then
        error("List is empty")
    end
    local value = list[last]
    list[last] = nil
    list.last = last - 1
    return value
end

function List.isEmpty(list)
    local last = list.last
    if list.first > last then
        return true
    end
    return false
end

return List