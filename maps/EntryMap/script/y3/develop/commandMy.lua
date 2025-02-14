--作弊指令
--
--该功能仅在开发模式有效
---@class Develop.Command
local M = Class 'Develop.Command'

---@class Develop.Command.ExecuteParam
---@field command string # 输入的命令（和输入一致，不保证大小写状态）
---@field args string[] # 命令参数
---@field player? Player # 调用命令的玩家

---@class Develop.Command.InfoParam
---@field onCommand? fun(...)
---@field onCommandEX? fun(param: Develop.Command.ExecuteParam)
---@field needSync? boolean
---@field priority? number
---@field desc? string

---@class Develop.Command.Info: Develop.Command.InfoParam
---@field name string
---@field priority number


M.player = nil

---@private
---@type table<string, Develop.Command.Info>
M.commands = {}

-- 注册作弊指令（指令名称无视大小写）
---@param command string
---@param info Develop.Command.InfoParam|function
function M.register(command, info)
    local lname = command:lower()
    if type(info) == 'function' then
        info = {
            onCommand = info,
        }
    end
    ---@cast info Develop.Command.Info
    info.name = lname
    info.priority = info.priority or 0
    M.commands[lname] = info
end

---@param reload Reload
local function remove_all_triggers_in_include(reload)
    local event_manager = y3.game:get_event_manager()
    for trigger in event_manager:pairs() do
        local name = trigger:get_include_name()
        if reload:isValidName(name) then
            trigger:remove()
        end
    end
end

---@param reload Reload
local function remove_all_custom_triggers_in_include(reload)
    local event_manager = y3.game:get_custom_event_manager()
    if not event_manager then
        return
    end
    for trigger in event_manager:pairs() do
        local name = trigger:get_include_name()
        if reload:isValidName(name) then
            trigger:remove()
        end
    end
end

---@param reload Reload
local function remove_all_timers_in_include(reload)
    for timer in y3.timer.pairs() do
        local name = timer:get_include_name()
        if reload:isValidName(name) then
            timer:remove()
        end
    end
end

---@param reload Reload
local function remove_all_local_timers_in_include(reload)
    for timer in y3.ltimer.pairs() do
        local name = timer:get_include_name()
        if reload:isValidName(name) then
            timer:remove()
        end
    end
end

---@param reload Reload
local function remove_all_client_timers_in_include(reload)
    for timer in y3.ctimer.pairs() do
        local name = timer:get_include_name()
        if reload:isValidName(name) then
            timer:remove()
        end
    end
end

-------------------------------------------------------------------------------------
M.register('RD', {
    needSync = true,
    priority = 100,
    desc = GameAPI.get_text_config('#-743435501#lua'),
    onCommand = function()
        y3.reload.reload()
    end,
})

M.register('SS', {
    desc = GameAPI.get_text_config('#-882648198#lua'),
    onCommand = function()
        collectgarbage()
        collectgarbage()
        local reports = y3.doctor.report()
        local lines = {}
        for _, report in ipairs(reports) do
            lines[#lines + 1] = string.format('%16s(%d): %s'
            , report.point
            , report.count
            , report.name
            )
        end
        local content = table.concat(lines, '\n')
        ---@diagnostic disable-next-line: undefined-global
        py_write_file(lua_script_path .. '/log/snapshot.txt', 'w', content)
        log.debug('快照已保存到 script/log/snapshot.txt')
    end
})

