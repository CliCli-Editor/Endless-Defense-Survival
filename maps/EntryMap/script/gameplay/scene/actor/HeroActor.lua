local GlobalConfigHelper  = require "gameplay.level.logic.helper.GlobalConfigHelper"
local SurviveHelper       = include "gameplay.level.logic.helper.SurviveHelper"
local ActorBuffComponent  = include "gameplay.scene.com.ActorBuffComponent"
local ActorSkillComponnet = include("gameplay.scene.com.ActorSkillComponent")
local ActorItemComponent  = include("gameplay.scene.com.ActorItemComponent")
local ActorHurtComponent  = include("gameplay.scene.com.ActorHurtComponent")
local ActorBase           = include("gameplay.base.ActorBase")
local UnitConst           = include("gameplay.const.UnitConst")
local SkillConst          = include("gameplay.const.SkillConst")
local Weapon              = include("gameplay.scene.actor.Weapon")
local HeroActor           = class("HeroActor", ActorBase)
local HeroSoulActor       = include("gameplay.scene.actor.HeroSoulActor")

local ATTACK_RANGE        = 1000
local SHIELD_BAR          = 134275021
local NO_SHIELD_BAR       = 134250194

function HeroActor:ctor(player_id)
    self._ownPlayerId = player_id
    HeroActor.super.ctor(self, player_id, UnitConst.UNIT_HERO_ID)
    self._itemCom = ActorItemComponent.new(self)
    self._skillCom = ActorSkillComponnet.new(self)
    self._buffCom = ActorBuffComponent.new(self)
    self._hurtCom = ActorHurtComponent.new(self)
    local playerData = y3.userData:getPlayerData(player_id)
    self._abilityKeyList = {}
    self:_initAttr()
    self:_initData()
    self:_initSkill()
    self:_handlerAttack()
    self._actorUnit:event("单位-造成伤害后", handler(self, self._handlerDamage))
    self._actorUnit:event("单位-死亡", handler(self, self._handlerDeath))
    self._actorUnit:event("单位-属性变化", y3.const.UnitAttr['最大魔法'], handler(self, self._handlerAttrChange))
    self._actorUnit:event("单位-受到伤害后", handler(self, self._handlerBeHurt))
    self._actorUnit:event("单位-受到伤害前", function(trg, data)
        local damage_instance = data.damage_instance
        local player = self._actorUnit:get_owner_player()
        if damage_instance:is_missed() then
            y3.Sugar.achievement():recordAchievementDataIncrement(player:get_id(), y3.SurviveConst.ACHIEVEMENT_COND_MISS,
                1)
            y3.Sugar.achievement():updateAchievement(player:get_id(), y3.SurviveConst.ACHIEVEMENT_REFRESH_TYPE_MISS)
        end
    end)
    self._actorUnit:add_tag(y3.SurviveConst.STATE_PLAYER_TAG)
    y3.gameApp:addTimerLoop(1, handler(self, self._statisticsDamage))

    local max_cnt = GlobalConfigHelper.get(32)
    self._actorUnit:set_bar_cnt(max_cnt)
    self._actorUnit:set_pkg_cnt(18)

    self._totalDamage       = 0
    self._soulDamage        = 0
    self._lastTotalDamage   = 0
    self._finalBossHurt     = 0
    self._totalDps          = 0
    self._abilityKillMap    = {}
    self._abilityKillGold   = {}
    self._globalHpPer       = 100
    self._globalMinHpper    = 100
    self._maxDps            = 0

    self._recordAttrChanges = {}
    self._soulFirst         = true
    self:_handAllAttrChange()
    self._soulActor = HeroSoulActor.new(player_id, self._actorUnit, self)
end

function HeroActor:replaceModelId(modelId)
    self._actorUnit:replace_model(modelId)
end

function HeroActor:getSoulHeroActor()
    return self._soulActor
end

function HeroActor:setHeroIcon(heroIcon)
    self._heroIcon = heroIcon
end

