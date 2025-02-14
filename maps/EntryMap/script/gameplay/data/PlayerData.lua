local BaseData = include("gameplay.base.BaseData")
local PlayerData = class("PlayerData", BaseData)

local schema = {}
schema["recoverSpeed"] = { "number", 5 }
schema["qiuxianling"] = { "number", 100 }
schema["liangcao"] = { "number", 0 }
schema["max_liangcao"] = { "number", 2000 }
schema["zhangong"] = { "number", 200 }
schema["yinliang"] = { "number", 2000 }
schema["qiuxian_lv"] = { "number", 0 }
schema["liangcao_lv"] = { "number", 0 }

--------------------------
schema["wave_refresh_count"] = { "number", 0 }
schema["round_count"] = { "number", 1 }
schema["isFailed"] = { "boolean", false }
schema["pauseCount"] = { "number", 3 }
schema["skinTower"] = { "number", 1 }
schema["isCheating"] = { "boolean", false }
schema["endFlag"] = { "boolean", false }
schema["soulHeroId"] = { "number", 1 }
schema["preTitleId"] = { "number", 0 }
schema["connectTitleId"] = { "number", 0 }
schema["suffixTtileId"] = { "number", 0 }
schema["towerSkinId"] = { "number", 0 }

PlayerData.schema = schema

function PlayerData:ctor(player, index)
    PlayerData.super.ctor(self)
    self._index = index
    self._player = player
    self._playerImage = 0
    self._isReady = false
    self._monsterKillMap = {}
    self._monsterIdKillMap ={}
    self._recordDrop = {}
    self._weaponEffectMap = {}
end

function PlayerData:getPlayerName()
    return self._player:get_name()
end

function PlayerData:setPlayerImage(image)
    self._playerImage = image
end

function PlayerData:getPlayerImage()
    return self._playerImage
end

function PlayerData:setReady(ready)
    self._isReady = ready
end

function PlayerData:isReady()
    return self._isReady
end

function PlayerData:isRoomMaster()
    return self._index == 1
end

function PlayerData:isOnline()
    return self._player:get_state() == 1
end

function PlayerData:setMainActor(actor)
    self._mainActor = actor
end

function PlayerData:getMainActor()
    return self._mainActor
end

--- comment
--- @return Player
function PlayerData:getPlayer()
    return self._player
end

function PlayerData:getId()
    return self._player:get_id()
end

function PlayerData:setRandomPools(skills, stageIndex)
    self._randomPools = skills
    self._randomPoolsStageIndex = stageIndex
    self._randomPoolStateMap = {}
    for i, _ in ipairs(self._randomPools) do
        self._randomPoolStateMap[i] = 0
    end
end

function PlayerData:getRandomPools()
    return self._randomPools or {}
end

function PlayerData:getRandomPoolData(slot)
    if self._randomPools then
        return self._randomPools[slot]
    end
end

function PlayerData:getRandomPoolState(i)
    return self._randomPoolStateMap[i] or 0
end

function PlayerData:setRandomPoolState(i, state)
    self._randomPoolStateMap[i] = state
end

function PlayerData:getRandomPoolStageIndex()
    return self._randomPoolsStageIndex or 0
end

function PlayerData:addKillNum(monsterType, count)
    if not self._monsterKillMap[monsterType] then
        self._monsterKillMap[monsterType] = 0
    end
    self._monsterKillMap[monsterType] = self._monsterKillMap[monsterType] + count
end

function PlayerData:getKillNum(monsterType)
    return self._monsterKillMap[monsterType] or 0
end

function PlayerData:addKillNumId(monsterId, count)
    if not self._monsterIdKillMap[monsterId] then
        self._monsterIdKillMap[monsterId] = 0
    end
    self._monsterIdKillMap[monsterId] = self._monsterIdKillMap[monsterId] + count
end

function PlayerData:getKillNumId(monsterId)
    return self._monsterIdKillMap[monsterId] or 0
end


function PlayerData:getAllKillNum()
    local allNum = 0
    for _, count in pairs(self._monsterKillMap) do
        allNum = allNum + count
    end
    return allNum
end

function PlayerData:addRecordDrop(data)
    table.insert(self._recordDrop, data)
end

function PlayerData:getRecordDrop()
    return self._recordDrop
end

function PlayerData:getWeaponEffectMap()
    return self._weaponEffectMap
end

function PlayerData:getWeaponEffectValue(weaponId, effectId)
    local weanpon = self._weaponEffectMap[weaponId]
    if not weanpon then
        return 0
    end
    return weanpon[effectId] or 0
end

function PlayerData:getTitleText()
    local preTitleId = self:getPreTitleId()
    local cfg1 = include("gameplay.config.title").get(preTitleId)
    if not cfg1 then
        return ""
    end
    local connectTitleId = self:getConnectTitleId()
    local cfg2 = include("gameplay.config.title").get(connectTitleId)
    if not cfg2 then
        return ""
    end
    local suffixTtileId = self:getSuffixTtileId()
    local cfg3 = include("gameplay.config.title").get(suffixTtileId)
    if not cfg3 then
        return ""
    end
    return "<" .. cfg1.name .. cfg2.name .. cfg3.name .. ">"
end

function PlayerData:isEquipTitle(titleId)
    local preTitleId = self:getPreTitleId()
    local connectTitleId = self:getConnectTitleId()
    local suffixTtileId = self:getSuffixTtileId()
    return preTitleId == titleId or connectTitleId == titleId or suffixTtileId == titleId
end

return PlayerData
