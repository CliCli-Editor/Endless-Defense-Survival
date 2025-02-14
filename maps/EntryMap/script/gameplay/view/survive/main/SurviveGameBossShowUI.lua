local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGameBossShowUI = class("SurviveGameBossShowUI", StaticUIBase)

function SurviveGameBossShowUI:ctor()
    local ui = y3.UIHelper.getUI("2237626b-ad0d-4b3f-8682-4f470e4441b2")
    SurviveGameBossShowUI.super.ctor(self, ui)
    self._exitBtn = y3.UIHelper.getUI("965b1658-e812-4e1b-ab8f-8cb903ad93c6")
    self._titleText = y3.UIHelper.getUI("484bd37e-b750-4b49-8cf6-298264358ca8")
    self._endBtn = y3.UIHelper.getUI("120f7694-8f24-409e-a6ff-27f7d2c248f1")
    self._bossListUI = y3.UIHelper.getUI("c8786ab9-17f6-4c33-9d2e-8d61b0ce4ecf")
    self._rightUI = y3.UIHelper.getUI("741fa3a4-751b-4992-9d82-1bb8ae94a516")
    self._gotoBtn = y3.UIHelper.getUI("49d9a03c-2858-493a-9a38-d2bda62dc75f")
    self._gotoText = y3.UIHelper.getUI("ac2c8638-8a01-438d-8120-9fca0a88b5b6")

    self._exitBtn:add_local_event("左键-点击", handler(self, self._onExitBtnClick))
    self._endBtn:add_local_event("左键-点击", handler(self, self._onEndBtnClick))
    self._gotoBtn:add_local_event("左键-点击", handler(self, self._onGotoBtnClick))

    self._bossCards = {}
    self._selectIndex = 1
    self._awardIcons = {}
    self:_initUI()
end

function SurviveGameBossShowUI:_initUI()
    local spawnEnemy = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy")
    local bossList = spawnEnemy:getArchieveCfgListAll()
    for i = 1, #bossList do
        local card = self._bossCards[i]
        if not card then
            card = include("gameplay.view.survive.main.SurviveGameBossShowCard").new(self._bossListUI)
            self._bossCards[i] = card
        end
    end
end

function SurviveGameBossShowUI:hideAllCard()
    for i = 1, #self._bossCards do
        self._bossCards[i]:setVisible(false)
    end
end

function SurviveGameBossShowUI:show(bossList)
    if not bossList then
        self:hide()
        return
    end
    if #bossList == 0 then
        self:hide()
        return
    end
    self:setVisible(true)
    self:hideAllCard()
    self._bossList = bossList
    for i = 1, #bossList do
        local card = self._bossCards[i]
        if not card then
            card = include("gameplay.view.survive.main.SurviveGameBossShowCard").new(self._bossListUI)
            self._bossCards[i] = card
        end
        local boss = bossList[i]
        card:setVisible(true)
        card:updateUI(boss, self, i)
    end
    self:onSelectBossCard(1)
end

function SurviveGameBossShowUI:onSelectBossCard(index)
    self._selectIndex = index
    self:_updateRightUI(self._bossList[index])
    for i = 1, #self._bossCards do
        self._bossCards[i]:updateSelect(index)
    end
end

function SurviveGameBossShowUI:_updateRightUI(cfg)
    if not cfg then
        return
    end
    local params = string.split(cfg.stage_archive_boss_locked, "#")
    local fightType = tonumber(params[1]) or 0
    local fightText = params[2] or ""
    if fightType == 1 then
        self._gotoBtn:set_button_enable(false)
        self._gotoText:set_text(fightText)
    else
        local spawnEnemy = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy")
        local archieveActor = spawnEnemy:getArchieveBossActor(cfg.id)
        if archieveActor then
            if archieveActor:isDie() then
                self._gotoBtn:set_button_enable(false)
                self._gotoText:set_text(y3.langCfg.get(63).str_content)
            else
                self._gotoBtn:set_button_enable(true)
                self._gotoText:set_text(GameAPI.get_text_config('#-301034812#lua'))
            end
        end
    end
    local monsterCfg = include("gameplay.config.monster").get(cfg.stage_archive_boss_id)
    assert(monsterCfg, "monsterCfg is nil")
    local icon = self._rightUI:get_child("basic.avatar.avatar.mask._icon_IMG")
    local nameText = self._rightUI:get_child("basic._title_TEXT")
    local labelText = self._rightUI:get_child("label.title_TEXT")
    local descrText = self._rightUI:get_child("descr.title_TEXT")
    local reward_LIST = self._rightUI:get_child("reward.reward_LIST")
    nameText:set_text(monsterCfg.monster_name)
    labelText:set_text(monsterCfg.monster_feature_sign)
    descrText:set_text(monsterCfg.des)
    icon:set_image(monsterCfg.monster_avatar_icon)
    self:_updateAward(cfg, reward_LIST)
end

function SurviveGameBossShowUI:_hideAllIcon()
    for i, icon in ipairs(self._awardIcons) do
        icon:setVisible(false)
    end
end

function SurviveGameBossShowUI:_updateAward(bossCfg, reward_LIST)
    local list = y3.userDataHelper.getArchieveBossAward(bossCfg)
    self:_hideAllIcon()
    for i = 1, #list do
        local icon = self._awardIcons[i]
        if not icon then
            icon = include("gameplay.view.component.CommonItemIcon").new(reward_LIST)
            self._awardIcons[i] = icon
        end
        icon:updateUI(list[i])
        icon:setVisible(true)
    end
end

function SurviveGameBossShowUI:hide()
    self:setVisible(false)
end

function SurviveGameBossShowUI:_onExitBtnClick(trg, local_player)
    print("exit boss show ui")
    self:hide()
end

function SurviveGameBossShowUI:_onEndBtnClick(trg, local_player)
    if self._isEnd then
        return
    end
    print("exit game")
    local data          = {}
    data.title          = "提示"
    data.desc           = GameAPI.get_text_config('#-1994957433#lua')
    data.okCallback     = function(local_player)
        self._isEnd = true
        y3.SyncMgr:sync(y3.SyncConst.SYNC_END_BOSS_RESULT, {})
    end
    data.cancelCallback = function(local_player)
    end
    local popAlert      = include("gameplay.view.tip.PopupSystemAlert").new(data)
    popAlert:setConfirmBtnText("确认")
    popAlert:setCancelBtnText("取消")
end

function SurviveGameBossShowUI:_onGotoBtnClick(trg, local_player)
    self:hide()
    if self._bossList then
        local bossCfg = self._bossList[self._selectIndex]
        if bossCfg then
            y3.SyncMgr:sync(y3.SyncConst.SYNC_SELECT_SAVE_BOSS, { bossId = bossCfg.id })
        end
    end
end

return SurviveGameBossShowUI