function HeroActor:getHeroIcon()
    if self._heroIcon then
        return self._heroIcon
    end
    return self._actorUnit:get_icon()
end

-- -@class EventParam.ET_UNIT_ATTR_CHANGE
-- -@field unit Unit # 无描述
-- -@field attr string # 无描述
-- -@field old_float_attr_value number # 无描述
function HeroActor:_handAllAttrChange()
    local attr = include("gameplay.config.attr")
    local len = attr.length()
    for i = 1, len do
        local cfg = attr.indexOf(i)
        assert(cfg, "")
        if cfg.y3_name ~= "" then
            if y3.const.UnitAttr[cfg.y3_name] then
                self._actorUnit:event("单位-属性变化", y3.const.UnitAttr[cfg.y3_name], function(trg, data)
                    table.insert(self._recordAttrChanges, data.attr)
                end)
            end
        end
    end
end

function HeroActor:getRecordAttrChanges()
    return self._recordAttrChanges
end

function HeroActor:clearRecordAttrChanges()
    self._recordAttrChanges = {}
end

function HeroActor:_handlerBeHurt(trg, data)
    if data.damage > 0 then
        self._beDamage = self._beDamage + data.damage
    end
    local hp = self._actorUnit:get_attr(y3.const.UnitAttr['生命'])
    local maxHp = self._actorUnit:get_attr(y3.const.UnitAttr['最大生命'])
    self._globalHpPer = hp / maxHp * 100
    if self._globalHpPer < self._globalMinHpper then
        self._globalMinHpper = self._globalHpPer
    end
    local player = y3.player(self._ownPlayerId)
    if self._globalHpPer <= 50 then
        if not self._xinshouFlag and y3.userDataHelper.has_store_item(player, y3.SurviveConst.PLATFORM_ITEM_MAP.XINSHOULIBAO) then
            self._actorUnit:add_attr(y3.const.UnitAttr['生命'], maxHp - hp)
            self._xinshouFlag = true
        end
    end
end

function HeroActor:getGlobalHpPer()
    return self._globalMinHpper
end

function HeroActor:getBeDamage()
    return self._beDamage
end

function HeroActor:setPosition(pos)
    HeroActor.super.setPosition(self, pos)
    self._initPos = pos
    for i, weapon in ipairs(self._weaponList) do
        weapon:updatePos()
    end
    if self._soulActor:isSoul() then
        local soulPos = pos:move(-1900, -1450, pos:get_z())
        self._soulActor:setPosition(soulPos)
    else
        local soulPos = pos:move(400, 0, pos:get_z())
        self._soulActor:setPosition(soulPos)
    end
end

function HeroActor:weaponHad(key)
    for i, weapon in ipairs(self._weaponList) do
        if weapon:getKey() == key then
            return true
        end
    end
end

function HeroActor:addWeapon(key, ability)
    if self:weaponHad(key) then
        return
    end
    local weapon = Weapon.new(key, self._actorUnit)
    table.insert(self._weaponList, weapon)
    self._weaponMap[ability:get_key()] = weapon
end

function HeroActor:getAbilityKeyList()
    return self._abilityKeyList
end

function HeroActor:getAbilityCanUp()
    local result = {}
    for i = 1, #self._abilityKeyList do
        local abilityKey = self._abilityKeyList[i]
        local cfg = include("gameplay.config.config_skillData").get(tostring(abilityKey))
        if cfg then
            if cfg.type >= 1 and cfg.type <= 5 then
                table.insert(result, abilityKey)
            end
        end
    end
    return result
end

