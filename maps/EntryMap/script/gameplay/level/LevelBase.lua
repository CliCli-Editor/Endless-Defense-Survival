local LevelBase = class("LevelBase")

function LevelBase:ctor()
    self._viewMap = {}
    self._triggerList = {}
    self._logic = {}
    self._logicList = {}

    self._saveLogic = {}
    self._saveLogicList = {}
    self._noticeMap = {}
    self:_onInit()
end

function LevelBase:addLogic(logicName, isSave)
    if self._logic[logicName] then
        return self._logic[logicName]
    end
    local logicPath = "gameplay.level.logic."
    if isSave then
        logicPath = "gameplay.level.save."
    end
    local inst = include(logicPath .. logicName).new(self)
    self._logic[logicName] = inst
    table.insert(self._logicList, logicName)
    return inst
end

function LevelBase:getLogic(logicName)
    return self._logic[logicName]
end

function LevelBase:onSave()
    for i = 1, #self._saveLogicList do
        local logicName = self._saveLogicList[i]
        local logic = self._saveLogic[logicName]
        if logic then
            logic:onSave()
        end
    end
end

function LevelBase:_onInit()
    self:onInitData()
    self:onInitLogic()
    self:onInitView()
end

function LevelBase:onInitData()

end

function LevelBase:onInitLogic()

end

function LevelBase:onInitView()

end

function LevelBase:getName()
    return self.__cname
end

function LevelBase:initView(viewList)
    for i = 1, #viewList do
        local view = include(viewList[i])
        if view then
            local inst = view.new()
            self._viewMap[inst:getName()] = inst
        end
    end
end

function LevelBase:getView(name)
    return self._viewMap[name]
end

function LevelBase:clear()
    for k, v in pairs(self._viewMap) do
        v:clear()
    end
    for k, v in pairs(self._logic) do
        v:clear()
    end
    self._viewMap = {}
    for i, trigger in ipairs(self._triggerList) do
        if trigger and y3.class.isValid(trigger) then
            trigger:remove()
        end
    end
    self._triggerList = {}
end

function LevelBase:getGameLogic()
end

function LevelBase:addTrigger(trigger)
    table.insert(self._triggerList, trigger)
end

return LevelBase