M.register('CT', {
    desc = GameAPI.get_text_config('#213905066#lua'),
    onCommand = function(...)
        collectgarbage()
        collectgarbage()
        local results = y3.doctor.catch(...)
        local lines = {}
        for _, result in ipairs(results) do
            result[1] = 'root'
            lines[#lines + 1] = table.concat(result, '\n\t')
        end
        local content = table.concat(lines, '\n')
        ---@diagnostic disable-next-line: undefined-global
        py_write_file(lua_script_path .. '/log/catch.txt', 'w', content)
        log.debug('快照已保存到 script/log/catch.txt')
    end
})

M.register('RR', {
    desc = GameAPI.get_text_config('#2115478975#lua'),
    onCommand = function()
        y3.develop.helper.prepareForRestart {
            debugger = y3.develop.wait_debugger,
        }
        y3.game.restart_game(true)
    end
})

M.register('ADG', {
    desc = GameAPI.get_text_config('#266669772#lua'),
    onCommand = function(...)
        local args = { ... }
        local player = M.player
        if not player then
            return
        end
        local gold = player:get_attr("gold")
        local addgold = tonumber(args[1])
        player:set("gold", gold + addgold)
    end
})

M.register('ASK', {
    desc = GameAPI.get_text_config('#1224533677#lua'),
    onCommand = function(...)
        local args   = { ... }
        local player = M.player
        if not player then
            return
        end
        local SurviveHelper = include("gameplay.level.logic.helper.SurviveHelper")
        SurviveHelper.leanSkill({ player:get_id(), tonumber(args[1]) })
    end
})

M.register('ATR', {
    desc = GameAPI.get_text_config('#1817277783#lua'),
    onCommand = function(...)
        local args = { ... }
        local player = M.player
        if not player then
            return
        end
        local attrName = tostring(args[1])
        local attrValue = tonumber(args[2])
        local playerData = y3.userData:getPlayerData(player:get_id())
        local mainActor = playerData:getMainActor()
        if mainActor then
            mainActor:getUnit():add_attr(attrName, attrValue)
        end
    end
})

M.register('RSK', {
    desc = GameAPI.get_text_config('#-1096016991#lua'),
    onCommand = function(...)
        local args = { ... }
        local player = M.player
        if not player then
            return
        end
        local skillId = tonumber(args[1])
        local playerData = y3.userData:getPlayerData(player:get_id())
        local mainActor = playerData:getMainActor()
        if mainActor then
            mainActor:getUnit():remove_ability_by_key(y3.const.AbilityType.COMMON, skillId)
        end
    end
})

M.register('WUDI', {
    desc = GameAPI.get_text_config('#1879005995#lua'),
    onCommand = function(...)
        local args = { ... }
        local player = M.player
        if not player then
            return
        end
        local playerData = y3.userData:getPlayerData(player:get_id())
        local mainActor = playerData:getMainActor()
        if mainActor then
            mainActor:getUnit():add_attr(y3.const.UnitAttr['生命恢复'], 100000)
        end
        local gold = player:get_attr("gold")
        player:set("gold", gold + 100000000)
        player:set("diamond", 1000000)
    end
})

M.register('addItem', {
    desc = GameAPI.get_text_config('#1783564974#lua'),
    onCommand = function(...)
        local args = { ... }
        local player = M.player
        if not player then
            return
        end
        local itemId = tonumber(args[1])
        local itemNum = tonumber(args[2])
        local playerData = y3.userData:getPlayerData(player:get_id())
        local mainActor = playerData:getMainActor()
        if mainActor then
            for i = 1, itemNum do
                local SurviveHelper = include("gameplay.level.logic.helper.SurviveHelper")
                SurviveHelper.dropItem(player:get_id(), itemId)
            end
        end
    end
})

M.register('RALL', {
    desc = GameAPI.get_text_config('#-2072994304#lua'),
    onCommand = function(...)
        local player = M.player
        if not player then
            return
        end
        local playerData = y3.userData:getPlayerData(player:get_id())
        local mainActor = playerData:getMainActor()
        if mainActor then
            local skillList = mainActor:getAbilityKeyList()
            for i = 1, #skillList do
                mainActor:getUnit():remove_ability_by_key(y3.const.AbilityType.COMMON, skillList[i])
            end
        end
    end
})

M.register('addTask', {
    desc = GameAPI.get_text_config('#-1629235885#lua'),
    onCommand = function(...)
        local args = { ... }
        local player = M.player
        if not player then
            return
        end
        local taskId = tonumber(args[1])
        local playerData = y3.userData:getPlayerData(player:get_id())
        local mainActor = playerData:getMainActor()
        if mainActor then
            local taskSystem = y3.gameApp:getLevel():getLogic("SurviveGameTaskSyetem")
            taskSystem:receiveTask(playerData:getId(), taskId)
        end
    end
})

M.register('addTower', {
    desc = GameAPI.get_text_config('#-1882915314#lua'),
    onCommand = function(...)
        local args = { ... }
        local player = M.player
        if not player then
            return
        end
        local taskId = tonumber(args[1])
        local playerData = y3.userData:getPlayerData(player:get_id())
        local mainActor = playerData:getMainActor()
        if mainActor then
            local cfg = include("gameplay.config.stage_tower").get(taskId)
            assert(cfg, "tower config not found: " .. taskId)
            local SurviveHelper = include("gameplay.level.logic.helper.SurviveHelper")
            SurviveHelper.leanSkill({ player:get_id(), cfg.tower_config_skill_id })
        end
    end
})

M.register('addSaveItem', {
    desc = GameAPI.get_text_config('#-690507486#lua'),
    onCommand = function(...)
        local args = { ... }
        local player = M.player
        if not player then
            return
        end
        local itemId = tonumber(args[1])
        local num = tonumber(args[2])
        local playerData = y3.userData:getPlayerData(player:get_id())
        local surviveSaveItem = y3.gameApp:getLevel():getLogic("SurviveGameSaveItem")
        surviveSaveItem:dropSaveItem(playerData:getId(), itemId, num)
    end
})

M.register('addTreasure', {
    desc = GameAPI.get_text_config('#-1664402270#lua'),
    onCommand = function(...)
        local args = { ... }
        local player = M.player
        if not player then
            return
        end
        local itemId = tonumber(args[1])
        local playerData = y3.userData:getPlayerData(player:get_id())
        local surviveTreasure = y3.gameApp:getLevel():getLogic("SurviveGameTreasure")
        surviveTreasure:dropTreasure(playerData:getId(), itemId)
    end
})

M.register('fastWin', {
    desc = GameAPI.get_text_config('#-1836509485#lua'),
    onCommand = function(...)
        local args = { ... }
        local player = M.player
        if not player then
            return
        end
        local spawnEnemy = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy")
        spawnEnemy:setWin(true)

        y3.Sugar.stagePass(player:get_id(), y3.userData:getCurStageId())

        y3.Sugar.achievement():updateAchievement(player:get_id(),
            y3.SurviveConst.ACHIEVEMENT_REFRESH_TYPE_PASS)

        y3.Sugar.achievement():updateAchievement(player:get_id(),
            y3.SurviveConst.ACHIEVEMENT_REFRESH_TYPE_PLAYED)

        local treasureDrop = y3.gameApp:getLevel():getLogic("SurviveGameTreasureDrop")
        treasureDrop:updateStagePass(player:get_id(), y3.userData:getCurStageId(), true, 2)

        y3.ltimer.wait(1.5, function(timer, count)
            y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SURVEVE_RESULT_WIN, player:get_id())
            y3.game.end_player_game(player, y3.GameConst.VICTORY, true)
        end)
    end
})

