local LogicBase = include("gameplay.level.logic.LogicBase")
local SurviveGameSevenDay = class("SurviveGameSevenDay", LogicBase)

function SurviveGameSevenDay:ctor(level)
    SurviveGameSevenDay.super.ctor(self, level)
    self:_initData()
end

function SurviveGameSevenDay:_initData()
    local saveInfo = y3.userData:loadTable("PlayerInfo")
    self._playerInfo = saveInfo
    local game_sign = include("gameplay.config.game_sign")
    local len = game_sign.length()
    self._gameSign = {}
    for i = 1, len do
        local cfg = game_sign.indexOf(i)
        assert(cfg, "")
        if cfg.game_sign_type == 1 then
            self._gameSign[cfg.game_sign_day] = cfg
        end
    end
end

function SurviveGameSevenDay:recordSignDay(playerId)
    if playerId ~= y3.gameApp:getMyPlayerId() then
        return
    end
    xpcall(function()
        local curTime = y3.gameUtils.get_server_time().timestamp
        local year, month, day = y3.gameUtils.getCurrentDate(curTime)
        local lastSignDay = self._playerInfo.lastSignDay or ""
        local curSignDay = year .. "#" .. month .. "#" .. day
        if lastSignDay ~= curSignDay then
            self._playerInfo.lastSignDay = curSignDay
            if not self._playerInfo.grandtotalDay then
                self._playerInfo.grandtotalDay = y3.gameApp:encryptString(1)
            else
                local day = tonumber(y3.gameApp:decryptString(self._playerInfo.grandtotalDay))
                self._playerInfo.grandtotalDay = y3.gameApp:encryptString(day + 1)
            end
        end
    end, __G__TRACKBACK__)
end

function SurviveGameSevenDay:signDay(playerId)
    if playerId ~= y3.gameApp:getMyPlayerId() then
        return
    end
    xpcall(function(...)
        local day = 0
        if self._playerInfo.grandtotalDay then
            day = tonumber(y3.gameApp:decryptString(self._playerInfo.grandtotalDay)) or 0
        end
        if not self._playerInfo.signDays then
            self._playerInfo.signDays = {}
        end
        for i = 1, day do
            if self._gameSign[i] then
                local encIndex = y3.gameApp:encryptString(i .. "")
                --if not self._playerInfo.signDays[encIndex] then
                if not y3.gameApp:isArchiveDataExists(self._playerInfo.signDays, encIndex) then
                    self._playerInfo.signDays[encIndex] = 1
                    local game_sign_reward = self._gameSign[i].game_sign_reward
                    if game_sign_reward ~= "" then
                        game_sign_reward = y3.SurviveConst.DROP_TYPE_SAVE_ITEM .. "#" .. game_sign_reward
                        y3.userDataHelper.dropSaveItem(playerId, game_sign_reward)
                    end
                end
            end
        end
    end, __G__TRACKBACK__)
end

function SurviveGameSevenDay:checkSignDayHasReward(playerId)
    local playerData = y3.userData:getPlayerData(playerId)
    local player = playerData:getPlayer()
    local playerInfo = playerId == y3.gameApp:getMyPlayerId() and self._playerInfo or
        y3.userData:loadTableByPlayer(player, "PlayerInfo")
    local day = 0
    if playerInfo.grandtotalDay then
        day = tonumber(y3.gameApp:decryptString(playerInfo.grandtotalDay)) or 0
    end
    -- print(day)
    for i = 1, day do
        if self._gameSign[i] then
            local encIndex = y3.gameApp:encryptString(i .. "")
            if not playerInfo.signDays then
                return true
            end
            if not y3.gameApp:isArchiveDataExists(playerInfo.signDays, encIndex) then
            --if (not playerInfo.signDays[encIndex]) then
                return true
            end
        end
    end
    return false
end

function SurviveGameSevenDay:checkHasGetDayReward(playerId, day)
    local playerData = y3.userData:getPlayerData(playerId)
    local player = playerData:getPlayer()
    local playerInfo = playerId == y3.gameApp:getMyPlayerId() and self._playerInfo or
        y3.userData:loadTableByPlayer(player, "PlayerInfo")
    if not playerInfo.signDays then
        return false
    end
    local encIndex = y3.gameApp:encryptString(day .. "")
    if y3.gameApp:isArchiveDataExists(playerInfo.signDays, encIndex) then
    --if playerInfo.signDays[encIndex] then
        return true
    end
    return false
end

return SurviveGameSevenDay
