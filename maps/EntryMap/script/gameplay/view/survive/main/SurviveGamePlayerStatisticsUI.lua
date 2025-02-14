local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGamePlayerStatisticsUI = class("SurviveGamePlayerStatisticsUI", StaticUIBase)

local TAB_DPS_SKILL = 1
local TAB_DPS_PLAYER = 2
local TAB_KILL_NUM = 3

local INIT_DPS = 500
local INIT_PER_SKILL = 300
local INIT_BAR = 2000

local NORMAL_IMG = 134270277
local SELECT_IMG = 134268071

function SurviveGamePlayerStatisticsUI:ctor(root)
    self._root = root
    local ui = y3.UIHelper.getUI("2d0d3c5d-e364-426f-b8f5-c9f941692b77")
    SurviveGamePlayerStatisticsUI.super.ctor(self, ui)
    self._fold_BTN                   = y3.UIHelper.getUI("39288081-7d65-4cac-9b4a-074853bbe843")
    self._main                       = y3.UIHelper.getUI("0bd89cd9-6492-454d-b184-2d5287fa34f6")

    self._tabIndex                   = TAB_DPS_SKILL
    self._dps_per_skill_BTN          = y3.UIHelper.getUI("3da9f5fd-7f0c-499a-ac27-38c16d07ceb8")
    self._dps_per_player_BTN         = y3.UIHelper.getUI("f7b9e524-d2d8-4d9d-beef-b4832a70d492")
    self._kills_count_per_player_BTN = y3.UIHelper.getUI("b4138fef-bdba-4441-a09a-cdf9a625707c")
    self._time_TEXT                  = y3.UIHelper.getUI("d141101a-7c49-4649-80d7-6cbbf55c3879")
    self._core                       = y3.UIHelper.getUI("1574a4a3-f345-4cf6-8b63-7d7831b35a8f")
    self._tabBtnList                 = {}
    table.insert(self._tabBtnList, self._dps_per_skill_BTN)
    table.insert(self._tabBtnList, self._dps_per_player_BTN)
    table.insert(self._tabBtnList, self._kills_count_per_player_BTN)
    self._fold_BTN:add_local_event('左键-按下', handler(self, self._onFoldBtnClick))
    self._dps_per_skill_BTN:add_local_event('左键-按下', handler(self, self._onDpsPerSkillBtnClick))
    self._dps_per_player_BTN:add_local_event('左键-按下', handler(self, self._onDpsPerPlayerBtnClick))
    self._kills_count_per_player_BTN:add_local_event('左键-按下', handler(self, self._onKillsCountPerPlayerBtnClick))


    --
    self._stageConfig = include("gameplay.config.stage_config").get(y3.userData:getCurStageId())
    self.INIT_DPS = self._stageConfig.dps_p
    self.INIT_BAR = self._stageConfig.dps_p2
    self.INIT_PER_SKILL = self._stageConfig.kill_num
    --
    self:_updateTabBtn()
    self:updateUI()
    self:_onFoldBtnClick(nil)
end

function SurviveGamePlayerStatisticsUI:updateUI()
    if self._tabIndex == TAB_DPS_SKILL then
        self:_updateSkillDps()
    elseif self._tabIndex == TAB_DPS_PLAYER then
        self:_updatePlayerDps()
    elseif self._tabIndex == TAB_KILL_NUM then
        self:_updateKillsCountPerPlayer()
    end
    local gameStatus = y3.gameApp:getLevel():getLogic("SurviveGameStatus")
    local totalGameTime = gameStatus:getTotalGameTime()
    local hour = math.floor(totalGameTime / 3600)
    local minute = math.floor((totalGameTime - hour * 3600) / 60)
    local second = totalGameTime - hour * 3600 - minute * 60
    self._time_TEXT:set_text(string.format(GameAPI.get_text_config('#30000001#lua24'), hour, minute, second))
end

function SurviveGamePlayerStatisticsUI:_updateSkillDps()
    local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local mainActor = playerData:getMainActor()
    local dpsSkills = mainActor:getSkillAllTimeDps()
    table.sort(dpsSkills, function(a, b)
        return a.dps > b.dps
    end)
    local maxBar = self.INIT_DPS
    if dpsSkills[1] and dpsSkills[1].dps > maxBar then
        maxBar = dpsSkills[1].dps
    end
    local cells = self._core:get_childs()
    for i, cell in ipairs(cells) do
        local titleText = cell:get_child("_title_TEXT")
        local bar = cell:get_child("_value_BAR")
        local icon = cell:get_child("avatar.mask._icon_IMG")
        local valueText = cell:get_child("_value_BAR._value_TEXT")
        local data = dpsSkills[i]
        if data then
            cell:set_visible(true)
            local cfg = include("gameplay.config.config_skillData").get(tostring(data.key))
            titleText:set_text(cfg.name)
            bar:set_current_progress_bar_value(data.dps / maxBar * 100, 0.3)
            icon:set_image(tonumber(cfg.icon))
            valueText:set_text(y3.gameUtils.convertText(data.dps) .. "/s")
        else
            cell:set_visible(false)
        end
    end
