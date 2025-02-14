local StaticUIBase = include("gameplay.base.StaticUIBase")
local CommonBuffList = class("CommonBuffList", StaticUIBase)

function CommonBuffList:ctor(listView)
    CommonBuffList.super.ctor(self, listView)
    self._listView = listView
    self._buffIconList = {}
end

---comment
---@param unit Unit
function CommonBuffList:bindUnit(unit)
    self._unit = unit
    self:_update_list()
    if not self._timer then
        self._timer = y3.ltimer.loop(0.5, handler(self, self._update_list))
    end
end

function CommonBuffList:hideAll()
    for _, icon in pairs(self._buffIconList) do
        icon:setVisible(false)
    end
end

function CommonBuffList:_update_list()
    self:hideAll()
    if self._unit then
        local buffs = self._unit:get_buffs()
        for i, buff in ipairs(buffs) do
            local buffIcon = self._buffIconList[i]
            if not buffIcon then
                buffIcon = include("gameplay.view.component.CommonBuffIcon").new(self._listView)
                self._buffIconList[i] = buffIcon
            end
            buffIcon:setVisible(true)
            buffIcon:updateUI(buff)
        end
    end
end

return CommonBuffList
