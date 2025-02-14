local UserDataHelper = include "gameplay.level.logic.helper.UserDataHelper"
local UIBase = include("gameplay.base.UIBase")
local SurviveGameRewardSkillCard = class("SurviveGameRewardSkillCard", UIBase)

local CLASS_BG_MAP = {
    [1] = 134256281,
    [2] = 134233754,
    [3] = 134281692,
    [4] = 134249966,
    [5] = 134274990,
}

function SurviveGameRewardSkillCard:ctor(parent)
    SurviveGameRewardSkillCard.super.ctor(self, parent, y3.SurviveConst.PREFAB_MAP["select_reward"])
    self._sel           = self._ui:get_child("sel")
    self._back          = self._ui:get_child("back")
    self._content       = self._ui:get_child("content")

    self._bg            = self._ui:get_child("content.bg")
    self._class         = self._ui:get_child("content.bg_class")
    self._title_TEXT    = self._ui:get_child("content.title._title_TEXT")
    self._titletype     = self._ui:get_child("content.type._type_TEXT")
    self._newFlag       = self._ui:get_child("content.new")
    self._avatarBg      = self._ui:get_child("content.avatar.bg")
    self._avatarIcon    = self._ui:get_child("content.avatar._icon_IMG")
    self._nameTitleText = self._ui:get_child("content._name_TEXT")
    self._descr_TEXT    = self._ui:get_child("content.desc_Text_LIST._descr_TEXT")

    self._back:set_visible(false)
    self._content:set_visible(true)

    self._avatarBg:add_local_event("鼠标-移入", function()
        local randomCfg = self._randomCfg
        if randomCfg and randomCfg.item_type == 1 or randomCfg.item_type == 2 then
            y3.Sugar.tipRoot():showSkillTip({ cfg = self._cfg })
        end
    end)
    self._avatarBg:add_local_event("鼠标-移出", function()
        y3.Sugar.tipRoot():hideSkillTip()
    end)
end

function SurviveGameRewardSkillCard:getUI()
    return self._ui
end

function SurviveGameRewardSkillCard:updateSelect(select)
    self._sel:set_visible(select)
end

function SurviveGameRewardSkillCard:setVisible(visible)
    self._ui:set_visible(visible)
end

function SurviveGameRewardSkillCard:getCardName()
    return self._textName
end

function SurviveGameRewardSkillCard:_updateTask(taskId)
    local taskCfg = include("gameplay.config.stage_task").get(taskId)
    assert(taskCfg, "taskCfg is nil")
    self._cfg = taskCfg
    self._textName = taskCfg.task_title
    self._title_TEXT:set_text(taskCfg.task_title)
    self._newFlag:set_visible(false)
    self._class:set_image(CLASS_BG_MAP[1])
    self._avatarIcon:set_image(tonumber(taskCfg.task_icon))
    self._nameTitleText:set_text(taskCfg.task_title)
    self._descr_TEXT:set_text(taskCfg.task_desc)
end

function SurviveGameRewardSkillCard:_updateHero(heroCfgId)
    local heroCfg = include("gameplay.config.hero").get(heroCfgId)
    assert(heroCfg, "heroCfg is nil")
    self._cfg = heroCfg
    self._textName = heroCfg.name
    self._title_TEXT:set_text(heroCfg.name)
    self._newFlag:set_visible(false)
    self._class:set_image(CLASS_BG_MAP[heroCfg.quality])
    self._avatarIcon:set_image(tonumber(heroCfg.hero_icon))
    self._nameTitleText:set_text(heroCfg.name)
    local skillCfg = include("gameplay.config.config_skillData").get(tostring(heroCfg.hero_skill_id))
    local skilldesc = y3.userDataHelper.getSkillDesc(skillCfg)
    if skillCfg then
        local descStr = y3.Lang.getLang(y3.langCfg.get(45).str_content,
            { hero_desc = heroCfg.hero_desc, skill_name = skillCfg.name, skill_desc = skilldesc })
        self._descr_TEXT:set_text(descStr)
    else
        self._descr_TEXT:set_text(heroCfg.hero_desc)
    end