function HeroActor:addSkill(ability)
    -- print("add skill", ability:get_name())
    local abilityKey = ability:get_key()
    table.insert(self._skillList, ability)
    if not self._skillMap[abilityKey] then
        self._skillMap[abilityKey] = 1
    else
        self._skillMap[abilityKey] = self._skillMap[abilityKey] + 1
    end
    -- print("add skill", ability:get_key(),ability:get_name())
    local cfg = include("gameplay.config.config_skillData").get(tostring(abilityKey))
    if cfg then
        local playerData = y3.userData:getPlayerData(self._actorUnit:get_owner_player():get_id())
        if playerData then
            ability:kv_save(y3.SurviveConst.WEAPON_ATTR_SPEED,
                playerData:getWeaponEffectValue(abilityKey, y3.SurviveConst.WEAPON_SPEED) * 1.0)
            ability:kv_save(y3.SurviveConst.WEAPON_ATTR_DMG,
                playerData:getWeaponEffectValue(abilityKey, y3.SurviveConst.WEAPON_DMG) * 1.0)
        end
        if not self._abilityDamage[abilityKey] then
            self._abilityDamage[abilityKey] = 0
            table.insert(self._abilityKeyList, abilityKey)
        end
        if cfg.tower_equipment > 0 then
            self:addWeapon(cfg.tower_equipment, ability)
        end
        if cfg.buff_desc ~= "" then
            if not self:hadInBuffList(cfg) then
                table.insert(self._buffList, cfg)
            end
        end
        if not self._skillTypeMap[cfg.type] then
            self._skillTypeMap[cfg.type] = 1
        else
            self._skillTypeMap[cfg.type] = self._skillTypeMap[cfg.type] + 1
        end
        y3.Sugar.achievement():updateAchievement(self._actorUnit:get_owner_player():get_id(),
            y3.SurviveConst.ACHIEVEMENT_REFRESH_ADD_SKILL)
        y3.SignalMgr:dispatch(y3.SignalConst.SIGNAL_UPDATE_SKILL, self._actorUnit:get_owner_player(), abilityKey)
        y3.gameApp:dispatchEvent(y3.EventConst.EVENT_HERO_ACTOR_ADD_SKILL, self._ownPlayerId, abilityKey)
    end
end

function HeroActor:hadInBuffList(cfg)
    for i = 1, #self._buffList do
        if self._buffList[i].id == cfg.id then
            return true
        end
    end
    return false
end

function HeroActor:getBuffList()
    local result = {}
    for i = 1, #self._buffList do
        local cfg = self._buffList[i]
        local num = self:getSkillNameNum(cfg.id)
        if num > 0 then
            table.insert(result, cfg)
        end
    end
    return result
end

function HeroActor:removeSkill(ability)
    for i, abilityEx in ipairs(self._skillList) do
        if ability == abilityEx then
            table.remove(self._skillList, i)
            local cfg = include("gameplay.config.config_skillData").get(tostring(abilityEx:get_key()))
            if cfg then
                if self._skillMap[abilityEx:get_key()] then
                    self._skillMap[abilityEx:get_key()] = math.max(0, self._skillMap[abilityEx:get_key()] - 1)
                end
                if self._skillTypeMap[cfg.type] then
                    self._skillTypeMap[cfg.type] = math.max(0, self._skillTypeMap[cfg.type] - 1)
                end
                return
            end
        end
    end
end

function HeroActor:learnSkill(skillCfgId, abilityType)
    -- print("学习了技能", self._actorUnit, skillCfgId)
    local skillCfg = include("gameplay.config.config_skillData").get(tostring(skillCfgId))
    assert(skillCfg, "skillCfg is nil by id=" .. skillCfgId)
    local ability = self._actorUnit:add_ability(abilityType or y3.const.AbilityType.COMMON, tonumber(skillCfg.id))
    assert(ability, "技能物编不存在 id=" .. skillCfg.id)
    -- ability:setCfg(skillCfg)
    y3.gameApp:dispatchEvent(y3.EventConst.EVENT_SURVIVE_SKILL_INFO_UPDATE, self._ownPlayerId)
end

function HeroActor:forgetSkill(skillCfgId)
end

function HeroActor:getSkillNameNum(key)
    local key = tonumber(key)
    if self._skillMap[key] then
        return self._skillMap[key]
    end
    return 0
end

function HeroActor:getSkillTypeNum(skilltype)
    if self._skillTypeMap[skilltype] then
        return self._skillTypeMap[skilltype]
    end
    return 0
end

