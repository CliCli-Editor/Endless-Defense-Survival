local SurviveGamePlayerInfoTip = class("SurviveGamePlayerInfoTip")

function SurviveGamePlayerInfoTip:ctor()
    self._ui = y3.UIHelper.getUI("042d79f2-17de-47a3-b6f8-99504ea2538e")
    self._ui:set_anchor(0, 0)
    self._player_damage            = y3.UIHelper.getUI("d56bf2e7-4ab3-45ac-ba9a-2488f2f630d2")
    self._player_damage_num_text   = y3.UIHelper.getUI("6808b97d-f940-4072-b427-2b48ed3b1ba1")
    self._player_region            = y3.UIHelper.getUI("f112c368-c675-4fd6-bceb-594a1b1e2454")
    self._player_regen_text        = y3.UIHelper.getUI("524e6b69-72ba-4b78-aa1b-3b352d0f06b5")
    self._player_armor             = y3.UIHelper.getUI("6e79c09c-8651-4c34-9199-7aaa4e9c105c")
    self._armor_text               = y3.UIHelper.getUI("0e6a8ed5-39c5-4885-98bc-9e4d3563df2b")
    self._player_dam_decrease      = y3.UIHelper.getUI("5ae93aaa-e4ff-43b7-9270-2ef54339a561")
    self._player_dam_decrease_text = y3.UIHelper.getUI("d2e6673b-4f0e-44a2-a374-c5c4776c77a4")

    self._player_damage:get_child("_title_TEXT"):set_text(y3.langCfg.get(72).str_content)
end

function SurviveGamePlayerInfoTip:show()
    local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local player = playerData:getPlayer()
    local gameHud = y3.gameApp:getLevel():getView("SurviveGameHUD")
    local mainActor = playerData:getMainActor()
    self._player_damage:set_visible(false)
    if gameHud and not gameHud:getHeadUI():isShowTower() then
        mainActor = mainActor:getSoulHeroActor()
        self._player_damage:set_visible(true)
    end
    if mainActor then
        y3.UIActionMgr:playFadeAction(self._ui)

        self._ui:set_visible(true)

        local unit           = mainActor:getUnit()
        local atk            = math.floor(unit:get_attr(y3.const.UnitAttr['物理攻击']))
        local recover        = math.floor(unit:get_attr(y3.const.UnitAttr['生命恢复']))
        local def            = math.floor(unit:get_attr(y3.const.UnitAttr['物理防御']))

        local targetHuJia    = unit:get_attr("物理防御")
        local sourceChuantou = 0
        local defenseRate    = 0
        if targetHuJia - sourceChuantou >= 0 then
            defenseRate = (targetHuJia - sourceChuantou) * 0.05 / (1 + 0.05 * (targetHuJia - sourceChuantou))
        else
            local tempp = 0.99 ^ (targetHuJia - sourceChuantou)
            defenseRate = 1 - tempp
        end
        defenseRate = math.floor(defenseRate * 100)

        self._player_dam_decrease_text:set_text(defenseRate .. "%")
        self._player_damage_num_text:set_text(atk)
        self._player_regen_text:set_text(recover .. "/s")
        self._armor_text:set_text("")
        self._player_armor:set_text(def)

        local xOffset, yOffset = y3.UIHelper.limitTipOffset(y3.gameApp:getMyPlayerId(), self._ui)
        self._ui:set_follow_mouse(true, xOffset, yOffset)
    end
end

function SurviveGamePlayerInfoTip:hide()
    self._ui:set_follow_mouse(false, 10, 20)
    self._ui:set_visible(false)
end

return SurviveGamePlayerInfoTip
