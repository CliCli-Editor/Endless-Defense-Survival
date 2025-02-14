local Bomb = class("Bomb")
local ProjectileConst = include("gameplay.const.ProjectileConst")
local Vector = include("gameplay.utils.Vector")

local SPEED = 1000
local DAMAGE = 300

Bomb.MOVE_FOLLOW_TARGET = "follow_target"       -- 追踪单个敌人打击
Bomb.MOVE_CURVE_TARGET = "curve_target"         -- 曲线追踪单个敌人打击
Bomb.MOVE_WAVE_TARGET = "wave_target"           -- 多段曲线曲线追踪单个敌人打击
Bomb.MOVE_LINE_TARGET = "line_target"           -- 直线打击路径上的敌人
Bomb.MOVE_SET_IN_POINT = "set_in_point"         -- 原地喷射火焰持续杀伤敌人
Bomb.MOVE_LINE_TARGET_FIRE = "line_target_fire" -- 投射一个炸弹爆炸打击敌人
Bomb.MOVE_CATAPULT_TARGET = "catapult_target"   -- 击中目标后进行弹射

Bomb.selecter = y3.selector.create()

function Bomb:ctor(param)
    local unit = param.owner
    self._owerUnit = param.owner
    self._moveType = param.move_type
    self._target = param.target
    self._damage = param.damage or DAMAGE
    self._hitRemove = param.hitRemove or false
    self._hitCallback = param.hitCallback or nil
    self._hitRadius = param.hitRadius or 80
    self._speed = param.speed or 1000
    self._height = param.height or 400
    self._param = param
    self._bomb = nil
    local data = {}
    data.key = param.projectId or ProjectileConst.PROJECTILE_BOMB_ID
    data.target = unit:get_point()
    data.owner = unit
    data.height = self._height
    data.time = -1
    local bomb = y3.PoolMgr:getProjectile(data.key)
    bomb:set_owner(data.owner)
    bomb:set_point(data.target)
    bomb:set_height(data.height)
    self._bomb = bomb
    self:initBombMove()
end

function Bomb:initBombMove()
    local moveFunc = self["_move_" .. self._moveType]
    if moveFunc then
        moveFunc(self)
    end
end

------------------------------------------------------------
function Bomb:_move_follow_target()
    local moveData = {}
    moveData.target = self._target
    moveData.target_distance = 10
    moveData.speed = self._speed
    moveData.acceleration = 5
    moveData.min_speed = self._speed
    moveData.max_speed = 3000
    moveData.height = 50
    moveData.parabola_height = 600
    moveData.on_hit = function()
    end --handler(self, self._onHit)
    moveData.on_finish = function()
        self:_onHit(nil, self._target)
        self:_onFinish()
    end
    moveData.hit_radius = self._hitRadius
    moveData.hit_type = 0
    self._mover = self._bomb:mover_target(moveData)
end

function Bomb:_move_curve_target()
    -- -@class Mover.CreateData.Curve: Mover.CreateData.Base
    -- -@field angle number # 运动方向
    -- -@field distance number # 运动距离
    -- -@field speed number # 初始速度
    -- -@field path (Point|py.FixedVec2)[] # 路径点
    -- -@field acceleration? number # 加速度
    -- -@field max_speed? number # 最大速度
    -- -@field min_speed? number # 最小速度
    -- -@field init_height? number # 初始高度
    -- -@field fin_height? number # 终点高度
    -- local ownPoint =self._bomb:get_point()
    -- local tarPoint = self._target:get_point()
    -- local moveData = {}
    -- moveData.angle = ownPoint:get_angle_with(tarPoint)
    -- moveData.distance = ownPoint:get_distance_with(tarPoint)
    -- moveData.speed = 1000
    -- local curPos = Vector.new(ownPoint:get_x(), ownPoint:get_y())
    -- local tarPos = Vector.new(tarPoint:get_x(), tarPoint:get_y())
    -- print("curPos", curPos.x, curPos.y)
    -- print("tarPos", tarPos.x, tarPos.y)
    -- local stepPos1 = Vector.lerp(curPos, tarPos, 0.3)
    -- local stepPos2 = Vector.lerp(curPos, tarPos, 0.6)
    -- print("stepPos1", stepPos1.x, stepPos1.y)
    -- print("stepPos2", stepPos2.x, stepPos2.y)
    -- -- local dir = tarPos:subtract(curPos)
    -- -- dir:normalize()
    -- moveData.path = { ownPoint, tarPoint }
    local action = y3.ActionMgr:getAction(self._bomb)
    action:bezierMove(self._target)
    action:setFinishCallback(function()
        self:_onHit(nil, self._target)
        self:_onFinish()
    end)
    -- self._bomb:mover_line(moveData)
end

function Bomb:_move_wave_target()
    local action = y3.ActionMgr:getAction(self._bomb)
    action:waveMove(self._target, 3)
    action:setFinishCallback(function()
        self:_onHit(nil, self._target)
        self:_onFinish()
    end)