function HeroActor:addBuff(buffId)
    self._actorUnit:add_buff({ key = buffId, source = self._actorUnit, time = -1 })
end

function HeroActor:getRangeSkillList(range)
    local result = {}
    for i, ability in ipairs(self._skillList) do
        local abilityKey = ability:get_key()
        local cfg = include("gameplay.config.config_skillData").get(tostring(abilityKey)) --ability:getCfg()
        if cfg and cfg.range == range then
            table.insert(result, ability)
        end
    end
    return result
end

function HeroActor:_initSkill()
    self._skillList = {}
    self._skillMap = {}
    self._skillTypeMap = {}
    self._buffList = {}
    -- self:learnSkill(11001)
    self:_addBringOwnSkill(y3.const.AbilityType.COMMON)
    self:_addBringOwnSkill(y3.const.AbilityType.HERO)
    self:_addBringOwnSkill(y3.const.AbilityType.HIDE)
    self:_addBringOwnSkill(y3.const.AbilityType.NORMAL)
end

function HeroActor:_addBringOwnSkill(abilityType)
    local abilitys = self._actorUnit:get_abilities_by_type(abilityType)
    for i = 1, #abilitys do
        self:addSkill(abilitys[i])
    end
end

function HeroActor:_initData()
    self._totalDamage = 0
    self._roundDamage = {}
    self._killNum = 0
    self._weaponList = {}
    self._weaponMap = {}
    self._abilityDamage = {}
    self._abilityDps = {}
    self._lastCount = {}
    self._dpsMap = {}
    self._rebornCount = GlobalConfigHelper.get(10)
    local player = y3.player(self._ownPlayerId)
    if y3.userDataHelper.has_store_item(player, y3.SurviveConst.PLATFORM_ITEM_MAP.HUANGJINTEQUAN) then
        self._rebornCount = self._rebornCount + 1
    end
    self._rebornTime = GlobalConfigHelper.get(11)
    self._actorUnit:kv_save("rebornCount", self._rebornCount)
    self._beDamage = 0
    self._dieCount = 0
    self._jianchiKill = 0
    for i = 1, 1 do
        local param   = {}
        param.delay   = GlobalConfigHelper.get(31)
        param.totalDt = 0
        param.dpsMap  = {}
        table.insert(self._abilityDps, param)
    end
end

function HeroActor:getRebornCount()

end

function HeroActor:_initAttr()
    local value = GlobalConfigHelper.get(9)
    local cfg = include("gameplay.config.attr_pack").get(value)
    local attrs = string.split(cfg.attr, "|")
    for _, attr in ipairs(attrs) do
        local params = string.split(attr, "#")
        local attrId = tonumber(params[1])
        local attrCfg = include("gameplay.config.attr").get(attrId)
        local attrValue = tonumber(params[2])
        -- print("HeroActor:_initAttr", attrCfg.y3_name, attrValue)
        self._actorUnit:set_attr(y3.const.UnitAttr[attrCfg.y3_name], attrValue)
        if attrCfg.y3_name == "最大生命" then
            self._actorUnit:set_attr(y3.const.UnitAttr["生命"], attrValue)
        end
        if attrCfg.y3_name == "最大魔法" then
            self._actorUnit:set_attr(y3.const.UnitAttr['魔法'], attrValue)
        end
    end
end

function HeroActor:addAttrPack(attrPackId, attrType)
    local cfg = include("gameplay.config.attr_pack").get(attrPackId)
    if not cfg then
        return
    end
    local attrs = string.split(cfg.attr, "|")
    assert(attrs)
    for _, attr in ipairs(attrs) do
        self:addPureAttr(attr, attrType)
        -- local params = string.split(attr, "#")
        -- assert(params)
        -- local attrId = tonumber(params[1])
        -- local attrCfg = include("gameplay.config.attr").get(attrId)
        -- assert(attrCfg)
        -- local attrValue = tonumber(params[2])
        -- self._actorUnit:add_attr(y3.const.UnitAttr[attrCfg.y3_name], attrValue)
    end
