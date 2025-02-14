local StaticUIBase = include("gameplay.base.StaticUIBase")
local M = class("SurviveGameBattlePassUI", StaticUIBase)

local TAB_SELECT_IMG = 134221722
local TAB_NORMAL_IMG = 134264844
local DEFAULT_SEASON_INDEX = 1

function M:ctor()
    local ui = y3.UIHelper.getUI("8414b017-588a-4aba-a503-98d0cee10826")
    M.super:ctor(self, ui)

    self._curSeasonIndex = DEFAULT_SEASON_INDEX
    if ui then
        self._menuIndex = tonumber(ui:get_name())
    end

    self:_initUINode()
    self:_initTab()
    self:_onTabClick(self._curSeasonIndex)

    M.super:addTrigger(y3.gameApp:registerEvent(y3.EventConst.EVENT_BP_DB_Changed, function(trg, arg)
        if not ui or not ui:is_visible() then
            return
        end
        self:_initUI(self._curSeasonIndex)
    end))
end

function M:indexOfMenuList()
    return self._menuIndex
end

function M:onShow()
    self:_initUI(self._curSeasonIndex or DEFAULT_SEASON_INDEX)
end

function M:_initUINode()
    self._lvInfo = y3.UIHelper.getUI("5a9c2709-44aa-4f8d-8883-51390b95bd62")
    self._expContent = y3.UIHelper.getUI("fc197b4b-1bdf-4ed1-adc8-0d7a580da33f")    
    self._expProgress = y3.UIHelper.getUI("035ffbde-2fb6-4135-a0f6-406a770f8953")
    self._todayExpInfo = y3.UIHelper.getUI("ddc762b7-d675-4dfc-afc9-43e9937fd553")
    self._advancedLvTitle = y3.UIHelper.getUI("515571ee-b219-452f-92bc-dd78742c5cb0")
    self._buyTips = y3.UIHelper.getUI("c0f4f842-6982-4481-b65c-3c312cc45136")
    self._rewardListParent = y3.UIHelper.getUI("06ecfae8-68e4-450e-8740-39df158aadf3")
    self._tabParent = y3.UIHelper.getUI("e7d02500-7868-44e7-9f95-e9f514588bd5")
    self._advancedTitle = y3.UIHelper.getUI("515571ee-b219-452f-92bc-dd78742c5cb0")
    self._ultimateTitle = y3.UIHelper.getUI("8b8fcb71-dcc3-4dba-8fd7-1d991f7696c2")
    self._buyExpBtnContent = y3.UIHelper.getUI("bf9ab780-c69c-426d-8dd2-ab53016c731c")
    self._expInfo = y3.UIHelper.getUI("80b2381b-0064-48a0-8abf-c9e990d8d8ee")

    self._finalRewardUI = y3.UIHelper.getUI("326cddd3-cd2a-4b26-80c8-368be895adf9")
    self._finalRewardInfo = include("gameplay.view.survive.save.SurviveGameBattlePassLvRewardUI").new(self._rewardListParent, self._finalRewardUI)

    self._specialReward = y3.UIHelper.getUI("a2519b4e-0842-4496-858b-5f910946ad52")
    self._specialRewardInfo = include("gameplay.view.survive.save.SurviveGameBattlePassSpeicalRewardUI").new(self._specialReward)

    self._advancedRewardTitleBtn = y3.UIHelper.getUI("01590a97-63bb-4cc7-9aca-8fef6b671f87")
    self._ultimateRewardTitleBtn = y3.UIHelper.getUI("b1411d27-9dfd-4eaf-88ee-8a166437a16e")

    self._buyExpBtn = y3.UIHelper.getUI("b391930a-24ed-4a8e-b92b-a0c6e711fa41")
    self._receiveAllBtn = y3.UIHelper.getUI("220e96e4-743f-4dbf-b629-29f28b1db95d")
    self._unlockAdvancedRewardBtn = y3.UIHelper.getUI("5011d5e9-bc9a-4e78-8cd4-784a91b450d2")
    self._unlockAdvancedRewardBtnContent = y3.UIHelper.getUI("4a50e9f6-6b5b-4d7b-af0a-f9f8aa2e55c3")

    self._unlockAdvancedRewardBtn:add_local_event("左键-点击", function(local_player)
        self:_onBuyNextChargePkgClick()
    end)
    self._advancedRewardTitleBtn:add_local_event("左键-点击", function(local_player)
        self:_onBuyAdvancedRewawrdPassPkgClick()
    end)
    self._ultimateRewardTitleBtn:add_local_event("左键-点击", function(local_player)
        self:_onBuyUltimateRewawrdPassPkgClick()
    end)
    self._buyExpBtn:add_local_event("左键-点击", function(local_player)
        self:_onBuyExpPkgClick()
    end)
    self._expInfo:add_local_event("鼠标-移入", function()
        y3.Sugar.tipRoot():showUniversalTip({ title="", desc = y3.langCfg.get(40).str_content })
    end)
    self._expInfo:add_local_event("鼠标-移出", function()
        y3.Sugar.tipRoot():hideUniversalTip()
    end)
    self._receiveAllBtn:add_local_event("左键-点击", function(local_player)
        self:_onReceiveAllExpPkgClick()
    end)
