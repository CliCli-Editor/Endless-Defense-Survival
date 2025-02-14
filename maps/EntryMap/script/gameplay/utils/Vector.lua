Vector = {}
Vector.__index = Vector

function Vector.new(x, y)
    local self = setmetatable({}, Vector)
    self.x = x
    self.y = y
    return self
end

function Vector:add(other)
    return Vector.new(self.x + other.x, self.y + other.y)
end

function Vector:subtract(other)
    return Vector.new(self.x - other.x, self.y - other.y)
end

function Vector:multiply(scalar)
    return Vector.new(self.x * scalar, self.y * scalar)
end

function Vector:length()
    return math.sqrt(self.x ^ 2 + self.y ^ 2)
end

function Vector:dotProduct(other)
    return self.x * other.x + self.y * other.y
end

function Vector:normalize()
    local len = self:length()
    if len ~= 0 then
        return Vector.new(self.x / len, self.y / len)
    else
        return Vector.new(0, 0)
    end
end

function Vector:distanceTo(other)
    local dx = self.x - other.x
    local dy = self.y - other.y
    return math.sqrt(dx ^ 2 + dy ^ 2)
end

function Vector:perpendicularVector()
    return Vector.new(-self.y, self.x), Vector.new(self.y, -self.x)
end

function Vector.lerp(vec1, vec2, t)
    return vec1:add(vec2:subtract(vec1):multiply(t))
end

return Vector