M.register('fastWin2', {
    desc = GameAPI.get_text_config('#-1225516226#lua'),
    onCommand = function(...)
        local args = { ... }
        local player = M.player
        if not player then
            return
        end
        local spawnEnemy = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy")
        spawnEnemy:setWin(true)

        y3.Sugar.stagePass(player:get_id(), y3.userData:getCurStageId())

        y3.Sugar.achievement():updateAchievement(player:get_id(),
            y3.SurviveConst.ACHIEVEMENT_REFRESH_TYPE_PASS)

        y3.Sugar.achievement():updateAchievement(player:get_id(),
            y3.SurviveConst.ACHIEVEMENT_REFRESH_TYPE_PLAYED)

        local treasureDrop = y3.gameApp:getLevel():getLogic("SurviveGameTreasureDrop")
        treasureDrop:updateStagePass(player:get_id(), y3.userData:getCurStageId(), true, 3)

        y3.ltimer.wait(1.5, function(timer, count)
            y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SURVEVE_RESULT_WIN, player:get_id())
            y3.game.end_player_game(player, y3.GameConst.VICTORY, true)
        end)
    end
})

M.register('fastWin3', {
    desc = GameAPI.get_text_config('#2101813810#lua'),
    onCommand = function(...)
        local args = { ... }
        local player = M.player
        if not player then
            return
        end
        local spawnEnemy = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy")
        spawnEnemy:setWin(true)

        y3.Sugar.stagePass(player:get_id(), y3.userData:getCurStageId())

        y3.Sugar.achievement():updateAchievement(player:get_id(),
            y3.SurviveConst.ACHIEVEMENT_REFRESH_TYPE_PASS)

        y3.Sugar.achievement():updateAchievement(player:get_id(),
            y3.SurviveConst.ACHIEVEMENT_REFRESH_TYPE_PLAYED)

        local treasureDrop = y3.gameApp:getLevel():getLogic("SurviveGameTreasureDrop")
        treasureDrop:updateStagePass(player:get_id(), y3.userData:getCurStageId(), true, 4)

        y3.ltimer.wait(1.5, function(timer, count)
            y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SURVEVE_RESULT_WIN, player:get_id())
            y3.game.end_player_game(player, y3.GameConst.VICTORY, true)
        end)
    end
})

