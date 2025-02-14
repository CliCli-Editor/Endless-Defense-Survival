local GlobalConfigHelper = require "gameplay.level.logic.helper.GlobalConfigHelper"
local SurviveGameSkillTotal = class("SurviveGameSkillTotal")
local SurviveGameSkillTotalCell = include("gameplay.view.survive.main.SurviveGameSkillTotalCell")

local CELL_LIST = {
    [1] = y3.SurviveConst.DAMAGE_TYPE_1,
    [2] = y3.SurviveConst.DAMAGE_TYPE_2,
    [3] = y3.SurviveConst.DAMAGE_TYPE_3,
    [4] = y3.SurviveConst.DAMAGE_TYPE_4,
    [5] = y3.SurviveConst.DAMAGE_TYPE_5,
}

function SurviveGameSkillTotal:ctor(ui, root)
    self._ui = ui
    self._root = root
    self:_init()
    self._allCardList = {}
    y3.gameApp:registerEvent(y3.EventConst.EVENT_SKIL_TOTAL_HIGHLIGHT, handler(self, self._onEventSkillTotalHighlight))
    y3.gameApp:registerEvent(y3.EventConst.EVENT_SKIL_TOTAL_HIDE_HIGHLIGHT, handler(self, self._onEventHideHighlight))
end

function SurviveGameSkillTotal:_init()
    local configSkill = include("gameplay.config.config_skillData")
    local len = configSkill.length()
    self._skillTypeMap = {}
    for i = 1, len do
        local cfg = configSkill.indexOf(i)
        if not self._skillTypeMap[cfg.type] then
            self._skillTypeMap[cfg.type] = {}
        end
        table.insert(self._skillTypeMap[cfg.type], cfg)
    end
    self._cellList = {}
    local cells = self._ui:get_childs()
    for i, cell in ipairs(cells) do
        local card = SurviveGameSkillTotalCell.new(cell)
        self._cellList[i] = card
    end
end

function SurviveGameSkillTotal:updateUI()
    local curStageId = y3.userData:getMaxUnLockStageId()
    local unlockMap = GlobalConfigHelper.getAttackTypeUnlockMap()
    for i = 1, 5 do
        if CELL_LIST[i] then
            local unlockId = unlockMap[i] or 0
            self._cellList[i]:setVisible(curStageId >= unlockId)
            self._cellList[i]:updateUI(CELL_LIST[i], self._root, self._skillTypeMap, self._allCardList)
        else
            self._cellList[i]:setVisible(false)
        end
    end
end

function SurviveGameSkillTotal:setVisible(visible)
    self._ui:set_visible(visible)
end

function SurviveGameSkillTotal:_onEventSkillTotalHighlight(trg, playerId, conStr)
    if playerId ~= y3.gameApp:getMyPlayerId() then
        return
    end
    if conStr == "" then
        return
    end
    local cons = string.split(conStr, "|")
    assert(cons)
    local condList = {}
    for i, con in ipairs(cons) do
        local params = string.split(con, "#")
        table.insert(condList, params)
    end
    local result = {}
    for i = 1, #self._allCardList do
        local card = self._allCardList[i]
        if card:isVisible() then
            self:isNeedInserResult(result, card, condList)
        end
    end
    self._hightlightCards = result
    for i, card in ipairs(result) do
        card:setHighlight(true)
    end
end

function SurviveGameSkillTotal:_onEventHideHighlight(trg, playerId)
    if playerId ~= y3.gameApp:getMyPlayerId() then
        return
    end
    if self._hightlightCards then
        for i, card in ipairs(self._hightlightCards) do
            card:setHighlight(false)
        end
        self._hightlightCards = nil
    end
end

function SurviveGameSkillTotal:isNeedInserResult(result, card, condList)
    -- 根据技能ID高亮组|根据技能type高亮组|根据技能range高亮组|武器标签组(label)|武器攻击类型组(atk_target)
    local cfg = card:getCfg()
    local params1 = condList[1] or {}
    for i = 1, #params1 do
        if params1[i] == cfg.id then
            table.insert(result, card)
            return
        end
    end
    local params2 = condList[2] or {}
    for i = 1, #params2 do
        if tonumber(params2[i]) == cfg.type then
            table.insert(result, card)
            return
        end
    end
    local params3 = condList[3] or {}
    for i = 1, #params3 do
        if tonumber(params3[i]) == cfg.range then
            table.insert(result, card)
            return
        end
    end
    local params4 = condList[4] or {}
    for i = 1, #params4 do
        if tonumber(params4[i]) > 0 and cfg.label == tonumber(params4[i]) then
            table.insert(result, card)
            return
        end
    end
    local params5 = condList[5] or {}
    for i = 1, #params5 do
        local atk_targets = string.split(cfg.atk_target, "|")
        assert(atk_targets)
        for _, atk_target in ipairs(atk_targets) do
            if tonumber(params5[i]) > 0 and atk_target == params5[i] then
                table.insert(result, card)
                return
            end
        end
    end
    return false
end

return SurviveGameSkillTotal
