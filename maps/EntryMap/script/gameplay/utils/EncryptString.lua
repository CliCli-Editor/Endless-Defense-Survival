local EncryptString = class("EncryptString")
local encrypted = {}

EncryptString.MAP_BU = { 1, 2, 3, 4, 5 }
EncryptString.MAP_INDEX = 1

function EncryptString:ctor(value)
    self._randKey = "3256974563215698" --self:getStr() -- tostring(os.time()) --math.random(1, 1000000)
    self._randIv = "1579632546321478"  --self:getStr2() --tostring(os.time() % 100000)
    EncryptString.MAP_INDEX = (EncryptString.MAP_INDEX + 1) % #EncryptString.MAP_BU + 1
    self._curIndex = 1
    self._arrSize = os.time() % 4 + 3
    self._arr = {}
    self.isEncrypt = true
    self:set(value)
end

function EncryptString:getStr()
    local ret = ""
    local str = tostring(os.time())
    local maxSize = #str
    for i = 1, 16 do
        if i <= maxSize then
            local charCode = string.byte(str, i)
            ret = ret .. string.char(charCode)
        else
            ret = ret .. string.char(EncryptString.MAP_BU[EncryptString.MAP_INDEX])
        end
    end
    return ret
end

function EncryptString:getStr2()
    local ret = ""
    local str = tostring(os.time() % 100000)
    local maxSize = #str
    for i = 1, 16 do
        if i <= maxSize then
            local charCode = string.byte(str, i)
            ret = ret .. string.char(charCode)
        else
            ret = ret .. string.char(EncryptString.MAP_BU[EncryptString.MAP_INDEX])
        end
    end
    return ret
end

function encrypted.encrypt(text, key)
    local encrypted = ""
    for i = 1, #text do
        local char = text:byte(i)
        local keychar = key:byte((i - 1) % #key + 1)
        local encryptedchar = bit.bxor(char, keychar)
        encrypted = encrypted .. string.char(encryptedchar)
    end
    return encrypted
end

-- 解密函数
function encrypted.decrypt(encrypted, key)
    local decrypted = ""
    for i = 1, #encrypted do
        local char = encrypted:byte(i)
        local keychar = key:byte((i - 1) % #key + 1)
        local decryptedchar = bit.bxor(char, keychar)
        decrypted = decrypted .. string.char(decryptedchar)
    end
    return decrypted
end

function EncryptString:encryptString(str)
    local result = y3.aes.encrypt(self._randKey, self._randIv, tostring(str))
    result = y3.base64.encode(result)
    return result
end

function EncryptString:decryptString(str)
    local result = y3.base64.decode(str)
    return y3.aes.decrypt(self._randKey, self._randIv, result)
end

function EncryptString:set(value)
    assert(type(value) == "string", "value must be a string")
    local svalue = self:encryptString(value)
    self._curIndex = (self._curIndex + 1) % self._arrSize
    if self._curIndex == 0 then
        self._curIndex = self._arrSize
    end
    self._arr[self._curIndex] = svalue
end

function EncryptString:get()
    return self:decryptString()
end

return EncryptString
