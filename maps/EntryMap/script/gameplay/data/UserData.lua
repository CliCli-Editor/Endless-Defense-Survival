local BaseData = include("gameplay.base.BaseData")
local GameUtils = include("gameplay.utils.GameUtils")
local UserData = class("UserData", BaseData)

local schema = {}

UserData.schema = schema

local SAVE_SLOT = {
    ["MaxStageId"] = { slot = 1, type = "integer" },
    ["Achievement"] = { slot = 2, type = "table" },
    ["StagePass"] = { slot = 3, type = "table" },
    ["Treasure"] = { slot = 4, type = "table" },
    ["SaveItem"] = { slot = 5, type = "table" },
    ["Weapon"] = { slot = 6, type = "table" },
    ["PlayerInfo"] = { slot = 7, type = "table" },
    ["gamePatch"] = { slot = 8, type = "table" },
    ["BattlePass"] = { slot = 9, type = "table" },
    ["maxPower"] = { slot = 10, type = "integer" },
    ["passValue"] = { slot = 11, type = "integer" },
}

function UserData:ctor()
    self._ecaPlayers = {}
    self._curStageId = 0
    self._maxUnlockStageId = 1000
    self:_initData()
    self:initPlayerData()
end

function UserData:clear()
end

function UserData:setCurStageId(stageId)
    self._curStageId = stageId
end

function UserData:getCurStageId()
    return self._curStageId
end

function UserData:setMaxUnLockStageId(maxUnLockId)
    self._maxUnlockStageId = maxUnLockId
end

function UserData:getMaxUnLockStageId()
    return self._maxUnlockStageId
end

function UserData:_initData()
    self._gameMode = 0
    self._levelId = 0
    self._playerImage = 0
end

function UserData:getGameMode()
    return self._gameMode
end

function UserData:setGameMode(mode)
    self._gameMode = mode
end

function UserData:getGameLevelId()
    return self._levelId
end

function UserData:setGameLevelId(id)
    self._levelId = id
end

function UserData:isGameStart()
    -- print("isGameStart", self._gameMode, self._levelId, self:allInRoomPlayerIsReady())
    return self._gameMode > 0 and self._levelId > 0 and self:allInRoomPlayerIsReady()
end

function UserData:setDragItem(item)
    self._dragItem = item
end

function UserData:getDragItem()
    return self._dragItem
end

function UserData:allInRoomPlayerIsReady()
    for id, playerData in pairs(self._playerDataMap) do
        if playerData:isOnline() then
            if not playerData:isReady() then
                return false
            end
        end
    end
    return true
end

