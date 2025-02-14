local StaticUIBase = include("gameplay.base.StaticUIBase")
local SettlementUI = class("SettlementUI", StaticUIBase)
local SettlementPlayerCell = include("gameplay.view.settlement.SettlementPlayerCell")

local MAX_PLAYER = 4

function SettlementUI:ctor(ui)
    SettlementUI.super.ctor(self, ui)
    self._content = self._ui:get_child("main.content")
    self._player1 = SettlementPlayerCell.new(self._ui:get_child("main.content.player_1"))
    self._player2 = SettlementPlayerCell.new(self._ui:get_child("main.content.player_2"))
    self._player2:setVisible(false)
    self._player3 = SettlementPlayerCell.new(self._ui:get_child("main.content.player_3"))
    self._player3:setVisible(false)
    self._player4 = SettlementPlayerCell.new(self._ui:get_child("main.content.player_4"))
    self._player4:setVisible(false)

    self._rewardGrid = self._ui:get_child("main.reward.content.reward_GRID")
    self._exitBtn = self._ui:get_child("control.exit_BTN")
    self._returnBtn = self._ui:get_child("control.return_BTN")

    self._exitBtn:get_child("title_TEXT"):set_text(GameAPI.get_text_config('#-1071397524#lua'))
    self._exitBtn:add_local_event("左键-点击", handler(self, self._onReturnBtnClick))
    -- local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    -- if playerData:isRoomMaster() then
    --     self._returnBtn:set_button_enable(true)
    -- else
    --     self._returnBtn:set_button_enable(false)
    --     self._returnBtn:get_child("title_TEXT"):set_text(GameAPI.get_text_config('#-2061647079#lua'))
    -- end
    self._awardIcons = {}
end

function SettlementUI:updatePlayer()
    local allInPlayers = y3.userData:getAllInPlayers()
    local totalBossDamage = 0
    for i = 1, #allInPlayers do
        local playerData = allInPlayers[i]
        local mainActor = playerData:getMainActor()
        totalBossDamage = totalBossDamage + mainActor:getFinalBossHurt()
    end
    for i = 1, MAX_PLAYER do
        local playerData = allInPlayers[i]
        local playerUI   = self["_player" .. i]
        playerUI:updateUI(playerData, totalBossDamage)
    end
end

function SettlementUI:updateReward()
    local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local dropAwards = playerData:getRecordDrop()
    dropAwards = y3.userDataHelper.mergeAwards(dropAwards)
    for i = 1, #dropAwards do
        local icon = self._awardIcons[i]
        if not icon then
            icon = include("gameplay.view.settlement.SettlementIcon").new(self._rewardGrid)
            self._awardIcons[i] = icon
        end
        icon:updateUI(dropAwards[i])
    end
end

function SettlementUI:_onReturnBtnClick()
    -- local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    -- if playerData:isRoomMaster() then
    y3.gameApp:restart()
    -- else
    --     y3.Sugar.localTips(y3.gameApp:getMyPlayerId(), "您不是房主")
    -- end
end

return SettlementUI
