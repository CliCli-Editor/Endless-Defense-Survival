local SurviveGameItemTip       = include "gameplay.view.tip.SurviveGameItemTip"
local SurviveGamePlayerInfoTip = include "gameplay.view.tip.SurviveGamePlayerInfoTip"
local SurviveGameUIMouseTip    = include "gameplay.view.tip.SurviveGameUIMouseTip"
local SurviveGameMonsterDefTip = include "gameplay.view.tip.SurviveGameMonsterDefTip"
local SurviveGameMonsterAtkTip = include "gameplay.view.tip.SurviveGameMonsterAtkTip"
local ViewBase                 = include("gameplay.base.ViewBase")
local SurviveGameTip           = class("SurviveGameTip", ViewBase)
local SurviveGameSkillTip      = include("gameplay.view.tip.SurviveGameSkillTip")
local SurviveGameUniversalTip  = include("gameplay.view.tip.SurviveGameUniversalTip")

function SurviveGameTip:ctor()
    SurviveGameTip.super.ctor(self, "global_tip")
end

function SurviveGameTip:onInit()
    self._uiMosue = SurviveGameUIMouseTip.new(self)

    self._skillTip = SurviveGameSkillTip.new(y3.UIHelper.getUI("89fe2a56-87e5-4823-b902-d261b24e3cca"), self)
    self._universalTip = SurviveGameUniversalTip.new(y3.UIHelper.getUI("b7848ad6-6c61-4d1d-a072-2a4e4cb84473"), self)
    self._itemTip = SurviveGameItemTip.new()
    self._miniTip = include("gameplay.view.tip.SurviveGameMiniTip").new()

    self._sliderTip = include("gameplay.view.tip.SurviveGameSliderTip").new()

    self._monsterAtkTip = SurviveGameMonsterAtkTip.new(self)
    self._monsterDefTip = SurviveGameMonsterDefTip.new(self)
    self._playerInfoTip = SurviveGamePlayerInfoTip.new(self)
    self._infoTipMap = {}
    self._infoTipMap[y3.SurviveConst.UI_MOUSE_TYPE_MONSTER_ATK] = self._monsterAtkTip
    self._infoTipMap[y3.SurviveConst.UI_MOUSE_TYPE_MONSTER_DEF] = self._monsterDefTip
    self._infoTipMap[y3.SurviveConst.UI_MOUSE_TYPE_PLAYER_INFO] = self._playerInfoTip
end

function SurviveGameTip:pushSlider(data)
    self._sliderTip:pushNotice(data)
end

function SurviveGameTip:showSkillTip(data)
    self._skillTip:show(data)
end

function SurviveGameTip:hideSkillTip()
    self._skillTip:hide()
end

function SurviveGameTip:showUniversalTip(data)
    self._universalTip:show(data)
end

function SurviveGameTip:hideUniversalTip()
    self._universalTip:hide()
end

function SurviveGameTip:showMiniTip(data)
    self._miniTip:show(data)
end

function SurviveGameTip:hideMiniTip()
    self._miniTip:hide()
end

function SurviveGameTip:showInfoTip(tipType, cfgId)
    if self._infoTipMap[tipType] == nil then
        return
    end
    self._infoTipMap[tipType]:show()
end

function SurviveGameTip:hideInfoTip(tipType)
    if self._infoTipMap[tipType] == nil then
        return
    end
    self._infoTipMap[tipType]:hide()
end

function SurviveGameTip:showItemTip(cfgId, item)
    self._itemTip:show(cfgId, item)
end

function SurviveGameTip:hideItemTip()
    self._itemTip:hide()
end

return SurviveGameTip
