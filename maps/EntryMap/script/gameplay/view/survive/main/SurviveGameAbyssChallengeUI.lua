local SurviveGameAbyssChallengeUI = class("SurviveGameAbyssChallengeUI")

function SurviveGameAbyssChallengeUI:ctor(root)
    self._root = root
    self._ui = y3.UIHelper.getUI("b6ffcb73-863c-48e0-ae8a-7cea1793e89d")

    self._abyssBtnRoot = y3.UIHelper.getUI("507a532f-7ecc-4485-9110-fe345d69aa11")
    self._stageAbyssBtn = y3.UIHelper.getUI("d1c2c2b7-28db-407c-8e6f-b0e006905c6c")
    self._stage_challenge_abyss_cd_prgress = y3.UIHelper.getUI("2437d4d6-9488-479c-8cca-338b6532db24")
    self._stage_abyss_current_state_text = y3.UIHelper.getUI("c73b8b54-22f0-4d9a-b341-be9194dfa6ca")
    self._stage_abyss_current_floor_text = y3.UIHelper.getUI("8634e3a5-5034-4e82-8dfe-6b22fa0f9b8c")
    self._time_TEXT = y3.UIHelper.getUI("b3e7a823-15d5-4927-8cc0-1c499f2cc370")
    self._bonus = y3.UIHelper.getUI("7ecc1e3c-b40a-4eb6-a05f-cdc96c565cb9")
    self._bigBonus = y3.UIHelper.getUI("39a4ab04-f38d-40d9-a54c-5e74107d5fdf")
    self._bounsRoot = y3.UIHelper.getUI("394f46c8-1dd8-421d-b909-ef35d67c94fd")
    self._bounsRoot:set_visible(true)

    self._stageAbyssShopBtn = y3.UIHelper.getUI("18d1e73d-7188-4925-8cd6-5d9320a7b72f")
    self._stageAbyssShopBar = y3.UIHelper.getUI("1b050a4a-8ee3-45fa-8d6f-0692fced40bb")
    self._abyssShopEventRoot = y3.UIHelper.getUI("8a136a72-49b8-4b27-9422-630eeaf6faf6")
    self._shopBtnLvText = y3.UIHelper.getUI("461d449c-a3c6-4173-a183-dd9981351f54")
    self._abyssShopEventRoot:get_child("new"):set_visible(false)

    self._btn1 = y3.UIHelper.getUI("507a532f-7ecc-4485-9110-fe345d69aa11")
    self._btn2 = y3.UIHelper.getUI("8a136a72-49b8-4b27-9422-630eeaf6faf6")
    self._stageAbyssShopBar:set_visible(true)
    self._stageAbyssBtn:add_local_event('左键-按下', handler(self, self._onStageBbyssBtnClick))
    self._stageAbyssShopBtn:add_local_event('左键-按下', handler(self, self._onStageBbyssShopBtnClick))

    self._bonus:add_local_event('左键-按下', handler(self, self._onBonusBtnClick))
    self._bigBonus:add_local_event('左键-按下', handler(self, self._onBonusBtn2Click))

    self._abyssBtnRoot:get_child("new"):set_visible(false)
    self._abyssBtnRoot:set_visible(y3.FuncCheck.checkFuncIsOpen(y3.gameApp:getMyPlayerId(), y3.FuncConst.FUNC_ABYSS))
    self._abyssShopEventRoot:set_visible(y3.FuncCheck.checkFuncIsOpen(y3.gameApp:getMyPlayerId(),
        y3.FuncConst.FUNC_BLACKMARKET))

    self._abyssCfg = include("gameplay.config.stage_funcation_unlock").get(3)
    local params = string.split(self._abyssCfg.stage_funcation_unlock, "#")
    self._abyssOpentime = tonumber(params[2])

    self:updateUI()
    self:_bounsUpdate()
    y3.gameApp:registerEvent(y3.EventConst.EVENT_SURVIVE_ABYSS_START_CHALLENGE,
        handler(self, self._onEventAbyssStartChallenge))
    y3.gameApp:registerEvent(y3.EventConst.EVENT_SURVIVE_SELECT_REWARD_ADD, handler(self, self._onEventSelectRewardAdd))
    y3.gameApp:registerEvent(y3.EventConst.EVENT_SURVIVE_ABYSS_SHOP_RECHARGE_ADD,
        handler(self, self._onEventAbyssShopRefresh))
    y3.gameApp:registerEvent(y3.EventConst.EVENT_FUNC_CHECK_UPDATE, handler(self, self._onEventFuncCheckUpdate))
