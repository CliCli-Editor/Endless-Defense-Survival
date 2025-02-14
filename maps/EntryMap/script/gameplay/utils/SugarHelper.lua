local SugarHelper = {}

function SugarHelper.gameCourse()
    return y3.gameApp:getLevel():getLogic("SurviveGameCourse")
end

function SugarHelper.achievement()
    return y3.gameApp:getLevel():getLogic("SurviveGameAchievement")
end

function SugarHelper.stagePass(playerId, satgeId)
    local stagePass = y3.gameApp:getLevel():getLogic("SurviveGameStagePass")
    local treasureDrop = y3.gameApp:getLevel():getLogic("SurviveGameTreasureDrop")
    stagePass:updateStagePass(playerId, satgeId)
    treasureDrop:updateStagePass(playerId, satgeId)
    y3.userDataHelper.unloadPassValue(playerId)
    y3.SignalMgr:dispatch(y3.SignalConst.SIGNAL_STAGE_PASS, y3.player(playerId))
end

function SugarHelper.localTips(playerId, tips)
    xpcall(function(...)
        if playerId == y3.gameApp:getMyPlayerId() then
            y3.G_PromptMgr:showTips(tips)
        end
    end
    , __G__TRACKBACK__)
end

function SugarHelper.localNotice(playerId, id, param)
    xpcall(function(...)
        if playerId == y3.gameApp:getMyPlayerId() then
            y3.G_PromptMgr:showNotice(id, param)
        end
    end, __G__TRACKBACK__)
end

function SugarHelper.NoticeAll(id, param)
    y3.G_PromptMgr:showNotice(id, param)
end

function SugarHelper.localSkillBuyNotice(playerId, recordData)
    xpcall(function(...)
        if playerId == y3.gameApp:getMyPlayerId() then
            y3.PromptBuy:showNotice2(recordData, 5)
        end
    end, __G__TRACKBACK__)
end

function SugarHelper.localNotice2(playerId, id, param)
    xpcall(function(...)
        if playerId == y3.gameApp:getMyPlayerId() then
            y3.G_PromptMgr:showNotice2(id, param)
        end
    end, __G__TRACKBACK__)
end

function SugarHelper.tipRoot()
    return y3.gameApp:getLevel():getView("SurviveGameTip")
end

function SugarHelper.recordPlayerDrop(playerId, data)
    local playerData = y3.userData:getPlayerData(playerId)
    playerData:addRecordDrop(data)
    xpcall(function(...)
        if playerId == y3.gameApp:getMyPlayerId() then
            y3.Sugar.tipRoot():pushSlider(data)
        end
    end, __G__TRACKBACK__)
end

function SugarHelper.showResult(win)
    y3.gameApp:getLevel():getView("SurviveGameHUD"):showResultUI(win)
end

return SugarHelper
