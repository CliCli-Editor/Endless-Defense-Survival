local StaticUIBase             = include("gameplay.base.StaticUIBase")
local SurviveMenuMaintitleView = class("SurviveMenuMaintitleView", StaticUIBase)

function SurviveMenuMaintitleView:ctor()
    local ui = y3.UIHelper.getUI("f762ecbe-f23b-4a4a-bf8e-9b399200278f")
    SurviveMenuMaintitleView.super.ctor(self, ui)
    self:onInit()
end

function SurviveMenuMaintitleView:onInit()
    self._click_to_start_TEXT = y3.UIHelper.getUI("ca5a8efb-f554-4de9-90ec-7095e5e31d0c")
    self._copy_right_TEXT = y3.UIHelper.getUI("680c1afa-7e54-4240-a4bb-9479fa09e0bd")
    self._game_mode_TEXT = y3.UIHelper.getUI("06ccb3f5-62e7-443a-afb9-a4de18263103")
    self._game_version_TEXT = y3.UIHelper.getUI("502159a1-d2e5-4e94-9015-f76cce732d17")
    self._logo = y3.UIHelper.getUI("17d9c851-ef6b-4a65-bfe3-08a6f97642df")
    self:_initUI()
    self:fadeLowHp()
end

function SurviveMenuMaintitleView:fadeLowHp()
    print(y3.const.UIAnimKey["menu_maintitle"])
    local player = y3.player(y3.gameApp:getMyPlayerId())

    GameAPI.stop_ui_comp_anim(player.handle, y3.const.UIAnimKey["menu_maintitle_clicktostart"])
    GameAPI.stop_ui_comp_anim(player.handle, y3.const.UIAnimKey["menu_maintitle_logo"])
    self._click_to_start_TEXT:set_alpha(0)
    self._logo:set_alpha(0)

    y3.ltimer.wait_frame(20, function(timer, count)
        self._logo:set_visible(true)
        y3.ui.play_timeline_animation(player, y3.const.UIAnimKey["menu_maintitle_logo"], 1, false)  --, 1, 4)
        -- y3.ltimer.wait_frame(86, function(timer, count)
        --     GameAPI.stop_ui_comp_anim(player.handle, y3.const.UIAnimKey["menu_maintitle_logo"])
        --     self._logo:set_alpha(255)
        -- end)
        y3.ltimer.wait_frame(60, function(timer, count)
            self._click_to_start_TEXT:set_alpha(0)
            y3.ui.play_timeline_animation(player, y3.const.UIAnimKey["menu_maintitle_clicktostart"], 1, true) --  300, 1, 3)
        end)
    end)
    --[[
    self._click_to_start_TEXT:set_alpha(0)
    local fade = include("gameplay.utils.uiAction.FadeTo").new(self._click_to_start_TEXT, 0, 255, 3)
    fade:run(0)
    local fade = include("gameplay.utils.uiAction.FadeTo").new(self._click_to_start_TEXT, 255, 0, 3)
    fade:run(0)
    local sequence = include("gameplay.utils.uiAction.Sequence").new()
    sequence:run(fade, fade)
    local loop = include("gameplay.utils.uiAction.Loop").new()
    loop:runAction(sequence)
    ]]
end

function SurviveMenuMaintitleView:_initUI()
    local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local roomMasterPlayerData = y3.userData:getRoomMasterPlayerData()
    if playerData:getId() == roomMasterPlayerData:getId() then
        self._click_to_start_TEXT:set_text(GameAPI.get_text_config('#-1893867201#lua'))
    else
        self._click_to_start_TEXT:set_text("GameAPI.get_text_config('#30000001#lua17')【" .. roomMasterPlayerData:getPlayerName() .. "】GameAPI.get_text_config('#30000001#lua18')")
    end
end

return SurviveMenuMaintitleView
