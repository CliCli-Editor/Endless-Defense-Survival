local SurviveGameSkillStatistics = class("SurviveGameSkillStatistics")

local INDEX_300 = 1
local INDEX_600 = 2
local INDEX_900 = 3
local INDEX_1200 = 4

local INDEX_MAP = {
    [INDEX_300] = 450,
    [INDEX_600] = 900,
    [INDEX_900] = 1350,
    [INDEX_1200] = 1800,
}

local CLASS_COLOR = {
    [1] = "48b05d",
    [2] = "25b2ed",
    [3] = "9b5dec",
    [4] = "e2b044",
    [5] = "d0513c",
}

local SUB_TAB_SELECT_IMG = 134258886
local SUB_TAB_UNSELECT_IMG = 999

function SurviveGameSkillStatistics:ctor(ui, parent)
    self._ui = ui
    self._parent = parent
    self._detailList = y3.UIHelper.getUI("bc9ad675-aba6-49a6-aadc-df85a228ea43") --self._ui:get_child("skill_info_LIST.detail_LIST")
    self._exitBtn = y3.UIHelper.getUI("6815ed72-581c-4dda-bcdb-37a4332dab20")

    self:_initCfg()
    self:_initTab()
    self:_initSortUI()
    self._exitBtn:add_local_event("左键-点击", handler(self, self._onExitBtnClick))
end

function SurviveGameSkillStatistics:_onExitBtnClick(local_player)
    self:hide()
end

function SurviveGameSkillStatistics:_initTab()
    self._tabRoot = y3.UIHelper.getUI("cdaa3ce0-d124-450c-a450-48e18f279278")
    self._tabContent = y3.UIHelper.getUI("6679635a-9ccb-4976-9385-87d5aa08a54e")
    self._mainTabIndex = 1
    local tabBtns = self._tabRoot:get_childs()
    for _, tabBtn in ipairs(tabBtns) do
        local name = tabBtn:get_name()
        local tabIndex = tonumber(name)
        if tabIndex then
            tabBtn:add_local_event("左键-点击", function(local_player)
                self:_onMainTabClick(tabIndex)
            end)
            if tabIndex == 1 then
                tabBtn:set_visible(true)
            else
                tabBtn:set_visible(false)
            end
        end
    end
    self._subTabRoot = y3.UIHelper.getUI("cab2d817-a0db-4dfa-8953-7c139548a145")
    self._skillType = 1
    local subTabBtns = self._subTabRoot:get_childs()
    self._subTanBtnList = {}
    for _, subTabBtn in ipairs(subTabBtns) do
        local name = subTabBtn:get_name()
        local subTabIndex = tonumber(name)
        if subTabIndex then
            local icon = subTabBtn:get_child("_weapon_type_IMG")
            icon:set_image(y3.SurviveConst.SKILLTYPE_ICON[subTabIndex])
            local name_TEXT = subTabBtn:get_child("_weapon_name_TEXT")
            name_TEXT:set_text(y3.SurviveConst.DAMAGE_TYPE_NAME_MAP[subTabIndex])
            table.insert(self._subTanBtnList, subTabBtn)
            subTabBtn:add_local_event("左键-点击", function(local_player)
                self:_onSubTabClick(subTabIndex)
            end)
        end
    end
end