end

function HeroActor:addPureAttr(attrStr, attrType)
    local params = string.split(attrStr, "#")
    assert(params)
    local attrId = tonumber(params[1])
    local attrCfg = include("gameplay.config.attr").get(attrId)
    assert(attrCfg)
    local attrValue = tonumber(params[2])
    self._actorUnit:add_attr(y3.const.UnitAttr[attrCfg.y3_name], attrValue, attrType)
end

function HeroActor:addBaseAttr(attrId, attrValue, attrType)
    local attrCfg = include("gameplay.config.attr").get(attrId)
    assert(attrCfg)
    self._actorUnit:add_attr(y3.const.UnitAttr[attrCfg.y3_name], attrValue, attrType)
end

-- -@class EventParam.ET_UNIT_HURT_OTHER_FINISH
-- -@field is_critical_hit number # 是否是暴击
-- -@field is_normal_hit boolean # 是否是普通攻击
-- -@field damage number # 受到的伤害值
-- -@field source_unit Unit # 施加伤害的单位
-- -@field target_unit Unit # 承受伤害的单位
-- -@field ability Ability # 当前伤害所属技能
-- -@field damage_type integer # 伤害类型
-- -@field unit Unit # 无描述
-- -@field damage_instance DamageInstance # 伤害实例
function HeroActor:_handlerDamage(trg, data)
    local target_unit = data.target_unit
    if target_unit and target_unit:has_tag(y3.SurviveConst.STATE_TAG_JIANCHI) then
        if not target_unit:is_alive() then -- 尖刺击杀敌人
            y3.Sugar.achievement():recordAchievementDataIncrement(self._actorUnit:get_owner_player():get_id(),
                y3.SurviveConst.ACHIEVEMENT_COND_JIANCHI_KILL, 1)
        end
        target_unit:remove_tag(y3.SurviveConst.STATE_TAG_JIANCHI)
    end
    if target_unit and not target_unit:is_alive() then --击杀敌人
        y3.Sugar.achievement():updateAchievement(self._actorUnit:get_owner_player():get_id(),
            y3.SurviveConst.ACHIEVEMENT_REFRESH_TYPE_KILL)
    end
    local ability = data.ability
    local damage = data.damage
    local abilityKey = 0
    if ability then
        abilityKey = ability:get_key()
    end
    if not self._abilityDamage[abilityKey] then
        self._abilityDamage[abilityKey] = damage
    else
        self._abilityDamage[abilityKey] = self._abilityDamage[abilityKey] + damage
    end
    if not target_unit:is_alive() then
        -- print("HeroActor:_handlerDamage", "死亡", target_unit)
        if not self._abilityKillMap[abilityKey] then
            self._abilityKillMap[abilityKey] = 1
        else
            self._abilityKillMap[abilityKey] = self._abilityKillMap[abilityKey] + 1
        end
    end
    self._totalDamage = self._totalDamage + damage
    if target_unit:has_tag(y3.SurviveConst.STATE_TAG_FINAL_BOSS) then
        self._finalBossHurt = self._finalBossHurt + damage
    end
end

function HeroActor:addSoulDamage(abilityKey, damage)
    self._soulDamage = self._soulDamage + damage
    self._totalDamage = self._totalDamage + damage
    if not self._abilityDamage[abilityKey] then
        self._abilityDamage[abilityKey] = damage
    else
        self._abilityDamage[abilityKey] = self._abilityDamage[abilityKey] + damage
    end
end

function HeroActor:getSkillDmgTotal(skillId)
    skillId = tonumber(skillId)
    return self._abilityDamage[skillId] or 0
end

function HeroActor:getSkillKillTotal(skillId)
    skillId = tonumber(skillId)
    return self._abilityKillMap[skillId] or 0
end

