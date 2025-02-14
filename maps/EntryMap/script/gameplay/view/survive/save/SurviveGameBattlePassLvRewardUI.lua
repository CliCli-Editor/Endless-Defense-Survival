local UIBase = include("gameplay.base.UIBase")
local SurviveGameBattlePassLvRewardUI = class("SurviveGameBattlePassLvRewardUI", UIBase)
local UserDataHelper = include "gameplay.level.logic.helper.UserDataHelper"

function SurviveGameBattlePassLvRewardUI:ctor(parent, root)
    
    if root then
        self._ui = root
    else
        SurviveGameBattlePassLvRewardUI.super.ctor(self, parent, y3.SurviveConst.PREFAB_MAP["bp_reward_info"])
    end

    self._title_TEXT = self._ui:get_child("title._bp_level_TEXT")

    self._freeItemBg = self._ui:get_child("free.item.bg")
    self._freeItemIcon = self._ui:get_child("free.item._icon_IMG")
    self._freeItemLock = self._ui:get_child("free.item.lock")
    self._freeItemReceived = self._ui:get_child("free.item.unlock")
    self._freeItemName = self._ui:get_child("free.reward_line_1_TEXT")
    self._freeItemCount = self._ui:get_child("free.reward_line_2_TEXT")
    self._freeItemMask = self._ui:get_child("free.mask")

    self._advancedItemBg = self._ui:get_child("advanced.item.bg")
    self._advancedItemIcon = self._ui:get_child("advanced.item._icon_IMG")
    self._advancedItemLock = self._ui:get_child("advanced.item.lock")
    self._advancedItemReceived = self._ui:get_child("advanced.item.unlock")
    self._advancedItemName = self._ui:get_child("advanced.reward_line_1_TEXT")
    self._advancedItemCount = self._ui:get_child("advanced.reward_line_2_TEXT")
    self._advancedItemMask = self._ui:get_child("advanced.mask")

    self._ultimateItemBg = self._ui:get_child("ultimate.item.bg")
    self._ultimateItemIcon = self._ui:get_child("ultimate.item._icon_IMG")
    self._ultimateItemLock = self._ui:get_child("ultimate.item.lock")
    self._ultimateItemReceived = self._ui:get_child("ultimate.item.unlock")
    self._ultimateItemName = self._ui:get_child("ultimate.reward_line_1_TEXT")
    self._ultimateItemCount = self._ui:get_child("ultimate.reward_line_2_TEXT")
    self._ultimateItemMask = self._ui:get_child("ultimate.mask")
    
    self._freeItemBg:add_local_event("左键-点击", handler(self, self._onFreeRewardClick))
    self._advancedItemBg:add_local_event("左键-点击", handler(self, self._onAdvancedRewardClick))
    self._ultimateItemBg:add_local_event("左键-点击", handler(self, self._onUltimateRewardClick))
end

function SurviveGameBattlePassLvRewardUI:updateUI(cfg, index, curLv, receiveStatus, isUnlockAdvanceReward, isUnlockUltimateReward)

    local levelInfo = y3.Lang.getLang(y3.langCfg.get(27).str_content, {level = index})
    self._title_TEXT:set_text(levelInfo)

    if not receiveStatus or getTableLength(receiveStatus) == 0 then
        return
    end
    
    self._cfg = cfg
    self._cfgLv = index
    self._curLv = curLv
    self._receiveStatus = receiveStatus

    local basttlePassData = y3.gameApp:getLevel():getLogic("SurviveGameBattlePass")

    local freeRewardParams = string.split(self._cfg.game_battlepass_basic_reward, "#")
    local freeRewardUI = {
        bg = self._freeItemBg, 
        icon =self._freeItemIcon,
        lockTips = self._freeItemLock,
        receiveTips = self._freeItemReceived,
        name = self._freeItemName,
        count = self._freeItemCount,
        mask = self._freeItemMask,
    }
    local isReceivedFreeReward = receiveStatus[basttlePassData.SeasonDataIndex.FreeReward] and 
                                receiveStatus[basttlePassData.SeasonDataIndex.FreeReward] == basttlePassData.RewardReceiveStatus.Received
    self:updateRewardInfo(freeRewardUI, freeRewardParams, index, curLv, isReceivedFreeReward, false)

    local advancedRewardParams = string.split(self._cfg.game_battlepass_privilege_reward, "#")
    local advancedRewardUI = {
        bg = self._advancedItemBg, 
        icon =self._advancedItemIcon,
        lockTips = self._advancedItemLock,
        receiveTips = self._advancedItemReceived,
        name = self._advancedItemName,
        count = self._advancedItemCount,
        mask = self._advancedItemMask,
    }
    local isReceivedAdvancedReward = receiveStatus[basttlePassData.SeasonDataIndex.AdvancedReward] and 
                                    receiveStatus[basttlePassData.SeasonDataIndex.AdvancedReward] == basttlePassData.RewardReceiveStatus.Received
    self:updateRewardInfo(advancedRewardUI, advancedRewardParams, index, curLv, isReceivedAdvancedReward, not isUnlockAdvanceReward)

    local ultimateRewardParams = string.split(self._cfg.game_battlepass_gold_reward, "#")
    local ultimateRewardUI = {
        bg = self._ultimateItemBg, 
        icon =self._ultimateItemIcon,
        lockTips = self._ultimateItemLock,
        receiveTips = self._ultimateItemReceived,
        name = self._ultimateItemName,
        count = self._ultimateItemCount,
        mask = self._ultimateItemMask,
    }
    local isReceivedUltimateReward = receiveStatus[basttlePassData.SeasonDataIndex.UltimateReward] and 
                                    receiveStatus[basttlePassData.SeasonDataIndex.UltimateReward] == basttlePassData.RewardReceiveStatus.Received
    self:updateRewardInfo(ultimateRewardUI, ultimateRewardParams, index, curLv, isReceivedUltimateReward, not isUnlockUltimateReward)