end

function SurviveGameRewardSkillCard:_updateItem(cfgId)
    local itemCfg = include("gameplay.config.item").get(tonumber(cfgId))
    assert(itemCfg, "itemCfg is nil")
    self._cfg = itemCfg
    self._textName = itemCfg.item_name
    self._title_TEXT:set_text(itemCfg.item_name)
    self._newFlag:set_visible(false)
    self._class:set_image(CLASS_BG_MAP[itemCfg.item_quality])
    self._avatarIcon:set_image(tonumber(itemCfg.item_icon))
    self._nameTitleText:set_text(itemCfg.item_name)
    local appendText = ""
    if self._cfg.item_hold_type == 1 then
        local item_hold_args = string.split(self._cfg.item_hold_args, "#")
        if item_hold_args and item_hold_args[2] then
            local skillid = item_hold_args[2]
            local skillCfg = include("gameplay.config.config_skillData").get(skillid)
            if skillCfg and skillCfg.type == 6 then
                local skill_icon_highlight = string.split(skillCfg.skill_icon_highlight, "|")
                if skill_icon_highlight and skill_icon_highlight[1] then
                    local skills = string.split(skill_icon_highlight[1], "#")
                    if skills and skills[1] ~= "-1" then
                        local skillCfg2 = include("gameplay.config.config_skillData").get(skills[1])
                        if skillCfg2 then
                            local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
                            local mainActor = playerData:getMainActor()
                            local skillNum = mainActor:getSkillNameNum(skillCfg2.id)
                            appendText = y3.Lang.getLang(y3.langCfg.get(71).str_content,
                                { skill = skillCfg2.name, num = skillNum })
                        end
                    end
                end
            end
        end
    end
    self._descr_TEXT:set_text(UserDataHelper.getItemDescs(itemCfg) .. appendText)
end

function SurviveGameRewardSkillCard:_updateSkill(cfgId)
    local skillCfg = include("gameplay.config.config_skillData").get(tostring(cfgId))
    assert(skillCfg, "skillCfg is nil")
    self._cfg = skillCfg
    self._textName = skillCfg.name
    self._title_TEXT:set_text(skillCfg.name)
    self._newFlag:set_visible(false)
    self._class:set_image(CLASS_BG_MAP[skillCfg.class])
    self._avatarIcon:set_image(tonumber(skillCfg.icon))
    self._nameTitleText:set_text(skillCfg.name)

    if skillCfg.descr == "" then
        self._descr_TEXT:set_text(y3.langCfg.get(73).str_content)
    else
        local descStr = ""
        if skillCfg.ability_type ~= "" then
            local types = string.split(skillCfg.ability_type, "|")
            local descrs = string.split(skillCfg.descr, "|")
            local values = string.split(skillCfg.value, "|")
            assert(types, "")
            assert(descrs, "")
            assert(values, "")
            for i = 1, 2 do
                if types[i] then
                    local params = string.split(types[i], "#")
                    assert(params, "")
                    local desc = descrs[i] or ""
                    desc = string.gsub(desc, "({%a+[0-9]})", function(s)
                        local lenStr = string.len(s)
                        if string.find(s, "pvalue") then
                            local e = self:getValue(values[tonumber(string.sub(s, 8, 8))])
                            return math.floor(e * 100) .. "%"
                        elseif string.find(s, "value") then
                            local e = self:getValue(values[tonumber(string.sub(s, 7, 7))])
                            return e .. ""
                        end
                        return s
                    end)
                    descStr = descStr .. desc .. "\n"
                end
            end
        end
        self._descr_TEXT:set_text(descStr)
    end
end