end

function SurviveGamePlayerStatisticsUI:_updatePlayerDps()
    local cells = self._core:get_childs()
    local allInPlayers = y3.userData:getAllInPlayers()
    local maxDps = self.INIT_BAR
    for i, playerData in ipairs(allInPlayers) do
        local mainActor = playerData:getMainActor()
        local dps = mainActor:getTotalDps()
        if dps >= maxDps then
            maxDps = dps
        end
    end
    for i, cell in ipairs(cells) do
        local titleText = cell:get_child("_title_TEXT")
        local bar = cell:get_child("_value_BAR")
        local icon = cell:get_child("avatar.mask._icon_IMG")
        local valueText = cell:get_child("_value_BAR._value_TEXT")
        local playerData = allInPlayers[i]
        if playerData then
            local player = playerData:getPlayer()
            local mainActor = playerData:getMainActor()
            titleText:set_text(player:get_name())
            icon:set_image(mainActor:getUnit():get_icon())
            valueText:set_text(y3.gameUtils.convertText(mainActor:getTotalDps()) .. "/s")
            bar:set_current_progress_bar_value(mainActor:getTotalDps() / maxDps * 100, 0.3)
            cell:set_visible(true)
        else
            cell:set_visible(false)
        end
    end
end

function SurviveGamePlayerStatisticsUI:_updateKillsCountPerPlayer()
    local cells = self._core:get_childs()
    local allInPlayers = y3.userData:getAllInPlayers()
    local maxBar = self.INIT_PER_SKILL
    for i, playerData in ipairs(allInPlayers) do
        local killNum = playerData:getAllKillNum()
        if killNum >= maxBar then
            maxBar = killNum
        end
    end
    for i, cell in ipairs(cells) do
        local titleText = cell:get_child("_title_TEXT")
        local bar = cell:get_child("_value_BAR")
        local icon = cell:get_child("avatar.mask._icon_IMG")
        local valueText = cell:get_child("_value_BAR._value_TEXT")
        local playerData = allInPlayers[i]
        if playerData then
            local player = playerData:getPlayer()
            local mainActor = playerData:getMainActor()
            titleText:set_text(player:get_name())
            icon:set_image(mainActor:getUnit():get_icon())
            local killNum = math.floor(playerData:getAllKillNum())
            valueText:set_text(y3.gameUtils.convertText2(killNum))
            bar:set_current_progress_bar_value(killNum / maxBar * 100, 0.3)
            cell:set_visible(true)
        else
            cell:set_visible(false)
        end
    end
end

function SurviveGamePlayerStatisticsUI:_onFoldBtnClick(local_player)
    self._main:set_visible(not self._main:is_visible())
    if self._main:is_visible() then
        self._fold_BTN:set_widget_absolute_scale(1, 1)
    else
        self._fold_BTN:set_widget_absolute_scale(-1, 1)
    end
end

function SurviveGamePlayerStatisticsUI:_updateTabBtn()
    for i = 1, #self._tabBtnList do
        local title_TEXT = self._tabBtnList[i]:get_child("title_TEXT")
        if i == self._tabIndex then
            self._tabBtnList[i]:set_image(SELECT_IMG)
            title_TEXT:set_text_color_hex("#ffffff", 255)
        else
            self._tabBtnList[i]:set_image(NORMAL_IMG)
            title_TEXT:set_text_color_hex("#c9c8ce", 255)
        end
    end
end

function SurviveGamePlayerStatisticsUI:_onDpsPerSkillBtnClick(local_player)
    self._tabIndex = TAB_DPS_SKILL
    self:_updateTabBtn()
    self:updateUI()
end

function SurviveGamePlayerStatisticsUI:_onDpsPerPlayerBtnClick(local_player)
    self._tabIndex = TAB_DPS_PLAYER
    self:_updateTabBtn()
    self:updateUI()
end

function SurviveGamePlayerStatisticsUI:_onKillsCountPerPlayerBtnClick(local_player)
    self._tabIndex = TAB_KILL_NUM
    self:_updateTabBtn()
    self:updateUI()
end

return SurviveGamePlayerStatisticsUI
