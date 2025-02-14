local LogicBase = include("gameplay.level.logic.LogicBase")
local SurviveGameSaveItem = class("SurviveGameSaveItem", LogicBase)
local GameUtils = include("gameplay.utils.GameUtils")

function SurviveGameSaveItem:ctor(level)
    SurviveGameSaveItem.super.ctor(self, level)
    self:_initData()
end

-- 2,3,5,7,11,13,17,19,23,29,31,37,41,43,47,53,59,61,67,71,73, 79,83,89,97
function SurviveGameSaveItem:getKey()
    return 11 * 17 * 23 * 31 * 43
end

function SurviveGameSaveItem:_initData()
    local saveItem = y3.userData:loadTable("SaveItem")
    self._saveItem = saveItem
    if not self._saveItem[980809] then
        self._saveItem[980809] = {}
        self._saveItem[980809].id = self:getKey()
    else
        local saveData = self._saveItem[980809]
        if saveData then
            local isIn = GameUtils.isInteger(saveData.id / 23)
            if not isIn then
                local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
                playerData:setIsCheating(true)
            end
        end
    end
end

function SurviveGameSaveItem:dropSaveItem(playerId, itemId, num)
    if playerId ~= y3.gameApp:getMyPlayerId() then
        return
    end
    xpcall(function(...)
        local cfg = include("gameplay.config.save_item").get(itemId)
        assert(cfg, "")
        if cfg.item_type == 3 then
            for i = 1, num do
                local item_args = string.split(cfg.item_args, "|")
                if item_args then
                    for i = 1, #item_args do
                        y3.userDataHelper.dropSaveItem(playerId, item_args[i])
                    end
                end
            end
            return
        end
        if num > 0 then
            y3.Sugar.recordPlayerDrop(playerId,
                { type = y3.SurviveConst.DROP_TYPE_SAVE_ITEM, value = itemId, size = num })
        end
        if not self._saveItem[itemId] then
            self._saveItem[itemId] = y3.userDataHelper.getSaveDataEncryptConcat(itemId, math.max(0, num))
        else
            local saveData = self._saveItem[itemId]
            local params = y3.userDataHelper.getSaveDataDecryptConcat(saveData)
            local curnum = tonumber(params[2]) or 0
            print(curnum)
            curnum = math.max(0, curnum + num)
            self._saveItem[itemId] = y3.userDataHelper.getSaveDataEncryptConcat(itemId, curnum)
            print(curnum)
        end
    end, __G__TRACKBACK__)
end

function SurviveGameSaveItem:getSaveItemNum(playerId, itemId)
    local playerData = y3.userData:getPlayerData(playerId)
    local player = playerData:getPlayer()
    local saveItem = y3.userData:loadTableByPlayer(player, "SaveItem")
    local itemData = saveItem[itemId] or ""
    local params = y3.userDataHelper.getSaveDataDecryptConcat(itemData)
    local num = tonumber(params[2]) or 0
    return num
end

return SurviveGameSaveItem
