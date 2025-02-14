-- 游戏启动后会自动运行此文件
---comment
---@param message any
function __G__TRACKBACK__(message)
    --
    local traceback = debug.traceback()
    local playerPlatformName = y3.player.LOCAL_PLAYER:get_platform_name()
    playerPlatformName = playerPlatformName or "editor_dev"
    local versionInfo = tostring(GAME_VERSION)
    local errors = "\nERROR: " .. message .. "\n" .. playerPlatformName .. "\n" .. versionInfo .. "\n"
    errors = errors .. ">>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
    errors = errors .. traceback .. "\n"
    errors = errors .. "<<<<<<<<<<<<<<<<<<<<<<<<<<<\n"
    print(errors)
    --
    local modeInfo = y3.game.get_start_mode()
    if modeInfo == 1 then ---game_mode 游戏环境，1是编辑器，2是平台
        return
    end

    if Cache.hasCach(message) then
        return
    end
    Cache.addCach(message)

    uploadError(errors)
end



--在开发模式下，将日志打印到游戏中
-- function pathJoin(...)
--     local args = { ... }
--     local result = args[1]

--     for i = 2, #args do
--         local part = args[i]
--         result = result:match("(.+)[/\\]$") or result
--         result = result .. "/" .. part:gsub("^[/\\]", "")
--     end

--     return result
-- end

-- local currentDir = pathJoin(lua_script_path, "/../../../custom_lua/?.lua")
-- package.path = package.path .. ";" .. currentDir

require("gameplay.utils.bit") --gameplay\utils\bit.lua
require("gameplay.utils.functions")
require("EcaCallLua")
-- require("Permanent")
require("version")
require("debug_config")
require("projectile_pool")
require("core")
require("Cache")
local function main()
    y3.clickMinInterval = 100 -- 毫秒
    y3.lastClickMs = {}       -- GetCurrentTimeInMilliseconds()
    y3.game:event('游戏-初始化', function(trg, data)
        y3.game:event('键盘-按下', y3.const.KeyboardKey['F5'], function(trg, data)
            if y3.game.is_debug_mode() then
                GameAPI.request_switch_level(GameAPI.get_current_level())
            end
        end)
        -- y3.game:event('键盘-按下', y3.const.KeyboardKey['F6'], function(trg, data)
        --     if y3.game.is_debug_mode() then
        --         y3.reload:fire()
        --     end
        -- end)
        -- y3.game:event('键盘-按下', y3.const.KeyboardKey['F7'], function(trg, data)
        --     if y3.game.is_debug_mode() then
        --         package.loaded["HotCode"] = nil
        --         include("HotCode")
        --     end
        -- end)
        -- y3.game:event('键盘-按下', y3.const.KeyboardKey['F8'], function(trg, data)
        --     if y3.game.is_debug_mode() then
        --         y3.reload.reload({
        --             -- 通过列表指定文件
        --             list = {
        --             },
        --             -- 不在上述列表中的文件会尝试调用此函数，如果返回true表示需要重载，否则不重载
        --             filter = function(name, reload)
        --                 if y3.util.stringStartWith(name, 'gameplay.config.') then
        --                     print('reload config file:', name)
        --                     return true
        --                 else
        --                     return false
        --                 end
        --             end,
        --         })
        --     end
        -- end)
        include("GameStart")
    end)
end

local status, msg = xpcall(main, __G__TRACKBACK__)
if not status then
    print(msg)
end
