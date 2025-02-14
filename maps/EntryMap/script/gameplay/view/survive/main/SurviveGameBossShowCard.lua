local UIBase = include("gameplay.base.UIBase")
local SurviveGameBossShowCard = class("SurviveGameBossShowCard", UIBase)

function SurviveGameBossShowCard:ctor(parent)
    SurviveGameBossShowCard.super.ctor(self, parent, y3.SurviveConst.PREFAB_MAP["windows_gamesave_boss"])
    self._sel = self._ui:get_child("sel")
    self._title_TEXT = self._ui:get_child("content._title_TEXT")
    self._bossIcon = self._ui:get_child("content.avatar.mask._icon_IMG")
    self._label_TEXT = self._ui:get_child("content._label_TEXT")
    self._descr_TEXT = self._ui:get_child("content._descr_TEXT")
    -- self._reward_LIST = self._ui:get_child("content.reward.reward_LIST")
    self._content = self._ui:get_child("content")

    self._sel:set_visible(false)
    self._awardIcons = {}
    self._content:add_local_event("左键-点击", handler(self, self._onBossCardClick))
    -- self._content:add_local_event("鼠标-移入", function()
    --     self._sel:set_visible(true)
    -- end)
    -- self._content:add_local_event("鼠标-移出", function()
    --     self._sel:set_visible(false)
    -- end)
    -- self._ui:set_widget_absolute_scale(0.74, 0.74)
end

function SurviveGameBossShowCard:updateUI(bossCfg, root, index)
    self._bossCfg = bossCfg
    self._parent = root
    self._index = index
    local monsterCfg = include("gameplay.config.monster").get(self._bossCfg.stage_archive_boss_id)
    assert(monsterCfg, "monsterCfg is nil by id= " .. self._bossCfg.stage_archive_boss_id)
    self._title_TEXT:set_text(monsterCfg.monster_name)
    self._label_TEXT:set_text(monsterCfg.monster_feature_sign)
    self._descr_TEXT:set_text(monsterCfg.des)
    self._bossIcon:set_image(monsterCfg.monster_avatar_icon)
    -- self._bossMod:set_ui_model_id(monsterCfg.model)
    -- self:_updateAward()
end

function SurviveGameBossShowCard:_onBossCardClick(local_player)
    print("SurviveGameBossShowCard:_onBossCardClick")
    if self._parent then
        self._parent:onSelectBossCard(self._index)
    end
end

function SurviveGameBossShowCard:_hideAllIcon()
    for i, icon in ipairs(self._awardIcons) do
        icon:setVisible(false)
    end
end

function SurviveGameBossShowCard:_updateAward()
    local list = y3.userDataHelper.getArchieveBossAward(self._bossCfg)
    self:_hideAllIcon()
    for i = 1, #list do
        local icon = self._awardIcons[i]
        if not icon then
            icon = include("gameplay.view.component.CommonItemIcon").new(self._reward_LIST)
            self._awardIcons[i] = icon
        end
        icon:updateUI(list[i])
        icon:setVisible(true)
    end
end

function SurviveGameBossShowCard:updateSelect(index)
    self._sel:set_visible(self._index == index)
end

return SurviveGameBossShowCard
