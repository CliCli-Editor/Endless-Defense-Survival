local UIBase = include("gameplay.base.UIBase")
local M = class("SurviveGameBattlePassSpeicalRewardUI", UIBase)

function M:ctor(root)
    
    self._ui = root

    self._title_TEXT = self._ui:get_child("title._title_TEXT")
    self._titleMask = self._ui:get_child("title.mask")
    self._contentMask = self._ui:get_child("content.mask")
    self._contentBg = self._ui:get_child("content.bg")
    
    self._contentBg:add_local_event("左键-点击", handler(self, self._onSpecialRewardClick))
end

function M:updateUI(seasonIndex, rewardInfo, isUnlockUltimateReward, isReceived)

    self._seasonIndex = seasonIndex

    local levelInfo = y3.langCfg.get(49) and y3.langCfg.get(49).str_content or ""
    self._title_TEXT:set_text(levelInfo)

    local rewardParams = string.split(rewardInfo, "|")
    if not rewardParams or #rewardParams < 1 then
        log.error("invalid rewardParams", rewardInfo)
        return
    end

    for index, value in pairs(rewardParams) do
        local detailParams = string.split(value, "#")
        if not detailParams or #detailParams < 1 then
            log.error("invalid detailParams", value)
            return
        end

        local uiTable = {
            bg = self._ui:get_child(string.format("content.item_%d.bg", index)),
            icon = self._ui:get_child(string.format("content.item_%d._icon_IMG", index)),
            lockTips = self._ui:get_child(string.format("content.item_%d.lock", index)),
            receiveTips = self._ui:get_child(string.format("content.item_%d.unlock", index)),
            name = self._ui:get_child(string.format("content.item_%d._title_TEXT", index)),
        }
        self:updateRewardInfo(uiTable, detailParams, isReceived, not isUnlockUltimateReward)
    end

    self._titleMask:set_visible(not isUnlockUltimateReward)
    self._contentMask:set_visible(not isUnlockUltimateReward)
end

function M:updateRewardInfo(uiTable, rewardParams, isReceived, islock)

    assert(rewardParams and #rewardParams == 3, "invalid reward params")

    local rewardType = tonumber(rewardParams[1])
    local rewardId = rewardParams[2]
    local rewardOtherParam = tonumber(rewardParams[3])

    local quality = 2 -- default quality
    if rewardType == y3.SurviveConst.DROP_TYPE_SAVE_ITEM then
        local itemCfg = include("gameplay.config.save_item").get(tonumber(rewardId))
        if not itemCfg then
            log.error("not found save_item cfg by id=", rewardId)
            return
        end

        uiTable.name:set_text(itemCfg.item_name .. " x" .. rewardOtherParam)
        uiTable.icon:set_image(tonumber(itemCfg.item_icon))
        quality = tonumber(itemCfg.item_quality)
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
        
        uiTable.name:set_text(treasureCfg.name .. " x" .. rewardOtherParam)
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
        uiTable.name:set_text(titleCfg.name .. " x" .. rewardOtherParam)
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
        
        uiTable.name:set_text(stCfg.tower_name .. " x" .. rewardOtherParam)
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
        
        uiTable.name:set_text(cfg.name .. " x" .. rewardOtherParam)
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
            log.error("invalid attrPack cfg", rewardId)
            return
        end
        local attrParams = string.split(attrPackCfg.attr, "#")
        assert(attrParams and #attrParams >= 2, "invalid attr params")

        local countInfo = attrParams[2] and tonumber(attrParams[2]) or 0
        uiTable.icon:set_image(rewardOtherParam)

        local attrCfg = include("gameplay.config.attr").get(tonumber(attrParams[1]))
        assert(attrCfg, "invalid attr cfg")

        local suffix = attrCfg.show_type == 1 and "" or "%"
        local attrName = countInfo > 0 and attrCfg.attr_name .. " +" .. countInfo .. suffix or attrCfg.attr_name
        uiTable.name:set_text(attrName)

        uiTable.icon:add_local_event("鼠标-移入", function() end)
        uiTable.icon:add_local_event("鼠标-移出", function() end)
    elseif rewardType == y3.SurviveConst.DROP_TYPE_TOWER_SKIN then
        local towerSkinCfg = include("gameplay.config.stage_tower_skin").get(rewardId)
        if not towerSkinCfg then
            log.warn("invalid towerSkin cfg", tostring(rewardId))
            return
        end
        uiTable.name:set_text(towerSkinCfg.tower_skin_name .. " x" .. rewardOtherParam)
        uiTable.icon:set_image(towerSkinCfg.tower_skin_icon)
        quality = tonumber(towerSkinCfg.tower_skin_quality)
        uiTable.icon:add_local_event("鼠标-移入", function()
            y3.Sugar.tipRoot():showUniversalTip({title = towerSkinCfg.tower_skin_name, desc = towerSkinCfg.tower_desc })
        end)
        uiTable.icon:add_local_event("鼠标-移出", function()
            y3.Sugar.tipRoot():hideUniversalTip()
        end)
    end

    uiTable.bg:set_image(y3.SurviveConst.ITEM_CLASS_MAP[quality])
    uiTable.lockTips:set_visible(islock)
    uiTable.receiveTips:set_visible(isReceived)
end

function M:_onSpecialRewardClick(local_player, data)
    print("try receive [special] reward" )

    xpcall(function(...)
        local playerId = y3.gameApp:getMyPlayerId()
        local basttlePassData = y3.gameApp:getLevel():getLogic("SurviveGameBattlePass")
        local detailInfo = basttlePassData:getSaveData(self._seasonIndex)
        if not detailInfo then
            log.error("bp archiveData error")
            return
        end

        local receiveStatus = detailInfo[basttlePassData.SeasonDataIndex.SpecialReward]
        if receiveStatus and receiveStatus == basttlePassData.RewardReceiveStatus.Received then
            return
        end

        local isUnlockUltimateReward = basttlePassData:isUnlockUltimateReward(self._seasonIndex)
        if not isUnlockUltimateReward then
            log.debug("未解锁")
            return
        end

        local battlepassActivityCfg = include("gameplay.config.game_acitivity")
        if not battlepassActivityCfg then
            log.error("battlepass activity cfg error")
            return
        end
        local activityInfo = battlepassActivityCfg.get(self._seasonIndex)
        if not activityInfo then
            log.error("battlepass activityInfo error")
            return
        end

        local basttlePassData = y3.gameApp:getLevel():getLogic("SurviveGameBattlePass")
        local paramDic = {}
        paramDic[basttlePassData.SeasonDataIndex.SpecialReward] = {}
        local rewardList = string.split(activityInfo.game_activity_reward, "|")
        if rewardList and #rewardList > 0 then
            for _,value in pairs(rewardList) do
                table.insert(paramDic[basttlePassData.SeasonDataIndex.SpecialReward], value)
            end
        end

        y3.SyncMgr:sync(y3.SyncConst.SYNC_RECEIVE_BP_REWARD, { playerId = playerId, seasonIndex = self._seasonIndex, param = paramDic})
    end, __G__TRACKBACK__)

end


return M
