local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGamePlayerAllyIcon = class("SurviveGamePlayerAllyIcon", StaticUIBase)

local DOT_IMG_DIE = 134238498
local DOT_ALIVE = 134279883
local DOT_OFFLINE = 134239828

local HP_ME = 134227160
local HP_FRIEND = 134276059

local ME_BG = {
    [1] = 134223869,
    [2] = 134234685
}
local FRIEND_BG = {
    [1] = 134273246,
    [2] = 134221016
}

function SurviveGamePlayerAllyIcon:ctor(ui)
    SurviveGamePlayerAllyIcon.super.ctor(self, ui)
    self._player_avatar_ICON = self._ui:get_child("avatar.mask._player_avatar_ICON")
    self._dotImg = self._ui:get_child("avatar.dot")
    self._hpBar = self._ui:get_child("hp_BAR")
    self._hpBarImg = self._ui:get_child("hp_BAR.progress_bar_img")
    self._bgBtn = self._ui:get_child("bg_BTN")
    self._heroIcon = self._ui:get_child("avatar_hero.mask._player_avatar_ICON")

    self._bgBtn:add_local_event("左键-点击", handler(self, self._onPlayerAvatarClick))
end

function SurviveGamePlayerAllyIcon:updateUI(player, mainActor)
    local myPlayerId = y3.gameApp:getMyPlayerId()
    self._player = player
    if self._player:get_id() == myPlayerId then
        self._hpBarImg:set_image(HP_ME)
        self._bgBtn:set_image(ME_BG[1])
        self._bgBtn:set_hover_image_type(ME_BG[2])
    else
        self._hpBarImg:set_image(HP_FRIEND)
        self._bgBtn:set_image(FRIEND_BG[1])
        self._bgBtn:set_hover_image_type(FRIEND_BG[2])
    end

    if mainActor then
        self._player_avatar_ICON:set_image(mainActor:getHeroIcon())
        local mainUnit = mainActor:getUnit()
        local curHp = mainUnit:get_attr(y3.const.UnitAttr['生命'])
        local maxHp = mainUnit:get_attr(y3.const.UnitAttr['最大生命'])
        local hpPro = curHp / maxHp * 100
        self._hpBar:set_current_progress_bar_value(hpPro)
        local soulIcon = mainActor:getSoulHeroActor():getSoulIcon()
        self._heroIcon:set_image(soulIcon)
        if curHp > 0 then
            self._dotImg:set_image(DOT_ALIVE)
        else
            self._dotImg:set_image(DOT_IMG_DIE)
        end
    end
end

function SurviveGamePlayerAllyIcon:_onPlayerAvatarClick(local_player)
    local playerData = y3.userData:getPlayerData(self._player:get_id())
    local mainActor = playerData:getMainActor()
    if mainActor then
        y3.gameApp:moveCameraToPoint(local_player, mainActor:getPosition(), 0.3)
    end
end

return SurviveGamePlayerAllyIcon
