local Action    = class("Action")
local Vector3   = include("gameplay.utils.Vector3")
local GameUtils = include("gameplay.utils.GameUtils")

-- @param owner unit、projectile、item、particle
function Action:ctor(onwer)
    self._owenr = onwer
    self._totalDt = Fix32(0)
    self._animTime = Fix32(0)
end

function Action:getOwner()
    return self._owenr
end

function Action:setManager(manager)
    self._manager = manager
end

-- @param dt:fix32 deltatime
function Action:update(dt)
    local updateFunc = "_update_" .. self._updateType
    if self[updateFunc] then
        self[updateFunc](self, dt)
    end
    -- self._totalDt = self._totalDt + dt
    -- if self._totalDt >= self._animTime then

    --     self:onEnd()
    -- end
end

function Action:stop()
    self:onEnd()
end

function Action:onEnd()
    if self._finishCall then
        self._finishCall()
    end
    if self._manager then
        self._manager:removeAcion(self)
    end
end

function Action:setFinishCallback(callback)
    self._finishCall = callback
end

function Action:BezierCurve(startPoint, controlPoint, endPoint, t)
    local x = (1 - t) ^ 2 * startPoint.x + 2 * t * (1 - t) * controlPoint.x + t ^ 2 * endPoint.x
    local y = (1 - t) ^ 2 * startPoint.y + 2 * t * (1 - t) * controlPoint.y + t ^ 2 * endPoint.y
    return Vector3.new(x, y, 0)
end

function Action:moveToTarget(target)
    self._target = target
    self._updateType = "move_target"
    self._ownVec = Vector3.new(0, 0, 0)
    self._tarVec = Vector3.new(0, 0, 0)
    self._ownVec:updateFromPoint(self._owenr:get_point())
    self._tarVec:updateFromPoint(self._target:get_point())
end

function Action:_update_move_target(dt)
    if not self._ownVec or not self._target then
        self:onEnd()
        return
    end
    self._totalDt = self._totalDt + dt
    local curPos = self._owenr:get_point()
    local targetPos = self._target:get_point()
    local dist = curPos:get_distance_with(targetPos)
    if dist <= 20 then
        self:onEnd()
        return
    end
    self._tarVec:updateFromPoint(targetPos)
    self._ownVec:updateFromPoint(curPos)
    local curPos = Vector3.lerp(self._ownVec, self._tarVec, self._totalDt:float() * 4)
    self._owenr:set_point(curPos:toPoint())
end

function Action:floatHeight(offsetHeight, speed)
    self._updateType = "float_height"
    self._offsetHeight = offsetHeight
    self._initHeight = self._owenr:get_height()
    self._targetHeight = self._initHeight + self._offsetHeight
    self._speed = speed
    self._flag = 1
end

function Action:_update_float_height(dt)
    --GameUtils.lerp(curHeight, self._targetHeight, dt:float() * 3)
    local curHeight = self._owenr:get_height()
    local targetHeight = curHeight + self._flag * dt:float() * self._speed
    self._owenr:set_height(targetHeight)
    if math.abs(targetHeight - self._targetHeight) <= 5 then
        if self._flag == 1 then
            self._flag = -1
            self._targetHeight = self._initHeight - self._offsetHeight
        else
            self._flag = 1
            self._targetHeight = self._initHeight + self._offsetHeight
        end
    end
end

function Action:bezierMove(target)
    self._target = target
    self._updateType = "bezier_move"
    self._ownVec = Vector3.new(0, 0, 0)
    self._tarVec = Vector3.new(0, 0, 0)
    self._ownVec:updateFromPoint(self._owenr:get_point())
    self._tarVec:updateFromPoint(self._target:get_point())
    self._controlPoint = Vector3.lerp(self._ownVec, self._tarVec, 0.4)
    self._initHeight = 400 --self._owenr:get_height()
    local dir = self._tarVec:subtract(self._ownVec)
    dir = dir:normalize()
    local preVec, preVec2 = dir:perpendicularVectorXY()
    if math.random(1, 2) == 1 then
        preVec = preVec:normalize()
    else
        preVec = preVec2:normalize()
    end
    self._controlPoint = self._controlPoint:add(preVec:multiply(900))
    self._totalDt = Fix32(0)
end

function Action:_update_bezier_move(dt)
    self._totalDt = self._totalDt + dt * Fix32(2)
    local curHeight = GameUtils.lerp(self._initHeight, 20, self._totalDt:float())
    self._tarVec:updateFromPoint(self._target:get_point())
    local curPos = self:BezierCurve(self._ownVec, self._controlPoint, self._tarVec, self._totalDt:float())
    self._owenr:set_point(y3.point.create(curPos.x, curPos.y, curPos.z))
    self._owenr:set_height(curHeight)
    if self._totalDt >= Fix32(1) then
        self:onEnd()
    end