end

function M:_initUI(seasonIndex)
    
    local battlepassActivityCfg = include("gameplay.config.game_acitivity")
    assert(battlepassActivityCfg, "battlepass activity cfg error")

    local activityInfo = battlepassActivityCfg.get(seasonIndex)
    assert(activityInfo, "battlepass activity info error")

    local expItemInfo = string.split(activityInfo.game_activity_args, "#")
    assert(expItemInfo and #expItemInfo == 3, "exp item info error")

    local perDayMaxGetableExp = tonumber(expItemInfo[3])
    assert(perDayMaxGetableExp, "exp item info not number")

    local archiveData = y3.userData:loadTable("BattlePass")
    assert(archiveData and archiveData[seasonIndex], "战令存档数据为空")

    local basttlePassData = y3.gameApp:getLevel():getLogic("SurviveGameBattlePass")
    local encryptedExpInfo = archiveData[seasonIndex][basttlePassData.SeasonDataIndex.Exp]
    local decryptedExpInfo = y3.gameApp:decryptString(encryptedExpInfo)
    local expParams = string.split(decryptedExpInfo, "#")
    if not expParams or #expParams ~= 2 then
        return
    end

    local detailInfo = basttlePassData:getSaveData(seasonIndex)
    assert(detailInfo, "战令详细信息为空")

    local saveItemLogic = y3.gameApp:getLevel():getLogic("SurviveGameSaveItem")
    local playerId = y3.gameApp:getMyPlayerId()
    local expItemId = tonumber(expItemInfo[2])
    local totalExp = saveItemLogic:getSaveItemNum(playerId, expItemId)
    local curLv, curExp, curLvMaxExp = basttlePassData:getCurLvAndExp(seasonIndex, totalExp)
    local levelInfo = y3.Lang.getLang(y3.langCfg.get(27).str_content, {level = curLv})
    self._lvInfo:set_text(levelInfo)
    self._expContent:set_text(string.format("%d/%d", curExp, curLvMaxExp))

    expParams[basttlePassData.ExpDataIndex.today] = tonumber(expParams[basttlePassData.ExpDataIndex.today])
    local expInfo = y3.Lang.getLang(y3.langCfg.get(28).str_content, {current = expParams[basttlePassData.ExpDataIndex.today], max = perDayMaxGetableExp})
    self._todayExpInfo:set_text(expInfo)

    local progress = curExp / curLvMaxExp * 100
    self._expProgress:set_current_progress_bar_value(progress)

    local isUnlockAdvanceReward = basttlePassData:isUnlockAdvanceReward(playerId, seasonIndex)
    local isUnlockUltimateReward = basttlePassData:isUnlockUltimateReward(seasonIndex)

    self._advancedRewardTitleBtn:set_visible(not isUnlockAdvanceReward)
    self._ultimateRewardTitleBtn:set_visible(not isUnlockUltimateReward)

    local unlockTips = y3.langCfg.get(34).str_content
    local advancedTitleKeyWord = y3.langCfg.get(30).str_content
    local advancedTitleContent = isUnlockAdvanceReward and 
                                    advancedTitleKeyWord .. "" or
                                    advancedTitleKeyWord .. "\n" .. unlockTips
    self._advancedTitle:set_text(advancedTitleContent)
    local ultimateTitleKeyWord = y3.langCfg.get(31).str_content
    local ultimateTitleContent = isUnlockUltimateReward and 
                                    ultimateTitleKeyWord .. "" or 
                                    ultimateTitleKeyWord .. "\n" .. unlockTips
    self._ultimateTitle:set_text(ultimateTitleContent)

    local showBuyBtn = not isUnlockUltimateReward
    self._buyTips:set_visible(showBuyBtn)
    self._unlockAdvancedRewardBtn:set_visible(showBuyBtn)

    if showBuyBtn then
        local keyWorld = isUnlockAdvanceReward and ultimateTitleKeyWord or advancedTitleKeyWord
        local completeContent = y3.Lang.getLang(y3.langCfg.get(35).str_content, {bp = keyWorld})
        self._unlockAdvancedRewardBtnContent:set_text(completeContent)
    end

    local battlepassCfg = include("gameplay.config.game_battlepass")
    if not battlepassCfg then
        log.error("battlePass cfg error")
        return
    end
    
    local lvUIList = self._rewardListParent:get_childs()
    self._lvInfoList = self._lvInfoList or {}
    if getTableLength(lvUIList) > 0 then
        for _, value in pairs(lvUIList) do
            value:set_visible(false)
        end
    end

    local seasonLvIndex = 1
    local length = battlepassCfg.length()
    local lastCfgInfo
    for index = 1, length, 1 do
        local cfgInfo = battlepassCfg.indexOf(index)
        assert(cfgInfo, "")

        if cfgInfo.game_season == seasonIndex then
            self._lvInfoList[seasonLvIndex] = self._lvInfoList[seasonLvIndex] or include("gameplay.view.survive.save.SurviveGameBattlePassLvRewardUI").new(self._rewardListParent)
            self._lvInfoList[seasonLvIndex]:setVisible(true)

            local receiveStatus = {}
            receiveStatus[basttlePassData.SeasonDataIndex.FreeReward] = detailInfo[basttlePassData.SeasonDataIndex.FreeReward][seasonLvIndex]
            receiveStatus[basttlePassData.SeasonDataIndex.AdvancedReward] = detailInfo[basttlePassData.SeasonDataIndex.AdvancedReward][seasonLvIndex]
            receiveStatus[basttlePassData.SeasonDataIndex.UltimateReward] = detailInfo[basttlePassData.SeasonDataIndex.UltimateReward][seasonLvIndex]
            self._lvInfoList[seasonLvIndex]:updateUI(cfgInfo, seasonLvIndex, curLv, receiveStatus, isUnlockAdvanceReward, isUnlockUltimateReward)
            seasonLvIndex = seasonLvIndex + 1
            lastCfgInfo = cfgInfo
        end
    end

    local finalRewardReceiveStatus = {}
    local seasonMaxLv = math.max(seasonLvIndex - 1, 0)
    finalRewardReceiveStatus[1] = 0
    finalRewardReceiveStatus[basttlePassData.SeasonDataIndex.FreeReward] = detailInfo[basttlePassData.SeasonDataIndex.FreeReward][seasonMaxLv]
    finalRewardReceiveStatus[basttlePassData.SeasonDataIndex.AdvancedReward] = detailInfo[basttlePassData.SeasonDataIndex.AdvancedReward][seasonMaxLv]
    finalRewardReceiveStatus[basttlePassData.SeasonDataIndex.UltimateReward] = detailInfo[basttlePassData.SeasonDataIndex.UltimateReward][seasonMaxLv]
    self._finalRewardInfo:updateUI_Final(lastCfgInfo, seasonMaxLv, curLv, finalRewardReceiveStatus, isUnlockAdvanceReward, isUnlockUltimateReward)
    
    local specialRewardSign = detailInfo[basttlePassData.SeasonDataIndex.SpecialReward]
    local isReceivedSpecialReward = specialRewardSign == basttlePassData.RewardReceiveStatus.Received
    self._specialRewardInfo:updateUI(seasonIndex, activityInfo.game_activity_reward, isUnlockUltimateReward, isReceivedSpecialReward)

    if basttlePassData:existReciveableReward(seasonIndex) then
        self._receiveAllBtn:set_button_enable(true)
    else
        self._receiveAllBtn:set_button_enable(false)
    end

    if curLv == seasonMaxLv then
        local attachMaxLvContent = y3.langCfg.get(41).str_content
        self._buyExpBtnContent:set_text(attachMaxLvContent)
        self._expContent:set_text(attachMaxLvContent)
        self._expProgress:set_current_progress_bar_value(100)
        self._buyExpBtn:set_button_enable(false)
    else
        self._buyExpBtnContent:set_text(GameAPI.get_text_config('#-2052963237#lua'))
        self._buyExpBtn:set_button_enable(true)
    end

end

function M:_initTab()
    local childs = self._tabParent:get_childs()
    self._tabBtns = {}
    for i, child in ipairs(childs) do
        local index = tonumber(child:get_name())
        if index then
            self._tabBtns[index] = child
            child:add_local_event("左键-点击", function(local_player)
                self:_onTabClick(index)
            end)
        end
    end
end

function M:_onTabClick(index)
    local childs = self._tabParent:get_childs()
    for i, child in ipairs(childs) do
        local name = tonumber(child:get_name())
        child:set_visible(name == index)
    end
    for i = 1, #self._tabBtns do
        self._tabBtns[i]:set_image(index == i and TAB_SELECT_IMG or TAB_NORMAL_IMG)
    end
    self:_initUI(index)

    self._curSeasonIndex = index
end

function M:_onBuyNextChargePkgClick()
    log.debug("触发 购买 下一级通行证")

    xpcall(function(...)
        local playerId = y3.gameApp:getMyPlayerId()
        local player = y3.player(playerId)
        local itmeId = player:get_store_item_number(y3.SurviveConst.PLATFORM_ITEM_MAP.S1_BP_ADVANCED) == 0 and 
                            y3.SurviveConst.PLATFORM_ITEM_MAP.S1_BP_ADVANCED or 
                            y3.SurviveConst.PLATFORM_ITEM_MAP.S1_BP_ULTIMATE
        player:open_platform_shop(itmeId)
    end, __G__TRACKBACK__)
end

function M:_onBuyAdvancedRewawrdPassPkgClick()
    log.debug("触发 购买 高级奖励 通行证")
    xpcall(function(...)
        local playerId = y3.gameApp:getMyPlayerId()
        local player = y3.player(playerId)
        local basttlePassData = y3.gameApp:getLevel():getLogic("SurviveGameBattlePass")
        local isUnlockAdvanceReward = basttlePassData:isUnlockAdvanceReward(playerId, self._curSeasonIndex)
        if isUnlockAdvanceReward then
            log.debug("已购买过")
            return
        end
        player:open_platform_shop(y3.SurviveConst.PLATFORM_ITEM_MAP.S1_BP_ADVANCED)
    end, __G__TRACKBACK__)

end

function M:_onBuyUltimateRewawrdPassPkgClick()
    log.debug("触发 购买 终极奖励 通行证")

    xpcall(function(...)
        local playerId = y3.gameApp:getMyPlayerId()
        local player = y3.player(playerId)
        local itmeId = y3.SurviveConst.PLATFORM_ITEM_MAP.S1_BP_ULTIMATE

        local basttlePassData = y3.gameApp:getLevel():getLogic("SurviveGameBattlePass")
        local isUnlockUltimateReward = basttlePassData:isUnlockUltimateReward(self._curSeasonIndex)
        if isUnlockUltimateReward then
            log.debug("已购买过")
            return
        end

        player:open_platform_shop(itmeId)
    end, __G__TRACKBACK__)

end

function M:_onBuyExpPkgClick()
    log.debug("触发 购买 经验包")
    xpcall(function(...)
        local playerId = y3.gameApp:getMyPlayerId()
        local player = y3.player(playerId)
        player:open_platform_shop(y3.SurviveConst.PLATFORM_ITEM_MAP.S1_BP_EXP_ITEM)
    end, __G__TRACKBACK__)

end

function M:_onReceiveAllExpPkgClick()
    log.debug("触发 领取所有 奖励")

    xpcall(function(...)
        self._receiveAllBtn:set_button_enable(false)

        local battlepassActivityCfg = include("gameplay.config.game_acitivity")
        assert(battlepassActivityCfg, "battlepass activity cfg error")

        local activityInfo = battlepassActivityCfg.get(self._curSeasonIndex)
        assert(activityInfo, "battlepass activity info error")

        local expItemInfo = string.split(activityInfo.game_activity_args, "#")
        assert(expItemInfo and #expItemInfo == 3, "exp item info error")

        local basttlePassData = y3.gameApp:getLevel():getLogic("SurviveGameBattlePass")
        local detailInfo = basttlePassData:getSaveData(self._curSeasonIndex)
        if not detailInfo then
            log.error("bp archiveData error")
            return
        end

        local saveItemLogic = y3.gameApp:getLevel():getLogic("SurviveGameSaveItem")
        local playerId = y3.gameApp:getMyPlayerId()
        local expItemId = tonumber(expItemInfo[2])
        local totalExp = saveItemLogic:getSaveItemNum(playerId, expItemId)
        local curLv = basttlePassData:getCurLvAndExp(self._curSeasonIndex, totalExp)

        local isUnlockAdvanceReward = basttlePassData:isUnlockAdvanceReward(playerId, self._curSeasonIndex)
        local isUnlockUltimateReward = basttlePassData:isUnlockUltimateReward(self._curSeasonIndex)
        local battlepassCfg = include("gameplay.config.game_battlepass")
        assert(battlepassCfg, "bp cfg error")

        local length = battlepassCfg.length()
        local receiveRecordInfo = {}
        receiveRecordInfo[basttlePassData.SeasonDataIndex.FreeReward] = {}
        if isUnlockAdvanceReward then
            receiveRecordInfo[basttlePassData.SeasonDataIndex.AdvancedReward] = {}
        end
        if isUnlockUltimateReward then
            receiveRecordInfo[basttlePassData.SeasonDataIndex.UltimateReward] = {}
        end
        for index = 1, length, 1 do
            while true do
                local cfgInfo = battlepassCfg.indexOf(index)
                if not cfgInfo then
                    break
                end
                
                if cfgInfo.game_season ~= self._curSeasonIndex then
                    break
                end
                
                local level = cfgInfo.game_battlepass_level
                if curLv < cfgInfo.game_battlepass_level then
                    break
                end

                if detailInfo[basttlePassData.SeasonDataIndex.FreeReward][level] == basttlePassData.RewardReceiveStatus.Havent then
                    table.insert(receiveRecordInfo[basttlePassData.SeasonDataIndex.FreeReward], level)
                end

                if isUnlockAdvanceReward and detailInfo[basttlePassData.SeasonDataIndex.AdvancedReward][level] == basttlePassData.RewardReceiveStatus.Havent then
                    table.insert(receiveRecordInfo[basttlePassData.SeasonDataIndex.AdvancedReward], level)
                end

                if isUnlockUltimateReward and detailInfo[basttlePassData.SeasonDataIndex.UltimateReward][level] == basttlePassData.RewardReceiveStatus.Havent then
                    table.insert(receiveRecordInfo[basttlePassData.SeasonDataIndex.UltimateReward], level)
                end
                break
            end
        end

        y3.SyncMgr:sync(y3.SyncConst.SYNC_RECEIVE_BP_REWARD, { playerId = playerId, seasonIndex = self._curSeasonIndex, param = receiveRecordInfo})
    end, __G__TRACKBACK__)

end

return M
