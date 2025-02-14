local UserDataHelper = include "gameplay.level.logic.helper.UserDataHelper"
local SurviveGameMiniTip = class("SurviveGameMiniTip")

function SurviveGameMiniTip:ctor(root)
    self._ui = y3.UIHelper.getUI("99f1b88e-6832-4b66-a578-698eec4c8751")
    self._ui:set_anchor(0, 0)
    self._root = root
    self._descText = y3.UIHelper.getUI("54102b75-5ac6-412f-b3dd-51d74cbab5c7")
end

function SurviveGameMiniTip:show(data)
    self._ui:set_visible(true)
    self._data = data
    self._descText:set_text(data.desc)
    self._hide = false
    local xOffset, yOffset = y3.UIHelper.limitTipOffset(y3.gameApp:getMyPlayerId(), self._ui)
    self._ui:set_follow_mouse(true, xOffset, yOffset)
    y3.ctimer.wait_frame(3, function(timer, count, local_player)
        if self._hide then
            return
        end
        local xOffset, yOffset = y3.UIHelper.limitTipOffset(y3.gameApp:getMyPlayerId(), self._ui)
        self._ui:set_follow_mouse(true, xOffset, yOffset)
    end)
end

function SurviveGameMiniTip:hide()
    self._hide = true
    self._ui:set_follow_mouse(false)
    self._ui:set_visible(false)
end

return SurviveGameMiniTip
