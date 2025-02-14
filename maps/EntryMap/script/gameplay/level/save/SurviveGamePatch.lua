local LogicBase = include("gameplay.level.logic.LogicBase")
local SurviveGamePatch = class("SurviveGamePatch", LogicBase)

local PATCH_LIST = {
    [1] = { patchId = "", playerList = {} }
}

function SurviveGamePatch:ctor(level)
    SurviveGamePatch.super.ctor(self, level)
    self:_initData()
end

function SurviveGamePatch:_initData()
    local gamePatch = y3.userData:loadTable("gamePatch")
    self._gamePatch = gamePatch
end

function SurviveGamePatch:initPatch(playerId)
    if playerId ~= y3.gameApp:getPlayerId() then
        return
    end
    xpcall(function(...)
        local playerData = y3.userData:getPlayerData(playerId)
        local player = playerData:getPlayer()
        local nameUid = player:get_platform_name()
        -----------------------------------全服patch奖励--------------------------------------
        local patchKey = y3.gameApp:encryptString("test")        
        --if not self._gamePatch[patchKey] then
        if not y3.gameApp:isArchiveDataExists(self._gamePatch, patchKey) then
            self._gamePatch[patchKey] = patchKey
            self:_dropPatchAward()
        end

        -----------------------------------特定玩家patch奖励-----------------------------------
        local patchNameList = {}
        for i = 1, #patchNameList do
            if nameUid == patchNameList[i] then
                local patchKey = y3.gameApp:encryptString("test2")
                if not y3.gameApp:isArchiveDataExists(self._gamePatch, patchKey) then
                --if not self._gamePatch[patchKey] then
                    self._gamePatch[patchKey] = patchKey
                    self:_dropPatchAward()
                end
            end
        end
    end, __G__TRACKBACK__)
end

function SurviveGamePatch:_dropPatchAward()

end

return SurviveGamePatch