function UserData:initPlayerData()
    self._playerDataMap = {}
    self._playerDataList = {}
    local playerGroup = y3.player_group.get_all_players()
    local players = playerGroup:pick()
    table.sort(players, function(a, b)
        return a:get_id() < b:get_id()
    end)
    for i = 1, #players do
        local player = players[i]
        if player:get_state() ~= y3.const.RoleStatus['NONE'] and player:get_controller() == y3.const.RoleType['USER'] then
            local index = #self._playerDataList + 1
            self._playerDataMap[players[i]:get_id()] = include("gameplay.data.PlayerData").new(players[i], index)
            self._playerDataList[#self._playerDataList + 1] = self._playerDataMap[i]
        end
    end
end

function UserData:getAllInPlayers()
    return self._playerDataList
end

function UserData:getPlayerCount()
    return #self._playerDataList
end

function UserData:getRoomMasterPlayerData()
    for i = 1, #self._playerDataList do
        local playerData = self._playerDataList[i]
        if playerData:isRoomMaster() then
            return playerData
        end
    end
    return self._playerDataList[1]
end

function UserData:getMainActorByUnitId(actorUnitId)
    for i = 1, #self._playerDataList do
        local playerData = self._playerDataList[i]
        local mainActor = playerData:getMainActor()
        if mainActor and mainActor:getUnit():get_id() == actorUnitId then
            return mainActor
        end
    end
end

function UserData:setEcaPlayer(count, player)
    self._ecaPlayers[count] = player
end

function UserData:getPlayerData(playerId)
    return self._playerDataMap[playerId]
end

function UserData:isRoomMaster()
    return self:getPlayerData(y3.gameApp:getMyPlayerId()):isRoomMaster()
end

function UserData:isAutoShifa()
    return self._autoShifa
end

function UserData:isShareItem()
    return self._shareItem
end

function UserData:isAutoShengxing()
    return self._autoShengxing
end

function UserData:toggleAutoShifa()
    self._autoShifa = not self._autoShifa
end

function UserData:toggleShareItem()
    self._shareItem = not self._shareItem
end

function UserData:toggleAutoShengxing()
    self._autoShengxing = not self._autoShengxing
end

-------------------- 存档相关  -----------------------
function UserData:loadSave()
    for key, data in pairs(SAVE_SLOT) do
        local slot = data.slot
        local type = data.type
        if type == "table" then
            local t = self:loadTable(slot)
            local loadFunc = self["_load_" .. key]
            loadFunc(self, t)
        elseif type == "Integer" then
            self["_" .. key] = self:loadEncryptInteger(slot)
        elseif type == "float" then
            self["_" .. key] = self:loadEncryptFloat(slot)
        end
    end
end

function UserData:_load_item(t)
    self._item = {}
    for key, value in pairs(t) do
        self:addItem(value)
    end
end

function UserData:_load_card(t)
    self._card = {}
    for key, value in pairs(t) do
        self:addCard(value)
    end
end

function UserData:_load_hero(t)

end

function UserData:printSaveData()
    -- dump_all(self._item)
    -- dump_all(self._card)
    -- print(self._level:get())
end

function UserData:uploadSave()
    for key, data in pairs(SAVE_SLOT) do
        local slot = data.slot
        local type = data.type
        if self["_" .. key] then
            if type == "table" then
                self:saveTable(slot, clone(self["_" .. key]))
            elseif type == "Integer" then
                self:saveEncryptInteger(slot, self["_" .. key])
            elseif type == "float" then
                self:saveEncryptFloat(slot, self["_" .. key])
            end
        end
    end
end

function UserData:addItem(setData)
    local data = self._item[setData.id]
    if not data then
        data = {}
        data.id = setData.id
        data.num = include("gameplay.utils.EncryptNumber").new(setData.num)
        self._item[setData.id] = data
    else
        data.num:set(data.num:get() + setData.num)
    end
end

function UserData:getItemNum(id)
    return self._item[id].num:get()
end

function UserData:addCard(setCard)
    local data = self._card[setCard.id]
    if not data then
        data = {}
        data.id = setCard.id
        data.level = include("gameplay.utils.EncryptNumber").new(setCard.level)
        self._card[setCard.id] = data
    else
        data.level:set(data.level:get() + setCard.level)
    end
end

function UserData:getCardNum(id)
    return self._card[id].level:get()
end

function UserData:setLevel(level)
    self._level:set(self._level:get() + level)
end

function UserData:getLevel()
    return self._level:get()
end

function UserData:getExp()
    return self._exp:get()
end

function UserData:setExp(exp)
    self._exp:set(self._exp:get() + exp)
end

----------------------------------------------------------

function UserData:getCurRound()
    return self._curRound
end

function UserData:addRound()
    self._curRound = self._curRound + 1
    return self._curRound
end

function UserData:getMaxRound()
    return self._maxRound
end

function UserData:getRoundTime()
    return self._roundTime
end

function UserData:cacheBuildCfg(buildCfg)
    self._buildCfg = buildCfg
end

function UserData:recoverInter()
    return 2
end

function UserData:getDrawCost(level)
    return self._drawCost[level]
end

function UserData:getRandomHeroList(n)
    self._heroList = GameUtils.shuffleArray(self._heroList)
    local result = {}
    for i = 1, n do
        table.insert(result, self._heroList[i])
    end
    return result
end

function UserData:getRecoverSpeed(id)
    local local_player = y3.player(y3.gameApp:getMyPlayerId())
    local speed = local_player:get_attr('qiuxian_speed')
    return speed
end

function UserData:saveEncryptInteger(slot, encryptNumber)
    local svalue = encryptNumber:get()
    y3.save_data.save_integer(y3.player(y3.gameApp:getMyPlayerId()), slot, svalue)
end

function UserData:saveEncryptFloat(slot, encryptNumber)
    local svalue = encryptNumber:get()
    y3.save_data.save_real(y3.player(y3.gameApp:getMyPlayerId()), slot, svalue)
end

function UserData:saveEncryptString(slot, encryptString)
    local svalue = encryptString:get()
    y3.save_data.save_string(y3.player(y3.gameApp:getMyPlayerId()), slot, svalue)
end

function UserData:loadEncryptInteger(slot)
    local value = y3.save_data.load_integer(y3.player(y3.gameApp:getMyPlayerId()), slot)
    local encryptNumber = include("gameplay.utils.EncryptNumber").new(value)
    return encryptNumber
end

function UserData:loadEncryptFloat(slot)
    local value = y3.save_data.load_real(y3.player(y3.gameApp:getMyPlayerId()), slot)
    local encryptNumber = include("gameplay.utils.EncryptNumber").new(value)
    return encryptNumber
end

function UserData:loadEncryptString(slot)
    local value = y3.save_data.load_string(y3.player(y3.gameApp:getMyPlayerId()), slot)
    local encryptNumber = include("gameplay.utils.EncryptString").new(value)
    return encryptNumber
end

local function lookup_tablex(t)
    for key, value in pairs(t) do
        if type(value) == "table" then
            if value.isEncrypt then
                t[key] = value:get()
            else
                lookup_tablex(value)
            end
        end
    end
end

function UserData:getSaveSlot(saveName)
    local slot = SAVE_SLOT[saveName].slot
    return slot
end

function UserData:saveTable(slot, t)
    lookup_tablex(t)
    y3.save_data.save_table(y3.player(y3.gameApp:getMyPlayerId()), slot, t)
end

function UserData:loadTable(name)
    local slot = SAVE_SLOT[name].slot
    local t = y3.save_data.load_table(y3.player(y3.gameApp:getMyPlayerId()), slot, true)
    return t
end

function UserData:loadTableByPlayer(player, name)
    local slot = SAVE_SLOT[name].slot
    local t = y3.save_data.load_table(player, slot, true)
    return t
end

return UserData
