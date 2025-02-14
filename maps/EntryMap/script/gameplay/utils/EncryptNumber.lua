local EncryptNumber = class("EncryptNumber")

function EncryptNumber:ctor(value)
    self._randKey = os.time() --math.random(1, 1000000)
    self._curIndex = 1
    self._arrSize = os.time() % 4 + 3
    self._arr = {}
    self.isEncrypt = true
    self:set(value)
end

function EncryptNumber:isInteger(num)
    return num == math.floor(num)
end

function EncryptNumber:set(value)
    if type(value) == "number" then
    elseif type(value) == "userdata" then
        value = value:float()
    end
    assert(type(value) == "number", "value must be a number")
    self._isInteger = self:isInteger(value)
    local svalue = value
    if self._isInteger then
        svalue = value ~ self._randKey
    else
        value = math.floor(value * 10000)
        svalue = value ~ self._randKey
    end
    self._curIndex = (self._curIndex + 1) % self._arrSize
    if self._curIndex == 0 then
        self._curIndex = self._arrSize
    end
    self._arr[self._curIndex] = svalue
end

function EncryptNumber:get()
    if self._isInteger then
        return self._arr[self._curIndex] ~ self._randKey
    else
        local value = self._arr[self._curIndex] ~ self._randKey
        return value / 10000
    end
end

return EncryptNumber