function SurviveGameSkillStatistics:_initSortUI()
    self._nameSortBtn      = y3.UIHelper.getUI("1edd84a1-e2e2-4739-b357-e895be6efbfe")
    self._classSortBtn     = y3.UIHelper.getUI("44fce212-e4b2-43d1-afe5-b9e4980be691")
    self._countSortBtn     = y3.UIHelper.getUI("e91d3fc4-e372-4a7d-a708-e94cf51ee42a")
    self._dpsSortBtn       = y3.UIHelper.getUI("0aa057c7-754b-454d-9077-1e0466ff68fa")
    self._dmgTotalSortBtn  = y3.UIHelper.getUI("6e457ad4-ca14-4ab1-b833-bad9188216b4")
    self._killSortBtn      = y3.UIHelper.getUI("b181c45b-402d-43b8-b0a8-7d3f1858bc7f")
    self._sortBtnList      = {
        self._nameSortBtn,
        self._classSortBtn,
        self._countSortBtn,
        self._dpsSortBtn,
        self._dmgTotalSortBtn,
        self._killSortBtn
    }
    self._nameSortFlag     = y3.UIHelper.getUI("b901b79e-0a8c-4108-9f7e-1801af62181a")
    self._classSortFlag    = y3.UIHelper.getUI("aae3c886-4544-4398-93d4-b779b27318cf")
    self._countSortFlag    = y3.UIHelper.getUI("c5ad0ce6-55b7-4dfc-bb07-3fd89f524147")
    self._dpsSortFlag      = y3.UIHelper.getUI("6e98ccdb-ae9c-41c1-bd9e-654a89790b95")
    self._dmgTotalSortFlag = y3.UIHelper.getUI("953a5e2b-bf1a-4317-b42b-af5ae69f0181")
    self._killSortFlag     = y3.UIHelper.getUI("01df1d10-6cd8-4060-8126-ff157983403b")
    self._sortFlagList     = {
        self._nameSortFlag,
        self._classSortFlag,
        self._countSortFlag,
        self._dpsSortFlag,
        self._dmgTotalSortFlag,
        self._killSortFlag
    }
    for i = 1, #self._sortBtnList do
        self._sortBtnList[i]:add_local_event("左键-点击", function(local_player)
            self:_onSortBtnClick(i)
        end)
    end
    self._sortIndex = 0
    self:_onSortBtnClick(2)
end

function SurviveGameSkillStatistics:_onMainTabClick(index)

end

function SurviveGameSkillStatistics:_onSubTabClick(index)
    self._skillType = index
    self:_updateSubBtn()
    self:_onSortBtnClick(self._sortIndex)
    self:updateUI()
end

function SurviveGameSkillStatistics:_updateSubBtn()
    for i = 1, #self._subTanBtnList do
        if i == self._skillType then
            self._subTanBtnList[i]:set_image(SUB_TAB_SELECT_IMG)
        else
            self._subTanBtnList[i]:set_image(SUB_TAB_UNSELECT_IMG)
        end
    end
end

function SurviveGameSkillStatistics:_onSortBtnClick(index)
    self._sortIndex = index
    for i = 1, #self._sortFlagList do
        self._sortFlagList[i]:set_visible(i == index)
    end
    local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local mainActor = playerData:getMainActor()
    local sortFunc = {
        [1] = function(a, b)
            return a.name < b.name
        end,
        [2] = function(a, b)
            return a.class > b.class
        end,
        [3] = function(a, b)
            local numa = mainActor:getSkillNameNum(a.id)
            local numb = mainActor:getSkillNameNum(b.id)
            return numa > numb
        end,
        [4] = function(a, b)
            local dpsa = mainActor:getSkillDps(a.id)
            local dpsb = mainActor:getSkillDps(b.id)
            return dpsa > dpsb
        end,
        [5] = function(a, b)
            local dmga = mainActor:getSkillDmgTotal(a.id)
            local dmgb = mainActor:getSkillDmgTotal(b.id)
            return dmga > dmgb
        end,
        [6] = function(a, b)
            local killa = mainActor:getSkillKillTotal(a.id)
            local killb = mainActor:getSkillKillTotal(b.id)
            return killa > killb
        end
    }
    local skillMap = self._rangeSkillMap[self._skillType]
    for i, list in ipairs(skillMap) do
        table.sort(list, sortFunc[self._sortIndex])
    end
    self:updateUI()
end

function SurviveGameSkillStatistics:_initCfg()
    local config_skillData = include("gameplay.config.config_skillData")
    local len = config_skillData.length()
    self._rangeSkillMap = {}
    for i = 1, len do
        local cfg = config_skillData.indexOf(i)
        if not self._rangeSkillMap[cfg.type] then
            self._rangeSkillMap[cfg.type] = {}
        end
        if cfg.range == y3.SurviveConst.RANGE_300 then
            if not self._rangeSkillMap[cfg.type][INDEX_300] then
                self._rangeSkillMap[cfg.type][INDEX_300] = {}
            end
            table.insert(self._rangeSkillMap[cfg.type][INDEX_300], cfg)
        elseif cfg.range == y3.SurviveConst.RANGE_600 then
            if not self._rangeSkillMap[cfg.type][INDEX_600] then
                self._rangeSkillMap[cfg.type][INDEX_600] = {}
            end
            table.insert(self._rangeSkillMap[cfg.type][INDEX_600], cfg)
        elseif cfg.range == y3.SurviveConst.RANGE_900 then
            if not self._rangeSkillMap[cfg.type][INDEX_900] then
                self._rangeSkillMap[cfg.type][INDEX_900] = {}
            end
            table.insert(self._rangeSkillMap[cfg.type][INDEX_900], cfg)
        elseif cfg.range == y3.SurviveConst.RANGE_1200 then
            if not self._rangeSkillMap[cfg.type][INDEX_1200] then
                self._rangeSkillMap[cfg.type][INDEX_1200] = {}
            end
            table.insert(self._rangeSkillMap[cfg.type][INDEX_1200], cfg)
        end
    end