end

function SurviveGameAbyssChallengeUI:_onEventAbyssStartChallenge(trg, playerId)
    if playerId == y3.gameApp:getMyPlayerId() then
        self:updateUI()
    end
end

function SurviveGameAbyssChallengeUI:_onEventSelectRewardAdd(trg, playerId)
    if playerId == y3.gameApp:getMyPlayerId() then
        self:_bounsUpdate()
    end
end

function SurviveGameAbyssChallengeUI:_onEventAbyssShopRefresh(trg, playerId)
    if playerId == y3.gameApp:getMyPlayerId() then
        self:_updateAbyssNew()
    end
end

function SurviveGameAbyssChallengeUI:_onEventFuncCheckUpdate(trg, playerId, funcId)
    if playerId == y3.gameApp:getMyPlayerId() then
        if funcId == y3.FuncConst.FUNC_ABYSS then
            self._abyssBtnRoot:get_child("new"):set_visible(true)
        end
        if funcId == y3.FuncConst.FUNC_BLACKMARKET then
            self._abyssShopEventRoot:set_visible(y3.FuncCheck.checkFuncIsOpen(y3.gameApp:getMyPlayerId(), funcId))
        end
    end
end

function SurviveGameAbyssChallengeUI:_updateAbyssNew()
    self._abyssShopEventRoot:get_child("new"):set_visible(true)
end

function SurviveGameAbyssChallengeUI:updateUI()
    self:_updateChallengeBtn()
    self:_updateAbyssShopBtn()
end

function SurviveGameAbyssChallengeUI:_updateAbyssShopBtn()
    local abyssChallenge = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy"):getAbysChallenge()
    local abyssShop = abyssChallenge:getShop()
    local shopLv = abyssShop:getCurShopLv(y3.gameApp:getMyPlayerId())
    local time, maxtime, cnt = abyssShop:getShopParam(y3.gameApp:getMyPlayerId())
    self._stageAbyssShopBar:set_current_progress_bar_value(100 - time / maxtime * 100)
    local time_TEXT = self._stageAbyssShopBar:get_child("_time_TEXT")
    local min = math.floor(time / 60)
    local sec = math.floor(time % 60)
    if time > 0 then
        time_TEXT:set_text(string.format("%02d:%02d", min, sec))
    else
        self._stageAbyssShopBar:set_visible(false)
        time_TEXT:set_text("")
    end
    self._shopBtnLvText:set_text(string.format("lv.%d", shopLv))
end

function SurviveGameAbyssChallengeUI:_bounsUpdate()
    local abyssChallenge = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy"):getAbysChallenge()
    local bounsNum = abyssChallenge:getAbyssChallengeRecordNumByType(y3.gameApp:getMyPlayerId(), 1)
    local bounsNum3 = abyssChallenge:getAbyssChallengeRecordNumByType(y3.gameApp:getMyPlayerId(), 3)
    local bounsNum4 = abyssChallenge:getAbyssChallengeRecordNumByType(y3.gameApp:getMyPlayerId(), 4)
    self._bonus:set_visible((bounsNum3 + bounsNum + bounsNum4) > 0)
    self._bonus:get_child("_refresh_count_TEXT"):set_text(bounsNum + bounsNum3 + bounsNum4)
    local bounsNum2 = abyssChallenge:getAbyssChallengeRecordNumByType(y3.gameApp:getMyPlayerId(), 2)
    self._bigBonus:set_visible(bounsNum2 > 0)
    self._bigBonus:get_child("_refresh_count_TEXT"):set_text(bounsNum2)
end