end

function Action:waveMove(target, nums)
    self._target = target
    self._updateType = "wave_move"
    self._ownVec = Vector3.new(0, 0, 0)
    self._tarVec = Vector3.new(0, 0, 0)
    self._ownVec:updateFromPoint(self._owenr:get_point())
    self._tarVec:updateFromPoint(self._target:get_point())

    local dir = self._tarVec:subtract(self._ownVec)
    dir = dir:normalize()
    local preVec, preVec2 = dir:perpendicularVectorXY()
    preVec = preVec:normalize()
    preVec2 = preVec2:normalize()

    local distance = self._ownVec:distance(self._tarVec)
    local waveList = {}
    local lastPos = self._ownVec
    for i = 1, nums do
        local radio = math.floor((i / nums) * 0.8 * 100) / 100
        local pos = Vector3.lerp(self._ownVec, self._tarVec, radio)
        local part = math.floor(radio * distance * 100) / 100
        local controlPoint = Vector3.lerp(lastPos, pos, 0.5)
        if i % 2 == 0 then
            controlPoint = controlPoint:add(preVec:multiply(600))
        else
            controlPoint = controlPoint:add(preVec2:multiply(600))
        end
        table.insert(waveList, { pos = pos, part = Fix32(part), controlPoint = controlPoint })
        lastPos = pos
    end
    local controlPoint = Vector3.lerp(lastPos, self._tarVec, 0.5)
    table.insert(waveList, { pos = self._tarVec, part = Fix32(distance), controlPoint = controlPoint })
    self._waveList = waveList
    self._distance = Fix32(distance)
    self._initHeight = 400
    self._totalDt = Fix32(0)
end

function Action:_update_wave_move(dt)
    self._totalDt = self._totalDt + dt * Fix32(900)
    for i, wave in ipairs(self._waveList) do
        if self._totalDt <= wave.part then
            local lastPos = self._ownVec
            local lastVal = Fix32(0)
            if self._waveList[i - 1] then
                lastPos = self._waveList[i - 1].pos
                lastVal = self._waveList[i - 1].part
            end
            local curVal = self._totalDt - lastVal
            local allVal = wave.part - lastVal
            local radio = curVal / allVal
            if i == #self._waveList then
                self._tarVec:updateFromPoint(self._target:get_point())
                local curPos = self:BezierCurve(lastPos, wave.controlPoint, self._tarVec, radio:float())
                self._owenr:set_point(curPos:toPoint())
            else
                local curPos = self:BezierCurve(lastPos, wave.controlPoint, wave.pos, radio:float())
                self._owenr:set_point(curPos:toPoint())
            end
            break
        end
    end
    local curHeight = GameUtils.lerp(self._initHeight, 20, (self._totalDt / self._distance):float())
    self._owenr:set_height(curHeight)
    if self._totalDt >= self._distance then
        self:onEnd()
    end
end

function Action:rotation(rotAxisx, rotAxisy, rotAxisz)
    self._updateType = "rotation"
    self._rotAxis = Vector3.new(rotAxisx, rotAxisy, rotAxisz)
    self._totalDt = 0
end

function Action:_update_rotation(dt)
    local deltatime = dt:float()
    local rotx = self._rotAxis.x * deltatime
    local roty = self._rotAxis.y * deltatime
    local rotz = self._rotAxis.z * deltatime
    self._owenr:set_rotation(rotx, roty, rotz)
end

function Action:moveToPoint(target, fromPos)
    self._target = target
    self._updateType = "move_point"
    self._ownVec = Vector3.new(0, 0, 0)
    self._tarVec = Vector3.new(0, 0, 0)
    self._ownVec:updateFromPoint(fromPos)
    self._tarVec:updateFromPoint(self._target)
    self._ownPos = fromPos
end

function Action:_update_move_point(dt)
    if not self._ownVec or not self._target then
        self:onEnd()
        return
    end
    self._totalDt = self._totalDt + dt
    -- print("self._totalDt", self._totalDt:float())
    local curPos = self._ownPos    --self._owenr:get_point()
    local targetPos = self._target --self._target:get_point()
    local dist = curPos:get_distance_with(targetPos)
    if dist <= 20 then
        self:onEnd()
        return
    end
    local curPos = Vector3.lerp(self._ownVec, self._tarVec, self._totalDt:float() / 1)
    -- print("curPos", curPos.x, curPos.y, curPos.z)
    self._owenr:set_point(curPos:toPoint())
    self._ownPos = curPos:toPoint()
end

return Action
