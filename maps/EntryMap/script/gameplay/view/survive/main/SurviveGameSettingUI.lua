local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGameSettingUI = class("SurviveGameSettingUI", StaticUIBase)

function SurviveGameSettingUI:ctor(root)
    self._root = root
    local ui = y3.UIHelper.getUI("ee047713-9d91-4132-8a4c-0dae4463086d")
    SurviveGameSettingUI.super.ctor(self, ui)

    self._bg = y3.UIHelper.getUI("691af96e-0069-4ec3-ba22-cc1109b48b54")
    -- self._bg:set_intercepts_operations(true)
    self._back_to_game_BTN = y3.UIHelper.getUI("572b0e83-cbe0-40d8-9476-434dd0d68f8e")
    self._game_pause_BTN = y3.UIHelper.getUI("576dbad0-1e6f-4d09-9592-7071d51d758a")
    self._game_settings_BTN = y3.UIHelper.getUI("6fcadaf5-e494-48af-82c1-ac5e43fd8ecc")
    self._system_settings_BTN = y3.UIHelper.getUI("76272582-6609-44a4-bee1-0e37eb130f85")
    self._back_to_main_BTN = y3.UIHelper.getUI("43d35944-09ad-4ac4-84bd-b3b83d035496")
    self._exit_BTN = y3.UIHelper.getUI("34407e82-b34a-49a8-aa91-9d3935f6573d")

    self._settPanel = y3.UIHelper.getUI("5fa8acf7-bc24-4ea3-9865-6516bb0b7d06")

    self._back_to_main_BTN:set_visible(true)
    self._back_to_game_BTN:set_intercepts_operations(true)
    self._game_pause_BTN:set_intercepts_operations(true)
    self._game_settings_BTN:set_intercepts_operations(true)
    self._system_settings_BTN:set_intercepts_operations(true)
    self._exit_BTN:set_intercepts_operations(true)
    self._back_to_main_BTN:set_intercepts_operations(true)

    -- self._game_settings_BTN:set_visible()
    -- self._system_settings_BTN:set_visible(false)
    -- self._exit_BTN:set_visible(false)
    self._innerSettingUI = include("gameplay.view.survive.main.SurviveGameInnerSettingUI").new()

    self._back_to_game_BTN:add_local_event("左键-按下", handler(self, self._on_back_to_game_BTN_click))
    self._game_pause_BTN:add_local_event("左键-按下", handler(self, self._on_game_pause_BTN_click))
    self._game_settings_BTN:add_local_event("左键-按下", handler(self, self._on_game_settings_BTN_click))
    self._system_settings_BTN:add_local_event("左键-按下", handler(self, self._on_system_settings_BTN_click))
    self._back_to_main_BTN:add_local_event("左键-按下", handler(self, self._on_back_to_main_BTN_click))
    -- self._exit_BTN:add_local_event("左键-按下", handler(self, self._on_exit_BTN_click))

    y3.gameApp:registerEvent(y3.EventConst.EVENT_SURVIVE_GAME_PAUSE, handler(self, self._onEventGamePause))
end

function SurviveGameSettingUI:_onEventGamePause()
    local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local pauseCount = playerData:getPauseCount()
    local playerCount = y3.userData:getPlayerCount()
    if playerCount > 1 then
        self._game_pause_BTN:get_child("title_TEXT"):set_text("GameAPI.get_text_config('#30000001#lua25')(" .. playerData:getPauseCount() .. "GameAPI.get_text_config('#30000001#lua04'))")
        self._game_pause_BTN:set_button_enable(pauseCount > 0)
    else
        self._game_pause_BTN:get_child("title_TEXT"):set_text(GameAPI.get_text_config('#1942999347#lua'))
        self._game_pause_BTN:set_button_enable(true)
    end
end

function SurviveGameSettingUI:_on_back_to_game_BTN_click(local_player)
    -- self:setVisible(false)
    self:show(false)
end

function SurviveGameSettingUI:_on_game_pause_BTN_click(local_player)
    y3.SyncMgr:sync(y3.SyncConst.SYNC_SURVIVE_PAUSE_GAME, { pause = true })
end

function SurviveGameSettingUI:_on_game_settings_BTN_click(local_player)
    self._innerSettingUI:show(not self._innerSettingUI:isVisible())
end

function SurviveGameSettingUI:_on_system_settings_BTN_click(local_player)
    self._settPanel:set_visible(true)
end

function SurviveGameSettingUI:_on_back_to_main_BTN_click(local_player)
    if y3.gameApp:getLevel():isGameStart() then
        y3.gameApp:restart()
    else
        self:show(false)
    end
end

---comment
---@param local_player Player
function SurviveGameSettingUI:_on_exit_BTN_click(local_player)
    local_player:exit_game()
end

function SurviveGameSettingUI:show(visi)
    self:setVisible(visi)
    if visi then
        self:_onEventGamePause()
    else
        self._innerSettingUI:show(false)
    end
end

return SurviveGameSettingUI