function HeroActor:_statisticsDamage(delay)
    local dt = delay:float()
    for i = 1, #self._abilityDps do
        local param = self._abilityDps[i]
        param.totalDt = param.totalDt + dt
        if param.totalDt >= param.delay then
            param.totalDt = param.totalDt - param.delay
            for ability, damage in pairs(self._abilityDamage) do
                if not param.dpsMap[ability] then
                    param.dpsMap[ability] = { lastDamage = 0, dps = 0 }
                end
                local dps = (damage - param.dpsMap[ability].lastDamage) / param.delay

                param.dpsMap[ability].dps = dps
                param.dpsMap[ability].lastDamage = damage
            end
            if i == 1 then
                self._totalDps = (self._totalDamage - self._lastTotalDamage) / param.delay
                if self._totalDps > self._maxDps then
                    self._maxDps = self._totalDps
                end
                self._lastTotalDamage = self._totalDamage
            end
        end
    end
    for ability, damage in pairs(self._abilityDamage) do
        if not self._dpsMap[ability] then
            self._dpsMap[ability] = { dps = 0, lastCount = 0, totalCount = 0 }
        end
        local dpsData = self._dpsMap[ability]
        local curCount = self:getSkillNameNum(ability)
        dpsData.totalCount = dpsData.totalCount + dpsData.lastCount
        if dpsData.totalCount == 0 then
            dpsData.dps = 0
        else
            dpsData.dps = damage / (dpsData.totalCount)
        end
        dpsData.lastCount = curCount
    end
    local player = self._actorUnit:get_owner_player()
    y3.Sugar.achievement():updateAchievement(player:get_id(), y3.SurviveConst.ACHIEVEMENT_REFRESH_TYPE_ATTR)
end

function HeroActor:printDamage()
    local param = self._abilityDps[1]
    for ability, damage in pairs(self._abilityDamage) do
        if not param.dpsMap[ability] then
            param.dpsMap[ability] = { lastDamage = 0, dps = 0 }
        end
        local dps = param.dpsMap[ability].dps
        if param.totalDt > 0 then
            dps = (damage - param.dpsMap[ability].lastDamage) / param.totalDt
        end
        local cfg = include("gameplay.config.config_skillData").get(tostring(ability))
        print("[", cfg.name, "]", "总伤害:" .. damage, "秒伤:" .. dps)
    end
end

function HeroActor:getSkillAllTimeDps()
    local result = {}
    local param = self._abilityDps[1]
    for ability, damage in pairs(self._abilityDamage) do
        local cfg = include("gameplay.config.config_skillData").get(tostring(ability))
        if cfg then
            if (cfg.type >= 1 and cfg.type <= 5) or cfg.type == 500 then
                if not param.dpsMap[ability] then
                    param.dpsMap[ability] = { lastDamage = 0, dps = 0 }
                end
                local dps = param.dpsMap[ability].dps
                if param.totalDt > 0 then
                    dps = (damage - param.dpsMap[ability].lastDamage) / param.totalDt
                end
                param.dpsMap[ability].dps = dps
                table.insert(result, { key = ability, dps = dps, damage = damage })
            end
        end
    end
    return result
end

function HeroActor:getSkillDps(key)
    key = tonumber(key)
    return self._dpsMap[key] and self._dpsMap[key].dps or 0
end

function HeroActor:getDieCount()
    return self._dieCount
end

function HeroActor:isDieFianl()
    local isHas = self._actorUnit:has_item_by_key(2004801) -- 复活道具
    local isNoReborn = self._rebornCount == 0
    local isAlive = self._actorUnit:is_alive()
    return isNoReborn and (not isHas) and not isAlive
end