function SurviveGameRewardSkillCard:updateUI(data, recordType)
    self._recordType = recordType
    if self._recordType == y3.SurviveConst.SELECT_REWARD_SKILL then
        self._content:set_visible(true)
        self._back:set_visible(false)
    elseif self._recordType == y3.SurviveConst.SELECT_REWARD_SKILL_HIDE then
        self._content:set_visible(false)
        self._back:set_visible(true)
    elseif self._recordType == y3.SurviveConst.SELECT_REWARD_SOUL then
        self._content:set_visible(true)
        self._back:set_visible(false)
    elseif self._recordType == y3.SurviveConst.SELECT_REWARD_TASK then
    end
    self._ui:set_alpha(255)
    self._titletype:set_visible(true)
    local randomCfg = include("gameplay.config.random_pool").get(data.id)
    assert(randomCfg, "randomCfg is nil by id=" .. data.id)
    self._randomCfg = randomCfg
    if randomCfg.item_type == 1 or randomCfg.item_type == 2 then
        if randomCfg.item_type == 1 then
            self._titletype:get_child("_type_TEXT"):set_text(y3.Lang.get("jinnegwenben"))
        else
            self._titletype:get_child("_type_TEXT"):set_text(y3.Lang.get("jinnegwenben1"))
        end
        self:_updateSkill(data.random_pool_item)
    elseif randomCfg.item_type == 3 then
        self._titletype:get_child("_type_TEXT"):set_text(y3.Lang.get("wupinwenben"))
        self:_updateItem(data.random_pool_item)
    elseif randomCfg.item_type == 4 then
        self._titletype:get_child("_type_TEXT"):set_text(GameAPI.get_text_config('#750391471#lua'))
        self:_updateHero(data.random_pool_item)
    elseif randomCfg.item_type == 5 then
        self._titletype:get_child("_type_TEXT"):set_text(y3.langCfg.get(80).str_content)
        self:_updateTask(data.random_pool_item)
    end
end

function SurviveGameRewardSkillCard:getValue(value)
    if value == "" then
        return value
    end
    if tonumber(value) then
        return tonumber(value)
    else
        -- print("SurviveGameSkillTip:getValue", value)
        local attrPack = include("gameplay.config.attr_pack").get(value)
        if not attrPack then
            return value
        end
        local attrs = string.split(attrPack.attr, "|")
        local params = string.split(attrs[1], "#")
        return tonumber(params[2])
    end
end

function SurviveGameRewardSkillCard:playNormalCard()
    local scaleTo = include("gameplay.utils.uiAction.DelayTime").new(self._ui, 0.4,
        function()
            self._back:set_visible(false)
            self._content:set_visible(true)
        end)
    scaleTo:run(2)
    local delay = include("gameplay.utils.uiAction.DelayTime").new(self._ui, 2.5)
    delay:run(1)
    local posy = self._ui:get_relative_y()
    -- local movey = include("gameplay.utils.uiAction.MoveToY").new(self._ui, { x = 0, y = posy }, { x = 0, y = posy + 100 },
    --     0.4)
    -- movey:run(2)
    local fade = include("gameplay.utils.uiAction.FadeTo").new(self._ui, 255, 0, 0.6)
    fade:run(2)
    local spawn = include("gameplay.utils.uiAction.Spawn").new()
    spawn:runPure(fade)
    local seq = include("gameplay.utils.uiAction.Sequence").new()
    seq:runAction(scaleTo, delay, spawn)
end

function SurviveGameRewardSkillCard:playAnim()
    local scaleTo = include("gameplay.utils.uiAction.ScaleTo").new(self._ui, { x = 0.3, y = 1 }, { x = 1, y = 1 }, 0.4,
        function()
            self._back:set_visible(false)
            self._content:set_visible(true)
        end)
    scaleTo:run(2)
    local delay = include("gameplay.utils.uiAction.DelayTime").new(self._ui, 2.5)
    delay:run(1)
    local posy = self._ui:get_relative_y()
    local movey = include("gameplay.utils.uiAction.MoveToY").new(self._ui, { x = 0, y = posy }, { x = 0, y = posy + 100 },
        0.4)
    movey:run(2)
    local fade = include("gameplay.utils.uiAction.FadeTo").new(self._ui, 255, 0, 0.6)
    fade:run(2)
    local spawn = include("gameplay.utils.uiAction.Spawn").new()
    spawn:runPure(movey, fade)
    local seq = include("gameplay.utils.uiAction.Sequence").new()
    seq:runAction(scaleTo, delay, spawn)
end

return SurviveGameRewardSkillCard
