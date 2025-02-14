local UserDataHelper = include "gameplay.level.logic.helper.UserDataHelper"
local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGameStageTowerUI = class("SurviveGameStageTowerUI", StaticUIBase)
local stage_tower = include("gameplay.config.stage_tower")

function SurviveGameStageTowerUI:ctor()
    local ui = y3.UIHelper.getUI("60561171-9fe6-44a3-98ce-e1534c58b09f")
    SurviveGameStageTowerUI.super.ctor(self, ui)
    self._tower_name_TEXT = y3.UIHelper.getUI("3cc9bd52-bb02-47bf-86bc-49ad8309d6c7")
    self._tower_MOD = y3.UIHelper.getUI("e518066c-0ba8-454f-ada4-b07ab650343c")

    self._avatar_bg_IMG = y3.UIHelper.getUI("eeb84948-6a24-4287-a10b-da8e83de0fbf")
    self._avatar_tower_skill_IMG = y3.UIHelper.getUI("e85feafa-40b7-403a-a2f6-cc9598e6766c")
    self._skill_name_TEXT = y3.UIHelper.getUI("8c943e75-882a-43d4-91f1-e3b732569b78")
    self._skill_descr_TEXT = y3.UIHelper.getUI("848b6dfc-05a3-4776-9543-f09420b5fcbb")
    self._skill = y3.UIHelper.getUI("d507a176-4652-4e46-8800-9bb1ba7446a6")

    self._additional_descr_TEXT = y3.UIHelper.getUI("3c89b3f6-a095-4d2f-9a1f-7764d2a750c5")
    self._tower_select_LIST = y3.UIHelper.getUI("65d07508-d9b3-438d-a82a-853a417b90ab")
    self._previous_BTN = y3.UIHelper.getUI("eedf2ef1-eb12-42f4-b7bd-1f40407206d4")
    self._next_BTN = y3.UIHelper.getUI("375e61af-56bb-4bc7-95db-af4d6cd5c1ec")


    self._selectIndex = self:getDefaultSelectIndex()
    self._towerCards = {}
    self:updateUI()
    self:onSelectedTower(self._selectIndex)
    self._tower_select_LIST:set_list_view_percent((math.max(0, self._selectIndex - 4) / (stage_tower.length() - 4)) * 100)
    -- self:_onUpdateSelectTower()
end

function SurviveGameStageTowerUI:getDefaultSelectIndex()
    local gameCourse = y3.gameApp:getLevel():getLogic("SurviveGameCourse")
    local stageTowerId = gameCourse:getSelectStagePower(y3.gameApp:getMyPlayerId())
    local len = stage_tower.length()
    for i = 1, len do
        local cfg = stage_tower.indexOf(i)
        assert(cfg, "")
        if cfg.id == stageTowerId then
            return i
        end
    end
    return 1
end

function SurviveGameStageTowerUI:updateUI()
    local selectCells = self._tower_select_LIST:get_childs()
    for i, cellUI in ipairs(selectCells) do
        local cfg = stage_tower.indexOf(i)
        if cfg then
            cellUI:set_visible(true)
            local card = self._towerCards[i]
            if not card then
                card = include("gameplay.view.survive.main.SurviveGameStageTowerCell").new(cellUI, self)
                self._towerCards[i] = card
            end
            card:updateUI(cfg, i)
            card:updateSelect(self._selectIndex)
        else
            cellUI:set_visible(false)
        end
    end
end

function SurviveGameStageTowerUI:onSelectedTower(index)
    self._selectIndex = index
    for i = 1, #self._towerCards do
        self._towerCards[i]:updateSelect(index)
    end
    self:_onUpdateSelectTower()
    local cfg = stage_tower.indexOf(self._selectIndex)
    if cfg then
        local isUnlock = y3.userDataHelper.towerIsUnLock(y3.gameApp:getMyPlayerId(), cfg)
        if isUnlock then
            y3.SyncMgr:sync(y3.SyncConst.SYNC_SELECTED_SKIN_TOWER, { towerId = cfg.id })
        end
    end
end

function SurviveGameStageTowerUI:_onUpdateSelectTower()
    local cfg = stage_tower.indexOf(self._selectIndex)
    if cfg then
        self._additional_descr_TEXT:set_text(cfg.tower_acquire_desc)
        self._tower_name_TEXT:set_text(cfg.tower_name)
        self._tower_MOD:set_ui_model_id(cfg.tower_model_id)
        -- self._avatar_tower_skill_IMG:(cfg.avatar_tower_skill)
        local skillCfg = include("gameplay.config.config_skillData").get(tostring(cfg.tower_editor_skill_id))
        if skillCfg then
            self._skill:set_visible(true)
            -- self._avatar_bg_IMG:set_image(y3.SurviveConst.ITEM_CLASS_MAP[skillCfg.class + 1])
            self._avatar_tower_skill_IMG:set_image(tonumber(skillCfg.icon))
            self._skill_name_TEXT:set_text(skillCfg.name)
            local desc = UserDataHelper.getSkillDesc(skillCfg)
            self._skill_descr_TEXT:set_text(desc)
        else
            self._skill:set_visible(false)
        end
    end
end

return SurviveGameStageTowerUI
