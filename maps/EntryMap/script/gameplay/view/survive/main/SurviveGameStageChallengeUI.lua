local SurviveGameStageChallengeUI = class("SurviveGameStageChallengeUI")

function SurviveGameStageChallengeUI:ctor(root)
    self._root                     = root
    self._ui                       = y3.UIHelper.getUI("0d9e47c4-48af-4df7-801c-10a270e1f5f1")

    -- self._stageChallengeBtn        = y3.UIHelper.getUI("d1c2c2b7-28db-407c-8e6f-b0e006905c6c")
    self._stageChallengeNameText   = y3.UIHelper.getUI("c73b8b54-22f0-4d9a-b341-be9194dfa6ca")
    self._stageChallengeCountText  = y3.UIHelper.getUI("d3487324-4c08-454a-a7c4-9554601e4a1f")
    self._stageChallengeProgress   = y3.UIHelper.getUI("2437d4d6-9488-479c-8cca-338b6532db24")

    self._stageChallengeBtn2       = y3.UIHelper.getUI("168dfb28-53e8-4e3a-a058-51bb225264e5")
    self._stageChallengeNameText2  = y3.UIHelper.getUI("874de5a5-38bf-47e9-b5e3-30aae3615c9d")
    self._stageChallengeCountText2 = y3.UIHelper.getUI("e48b71c5-9d40-4a0f-a1a1-8a3d296ed1e9")
    self._stageChallengeProgress2  = y3.UIHelper.getUI("4aaf82a9-c128-40b6-9415-a807bfb0e8a8")

    -- self._stageChallengeBtn:add_local_event("左键-按下", handler(self, self._onStageChallengeBtnClick))
    -- self._stageChallengeBtn2:add_local_event("左键-按下", handler(self, self._onStageChallengeBtn2Click))
    -- local has1 = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy"):getGoldChallenge():challengeHas()
    -- local has2 = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy"):getDiamondChallenge():challengeHas()
    -- self._stageChallengeBtn:set_visible(has1)
    -- self._stageChallengeBtn2:set_visible(has2)
end

function SurviveGameStageChallengeUI:updateUI()
    local count, time, maxTime = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy"):getGoldChallenge()
        :getChallengeParam(y3.gameApp
            :getMyPlayerId())
    self._stageChallengeCountText:set_text(count)
    self._stageChallengeProgress:set_current_progress_bar_value(time / maxTime * 100, 1 / 30)

    local count2, time2, maxTime2 = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy"):getDiamondChallenge()
        :getChallengeParam(
            y3.gameApp
            :getMyPlayerId())
    -- print(count2, time2, maxTime2)
    self._stageChallengeCountText2:set_text(count2)
    self._stageChallengeProgress2:set_current_progress_bar_value(time2 / maxTime2 * 100, 1 / 30)
end

function SurviveGameStageChallengeUI:_onStageChallengeBtnClick(local_player)
    y3.SyncMgr:sync(y3.SyncConst.SYNC_STAGE_CHALLENGE_START, {})
end

function SurviveGameStageChallengeUI:_onStageChallengeBtn2Click(local_player)
    print("diamond challenge")
    y3.SyncMgr:sync(y3.SyncConst.SYNC_STAGE_CHALLENGE_COMMON_START, {
        challenge_type = 2
    })
end

return SurviveGameStageChallengeUI
