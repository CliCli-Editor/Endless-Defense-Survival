local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGameSaveView = class("SurviveGameSaveView", StaticUIBase)

local MAIN_TAB_BAOCHANG = 1

function SurviveGameSaveView:ctor()
    local ui = y3.UIHelper.getUI("ba809bce-d404-445e-b693-0b76de2c620e")
    SurviveGameSaveView.super.ctor(self, ui)
    self._content = y3.UIHelper.getUI("44e18840-6099-482a-bfc3-e312d1efbd02")
    self._exitBtn = y3.UIHelper.getUI("4afae9bb-aa10-47a5-a24f-cdea6e51f293")
    self._exitBtn:add_local_event("左键-按下", function(local_player)
        self:setVisible(false)
    end)
    self._treasureUI = include("gameplay.view.survive.save.SurviveGameTreasureUI").new()
    self._weaponBookUI = include("gameplay.view.survive.save.SurviveGameWeaponBookUI").new()
    self._liftUI = include("gameplay.view.survive.save.SurviveGameLiftUI").new()
    self._platformShopUI = include("gameplay.view.survive.save.SurviveGamePlatformShopUI").new()
    self._rankUI = include("gameplay.view.survive.save.SurviveGameRankUI").new()
    self._dressUpUI = include("gameplay.view.survive.save.dressUp.SurviveGameDressUpUI").new()
    self._tabUI = {
        [2] = self._treasureUI,
        [3] = self._weaponBookUI,
        [4] = self._liftUI,
        [5] = self._dressUpUI,
        [7] = self._rankUI,
        [8] = self._platformShopUI
    }
    -- self:_initMenuTab()
end

function SurviveGameSaveView:getTabView(index)
    return self._tabUI[index]
end

function SurviveGameSaveView:_initMenuTab()
    -- self._menuTabIndex = MAIN_TAB_BAOCHANG
    -- self._menuList = y3.UIHelper.getUI("35995fbe-f207-4ce1-b0f3-477438ff7be2")
    -- local menuTabs = self._menuList:get_childs()
    -- for tabIndex, tab in ipairs(menuTabs) do
    --     local childs = tab:get_childs()
    --     childs[1]:add_local_event("左键-按下", function()
    --         self:_onMenuMainTabClick(tabIndex)
    --     end)
    -- end
end

function SurviveGameSaveView:_onMenuMainTabClick(index)
    -- self._menuTabIndex = index
    -- self:_updateTabContent()
end

function SurviveGameSaveView:_updateTabContent()
    -- local childs = self._content:get_childs()
    -- for i, child in ipairs(childs) do
    --     child:set_visible(i == self._menuTabIndex)
    -- end
    -- if self._tabUI[self._menuTabIndex] then
    --     self._tabUI[self._menuTabIndex]:updateUI()
    -- end
end

function SurviveGameSaveView:show(visible)
    self:setVisible(visible)
    if visible then
        y3.UIActionMgr:playFadeAction(self._ui)
        self:_updateTabContent()
    end
end

function SurviveGameSaveView:toggleView()
    local isVisible = self._ui:is_visible()
    self:show(not isVisible)
end

return SurviveGameSaveView
