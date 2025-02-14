local GlobalConfigHelper = require "gameplay.level.logic.helper.GlobalConfigHelper"
local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGameRewardSkillSelectUI = class("SurviveGameRewardSkillSelectUI", StaticUIBase)
local SurviveGameRewardSkillCard = include("gameplay.view.survive.main.SurviveGameRewardSkillCard")

local MAX_CARD = 3

function SurviveGameRewardSkillSelectUI:ctor(callback)
    self._callback = callback
    local ui = y3.UIHelper.getUI("99570e1c-1712-4273-a8c3-f995b2950c88")
    SurviveGameRewardSkillSelectUI.super.ctor(self, ui)
    self._reward_choose_LIST = y3.UIHelper.getUI("45a8a8bd-eaab-4c80-acaa-3c86c2170ab7")
    self._refreshBtn = y3.UIHelper.getUI("96c811f1-73e6-4151-90da-e47fc1f4d3fd")
    self._refreshBtnText = y3.UIHelper.getUI("71a95c8b-34d8-4db7-b57b-21a8fdad2751")
    self._consume = y3.UIHelper.getUI("6412e4d4-2d75-4485-acec-e63774a24fa7")
    self._consume_icon_img = y3.UIHelper.getUI("0e65f541-224c-4f72-8f86-3bb801fc6e18")
    self._consume_text = y3.UIHelper.getUI("353b7bb4-cdcc-4390-8e55-5079557baf1a")
    -- self._refreshBtn:set_visible(false)
    self._consume:set_visible(false)
    self._refreshBtnText:set_text(GameAPI.get_text_config('#-1526313345#lua'))
    self._selectIndex = 1
    self._skillCards = {}

    self._refreshBtn:add_local_event("左键-点击", handler(self, self._onRefreshBtnClick))
    for i = 1, MAX_CARD do
        self._skillCards[i] = SurviveGameRewardSkillCard.new(self._reward_choose_LIST)
        local cardUi = self._skillCards[i]:getUI()
        cardUi:add_local_event("左键-点击", function(local_player)
            if self._lockSelect then
                return
            end
            if self._rewardData and self._rewardData.type == 2 then
                self:_onCardClick2(i)
            end
            if self._rewardData and (self._rewardData.type == 1 or self._rewardData.type == 3 or self._rewardData.type == 4) then
                self:_onCardClick(i)
            end
        end)
        cardUi:add_local_event('左键-双击', function(local_player)
            if self._lockSelect then
                return
            end
        end)
        cardUi:add_local_event("鼠标-移入", function()
            if self._lockSelect then
                return
            end
            self._selectIndex = i
            self:_updateSelect()
        end)
    end
    self._ui:add_local_event("左键-点击", function(local_player)
        if self._rewardData and self._rewardData.type == 2 then
            if self._lockSelect then
                return
            end
            self:close()
        end
    end)
end

function SurviveGameRewardSkillSelectUI:_updateCardPos()
    local totalWidth = self._reward_choose_LIST:get_width()
    local totalHeight = self._reward_choose_LIST:get_height()
    local cardWidth = self._skillCards[1]:getUI():get_width()
    local startx = totalWidth * 0.5 - (cardWidth) - 25
    for i = 1, MAX_CARD do
        local cardUi = self._skillCards[i]:getUI()
        local posy = totalHeight * 0.5
        cardUi:set_pos(startx, posy)
        startx = startx + (cardWidth + 50)
    end
end

function SurviveGameRewardSkillSelectUI:_updateSelect()
    for i = 1, #self._skillCards do
        self._skillCards[i]:updateSelect(i == self._selectIndex)
    end
end

function SurviveGameRewardSkillSelectUI:_delayHide()
    y3.UIActionMgr:stopAllActions(self._ui)
    local timeneed = GlobalConfigHelper.get(43)
    local delaytime = include("gameplay.utils.uiAction.DelayTime").new(self._ui, timeneed, function()
        self:close()
    end)
    delaytime:runAction(1)
end

-- hud.button.shop.main.upgrade.3.main.res._res_gold_TEXT
function SurviveGameRewardSkillSelectUI:show(recordIndex)
    if self._lockSelect then
        return
    end
    local spawnEnemy = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy")
    self._recordIndex = recordIndex
    self._rewardData = spawnEnemy:getAbysChallenge():getAbyssChallengeRecordList(y3.gameApp:getMyPlayerId(), recordIndex)
    self._list = self._rewardData.list
    if not self._list then
        self:close()
        return
    end
    if self._rewardData.type ~= 3 then
        self:_delayHide()
    end
    self._refreshBtn:set_visible(false)

    if self._rewardData.type == 3 then
        local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
        local mainActor = playerData:getMainActor()
        local soulActor = mainActor:getSoulHeroActor()
        if not soulActor:isSoul() then
            self._refreshBtn:set_visible(true)
            self._refreshBtnText:set_text(y3.langCfg.get(52).str_content)
        end
    end
    self:_updateCardPos()
    self._selectIndex = 1
    self:_updateSelect()
    self:setVisible(true)
    for i = 1, MAX_CARD do
        y3.UIActionMgr:stopAllActions(self._skillCards[i]:getUI())
        if self._list[i] then
            self._skillCards[i]:setVisible(true)
            self._skillCards[i]:updateUI(self._list[i], self._rewardData.type)
        else
            self._skillCards[i]:setVisible(false)
        end
    end
end

function SurviveGameRewardSkillSelectUI:close()
    if self._callback then
        self._callback(self._recordIndex)
    end
    self:setVisible(false)
end

function SurviveGameRewardSkillSelectUI:_onCardClick(index)
    if self._list[index] then
        y3.SyncMgr:sync(y3.SyncConst.SYNC_REWARD_SKILL_SELECT,
            { recordIndex = self._recordIndex, itemId = self._list[index].id })
    end
    self:close()
end

function SurviveGameRewardSkillSelectUI:_onCardClick2(index)
    self._lockSelect = true
    if self._skillCards[index] then
        y3.UIActionMgr:stopAllActions(self._ui)
        local cnIndex = 2
        for i = 1, MAX_CARD do
            if i == index then
                self._skillCards[i]:updateUI(self._list[1], self._rewardData.type)
                self._skillCards[i]:playAnim()
            else
                self._skillCards[i]:updateUI(self._list[cnIndex], self._rewardData.type)
                cnIndex = cnIndex + 1
                self._skillCards[i]:playNormalCard()
            end
        end
        y3.SyncMgr:sync(y3.SyncConst.SYNC_REWARD_SKILL_SELECT,
            { recordIndex = self._recordIndex, itemId = self._list[1].id })
        local cardName = self._skillCards[index]:getCardName()
        y3.Sugar.localNotice(y3.gameApp:getMyPlayerId(), 41, { reward_name = cardName })
        y3.ctimer.wait(3.5, function(timer, count, local_player)
            self._lockSelect = false
            self:close()
        end)
    else
        self:close()
    end
end

function SurviveGameRewardSkillSelectUI:_onRefreshBtnClick(local_player)
    if self._rewardData.type == 3 then
        y3.SyncMgr:sync(y3.SyncConst.SYNC_REMOVE_REWARD_SELECT, { recordIndex = self._recordIndex })
        self:close()
    end
end

return SurviveGameRewardSkillSelectUI
