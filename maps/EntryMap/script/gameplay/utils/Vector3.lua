Vector3 = {}
Vector3.__index = Vector3

function Vector3.new(x, y, z)
    local self = setmetatable({}, Vector3)
    self.x = x
    self.y = y
    self.z = z
    return self
end

function Vector3:add(otherVector)
    return Vector3.new(self.x + otherVector.x, self.y + otherVector.y, self.z + otherVector.z)
end

function Vector3:subtract(otherVector)
    return Vector3.new(self.x - otherVector.x, self.y - otherVector.y, self.z - otherVector.z)
end

function Vector3:dotProduct(otherVector)
    return self.x * otherVector.x + self.y * otherVector.y + self.z * otherVector.z
end

function Vector3:crossProduct(otherVector)
    local x = self.y * otherVector.z - self.z * otherVector.y
    local y = self.z * otherVector.x - self.x * otherVector.z
    local z = self.x * otherVector.y - self.y * otherVector.x
    return Vector3.new(x, y, z)
end

function Vector3:toPoint()
    return y3.point.create(self.x, self.y, self.z)
end

function Vector3:multiply(scalar)
    return Vector3.new(self.x * scalar, self.y * scalar, self.z * scalar)
end

function Vector3:updateFromPoint(point)
    self.x = point:get_x()
    self.y = point:get_y()
    self.z = point:get_z()
end

function Vector3:length()
    return math.sqrt(self.x * self.x + self.y * self.y + self.z * self.z)
end

function Vector3:lengthSQ()
    return self.x * self.x + self.y * self.y + self.z * self.z
end

function Vector3:normalize()
    local length = self:length()
    if length == 0 then
        return Vector3.new(0, 0, 0)
    else
        return self:multiply(1 / length)
    end
end

function Vector3:perpendicularVectorXY()
    return Vector3.new(-self.y, self.x, 0), Vector3.new(self.y, -self.x, 0)
end

function Vector3:distance(otherVector)
    return (self:subtract(otherVector)):length()
end

function Vector3.lerp(vec1, vec2, t)
    return vec1:add(vec2:subtract(vec1):multiply(t))
end

function Vector3.pointTo(point)
    return Vector3.new(point:get_x(), point:get_y(), point:get_z())
end

return Vector3