end

function SurviveGameBattlePassLvRewardUI:updateRewardInfo(uiTable, rewardParams, index, curLv, isReceived, islock)

    if not rewardParams or #rewardParams ~= 3 then
        log.error("invalid reward params")
        return
    end

    self._lv = index
    local rewardType = tonumber(rewardParams[1])
    local rewardId = rewardParams[2]
    local rewardOtherParam = tonumber(rewardParams[3])

    local quality = 2 -- default quality
    local countInfo = 0
    if rewardType == y3.SurviveConst.DROP_TYPE_SAVE_ITEM then
        local itemCfg = include("gameplay.config.save_item").get(tonumber(rewardId))
        if not itemCfg then
            log.error("invalid item cfg", rewardId, rewardParams)
            return
        end

        uiTable.name:set_text(itemCfg.item_name)
        uiTable.icon:set_image(tonumber(itemCfg.item_icon))

        quality = tonumber(itemCfg.item_quality)
        countInfo = rewardOtherParam > 0 and "x" .. rewardOtherParam or ""
        uiTable.count:set_text(countInfo)

        uiTable.icon:add_local_event("鼠标-移入", function()
            y3.Sugar.tipRoot():showUniversalTip({ title = itemCfg.item_name, desc = itemCfg.item_desc })
        end)
        uiTable.icon:add_local_event("鼠标-移出", function()
            y3.Sugar.tipRoot():hideUniversalTip()
        end)
    elseif rewardType == y3.SurviveConst.DROP_TYPE_TREASURE then
        local treasureCfg = include("gameplay.config.treasure").get(tonumber(rewardId))
        if not treasureCfg then
            log.error("not found treasure cfg by id=", rewardId)
            return
        end
        
        uiTable.name:set_text(treasureCfg.name)
        uiTable.count:set_text("x" .. rewardOtherParam)
        uiTable.icon:set_image(tonumber(treasureCfg.icon))
        quality = tonumber(treasureCfg.quality)
        uiTable.icon:add_local_event("鼠标-移入", function()
            y3.Sugar.tipRoot():showUniversalTip({ title = treasureCfg.name, desc = treasureCfg.unlock_desc })
        end)
        uiTable.icon:add_local_event("鼠标-移出", function()
            y3.Sugar.tipRoot():hideUniversalTip()
        end)
    elseif rewardType == y3.SurviveConst.DROP_TYPE_TITLE then
        local titleCfg = include("gameplay.config.title").get(tonumber(rewardId))
        if not titleCfg then
            log.error("not found title cfg by id=", rewardId)
            return
        end
        uiTable.name:set_text(titleCfg.name)
        uiTable.count:set_text("x" .. rewardOtherParam)
        uiTable.icon:set_image(titleCfg.title_icon)
        quality = tonumber(titleCfg.quality)
        uiTable.icon:add_local_event("鼠标-移入", function() end)
        uiTable.icon:add_local_event("鼠标-移出", function() end)
    elseif rewardType == y3.SurviveConst.DROP_TYPE_STAGE_TOWER then
        local stCfg = include("gameplay.config.stage_tower").get(tonumber(rewardId))
        if not stCfg then
            log.error("not found stage tower cfg by id=", rewardId)
            return
        end
        
        uiTable.name:set_text(stCfg.tower_name)
        uiTable.count:set_text("x" .. rewardOtherParam)
        uiTable.icon:set_image(tonumber(stCfg.tower_icon))
        quality = tonumber(stCfg.tower_quality)
        uiTable.icon:add_local_event("鼠标-移入", function()
            y3.Sugar.tipRoot():showUniversalTip({ title = stCfg.tower_name, desc = stCfg.tower_desc })
        end)
        uiTable.icon:add_local_event("鼠标-移出", function()
            y3.Sugar.tipRoot():hideUniversalTip()
        end)
    elseif rewardType == y3.SurviveConst.DROP_TYPE_HERO_SKIN then
        local cfg = include("gameplay.config.hero").get(tonumber(rewardId))
        if not cfg then
            log.error("not found cfg hero by id=", rewardId)
            return
        end
        
        uiTable.name:set_text(cfg.name)
        uiTable.count:set_text("x" .. rewardOtherParam)
        uiTable.icon:set_image(tonumber(cfg.hero_icon))
        quality = tonumber(cfg.quality)
        uiTable.icon:add_local_event("鼠标-移入", function()
            y3.Sugar.tipRoot():showUniversalTip({ title = cfg.name, desc = cfg.hero_desc })
        end)
        uiTable.icon:add_local_event("鼠标-移出", function()
            y3.Sugar.tipRoot():hideUniversalTip()
        end)
    elseif rewardType == y3.SurviveConst.DROP_TYPE_ATTR_PACK then
        local attrPackCfg = include("gameplay.config.attr_pack").get(rewardId)
        if not attrPackCfg then
            log.warn("invalid attrPack cfg", tostring(rewardId))
            return
        end

        local attrParams = string.split(attrPackCfg.attr, "#")
        assert(attrParams and #attrParams >= 2, "invalid attr params")

        uiTable.icon:set_image(rewardOtherParam)

        local attrCfg = include("gameplay.config.attr").get(tonumber(attrParams[1]))
        assert(attrCfg, "invalid attr cfg")
        local attrName = attrCfg.attr_name or ""
        uiTable.name:set_text(attrName)

        countInfo = attrParams[2] and tonumber(attrParams[2]) or 0
        local suffix = attrCfg.show_type == 1 and "" or "%"
        countInfo = countInfo > 0 and "+" .. countInfo .. suffix or ""
        uiTable.count:set_text(countInfo)

        uiTable.icon:add_local_event("鼠标-移入", function() end)
        uiTable.icon:add_local_event("鼠标-移出", function() end)
    elseif rewardType == y3.SurviveConst.DROP_TYPE_TOWER_SKIN then
        local towerSkinCfg = include("gameplay.config.stage_tower_skin").get(tonumber(rewardId))
        if not towerSkinCfg then
            log.warn("invalid towerSkin cfg", tostring(rewardId))
            return
        end
        uiTable.name:set_text(towerSkinCfg.tower_skin_name)
        uiTable.count:set_text("x" .. rewardOtherParam)
        uiTable.icon:set_image(towerSkinCfg.tower_skin_icon)
        quality = tonumber(towerSkinCfg.tower_skin_quality)
        uiTable.icon:add_local_event("鼠标-移入", function()
            y3.Sugar.tipRoot():showUniversalTip({ title = towerSkinCfg.tower_skin_name, desc = towerSkinCfg.tower_desc })
        end)
        uiTable.icon:add_local_event("鼠标-移出", function()
            y3.Sugar.tipRoot():hideUniversalTip()
        end)
    end

    uiTable.bg:set_image(y3.SurviveConst.ITEM_CLASS_MAP[quality])
    uiTable.lockTips:set_visible(islock)

    if uiTable.mask then
        uiTable.mask:set_visible(curLv < index)
    end
    uiTable.receiveTips:set_visible(isReceived)
end

function SurviveGameBattlePassLvRewardUI:updateUI_Final(cfg, index, curLv, receiveStatus, isUnlockAdvanceReward, isUnlockUltimateReward)

    local levelInfo = y3.Lang.getLang(y3.langCfg.get(27).str_content, {level = index})
    local titleContent = y3.Lang.getLang(y3.langCfg.get(33).str_content, {level = levelInfo})
    self._title_TEXT:set_text(titleContent)

    if not receiveStatus or getTableLength(receiveStatus) == 0 then
        return
    end

    self._cfg = cfg
    self._cfgLv = index
    self._curLv = curLv
    self._receiveStatus = receiveStatus

    local basttlePassData = y3.gameApp:getLevel():getLogic("SurviveGameBattlePass")

    local freeRewardParams = string.split(self._cfg.game_battlepass_basic_reward, "#")
    local freeRewardUI = {
        bg = self._freeItemBg, 
        icon =self._freeItemIcon,
        lockTips = self._freeItemLock,
        receiveTips = self._freeItemReceived,
        name = self._freeItemName,
        count = self._freeItemCount,
        mask = self._freeItemMask,
    }
    local isReceivedFreeReward = receiveStatus[basttlePassData.SeasonDataIndex.FreeReward] and 
                                receiveStatus[basttlePassData.SeasonDataIndex.FreeReward] == basttlePassData.RewardReceiveStatus.Received
    self:updateRewardInfo(freeRewardUI, freeRewardParams, index, curLv, isReceivedFreeReward, false)

    local advancedRewardParams = string.split(self._cfg.game_battlepass_privilege_reward, "#")
    local advancedRewardUI = {
        bg = self._advancedItemBg, 
        icon =self._advancedItemIcon,
        lockTips = self._advancedItemLock,
        receiveTips = self._advancedItemReceived,
        name = self._advancedItemName,
        count = self._advancedItemCount,
        mask = self._advancedItemMask,
    }
    local isReceivedAdvancedReward = receiveStatus[basttlePassData.SeasonDataIndex.AdvancedReward] and 
                                    receiveStatus[basttlePassData.SeasonDataIndex.AdvancedReward] == basttlePassData.RewardReceiveStatus.Received
    self:updateRewardInfo(advancedRewardUI, advancedRewardParams, index, curLv, isReceivedAdvancedReward, not isUnlockAdvanceReward)

    local ultimateRewardParams = string.split(self._cfg.game_battlepass_gold_reward, "#")
    local ultimateRewardUI = {
        bg = self._ultimateItemBg, 
        icon =self._ultimateItemIcon,
        lockTips = self._ultimateItemLock,
        receiveTips = self._ultimateItemReceived,
        name = self._ultimateItemName,
        count = self._ultimateItemCount,
        mask = self._ultimateItemMask,
    }
    local isReceivedUltimateReward = receiveStatus[basttlePassData.SeasonDataIndex.UltimateReward] and 
                                    receiveStatus[basttlePassData.SeasonDataIndex.UltimateReward] == basttlePassData.RewardReceiveStatus.Received
    self:updateRewardInfo(ultimateRewardUI, ultimateRewardParams, index, curLv, isReceivedUltimateReward, not isUnlockUltimateReward)
end

function SurviveGameBattlePassLvRewardUI:_onFreeRewardClick(local_player, data)
    xpcall(function(...)
        print("try receive [Free] reward" )
        local playerId = y3.gameApp:getMyPlayerId()
        
        local basttlePassData = y3.gameApp:getLevel():getLogic("SurviveGameBattlePass")
        local detailInfo = basttlePassData:getSaveData(self._cfg.game_season)
        assert(detailInfo, "bp archiveData error")

        local receiveStatus = detailInfo[basttlePassData.SeasonDataIndex.FreeReward][self._cfg.game_battlepass_level]
        if receiveStatus == basttlePassData.RewardReceiveStatus.Received then
            return
        end

        local battlepassActivityCfg = include("gameplay.config.game_acitivity")
        assert(battlepassActivityCfg, "battlepass activity cfg error")

        local saveItemLogic = y3.gameApp:getLevel():getLogic("SurviveGameSaveItem")
        local activityInfo = battlepassActivityCfg.get(self._cfg.game_season)
        assert(activityInfo, "battlepass activity info error")

        local expItemInfo = string.split(activityInfo.game_activity_args, "#")
        assert(expItemInfo and #expItemInfo == 3, "exp item info error")

        local expItemId = tonumber(expItemInfo[2])
        local totalExp = saveItemLogic:getSaveItemNum(playerId, expItemId)
        local curLv = basttlePassData:getCurLvAndExp(self._cfg.game_season, totalExp)
        if self._cfg.game_battlepass_level > curLv then
            return
        end

        local paramDic = {}
        paramDic[basttlePassData.SeasonDataIndex.FreeReward] = {self._cfg.game_battlepass_level}
        y3.SyncMgr:sync(y3.SyncConst.SYNC_RECEIVE_BP_REWARD, { playerId = playerId, seasonIndex = self._cfg.game_season, param = paramDic})
    end, __G__TRACKBACK__)

end

function SurviveGameBattlePassLvRewardUI:_onAdvancedRewardClick(local_player, data)
    print("try receive [Advanced] reward" )
    xpcall(function(...)
        local playerId = y3.gameApp:getMyPlayerId()

        local basttlePassData = y3.gameApp:getLevel():getLogic("SurviveGameBattlePass")
        local detailInfo = basttlePassData:getSaveData(self._cfg.game_season)
        assert(detailInfo, "bp archiveData error")

        local receiveStatus = detailInfo[basttlePassData.SeasonDataIndex.AdvancedReward][self._cfg.game_battlepass_level]
        if receiveStatus == basttlePassData.RewardReceiveStatus.Received then
            return
        end

        local battlepassActivityCfg = include("gameplay.config.game_acitivity")
        assert(battlepassActivityCfg, "battlepass activity cfg error")

        local saveItemLogic = y3.gameApp:getLevel():getLogic("SurviveGameSaveItem")
        local activityInfo = battlepassActivityCfg.get(self._cfg.game_season)
        assert(activityInfo, "battlepass activity info error")

        local expItemInfo = string.split(activityInfo.game_activity_args, "#")
        assert(expItemInfo and #expItemInfo == 3, "exp item info error")
        
        local expItemId = tonumber(expItemInfo[2])
        local totalExp = saveItemLogic:getSaveItemNum(playerId, expItemId)
        local curLv = basttlePassData:getCurLvAndExp(self._cfg.game_season, totalExp)
        if self._cfg.game_battlepass_level > curLv then
            log.debug("等级不足")
            return
        end

        local isUnlockAdvanceReward = basttlePassData:isUnlockAdvanceReward(playerId, self._cfg.game_season)
        if not isUnlockAdvanceReward then
            log.debug("未解锁")
            return
        end

        local basttlePassData = y3.gameApp:getLevel():getLogic("SurviveGameBattlePass")
        local paramDic = {}
        paramDic[basttlePassData.SeasonDataIndex.AdvancedReward] = {self._cfg.game_battlepass_level}
        y3.SyncMgr:sync(y3.SyncConst.SYNC_RECEIVE_BP_REWARD, { playerId = playerId, seasonIndex = self._cfg.game_season, param = paramDic})
    end, __G__TRACKBACK__)

end

function SurviveGameBattlePassLvRewardUI:_onUltimateRewardClick(local_player, data)
    print("try receive [Ultimate] reward" )

    xpcall(function(...)
        local playerId = y3.gameApp:getMyPlayerId()

        local basttlePassData = y3.gameApp:getLevel():getLogic("SurviveGameBattlePass")
        local detailInfo = basttlePassData:getSaveData(self._cfg.game_season)
        assert(detailInfo, "bp archiveData error")

        local receiveStatus = detailInfo[basttlePassData.SeasonDataIndex.UltimateReward][self._cfg.game_battlepass_level]
        if receiveStatus == basttlePassData.RewardReceiveStatus.Received then
            return
        end

        local battlepassActivityCfg = include("gameplay.config.game_acitivity")
        assert(battlepassActivityCfg, "battlepass activity cfg error")

        local saveItemLogic = y3.gameApp:getLevel():getLogic("SurviveGameSaveItem")
        local activityInfo = battlepassActivityCfg.get(self._cfg.game_season)
        assert(activityInfo, "battlepass activity info error")

        local expItemInfo = string.split(activityInfo.game_activity_args, "#")
        assert(expItemInfo and #expItemInfo == 3, "exp item info error")
        
        local expItemId = tonumber(expItemInfo[2])
        local totalExp = saveItemLogic:getSaveItemNum(playerId, expItemId)
        local curLv = basttlePassData:getCurLvAndExp(self._cfg.game_season, totalExp)
        if self._cfg.game_battlepass_level > curLv then
            log.debug("等级不足")
            return
        end

        local isUnlockUltimateReward = basttlePassData:isUnlockUltimateReward(self._cfg.game_season)
        if not isUnlockUltimateReward then
            log.debug("未解锁")
            return
        end

        local basttlePassData = y3.gameApp:getLevel():getLogic("SurviveGameBattlePass")
        local paramDic = {}
        paramDic[basttlePassData.SeasonDataIndex.UltimateReward] = {self._cfg.game_battlepass_level}
        y3.SyncMgr:sync(y3.SyncConst.SYNC_RECEIVE_BP_REWARD, { playerId = playerId, seasonIndex = self._cfg.game_season, param = paramDic})
    end, __G__TRACKBACK__)

end

function SurviveGameBattlePassLvRewardUI:setVisible(status)
    self._ui:set_visible(status)
end

return SurviveGameBattlePassLvRewardUI