end

function Bomb:_move_line_target()
    local moveData = {}
    local startPos = self._bomb:get_point()
    local targetPos = self._target:get_point()
    moveData.angle = startPos:get_angle_with(targetPos)
    moveData.distance = startPos:get_distance_with(targetPos)
    moveData.speed = self._speed or SPEED
    moveData.on_hit = handler(self, self._onHit)
    moveData.on_finish = handler(self, self._onFinish)
    moveData.hit_radius = self._hitRadius or 80
    moveData.hit_type = 0
    moveData.init_height = self._height
    moveData.fin_height = self._height
    self._bomb:mover_line(moveData)
end

function Bomb:_handleContinued(delay)
    self._bomb:set_point(self._owerUnit:get_point())
    self._totalDt = self._totalDt + delay
    self._totalDt2 = self._totalDt2 + delay
    if self._totalDt >= self._inter then
        self._totalDt = self._totalDt - self._inter
        local poDir = self._bomb:get_face_dir()
        local dir = Vector.new(poDir:get_x(), poDir:get_y())
        dir = dir:normalize()
        local curPos = Vector.new(self._bomb:get_point():get_x(), self._bomb:get_point():get_y())
        local tarPos = curPos:add(dir:multiply(self._param.distance))
        local units = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy"):findAllEnemyUnit(
            self._owerUnit:get_owner_player():get_id(), {})
        local hitResult = {}
        for slot, unit in pairs(units) do
            local unitPos = unit:get_point()
            if self:distancePointToSegment(unitPos:get_x(), unitPos:get_y(), curPos.x, curPos.y, tarPos.x, tarPos.y) < self._param.width then
                table.insert(hitResult, unit)
            end
        end
        if #hitResult > 0 then
            self:_onHit(nil, hitResult, true)
        end
    end
    if self._totalDt2 >= self._delayTime then
        y3.gameApp:removeTimer(self._timerId)
        self:_onFinish()
    end
end

function Bomb:_move_set_in_point()
    self._selecter  = Bomb.selecter
    self._totalDt   = Fix32(0)
    self._totalDt2  = Fix32(0)
    self._inter     = Fix32(self._param.inter)
    self._delayTime = Fix32(self._param.delayTime)
    self._bomb:set_facing(self._bomb:get_point():get_angle_with(self._target:get_point()))
    self:_handleContinued(self._inter)
    self._timerId = y3.gameApp:addTimerLoop(self._inter, handler(self, self._handleContinued))
end

function Bomb:_move_line_target_fire()
    local moveData = {}
    local startPos = self._bomb:get_point()
    local targetPos = self._target:get_point()
    moveData.angle = startPos:get_angle_with(targetPos)
    moveData.distance = startPos:get_distance_with(targetPos)
    moveData.speed = self._speed or SPEED
    moveData.on_hit = function()
    end
    moveData.on_finish = function()
        local data = {}
        data.key = 134241891
        data.target = targetPos
        data.time = 2
        y3.projectile.create(data)
        Bomb.selecter:in_shape(data.target, y3.shape.create_circular_shape(self._param.fireRadius))
        local group = Bomb.selecter:get()
        local units = group:pick()
        local hitResult = {}
        for i, unit in ipairs(units) do
            if unit:is_alive() and unit:is_enemy(self._owerUnit) then
                table.insert(hitResult, unit)
            end
        end
        if #hitResult > 0 then
            self:_onHit(nil, hitResult, true)
        end
        self:_onFinish()
    end
    moveData.hit_radius = self._hitRadius or 80
    moveData.hit_type = 0
    moveData.init_height = self._height
    moveData.fin_height = 20
    moveData.parabola_height = self._height + 200
    self._bomb:mover_line(moveData)
end

function Bomb:_moveToTarget(targetList)
    if not targetList[self._catapultIndex] then
        self:_onFinish()
        return
    end
    local moveData = {}
    moveData.target = targetList[self._catapultIndex]
    moveData.target_distance = 10
    moveData.speed = self._speed
    moveData.acceleration = 30
    moveData.min_speed = self._speed
    moveData.max_speed = 4000
    moveData.height = 20
    moveData.parabola_height = 20
    moveData.on_hit = function()
    end
    moveData.on_finish = function()
        self:_onHit(nil, targetList[self._catapultIndex], false)
        self._catapultIndex = self._catapultIndex + 1
        if self._catapultIndex > self._param.catapult_nums then
            self:_onFinish()
        else
            self:_moveToTarget(targetList)
        end
    end
    moveData.hit_radius = self._hitRadius
    moveData.hit_type = 0
    self._mover = self._bomb:mover_target(moveData)
end

