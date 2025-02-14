local FadeTo = include "gameplay.utils.uiAction.FadeTo"
local UIActionManager = class("UIActionManager")

function UIActionManager:ctor()
    self._timerAction = y3.ctimer.loop(1 / 45, handler(self, self._onTimerAction))
    self._lastelapsedTime = self._timerAction:get_elapsed_time()
    self._actionList = {}
end

function UIActionManager:stopAllActions(ui)
    for i = #self._actionList, 1, -1 do
        if self._actionList[i]:getUI() == ui then
            table.remove(self._actionList, i)
        end
    end
end

function UIActionManager:playFadeAction(ui)
    self:stopAllActions(ui)
    local fade = FadeTo.new(ui, 0, 255, 0.4)
    fade:runAction(2)
end

function UIActionManager:playScaleAndFade(ui)
    self:stopAllActions(ui)
end

function UIActionManager:addUIAction(action)
    for i = 1, #self._actionList do
        if self._actionList[i] == action then
            return
        end
    end
    table.insert(self._actionList, action)
end

function UIActionManager:_onTimerAction()
    local delta = self._timerAction:get_elapsed_time()
    -- print(self._timerAction:get_elapsed_time())
    for i = 1, #self._actionList do
        if y3.class.isValid(self._actionList[i]:getUI()) then
            self._actionList[i]:tick(delta)
        end
    end
    for i = 1, #self._actionList do
        if not y3.class.isValid(self._actionList[i]:getUI()) then
            table.remove(self._actionList, i)
            break
        end
        if self._actionList[i]:isDone() then
            table.remove(self._actionList, i)
            break
        end
    end
end

return UIActionManager
