local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGameStageMenuUI = class("SurviveGameStageMenuUI", StaticUIBase)
local game_function_state = include("gameplay.config.game_function_state")

local MENU_LIST = {
    [1] = { 134251139, 134223511, 134238034, 134239740 },
    [2] = { 134234178, 134222049, 134239358, 134264837 },
    [3] = { 134280173, 134277679, 134242858, 134271896 },
    [4] = { 134282205, 134241486, 134223612, 134254596 },
    [5] = { 134269025, 134227890, 134233175, 134260628 },
    [6] = { 134261780, 134242334, 134226034, 134247485 },
    [7] = { 134265595, 134239772, 134261957, 134279665 },
    [8] = { 134255992, 134232421, 134258449, 134248308 },
    [9] = { 134255992, 134232421, 134258449, 134248308 },
    [10] = { 134255992, 134232421, 134258449, 134248308 },
    [11] = { 134255992, 134232421, 134258449, 134248308 },
}

function SurviveGameStageMenuUI:ctor(parent)
    self._parent = parent
    local ui = y3.UIHelper.getUI("206a41f4-1132-4c1d-b628-d947ad8bf045")
    SurviveGameStageMenuUI.super.ctor(self, ui)
    self._menu_LIST = y3.UIHelper.getUI("784c5bc0-5246-403d-9162-606efe1391a5")
    self:_initUI()
    self:_onTabUpdate(1)
    self._curIndex = 1
end

function SurviveGameStageMenuUI:_initUI()
    local HIDE_MAP = {
        [6] = true,
        [7] = true,
        [8] = true,
    }
    local childs = self._menu_LIST:get_childs()
    self._tabBtnList = {}
    for i, child in ipairs(childs) do
        local cfg = game_function_state.get(i)
        if cfg then
            child:set_visible(cfg.game_function_state == 1)
        else
            child:set_visible(false)
        end
        if HIDE_MAP[i] then
            child:set_visible(false)
        end
        local openBtn = child:get_child("open_BTN")
        table.insert(self._tabBtnList, openBtn)
        openBtn:add_local_event('左键-点击', function(local_player)
            self:_onMenuBtnClick(i)
        end)
    end
end

function SurviveGameStageMenuUI:_onTabUpdate(index)
    for i = 1, #self._tabBtnList do
        local btn = self._tabBtnList[i]
        if i == index then
            btn:set_image(MENU_LIST[i][2])
            btn:set_hover_image_type(MENU_LIST[i][4])
        else
            btn:set_image(MENU_LIST[i][1])
            btn:set_hover_image_type(MENU_LIST[i][3])
        end
    end
end

function SurviveGameStageMenuUI:_onMenuBtnClick(index)
    self._parent:menuClick(index)
    self:_onTabUpdate(index)
end

return SurviveGameStageMenuUI