M.register('fastWin4', {
    desc = GameAPI.get_text_config('#-526852698#lua'),
    onCommand = function(...)
        local args = { ... }
        local player = M.player
        if not player then
            return
        end
        local spawnEnemy = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy")
        spawnEnemy:setWin(true)

        y3.Sugar.stagePass(player:get_id(), y3.userData:getCurStageId())

        y3.Sugar.achievement():updateAchievement(player:get_id(),
            y3.SurviveConst.ACHIEVEMENT_REFRESH_TYPE_PASS)

        y3.Sugar.achievement():updateAchievement(player:get_id(),
            y3.SurviveConst.ACHIEVEMENT_REFRESH_TYPE_PLAYED)

        local treasureDrop = y3.gameApp:getLevel():getLogic("SurviveGameTreasureDrop")
        treasureDrop:updateStagePass(player:get_id(), y3.userData:getCurStageId(), true, 5)

        y3.ltimer.wait(1.5, function(timer, count)
            y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SURVEVE_RESULT_WIN, player:get_id())
            y3.game.end_player_game(player, y3.GameConst.VICTORY, true)
        end)
    end
})

M.register('printAttr', {
    desc = GameAPI.get_text_config('#-572026137#lua'),
    onCommand = function(...)
        local args = { ... }
        local player = M.player
        if not player then
            return
        end
        local playerData = y3.userData:getPlayerData(player:get_id())
        local mainActor = playerData:getMainActor()
        if mainActor then
            local unit = mainActor:getUnit()
            local attr = include("gameplay.config.attr")
            local len = attr.length()
            print("----------------------------------------")
            print("玩家总属性:")
            for i = 1, len do
                local cfg = attr.indexOf(i)
                assert(cfg, "")
                if cfg.y3_name ~= "" then
                    local attrValue = unit:get_attr(y3.const.UnitAttr[cfg.y3_name])
                    print("" .. cfg.attr_name .. ":", attrValue)
                end
            end
        end
    end
})

M.register("printTreaAttr", {
    desc = GameAPI.get_text_config('#-1410617611#lua'),
    onCommand = function(...)
        local args = { ... }
        local player = M.player
        if not player then
            return
        end
        local treasureLogic = y3.gameApp:getLevel():getLogic("SurviveGameTreasure")
        treasureLogic:printRecordPacks()
    end
})

M.register("addGuaiwu", {
    desc = GameAPI.get_text_config('#-590270524#lua'),
    onCommand = function(...)
        local args = { ... }
        local player = M.player
        if not player then
            return
        end
        local monsterId = tonumber(args[1])
        local monsterCfg = include("gameplay.config.monster").get(monsterId)
        local playerData = y3.userData:getPlayerData(player:get_id())
        local mainActor = playerData:getMainActor()
        if not mainActor then
            return
        end
        local point = mainActor:getPosition()
        local spawnPoint = point:move(400, 500, 0)
        local points = { spawnPoint }
        -- _spawnSingleEnemy(monsterCfg, points, playerData, stageCfg, isBoss)
        local stageCfg = include("gameplay.config.stage_wave").get(1)
        local spawnEnemy = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy")
        spawnEnemy:_spawnSingleEnemy(monsterCfg, points, playerData, stageCfg, true)
    end
})

M.register("e", {
    desc = GameAPI.get_text_config('#-2039272081#lua'),
    onCommand = function(...)
        local args = { ... }
        local str = args[1]
        print(str)
        local destr = y3.userDataHelper.getSaveDataDecryptConcat(str)
        dump_all(destr)
    end
})

M.register("addBpExp", {
    desc = GameAPI.get_text_config('#1612866194#lua'),
    onCommand = function(...)
        local args = { ... }
        local seasonIndex = args[1] and tonumber(args[1]) or 1
        local exp = args[2] and tonumber(args[2]) or 5
        local playerId = y3.gameApp:getMyPlayerId()
        local paramDic = {
            playerId = playerId,
            seasonIndex = seasonIndex,
            exp = exp,
        }
        y3.SyncMgr:sync(y3.SyncConst.SYNC_ADD_BP_EXP, paramDic)
    end
})

