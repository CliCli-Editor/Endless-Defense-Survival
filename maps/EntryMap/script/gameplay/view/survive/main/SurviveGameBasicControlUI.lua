local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGameBasicControlUI = class("SurviveGameBasicControlUI", StaticUIBase)

function SurviveGameBasicControlUI:ctor(root)
    self._root = root
    local ui = y3.UIHelper.getUI("d90b51c1-7a93-488a-9aa8-870e5b80e6eb")
    SurviveGameBasicControlUI.super.ctor(self, ui)
    self:init()
    y3.game:event("本地-键盘-按下", y3.const.KeyboardKey['X'], function(trg, data)
        self:_on_click_static(data.player)
    end)
    y3.game:event("本地-键盘-按下", y3.const.KeyboardKey['C'], function(trg, data)
        self:_on_click_stat(data.player)
    end)
    y3.game:event("本地-键盘-按下", y3.const.KeyboardKey['V'], function(trg, data)
        self:_on_click_wiki(data.player)
    end)
    y3.game:event("本地-键盘-按下", y3.const.KeyboardKey['B'], function(trg, data)
        self:_on_click_inventory(data.player)
    end)
    self._powerText = y3.UIHelper.getUI("31eeccd7-44d8-40c3-87db-16a2fadb6990")
    -- y3.gameApp:registerEvent(y3.EventConst.EVENT_SURVIVE_ATTR_CHANGE, handler(self, self._onEventPowerUpdate))
    -- y3.gameApp:registerEvent(y3.EventConst.EVENT_HERO_ACTOR_ADD_SKILL,
    --     handler(self, self._onEventPowerUpdate))
    y3.gameApp:registerEvent(y3.EventConst.EVENT_SURVIVE_REFRESH_DPS, handler(self, self._onEventPowerUpdate))
end

function SurviveGameBasicControlUI:_onEventPowerUpdate(trg, playerId)
    self:updatePower()
end

function SurviveGameBasicControlUI:updatePower()
    local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local mainActor = playerData:getMainActor()
    self._powerText:set_text(math.floor(mainActor:getPower()) .. "")
end

function SurviveGameBasicControlUI:init()
    local cells = self._ui:get_childs()
    for _, cell in ipairs(cells) do
        local name = cell:get_name()
        local btn = cell:get_child("open_win_BTN")
        btn:add_local_event("左键-点击", function(local_player)
            local clickFunc = self["_on_click_" .. name]
            if clickFunc then
                clickFunc(self, local_player)
            end
        end)
    end
end

function SurviveGameBasicControlUI:_on_click_wiki(local_player)
    self._root:toggleWiki()
end

function SurviveGameBasicControlUI:_on_click_static(local_player)
    self._root:toggleStatics()
end

function SurviveGameBasicControlUI:_on_click_stat(local_player)
    self._root:toggleStat()
end

function SurviveGameBasicControlUI:_on_click_inventory(local_player)
    self._root:toggleInventory()
end

return SurviveGameBasicControlUI