function HeroActor:_handlerDeath(trg, data)
    if self._rebornCount > 0 then
        self._rebornCount = self._rebornCount - 1
        self._actorUnit:kv_save("rebornCount", self._rebornCount)
        self._dieCount = self._dieCount + 1
        self._actorUnit:add_attr(y3.const.UnitAttr['魔法'], self._actorUnit:get_attr(y3.const.UnitAttr['最大魔法']))
        y3.gameApp:addTimer(self._rebornTime, function()
            self._actorUnit:reborn()
            self._actorUnit:heals(self._actorUnit:get_attr(y3.const.UnitAttr['最大生命']), nil, nil, "heal")
            self._actorUnit:set_point(self._initPos, false)
        end)
        local player = self._actorUnit:get_owner_player()
        y3.Sugar.localNotice(player:get_id(), 25, { sec = self._rebornTime, times = self._rebornCount })
    else
        self._actorUnit:kv_save("rebornCount", 0)
        local player = self._actorUnit:get_owner_player()
        local playerData = y3.userData:getPlayerData(player:get_id())
        playerData:setIsFailed(true)
        y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy"):clearPlayerEnemy(playerData)
        -- y3.Sugar.localNotice(player:get_id(), 26, {})
    end
end

function HeroActor:getAttrValue(id)
    local attrCfg = include("gameplay.config.attr").get(id)
    assert(attrCfg, "")
    local curAttrValue = 0
    curAttrValue = self._actorUnit:get_attr(y3.const.UnitAttr[attrCfg.y3_name])
    if id == 16 then -- 金币成长
        local addRatio = self._actorUnit:get_attr("金币成长加成(%)") / 100
        curAttrValue = curAttrValue * (1 + addRatio)
        return curAttrValue
    end
    if id == 37 then
        local addRatio = self._actorUnit:get_attr("尖刺伤害加成(%)") / 100
        curAttrValue = curAttrValue * (1 + addRatio)
        return curAttrValue
    end
    return curAttrValue
end

function HeroActor:getAttrPureValue(id)
    local attrCfg = include("gameplay.config.attr").get(id)
    assert(attrCfg, "")
    local curAttrValue = 0
    curAttrValue = self._actorUnit:get_attr(y3.const.UnitAttr[attrCfg.y3_name])
    return curAttrValue
end

function HeroActor:getAttrPureValue1(id)
    local attrCfg = include("gameplay.config.attr").get(id)
    assert(attrCfg, "")
    local curAttrValue = 0
    curAttrValue = self._actorUnit:get_attr(y3.const.UnitAttr[attrCfg.y3_name], "基础")
    return curAttrValue
end

function HeroActor:getAttrPureValue2(id)
    local attrCfg = include("gameplay.config.attr").get(id)
    assert(attrCfg, "")
    local curAttrValue = 0
    curAttrValue = self._actorUnit:get_attr(y3.const.UnitAttr[attrCfg.y3_name], "增益")
    return curAttrValue
end

-- -@class EventParam.ET_UNIT_ATTR_CHANGE
-- -@field unit Unit # 无描述
-- -@field attr string # 无描述
-- -@field old_float_attr_value number # 无描述
function HeroActor:_handlerAttrChange(trg, data)
    local curValue = data.unit:get_attr(data.attr)
    if curValue > 0 then
        if self._curType == SHIELD_BAR then
            return
        end
        self._curType = SHIELD_BAR
        data.unit:set_blood_bar_type(SHIELD_BAR)
    else
        if self._curType == NO_SHIELD_BAR then
            return
        end
        self._curType = NO_SHIELD_BAR
        data.unit:set_blood_bar_type(NO_SHIELD_BAR)
    end
end

-- M.AbilityCastType = {
--     ['COMMON_ATK'] = 1,
--     ['ACTIVE_ABILITY'] = 2,
--     ['PASSIVE_ABILITY'] = 3,
--     ['BUILDING_ABILITY'] = 4,
--     ['PICK_ABILITY'] = 6,
-- }
function HeroActor:_handlerAttack()

end

function HeroActor:updateWeaponFacing(tarPos)
    for i, weapon in ipairs(self._weaponList) do
        weapon:setFacing(tarPos)
    end
end

