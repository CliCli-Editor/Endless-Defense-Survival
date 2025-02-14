local ActorBase     = include("gameplay.base.ActorBase")
local UnitConst     = include("gameplay.const.UnitConst")
local HeroSoulActor = class("HeroSoulActor", ActorBase)

function HeroSoulActor:ctor(player_id, ownUnit, ownActor)
    self._ownPlayerId = player_id
    self._ownActor = ownActor

    self._soulHeroCfg = nil
    self._isSoul = true
    local unit = y3.unit.create_unit(ownUnit, UnitConst.UNIT_SOUL_ID, y3.point.create(0, 0, 0), 0)
    self:_setUnit(unit)
    self._skillList = {}
    self._skillMap = {}
    unit:add_tag(y3.SurviveConst.STATE_TAG_SOUL_ACTOR)
    self:_initHero()
    self._actorUnit:event("单位-造成伤害后", handler(self, self._handlerDamage))
    self._actorUnit:set_bar_cnt(6)
    self._actorUnit:event("技能-获得", handler(self, self._onSkillGet))
    self._actorUnit:event("技能-失去", handler(self, self._onSkillLost))
end

function HeroSoulActor:_onSkillGet(trg, data)
    local ability = data.ability
    if ability then
        local skillCfgId = ability:get_key()
        local skillCfg = include("gameplay.config.config_skillData").get(tostring(skillCfgId))
        if skillCfg then
            print("learn skill id=" .. skillCfgId)
            if not self._skillMap[skillCfg.id] then
                self._skillMap[skillCfg.id] = 1
                table.insert(self._skillList, skillCfg)
            else
                self._skillMap[skillCfg.id] = self._skillMap[skillCfg.id] + 1
            end
        end
    end
    y3.gameApp:dispatchEvent(y3.EventConst.HERO_SOUL_ADD_SKILL, self._ownPlayerId)
end

function HeroSoulActor:_onSkillLost(trg, data)
    local ability = data.ability
    if ability then
        local skillCfgId = ability:get_key()
        local skillCfg = include("gameplay.config.config_skillData").get(tostring(skillCfgId))
        if skillCfg then
            print("lose skill id=" .. skillCfg.id)
            if self._skillMap[skillCfg.id] then
                local newValue = self._skillMap[skillCfg.id] - 1
                self._skillMap[skillCfg.id] = newValue
                if newValue <= 0 then
                    self._skillMap[skillCfg.id] = nil
                    for i = 1, #self._skillList do
                        if self._skillList[i].id == skillCfg.id then
                            table.remove(self._skillList, i)
                            break
                        end
                    end
                end
            end
        end
    end
end

function HeroSoulActor:_handlerDamage(trg, data)
    local ability = data.ability
    local damage = data.damage
    local target_unit = data.target_unit
    if target_unit and not target_unit:is_alive() then --击杀敌人
        y3.Sugar.achievement():updateAchievement(self._ownPlayerId, y3.SurviveConst.ACHIEVEMENT_REFRESH_TYPE_KILL)
    end
    self._ownActor:addSoulDamage(40000, damage)
    -- local abilities = self._actorUnit:get_abilities_by_type(y3.const.AbilityType.NORMAL)
    -- for i = 1, #abilities do
    --     log.info(abilities[i])
    -- end
end

function HeroSoulActor:_initHero()
    if self._soulHeroCfg then
        self._actorUnit:set_name(self._soulHeroCfg.name)
        self._actorUnit:replace_model(self._soulHeroCfg.editor_id)
        if self._soulHeroCfg.attr_pack ~= "" then
            self:addAttrPack(self._soulHeroCfg.attr_pack, "基础")
        end
    end
end

