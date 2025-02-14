local GameUtils = include "gameplay.utils.GameUtils"
local SurviveHelper = include("gameplay.level.logic.helper.SurviveHelper")
local Weapon = class("Weapon")

local BASE_HEIGHT = 800
-- local mount_point = {
--     { x = -500, y = 100,  z = 400, use = false },
--     { x = -400, y = 100,  z = 400, use = false },
--     { x = -300, y = 100,  z = 400, use = false },
--     { x = -200, y = 100,  z = 400, use = false },
--     { x = -100, y = 100,  z = 400, use = false },
--     { x = 0,    y = 100,  z = 400, use = false },
--     { x = 100,  y = 100,  z = 400, use = false },
--     { x = 200,  y = 100,  z = 400, use = false },
--     { x = 300,  y = 100,  z = 400, use = false },
--     { x = 400,  y = 100,  z = 400, use = false },
--     { x = 500,  y = 100,  z = 400, use = false },
--     { x = -500, y = -100, z = 400, use = false },
--     { x = -400, y = -100, z = 400, use = false },
--     { x = -300, y = -100, z = 400, use = false },
--     { x = -200, y = -100, z = 400, use = false },
--     { x = -100, y = -100, z = 400, use = false },
--     { x = 0,    y = -100, z = 400, use = false },
--     { x = 100,  y = -100, z = 400, use = false },
--     { x = 200,  y = -100, z = 400, use = false },
--     { x = 300,  y = -100, z = 400, use = false },
--     { x = 400,  y = -100, z = 400, use = false },
--     { x = 500,  y = -100, z = 400, use = false },
--     { x = -500, y = 100, z = 200, use = false },
--     { x = -400, y = 100, z = 200, use = false },
--     { x = -300, y = 100, z = 200, use = false },
--     { x = -200, y = 100, z = 200, use = false },
--     { x = -100, y = 100, z = 200, use = false },
--     { x = 0,    y = 100, z = 200, use = false },
--     { x = 100,  y = 100, z = 200, use = false },
--     { x = 200,  y = 100, z = 200, use = false },
--     { x = 300,  y = 100, z = 200, use = false },
--     { x = 400,  y = 100, z = 200, use = false },
--     { x = 500,  y = 100, z = 200, use = false },
--     { x = -500, y = 100, z = 600, use = false },
--     { x = -400, y = 100, z = 600, use = false },
--     { x = -300, y = 100, z = 600, use = false },
--     { x = -200, y = 100, z = 600, use = false },
--     { x = -100, y = 100, z = 600, use = false },
--     { x = 0,    y = 100, z = 600, use = false },
--     { x = 100,  y = 100, z = 600, use = false },
--     { x = 200,  y = 100, z = 600, use = false },
--     { x = 300,  y = 100, z = 600, use = false },
--     { x = 400,  y = 100, z = 600, use = false },
--     { x = 500,  y = 200, z = 600, use = false },
--     { x = -500, y = 200, z = 600, use = false },
--     { x = -400, y = 200, z = 600, use = false },
--     { x = -300, y = 200, z = 600, use = false },
--     { x = -200, y = 200, z = 600, use = false },
--     { x = -100, y = 200, z = 600, use = false },
--     { x = 0,    y = 200, z = 600, use = false },
--     { x = 100,  y = 200, z = 600, use = false },
--     { x = 200,  y = 200, z = 600, use = false },
--     { x = 300,  y = 200, z = 600, use = false },
--     { x = 400,  y = 200, z = 600, use = false },
--     { x = 500,  y = 200, z = 600, use = false },
-- }
local mount_point = {}
SurviveHelper.spawnWeaponPoints(mount_point, 200, 100)
SurviveHelper.spawnWeaponPoints(mount_point, 200, 500)
SurviveHelper.spawnWeaponPoints(mount_point, 300, 100)
SurviveHelper.spawnWeaponPoints(mount_point, 300, 500)
SurviveHelper.spawnWeaponPoints(mount_point, 400, 100)
SurviveHelper.spawnWeaponPoints(mount_point, 400, 500)

function Weapon:ctor(key, target, ability)
    local data = {}
    self._offset = self:getMountPoint()
    data.key = key
    data.target = target:get_point()
    data.time = -1
    data.height = self._offset.z
    self._target = target
    self._pro = y3.projectile.create(data)
    self._key = key
    self._ability = ability
    y3.gameApp:addTimerLoop(1 / y3.GameConst.GAME_FPS, handler(self, self._updateFacing))
    local action = y3.ActionMgr:getAction(self._pro)
    action:floatHeight(80, 120)
    self:updatePos()
end

function Weapon:getKey()
    return self._key
end

function Weapon:_updateFacing(dt)
    if self._facing then
        self._pro:set_facing(GameUtils.lerp(self._pro:get_facing(), Fix32(self._facing), dt * Fix32(10)))
    end
end

function Weapon:getMountPoint()
    for i, v in ipairs(mount_point) do
        if not v.use then
            v.use = true
            return v
        end
    end
    return mount_point[1]
end

function Weapon:updatePos()
    self._pro:set_point(self._target:get_point():move(self._offset.x, self._offset.y, 0))
end

function Weapon:setFacing(tarpos)
    self._facing = self._pro:get_point():get_angle_with(tarpos)
end

return Weapon
