local BaseData = class("BaseData")

BaseData.schema = {}

function BaseData:ctor(properties)
    local schema = self.class.schema

    for key, value in pairs(schema) do
        local getFunc = "get" .. key:ucfirst()
        local setFunc = "set" .. key:ucfirst()

        self[getFunc] = function(obj)
            return obj["_" .. key .. "_"]
        end
        self[setFunc] = function(obj, v)
            assert(type(v) == value[1], "type is fail")
            obj["_" .. key .. "_"] = v
        end
        self[setFunc](self, value[2])
    end

    self:setProperties(properties)
end

function BaseData:setProperties(properties)
    if not properties then
        return
    end

    for key, value in pairs(properties) do
        local setFunc = "set" .. key:ucfirst()
        if self[setFunc] and type(self[setFunc]) == "function" then
            self[setFunc](self, value)
        end
    end
end

return BaseData