function SurviveGameAbyssChallengeUI:_updateChallengeBtn()
    local abyssChallenge = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy"):getAbysChallenge()
    local id, doing, time, maxTime, challengeTime, maxChallengeTime, isEnd, close = abyssChallenge:getChallengeParam(y3
        .gameApp
        :getMyPlayerId())
    local gameStatus = y3.gameApp:getLevel():getLogic("SurviveGameStatus")
    self._abyssBtnRoot:set_visible(gameStatus:isInBattle())
    self._stage_abyss_current_floor_text:set_text(string.format(GameAPI.get_text_config('#30000001#lua21'), id))
    local readytime = gameStatus:getReadyEndTotalTime()
    if readytime <= self._abyssOpentime then
        time = self._abyssOpentime - readytime
        maxTime = self._abyssOpentime
    end

    if isEnd or close then
        if isEnd then
            self._stage_abyss_current_state_text:set_text(y3.langCfg.get(55).str_content)
        else
            self._stage_abyss_current_state_text:set_text(y3.langCfg.get(13).str_content)
        end
        self._stage_challenge_abyss_cd_prgress:set_visible(false)
        print("cccccccccccccccccccccccccccccc")
        return
    end
    local isState = 0
    if doing then
        isState = 1
        self._stage_abyss_current_state_text:set_text(y3.langCfg.get(54).str_content)
    else
        if time <= 0 then
            isState = 2
            self._stage_abyss_current_state_text:set_text(y3.langCfg.get(53).str_content)
        else
            isState = 3
            self._stage_abyss_current_state_text:set_text(y3.langCfg.get(57).str_content)
        end
    end
    self._stage_challenge_abyss_cd_prgress:set_visible(true)
    local exploring_ANIM = self._stageAbyssBtn:get_child("exploring_ANIM")
    local in_cd_ANIM = self._stageAbyssBtn:get_child("in_cd_ANIM")
    exploring_ANIM:set_visible(false)
    in_cd_ANIM:set_visible(false)
    if isState == 3 then
        exploring_ANIM:set_visible(false)
        in_cd_ANIM:set_visible(true)
        local min = math.floor(time / 60)
        local sec = math.floor(time % 60)
        self._time_TEXT:set_text(string.format("%02d:%02d", min, sec))
        self._stage_challenge_abyss_cd_prgress:set_current_progress_bar_value(100 - time / maxTime * 100)
    elseif isState == 2 then
        if self._lastInState ~= 2 then
            local refresh_ANIM = self._stageAbyssBtn:get_child("refresh_ANIM")
            refresh_ANIM:set_visible(true)
            refresh_ANIM:play_ui_sequence(false, 0.01)
        end
        self._stage_challenge_abyss_cd_prgress:set_visible(false)
    elseif isState == 1 then
        if challengeTime then
            exploring_ANIM:set_visible(true)
            in_cd_ANIM:set_visible(false)
            local min = math.floor(challengeTime / 60)
            local sec = math.floor(challengeTime % 60)
            self._time_TEXT:set_text(string.format("%02d:%02d", min, sec))
            self._stage_challenge_abyss_cd_prgress:set_current_progress_bar_value(100 -
                challengeTime / maxChallengeTime * 100)
        else
            self._stage_challenge_abyss_cd_prgress:set_visible(false)
        end
    else
        self._stage_challenge_abyss_cd_prgress:set_visible(false)
    end
    self._lastInState = isState
end

function SurviveGameAbyssChallengeUI:_onStageBbyssBtnClick(local_player)
    local isOpen = y3.FuncCheck.checkFuncIsOpen(y3.gameApp:getMyPlayerId(), y3.FuncConst.FUNC_ABYSS)
    if isOpen then
        self._abyssBtnRoot:get_child("new"):set_visible(false)
        y3.SyncMgr:sync(y3.SyncConst.SYNC_SURVIVE_STAGE_ABYSS_CHALLENGE_START, {})
    end
end

function SurviveGameAbyssChallengeUI:_onStageBbyssShopBtnClick(local_player)
    self._abyssShopEventRoot:get_child("new"):set_visible(false)
    self._root:showAbyssShop()
end

function SurviveGameAbyssChallengeUI:_onBonusBtnClick()
    y3.SyncMgr:sync(y3.SyncConst.SYNC_SURVIVE_ABYSS_CHALLENGE_BONUS_GET, { recordType = 1 })
end

function SurviveGameAbyssChallengeUI:_onBonusBtn2Click()
    y3.SyncMgr:sync(y3.SyncConst.SYNC_SURVIVE_ABYSS_CHALLENGE_BONUS_GET, { recordType = 2 })
end

return SurviveGameAbyssChallengeUI