function HeroActor:getPower()
    local weaponClassRatioMap = GlobalConfigHelper.getWeaponClassPowerRatioMap()
    local typeAttrMap = {
        { y3.const.UnitAttr["普通伤害加成"], y3.const.UnitAttr["普通攻击强度"] },
        { y3.const.UnitAttr["穿刺伤害加成"], y3.const.UnitAttr["穿刺攻击强度"] },
        { y3.const.UnitAttr["魔法伤害加成"], y3.const.UnitAttr["魔法攻击强度"] },
        { y3.const.UnitAttr["攻城伤害加成"], y3.const.UnitAttr["攻城攻击强度"] },
        { y3.const.UnitAttr["混乱伤害加成"], y3.const.UnitAttr["混乱攻击强度"] },
    }
    local typeTemMap = {}
    local extraPower = 0
    for i = 1, #self._abilityKeyList do
        local abilityKey = self._abilityKeyList[i]
        local cfg = include("gameplay.config.config_skillData").get(tostring(abilityKey))
        if cfg then
            if not typeTemMap[cfg.type] then
                typeTemMap[cfg.type] = 0
            end
            local count = self._skillMap[abilityKey] or 0
            extraPower = extraPower + count * (cfg.power_extra > 0 and cfg.power_extra or 0)
            if weaponClassRatioMap[cfg.class] then
                typeTemMap[cfg.type] = typeTemMap[cfg.type] + count * weaponClassRatioMap[cfg.class]
            end
        end
    end
    local weaponPower = 0
    for weaponType = 1, #typeAttrMap do
        local value = (1 + (typeTemMap[weaponType] or 0)) * (100 + self._actorUnit:get_attr(typeAttrMap[weaponType][1])) /
            100 *
            (1000 + self._actorUnit:get_attr(y3.const.UnitAttr['物理攻击']) + self._actorUnit:get_attr(typeAttrMap[weaponType][2])) /
            1000
        weaponPower = weaponPower + value
    end
    local attr = include("gameplay.config.attr")
    local len = attr.length()
    local attrpower = 0
    for i = 1, len do
        local attrCfg = attr.indexOf(i)
        assert(attrCfg, "")
        if attrCfg.y3_name ~= "" then
            if attrCfg.power > 0 then
                local value = self._actorUnit:get_attr(y3.const.UnitAttr[attrCfg.y3_name])
                value = (value - attrCfg.power_out) * attrCfg.power
                attrpower = attrpower + value
            end
        end
    end
    local soulAtk = self._soulActor:getSoulAtk()
    local soulAtkRatio = GlobalConfigHelper.get(58)
    return 1 * (extraPower + attrpower + soulAtk * soulAtkRatio)
end

function HeroActor:getMaxDps()
    return self._maxDps
end

function HeroActor:getTotalDamage()
    return self._totalDamage
end

function HeroActor:getFinalBossHurt()
    return self._finalBossHurt
end

function HeroActor:getTotalDps()
    local param = self._abilityDps[1]
    if param.totalDt > 0 then
        self._totalDps = (self._totalDamage - self._lastTotalDamage) / param.totalDt
        if self._totalDps > self._maxDps then
            self._maxDps = self._totalDps
        end
    end
    return self._totalDps
end

function HeroActor:getRoundDamage(round)
    return self._roundDamage[round] or 0
end

function HeroActor:checkNearHaveMonster()
    local myPos = self._actorUnit:get_point()
    self._selecter:in_shape(myPos, self._shape)
    local groups = self._selecter:get()
    local units = groups:pick()
    local minDis = 99999999999
    local minUnit = nil
    for i = 1, #units do
        if units[i]:get_name() == "monster" and units[i]:is_alive() then
            local unit = units[i]
            local unitPos = unit:get_point()
            local dis = myPos:get_distance_with(unitPos)
            if dis < minDis then
                minDis = dis
                minUnit = unit
            end
        end
    end
    return minUnit
end

function HeroActor:cleanup()
    self._itemCom:clear()
    self._itemCom = nil
    self._skillCom:clear()
    self._skillCom = nil
    self._buffCom:clear()
    self._buffCom = nil
    self._hurtCom:clear()
    self._hurtCom = nil
    HeroActor.super.cleanup(self)
end

function HeroActor:getJianciAttr()
    return self._actorUnit:get_attr(y3.const.UnitAttr['物理攻击'])
end

return HeroActor
