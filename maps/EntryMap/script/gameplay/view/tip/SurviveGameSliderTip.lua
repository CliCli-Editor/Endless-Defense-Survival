local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGameSliderTip = class("SurviveGameSliderTip", StaticUIBase)

local MAX_CARD = 2

function SurviveGameSliderTip:ctor()
    local ui = y3.UIHelper.getUI("92f77eb9-83a4-41d7-ade1-6b86336618e4")
    SurviveGameSliderTip.super.ctor(self, ui)
    self._slide_tip_LIST = y3.UIHelper.getUI("2db5a6e9-0e2c-4c87-8f4f-91cf56736a7a")

    self._notiList = {}
    y3.ctimer.loop(0.1, handler(self, self._update))
end

function SurviveGameSliderTip:pushNotice(data)
    table.insert(self._notiList, data)
end

function SurviveGameSliderTip:_update()
    local childs = self._slide_tip_LIST:get_childs()
    if #self._notiList > 0 and #childs < MAX_CARD then
        local data = table.remove(self._notiList, 1)
        local card = include("gameplay.view.tip.SurviveGameSliderCard").new(self._slide_tip_LIST)
        card:updateUI(data)
    end
end

return SurviveGameSliderTip
