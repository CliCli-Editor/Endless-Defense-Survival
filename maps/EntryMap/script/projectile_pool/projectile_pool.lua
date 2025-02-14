---@class ProjectilePool
local M = Class 'ProjectilePool'

local __table_insert = table.insert
local __table_remove = table.remove
local __math_min = math.min

local default_point
local default_owner

local client_role = GameAPI.get_client_role()

local function __create_projectile_in_scene(data)
    local py_obj = GameAPI.create_projectile_in_scene_new(
        data.key,
        data.target.handle,
        -- TODO 见问题3
        ---@diagnostic disable-next-line: param-type-mismatch
        data.owner.handle,
        Fix32(data.angle or 0.0),
        data.ability and data.ability or nil,
        Fix32(data.time or 60.0),
        data.time and true or false,
        Fix32(data.height or 0.0),
        data.visible_rule or 1,
        data.remove_immediately or false,
        data.remove_immediately == nil and true or false
    )
    return {
        handle = py_obj,
        id = py_obj:api_get_id()
    }
end

local function __create_timer(interval, callback)
    return GameAPI.run_timer_by_frame(interval, -1, false, {
        on_timer_callback = function ()
            callback()
        end,
        _rt = {
            call_with_frame = function (f)
                f()
            end
        }
    }, {})
end

function M:__init(pool_size, key, update_interval, update_num)
    if not default_point or not default_owner then
        error("init ProjectilePool error, defualt player and point not set")
    end
    self.key = key
    self.data = {
        key = self.key,
        target = default_point,
        owner = default_owner,
        time = -1 --99999秒
    }
    self.update_num = update_num
    self.pool_size = pool_size
    self.allocate_size = 0
    self.projectile_pool = {}
    self.pos_map = {}
    self.defer_num = pool_size
    self:set_interval(update_interval)
end

function M:__del()
    if self.timer then
        GameAPI.cancel_timer(self.timer[0])
        GameAPI.delete_timer(self.timer[0])
        self.timer = nil
    end
end

function M:update_defalut_setting()
    self.data = {
        key = self.key,
        target = default_point,
        owner = default_owner,
        time = -1
    }
end

function M:set_size(new_size)
    self.defer_num = new_size - self.pool_size
    self.pool_size = new_size
    self:set_interval(self.update_interval)
end

function M:get_size()
    return self.pool_size
end

function M:get_defer_size()
    return math.abs(self.defer_num)
end

function M:set_interval(new_interval)
    if new_interval <= 0 then
        self.update_interval = 0
        self:step_all()
    else
        self.update_interval = new_interval
        if self.timer then
            GameAPI.timer_set_interval_frame(self.timer[0], new_interval)
        else
            if self.defer_num ~= 0 then
                self.timer = __create_timer(self.update_interval, function ()
                    self:step()
                end)
            end
        end
    end
end

function M:set_update_num(new_update_num)
    if new_update_num ~= self.update_num then
        self.update_num = new_update_num
    end
end

function M:step()
    if self.defer_num > 0 then
        local num = __math_min(self.defer_num, self.update_num)
        for i = 1, num do
            local projectile = __create_projectile_in_scene(self.data)
            __table_insert(self.projectile_pool, projectile)
            projectile.handle:api_set_projectile_visible(client_role, false)
        end
        self.defer_num = self.defer_num - num
    elseif self.defer_num < 0 then
        local abs_defer_num = -self.defer_num
        local num = __math_min(abs_defer_num, self.update_num)
        for i = 1, num do
            local tail_projectile = __table_remove(self.projectile_pool, -1)
            if self.pos_map[tail_projectile.id] then
                self.allocate_size = self.allocate_size - 1
                self.pos_map[tail_projectile.id] = nil
            else
                tail_projectile:api_delete()
            end
        end
        self.defer_num = self.defer_num + num
    else
        GameAPI.cancel_timer(self.timer[0])
        GameAPI.delete_timer(self.timer[0])
        self.timer = nil
    end
end

function M:step_all()
    if self.timer then
        GameAPI.cancel_timer(self.timer[0])
        GameAPI.delete_timer(self.timer[0])
        self.timer = nil
    end

    if self.defer_num > 0 then
        for i = 1, self.defer_num do
            local projectile = __create_projectile_in_scene(self.data)
            __table_insert(self.projectile_pool, projectile)
            projectile.handle:api_set_projectile_visible(client_role, false)
        end
    elseif self.defer_num < 0 then
        local abs_defer_num = -self.defer_num
        for i = 1, abs_defer_num do
            local tail_projectile = __table_remove(self.projectile_pool, -1)
            if self.pos_map[tail_projectile.id] then
                self.allocate_size = self.allocate_size - 1
                self.pos_map[tail_projectile.id] = nil
            else
                tail_projectile:api_delete()
            end
        end
    end
    self.defer_num = 0
end

function M:allocate()
    local projectile
    if self.allocate_size < #self.projectile_pool then
        projectile = self.projectile_pool[self.allocate_size + 1]
    else
        local new_projectile = __create_projectile_in_scene(self.data)
        __table_insert(self.projectile_pool, new_projectile)
        projectile = new_projectile
    end
    self.allocate_size = self.allocate_size + 1
    self.pos_map[projectile.id] = self.allocate_size
    projectile.handle:api_set_projectile_visible(GameAPI.get_client_role(), true)
    GameAPI.api_particle_return_area(projectile.handle)
    return projectile
end

function M:deallocate(projectile)
    local id = projectile:api_get_id()
    if self.pos_map[id] then
        -- run on client
        projectile:api_set_projectile_visible(client_role, false)
        projectile:api_set_position(default_point.handle, false)
        projectile:api_set_face_angle(Fix32(0))
        projectile:api_raise_height(Fix32(0))
        GameAPI.api_particle_leave_area(projectile)
        -- y3.timer.wait(0.077, function (timer)
            -- run on client
        projectile = self.projectile_pool[self.pos_map[id]]
        local origin_pos = self.pos_map[projectile.id]
        local tail_projectile = self.projectile_pool[self.allocate_size]
        self.projectile_pool[origin_pos] = tail_projectile
        self.pos_map[tail_projectile.id] = origin_pos
        self.projectile_pool[self.allocate_size] = projectile
        self.pos_map[projectile.id] = nil
        self.allocate_size = self.allocate_size - 1
        -- end)
    else
        projectile:remove()
    end
end

function M.init(point, owner)
    default_point = point
    default_owner = owner
end

return M