end

function SurviveGameSkillStatistics:show(skillType)
    y3.UIActionMgr:playFadeAction(self._ui)
    self._skillType = skillType
    self:_updateSubBtn()
    self._ui:set_visible(true)
    self:updateUI()
end

function SurviveGameSkillStatistics:hide()
    self._ui:set_visible(false)
end

function SurviveGameSkillStatistics:toggleShow()
    local isVisible = self._ui:is_visible()
    if not isVisible then
        self:show(1)
    else
        self:hide()
    end
end

function SurviveGameSkillStatistics:updateUI()
    if not self._ui:is_visible() then
        return
    end
    if not self._totalCellList then
        self._totalCellList = {}
    end
    if not self._skillCallList then
        self._skillCallList = {}
    end
    local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local mainActor = playerData:getMainActor()
    if self._skillType then
        local typeCells = self._detailList:get_childs()
        for i, cell in ipairs(typeCells) do
            local list = self._rangeSkillMap[self._skillType][i] or {}
            local totalCell = self._totalCellList[i]
            if not totalCell then
                local total = cell:get_child("total")
                totalCell = include("gameplay.view.survive.main.SurviveGameSkillStatisticsTotalCell").new(total)
                self._totalCellList[i] = totalCell
            end
            if not self._skillCallList[i] then
                self._skillCallList[i] = {}
            end
            local skill = cell:get_child("weapon_LIST")
            assert(skill)
            local skillList = skill:get_childs()
            local totalDps = 0
            local totalDmg = 0
            local totalKill = 0
            local totalNum = 0
            for j, skillUI in ipairs(skillList) do
                local skillCfg = list[j]
                local skillCell = self._skillCallList[i][j]
                if not skillCell then
                    skillCell = include("gameplay.view.survive.main.SurviveGameSkillStatisticsCell").new(skillUI)
                    self._skillCallList[i][j] = skillCell
                end
                if skillCfg then
                    skillCell:setVisible(true)
                    totalNum = totalNum + mainActor:getSkillNameNum(skillCfg.id)
                    local dps, dmgTotal, killTotal = skillCell:updateUI(skillCfg)
                    totalDps = totalDps + dps
                    totalDmg = totalDmg + dmgTotal
                    totalKill = totalKill + killTotal
                else
                    skillCell:setVisible(false)
                end
            end
            totalCell:updateUI(totalNum, i, totalDps, totalDmg, totalKill)
        end
    end
end

function SurviveGameSkillStatistics:updateMiniSkillCell(cell, skillCfg, mainActor)
    local avatarIcon = cell:get_child("_avatar_ICON")
    local countValueText = cell:get_child("_avatar_ICON._count_value_TEXT")
    local nameText = cell:get_child("_name_TEXT")
    local dpsValueText = cell:get_child("_dps_value_TEXT")
    if skillCfg then
        cell:set_visible(true)
        avatarIcon:set_image(tonumber(skillCfg.icon))
        local count = mainActor:getSkillNameNum(skillCfg.id)
        -- print(skillCfg.name)
        nameText:set_text(skillCfg.name)
        local dps = mainActor:getSkillDps(skillCfg.id)
        dpsValueText:set_text("DPS:" .. math.floor(dps))
        if count > 0 then
            nameText:set_text_color_hex(CLASS_COLOR[skillCfg.class], 255)
            countValueText:set_text(count)
        else
            nameText:set_text_color_hex("8e8e8e", 255)
            countValueText:set_text("")
        end
    else
        cell:set_visible(false)
        avatarIcon:set_image(110010000)
        nameText:set_text((""))
        nameText:set_text_color_hex("8e8e8e", 255)
        dpsValueText:set_text("DPS:" .. 0)
    end
end

return SurviveGameSkillStatistics