function Bomb:_move_catapult_target()
    self._catapultIndex = 1
    local moveData = {}
    moveData.target = self._target
    moveData.target_distance = 10
    moveData.speed = self._speed
    moveData.acceleration = 30
    moveData.min_speed = self._speed
    moveData.max_speed = 3000
    moveData.height = 400
    moveData.on_hit = function()
    end
    moveData.on_finish = function()
        self:_onHit(nil, self._target)
        Bomb.selecter:in_shape(self._target:get_point(), y3.shape.create_circular_shape(self._param.catapultRadius))
        local groups = Bomb.selecter:get()
        local units = groups:pick()
        local targetList = {}
        for i, unit in ipairs(units) do
            if unit ~= self._target and unit:is_alive() and unit:is_enemy(self._owerUnit) then
                table.insert(targetList, unit)
            end
        end
        if #targetList > 0 then
            self:_moveToTarget(targetList)
        else
            self:_onFinish()
        end
    end
    moveData.hit_radius = self._hitRadius
    moveData.hit_type = 0
    self._mover = self._bomb:mover_target(moveData)
end

-----------------------------------------------------------
function Bomb:convertFacingToAngle(facing)
    local facAngle = facing:float()
    return facAngle
    -- if facAngle >= 0 and facAngle < 90 then
    --     return 270 + facAngle
    -- elseif facAngle >= 90 and facAngle <= 180 then
    --     return facAngle - 90
    -- elseif facAngle < 0 and facAngle >= -90 then
    --     return 270 + facAngle
    -- elseif facAngle < -90 and facAngle >= -180 then
    --     return 270 + facAngle
    -- end
end

function Bomb:distancePointToLine(x, y, x1, y1, x2, y2)
    local A = y2 - y1
    local B = x1 - x2
    local C = x2 * y1 - x1 * y2
    local dist = math.abs(A * x + B * y + C) / math.sqrt(A * A + B * B)
    return dist
end

function Bomb:distancePointToSegment(px, py, x1, y1, x2, y2)
    local function dot(v1x, v1y, v2x, v2y)
        return v1x * v2x + v1y * v2y
    end

    local function length(vx, vy)
        return math.sqrt(vx * vx + vy * vy)
    end

    local function distance(x, y, x1, y1, x2, y2)
        local vx, vy = x2 - x1, y2 - y1
        local wx, wy = x - x1, y - y1
        local c1 = dot(wx, wy, vx, vy)
        if c1 <= 0 then
            return length(x - x1, y - y1)
        end

        local c2 = dot(vx, vy, vx, vy)
        if c2 <= c1 then
            return length(x - x2, y - y2)
        end

        local b = c1 / c2
        local pbx, pby = x1 + b * vx, y1 + b * vy
        return length(x - pbx, y - pby)
    end

    return distance(px, py, x1, y1, x2, y2)
end

-- -@field speed number # 初始速度
-- -@field target_distance number # 撞击目标的距离
-- -@field acceleration? number # 加速度
-- -@field max_speed? number # 最大速度
-- -@field min_speed? number # 最小速度
-- -@field height? number # 初始高度
-- -@field parabola_height? number # 抛物线顶点高度
-- -@field bind_point? string # 绑定点

function Bomb:_onHit(mover, unit, isArray)
    -- if unit:get_name() == "monster" then
    --     self._owerUnit:damage {
    --         damage = self._damage,
    --         target = unit,
    --         type = '物理',
    --         text_type = 'physics'
    --     }
    --     if self._hitRemove then
    --         self._bomb:remove()
    --     end
    -- end
    if self._hitCallback then
        self._hitCallback(self._bomb, unit, isArray)
    end
    local unitGroup = y3.unit_group.create()
    if isArray then
        for i, v in ipairs(unit) do
            unitGroup:add_unit(v)
        end
    else
        unitGroup:add_unit(unit)
    end
    y3.eca.call('轨迹命中通知', self._param.ability, unitGroup)
    if self._hitRemove then
        self:recyle()
    end
end

function Bomb:recyle()
    if self._bomb then
        if self._mover then
            self._mover:stop()
            self._mover:remove()
        end
        y3.PoolMgr:recycleProjectile(self._bomb:get_key(), self._bomb)
        self._bomb = nil
    end
    self = nil
end

function Bomb:setHitCallback(callback)
    self._hitCallback = callback
end

function Bomb:_onFinish(delay)
    -- print("bomb finish")
    y3.gameApp:addTimer(delay or 0.2, function()
        self:recyle()
    end)
    -- y3.PoolMgr:recycleBomb(self._bomb)
end

-- local moveData = {}
-- moveData.angle = bombPos:get_angle_with(targetPos)
-- moveData.distance = 2000
-- moveData.speed = param.speed or SPEED
-- moveData.on_hit = handler(self, self._onHit)
-- moveData.on_finish = handler(self, self._onFinish)
-- moveData.hit_radius = param.hitRadius or 80
-- moveData.hit_type = 0
-- bomb:mover_line(moveData)

return Bomb