M.register("advancedBp", {
    desc = GameAPI.get_text_config('#-1380243217#lua'),
    onCommand = function(...)
        GM_IsUnlockAdvanceReward = true
        local playerId = y3.gameApp:getMyPlayerId()
        y3.gameApp:dispatchEvent(y3.EventConst.EVENT_BP_DB_Changed, playerId)
    end
})

M.register("ultimateBp", {
    desc = GameAPI.get_text_config('#1738455772#lua'),
    onCommand = function(...)
        GM_IsUnlockUltimateReward = true
        local playerId = y3.gameApp:getMyPlayerId()
        y3.gameApp:dispatchEvent(y3.EventConst.EVENT_BP_DB_Changed, playerId)
    end
})

M.register("speed", {
    desc = GameAPI.get_text_config('#789816892#lua'),
    onCommand = function(...)
        local args = { ... }
        local str = tonumber(args[1])
        local spawnEnemy = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy")
        spawnEnemy:setSpawnDeltaSpeed(str)
    end
})

M.register("addDay", {
    desc = GameAPI.get_text_config('#-304133501#lua'),
    onCommand = function(...)
        local spawnEnemy = y3.gameApp:getLevel():getLogic("SurviveGameCourse")
        spawnEnemy:addServerTime(24 * 3600)
    end
})

-- M.register("achievement")

-- M.register("ea", {
--     desc = GameAPI.get_text_config('#-2039272081#lua'),
--     onCommand = function(...)
--         local args = { ... }
--         local str = args[1]
--         print(str)
--         local destr = "" -- y3.gameApp:decryptString(str)
--         destr = io.readfile("E:/works/dm35/game/master/archive/archive_storage.json")
--         local jsonData = y3.json.decode(destr)
--         for k, saveData in pairs(jsonData) do
--             local archive = saveData.archive
--             for ka, v in pairs(archive) do
--                 local dataValue = v.data_value
--                 print("----------------------")
--                 print(type(dataValue))
--                 print(dataValue)
--             end
--         end
--     end
-- })

---------------------------------------------------------------------
y3.reload.onBeforeReload(function(reload, willReload)
    remove_all_triggers_in_include(reload)
    remove_all_custom_triggers_in_include(reload)
    remove_all_timers_in_include(reload)
    remove_all_local_timers_in_include(reload)
    remove_all_client_timers_in_include(reload)
end)

y3.game:event('玩家-发送消息', function(trg, data)
    M.input('.', data.str1, data.player)
end)

-- 输入作弊指令
---@param prefix string
---@param input string
---@param player? Player
function M.input(prefix, input, player)
    if input == "random" then
        local value = math.random(1, 10000)
        PrintGame(value)
    end
    if input == "get_uuid" then
        if player then
            local uuid = player:get_platform_uuid()
            PrintGame(uuid)
        end
    end
    if not y3.game.is_debug_mode() then
        return
    end
    if not y3.util.stringStartWith(input, prefix) then
        return
    end

    local content = input:sub(1 + #prefix)
    local strs = {}
    for str in content:gmatch('[^%s]+') do
        strs[#strs + 1] = str
    end

    if #strs == 0 then
        return
    end

    local command = table.remove(strs, 1):lower()
    local info = M.commands[command]
    if not info then
        return
    end
    M.player = player
    M.executeEX {
        command = command,
        args = strs,
        player = player,
        info = info,
    }
end

-- 执行作弊指令
---@param command string
---@param ... any
function M.execute(command, ...)
    M.executeEX {
        command = command,
        args = { ... },
    }
end

-- 执行作弊指令
---@param param Develop.Command.ExecuteParam
function M.executeEX(param)
    local command = param.command:lower()
    local info = M.commands[command]
    assert(info, '作弊指令不存在: ' .. param.command)
    M.params = param
    if info.onCommand then
        info.onCommand(table.unpack(param.args))
    end
    if info.onCommandEX then
        info.onCommandEX(param)
    end
end

---@param command string
---@return Develop.Command.Info?
function M.getCommandInfo(command)
    local lname = command:lower()
    return M.commands[lname]
end

---@return string[]
function M.getAllCommands()
    return y3.util.getTableKeys(M.commands, function(a, b)
        return M.getCommandInfo(a).priority > M.getCommandInfo(b).priority
    end)
end

---@return Develop.Command.ExecuteParam
function M.getParams()
    return M.params
end

return M