function HeroSoulActor:setSoulCfg(cfg)
    local oldUniqueSkillId = self:getUniqueSkill()
    self._soulHeroCfg = cfg
    self._actorUnit:set_attr(y3.const.UnitAttr['攻击范围'], cfg.hero_atk_range)
    self._actorUnit:set_scale(cfg.model_scale)
    self._actorUnit:kv_save("hero_id", cfg.id)
    self._actorUnit:set_icon(cfg.hero_icon)
    -- log.info("set soul cfg id=" .. cfg.id)
    self._actorUnit:stop_all_abilities()
    self._actorUnit:remove_ability_by_key(y3.const.AbilityType.NORMAL, 4000001)
    self._actorUnit:remove_ability_by_key(y3.const.AbilityType.NORMAL, 4000002)
    if cfg.hero_atk_type == 1 then
        self._actorUnit:add_ability(y3.const.AbilityType.NORMAL, 4000002)
    else
        self._actorUnit:add_ability(y3.const.AbilityType.NORMAL, 4000001)
    end
    if cfg.hero_skill_id > 0 then
        if oldUniqueSkillId > 0 then
            self._actorUnit:remove_ability_by_key(y3.const.AbilityType.HERO, oldUniqueSkillId)
        end
        self:learnSkill(cfg.hero_skill_id)
    end
    self:_initHero()
end

function HeroSoulActor:getAttrValue(id)
    local attrCfg = include("gameplay.config.attr").get(id)
    assert(attrCfg, "")
    local curAttrValue = 0
    curAttrValue = self._actorUnit:get_attr(y3.const.UnitAttr[attrCfg.y3_name])
    return curAttrValue
end

function HeroSoulActor:getSoulAtk()
    return self._actorUnit:get_attr(y3.const.UnitAttr['物理攻击'])
end

function HeroSoulActor:addAttrPack(attrPackId, attrType)
    local cfg = include("gameplay.config.attr_pack").get(attrPackId)
    if not cfg then
        return
    end
    local attrs = string.split(cfg.attr, "|")
    assert(attrs)
    for _, attr in ipairs(attrs) do
        self:addPureAttr(attr, attrType)
    end
end

function HeroSoulActor:addPureAttr(attrStr, attrType)
    local params = string.split(attrStr, "#")
    assert(params)
    local attrId = tonumber(params[1])
    local attrCfg = include("gameplay.config.attr").get(attrId)
    assert(attrCfg)
    local attrValue = tonumber(params[2])
    if attrType == "基础" then
        self._actorUnit:set_attr(y3.const.UnitAttr[attrCfg.y3_name], attrValue, attrType)
    else
        self._actorUnit:add_attr(y3.const.UnitAttr[attrCfg.y3_name], attrValue, attrType)
    end
end

function HeroSoulActor:learnSkill(skillCfgId)
    if not skillCfgId then
        print("技能id是空")
        return
    end
    local skillCfg = include("gameplay.config.config_skillData").get(tostring(skillCfgId))
    assert(skillCfg, "skillCfg is nil by id=" .. skillCfgId)
    local ability = nil
    if self:getUniqueSkill() == skillCfgId then
        ability = self._actorUnit:add_ability(y3.const.AbilityType.HERO, tonumber(skillCfg.id))
    else
        ability = self._actorUnit:add_ability(y3.const.AbilityType.COMMON, tonumber(skillCfg.id))
    end
    assert(ability, "技能物编不存在 id=" .. skillCfg.id)
    print("learn skill id=" .. skillCfg.id)
    if tonumber(skillCfgId) == 40003 then
        self._isSoul = false
    end
end

function HeroSoulActor:isSoul()
    return self._isSoul
end

function HeroSoulActor:getSkillNameNum(id)
    return self._skillMap[id] or 0
end

function HeroSoulActor:getSkikList()
    return self._skillList
end

function HeroSoulActor:getUniqueSkill()
    if self._soulHeroCfg then
        return self._soulHeroCfg.hero_skill_id
    end
    return 0
end

function HeroSoulActor:getSoulIcon()
    if self._soulHeroCfg then
        return self._soulHeroCfg.hero_icon
    end
    return 106484
end

function HeroSoulActor:getHeroIcon()
    return self:getSoulIcon()
end

return HeroSoulActor
