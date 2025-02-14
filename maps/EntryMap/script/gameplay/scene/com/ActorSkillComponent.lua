local ProjectileConst = require "gameplay.const.ProjectileConst"
local SkillConst = include "gameplay.const.SkillConst"
local ActorSkillComponnet = class("ActorSkillComponnet")
local HurtCalculate = include("gameplay.scene.com.HurtCalculate")
local SurviveHelper = include("gameplay.level.logic.helper.SurviveHelper")
ActorSkillComponnet.selecter = y3.selector.create()

-- -@field event fun(self: Unit, event: "技能-升级", callback: fun(trg: Trigger, data: EventParam.技能-升级)): Trigger
-- -@field event fun(self: Unit, event: "施法-即将开始", callback: fun(trg: Trigger, data: EventParam.施法-即将开始)): Trigger
-- -@field event fun(self: Unit, event: "施法-开始", callback: fun(trg: Trigger, data: EventParam.施法-开始)): Trigger
-- -@field event fun(self: Unit, event: "施法-引导", callback: fun(trg: Trigger, data: EventParam.施法-引导)): Trigger
-- -@field event fun(self: Unit, event: "施法-出手", callback: fun(trg: Trigger, data: EventParam.施法-出手)): Trigger
-- -@field event fun(self: Unit, event: "施法-完成", callback: fun(trg: Trigger, data: EventParam.施法-完成)): Trigger
-- -@field event fun(self: Unit, event: "施法-结束", callback: fun(trg: Trigger, data: EventParam.施法-结束)): Trigger
-- -@field event fun(self: Unit, event: "施法-打断开始", callback: fun(trg: Trigger, data: EventParam.施法-打断开始)): Trigger
-- -@field event fun(self: Unit, event: "施法-打断引导", callback: fun(trg: Trigger, data: EventParam.施法-打断引导)): Trigger
-- -@field event fun(self: Unit, event: "施法-打断出手", callback: fun(trg: Trigger, data: EventParam.施法-打断出手)): Trigger
-- -@field event fun(self: Unit, event: "施法-停止", callback: fun(trg: Trigger, data: EventParam.施法-停止)): Trigger
-- -@field event fun(self: Unit, event: "技能-获得", callback: fun(trg: Trigger, data: EventParam.技能-获得)): Trigger
-- -@field event fun(self: Unit, event: "技能-失去", callback: fun(trg: Trigger, data: EventParam.技能-失去)): Trigger
-- -@field event fun(self: Unit, event: "技能-交换", callback: fun(trg: Trigger, data: EventParam.技能-交换)): Trigger
-- -@field event fun(self: Unit, event: "技能-禁用", callback: fun(trg: Trigger, data: EventParam.技能-禁用)): Trigger
-- -@field event fun(self: Unit, event: "技能-启用", callback: fun(trg: Trigger, data: EventParam.技能-启用)): Trigger
-- -@field event fun(self: Unit, event: "技能-冷却结束", callback: fun(trg: Trigger, data: EventParam.技能-冷却结束)): Trigger

function ActorSkillComponnet:ctor(actor)
    self._actor = actor
    self._unit = self._actor:getUnit()
    self._hurtCalculate = HurtCalculate.new()
    self._triggerList = {}
    -- self:addTrigger(self._unit:event("技能-升级", handler(self, self._onSkillUpgrade)))
    -- self:addTrigger(self._unit:event("施法-即将开始", handler(self, self._onCastWillStart)))
    -- self:addTrigger(self._unit:event("施法-开始", handler(self, self._onCastStart)))
    -- self:addTrigger(self._unit:event("施法-引导", handler(self, self._onCastGuide)))
    -- self:addTrigger(self._unit:event("施法-出手", handler(self, self._onCastHand)))
    -- self:addTrigger(self._unit:event("施法-完成", handler(self, self._onCastComplete)))
    -- self:addTrigger(self._unit:event("施法-结束", handler(self, self._onCastEnd)))
    -- self:addTrigger(self._unit:event("施法-打断开始", handler(self, self._onCastBreakStart)))
    -- self:addTrigger(self._unit:event("施法-打断引导", handler(self, self._onCastBreakGuide)))
    -- self:addTrigger(self._unit:event("施法-打断出手", handler(self, self._onCastBreakHand)))
    -- self:addTrigger(self._unit:event("施法-停止", handler(self, self._onCastStop)))
    -- self:addTrigger(self._unit:event("技能-打开指示器", handler(self, self._onSkillOpenIndicator)))
    -- self:addTrigger(self._unit:event("技能-关闭指示器", handler(self, self._onSkillCloseIndicator)))
    -- self:addTrigger(self._unit:event("技能-建造完成", handler(self, self._onSkillBuildComplete)))
    self:addTrigger(self._unit:event("技能-获得", handler(self, self._onSkillGet)))
    self:addTrigger(self._unit:event("技能-失去", handler(self, self._onSkillLost)))

    -- self:addTrigger(self._unit:event("技能-交换", handler(self, self._onSkillExchange)))
    -- self:addTrigger(self._unit:event("技能-禁用", handler(self, self._onSkillDisable)))
    -- self:addTrigger(self._unit:event("技能-启用", handler(self, self._onSkillEnable)))
    -- self:addTrigger(self._unit:event("技能-冷却结束", handler(self, self._onSkillCoolDownEnd)))
    -- self:
end

function ActorSkillComponnet:_onSkillUpgrade(trg, data)
end

function ActorSkillComponnet:_onCastWillStart(trg, data)
    local ability = data.ability
    local unit = data.unit
    local ability_target_unit = data.ability_target_unit
    local cast = data.cast
end

function ActorSkillComponnet:_onCastStart(trg, data)
    local ability = data.ability
    local unit = data.unit
end

function ActorSkillComponnet:_onCastGuide(trg, data)
end

-- -@class EventParam.ET_ABILITY_SP_END
-- -@field ability Ability # 技能对象
-- -@field unit Unit # 技能Owner
-- -@field ability_target_unit Unit # 技能目标单位
-- -@field cast Cast # 施法
function ActorSkillComponnet:_onCastHand(trg, data)
    -- print("ActorSkillComponnet:_onCastHand", data.ability_target_unit)
    -- local ability = data.ability
    -- local unit = data.unit
    -- local ability_target_unit = data.ability_target_unit
    -- local cast = data.cast
    -- local ability_key = ability:get_key()
    -- local ability_name = ability:get_name()
    -- local cfg = include("gameplay.config.config_skillData").get(ability_key)
    -- -- print(ability, ability_name)
    -- -- print("ActorSkillComponnet:_onCastHand", ability_target_unit)
    -- local handFunc = self["_handle_" .. cfg["funcid"]]
    -- if handFunc then
    --     handFunc(ability, unit, ability_target_unit, cast, cfg)
    --     ability:set_cd(cfg["cd"]*(1-unit:get_attr(y3.const.UnitAttr['冷却缩减'])))
    -- end
end

function ActorSkillComponnet:_onCastComplete(trg, data)
end

function ActorSkillComponnet:_onCastEnd(trg, data)
end

function ActorSkillComponnet:_onCastBreakStart(trg, data)
end

function ActorSkillComponnet:_onCastBreakGuide(trg, data)
end

function ActorSkillComponnet:_onCastBreakHand(trg, data)
end

function ActorSkillComponnet:_onCastStop(trg, data)
end

-- -@field player Player # 玩家
-- -@field unit Unit # 释放单位
-- -@field ability_type py.AbilityType # 技能类型
-- -@field ability_index py.AbilityIndex # 技能Index
-- -@field ability_seq py.AbilitySeq # 技能Seq
-- -@field ability Ability # 技能
function ActorSkillComponnet:_onSkillOpenIndicator(trg, data)

end

-- -@class EventParam.ET_STOP_SKILL_POINTER
-- -@field player Player # 玩家
-- -@field unit Unit # 释放单位
-- -@field ability_type py.AbilityType # 技能类型
-- -@field ability_index py.AbilityIndex # 技能Index
-- -@field ability_seq py.AbilitySeq # 技能Seq
-- -@field ability Ability # 技能
function ActorSkillComponnet:_onSkillCloseIndicator(trg, data)

end

-- -@class EventParam.ET_ABILITY_BUILD_FINISH
-- -@field ability Ability # 技能
-- -@field ability_type py.AbilityType # 技能类型
-- -@field ability_index py.AbilityIndex # 技能ID
-- -@field ability_seq py.AbilitySeq # 技能Seq
-- -@field unit Unit # 主人
-- -@field build_unit Unit # 建造出来的单位
function ActorSkillComponnet:_onSkillBuildComplete(trg, data)
end

-- -@class EventParam.ET_ABILITY_OBTAIN
-- -@field ability Ability # 技能对象
-- -@field unit Unit # 单位
-- -@field lua_table py.Table # 用户自定义配置表
function ActorSkillComponnet:_onSkillGet(trg, data)
    -- log.info("ActorSkillComponnet:_onSkillGet")
    self._actor:addSkill(data.ability)
end

function ActorSkillComponnet:_onSkillLost(trg, data)
    self._actor:removeSkill(data.ability)
end

-- function ActorSkillComponnet:_onSkillExchange(trg, data)
-- end

-- function ActorSkillComponnet:_onSkillDisable(trg, data)
-- end

-- function ActorSkillComponnet:_onSkillEnable(trg, data)
-- end

-- function ActorSkillComponnet:_onSkillCoolDownEnd(trg, data)
-- end

function ActorSkillComponnet:addTrigger(trigger)
    self._unit:bindGC(trigger)
end

function ActorSkillComponnet:clear()
    for i = 1, #self._triggerList do
        self._triggerList[i]:remove()
    end
    self._triggerList = {}
end

-- - 造成伤害
-- -@class Unit.DamageData
-- -@field target Unit|Item|Destructible
-- -@field type y3.Const.DamageType
-- -@field damage number
-- -@field ability? Ability # 关联技能
-- -@field text_type? y3.Const.DamageTextType # 跳字类型
-- -@field text_track? integer # 跳字轨迹类型
-- -@field common_attack? boolean # 视为普攻
-- -@field critical? boolean # 必定暴击
-- -@field no_miss? boolean # 必定命中
-- -@field particle? py.SfxKey # 特效
-- -@field socket? string # 特效挂点
local Bomb = include("gameplay.scene.projectile.Bomb")

-----------伤害运算----------
function ActorSkillComponnet:hit_label(ability, cfg)
    local dmg = unit:get_attr(y3.const.UnitAttr['物理攻击']) * cfg["dmg"]
    if cfg["hit_putong"] then
        dmg = dmg * (1 + unit:get_attr(y3.const.UnitAttr['普通伤害']))
    end
    if cfg["hit_chuantou"] then
        dmg = dmg * (1 + unit:get_attr(y3.const.UnitAttr['穿透伤害']))
    end
    if cfg["hit_mofa"] then
        dmg = dmg * (1 + unit:get_attr(y3.const.UnitAttr['魔法伤害']))
    end
    if cfg["hit_weigong"] then
        dmg = dmg * (1 + unit:get_attr(y3.const.UnitAttr['围攻伤害']))
    end
    if cfg["hit_hunluan"] then
        dmg = dmg * (1 + unit:get_attr(y3.const.UnitAttr['混乱伤害']))
    end
    if cfg["hit_jianci"] then
        dmg = dmg * (1 + unit:get_attr(y3.const.UnitAttr['尖刺伤害']))
    end
    if cfg["hit_zhongdu"] then
        dmg = dmg * (1 + unit:get_attr(y3.const.UnitAttr['中毒伤害']))
    end

    return dmg
end

---------------------------------------------技能具体逻辑---------------------------------------
--- @param ability Ability
--- @param unit Unit
--- @param ability_target_unit Unit
--- @param cast Cast
function ActorSkillComponnet:_handle_fly_ball(ability, unit, ability_target_unit, cast, cfg)
    ability:set_cd(2)
    -- 处理飞弹技能
    -- print("处理飞弹技能")
    local param = {}
    -- param.projectId = 134282077
    param.owner = unit
    param.target = ability_target_unit
    param.move_type = Bomb.MOVE_CATAPULT_TARGET
    param.fireRadius = 400
    param.catapult_nums = 5
    param.catapultRadius = 600
    param.height = 450
    param.speed = 2000

    param.width = 120
    param.distance = 1500
    param.inter = 0.2
    param.delayTime = 3

    --基础变量
    local damage = self._hurtCalculate:calculate(self.hit_label(ability, cfg))
    param.hitCallback = function(projectile, hitTarget, isArray)
        if isArray then
            for i = 1, #hitTarget do
                unit:damage({
                    target = hitTarget[i],
                    type = y3.const.DamageTypeMap['真实'],
                    damage = damage,
                    text_type =
                    "physics"
                })
            end
        else
            unit:damage({ target = hitTarget, type = y3.const.DamageTypeMap['真实'], damage = damage, text_type = "physics" })
        end
    end
    local ball = Bomb.new(param)
end

--掷斧
function ActorSkillComponnet:_handle_skill1(ability, unit, ability_target_unit, cast, cfg)
    --运动变量
    local param = {}
    param.projectId = cfg["projectid"]
    param.owner = unit
    param.target = ability_target_unit
    param.move_type = Bomb.MOVE_CURVE_TARGET
    param.fireRadius = 400
    param.height = 450
    param.speed = 2000

    param.width = 120
    param.inter = 0.2
    param.delayTime = 3

    --基础变量
    local damage = self._hurtCalculate:calculate(self.hit_label(ability, cfg))
    param.hitCallback = function(projectile, hitTarget, isArray)
        unit:damage({ target = hitTarget, type = y3.const.DamageTypeMap['普通'], damage = damage, text_type = y3.Const
        .DamageTextType["physics"] })
    end
    local ball = Bomb.new(param)
end

--步枪
function ActorSkillComponnet:_handle_skill2(ability, unit, ability_target_unit, cast, cfg)
    --运动变量
    local param = {}
    param.projectId = cfg["projectid"]
    param.owner = unit
    param.target = ability_target_unit
    param.move_type = Bomb.MOVE_FOLLOW_TARGET
    param.speed = 3000

    --基础变量
    local damage = self._hurtCalculate:calculate(self.hit_label(ability, cfg))
    param.hitCallback = function(projectile, hitTarget, isArray)
        unit:damage({ target = hitTarget, type = y3.const.DamageTypeMap['普通'], damage = damage, text_type = y3.Const
        .DamageTextType["physics"] })
    end
    local ball = Bomb.new(param)
end

--翎笔
function ActorSkillComponnet:_handle_skill3(ability, unit, ability_target_unit, cast, cfg)
    --运动变量
    local param = {}
    param.projectId = cfg["projectid"]
    param.owner = unit
    param.target = ability_target_unit
    param.move_type = Bomb.MOVE_FOLLOW_TARGET
    param.speed = 3000

    --基础变量
    local damage = self._hurtCalculate:calculate(self.hit_label(ability, cfg))
    param.hitCallback = function(projectile, hitTarget, isArray)
        --主目标
        unit:damage({ target = hitTarget, type = y3.const.DamageTypeMap['物理'], damage = damage, text_type = y3.Const
        .DamageTextType["physics"] })
        --溅射
        ActorSkillComponnet.selecter:in_shape(ability_target_unit:get_point(), y3.shape.create_circular_shape(150))
        local group = ActorSkillComponnet.selecter:get()
        group:remove_unit(ability_target_unit)
        local units = group:pick()
        for i, u in ipairs(units) do
            if u:is_alive() and u:is_enemy(self._owerUnit) then
                unit:damage({ target = u, type = y3.const.DamageTypeMap['普通'], damage = damage * 0.5, text_type = y3
                .Const.DamageTextType["physics"] })
            end
        end
    end
    local ball = Bomb.new(param)
end

--冲击斧
function ActorSkillComponnet:_handle_skill4(ability, unit, ability_target_unit, cast, cfg)
    --运动变量
    local param = {}
    param.projectId = cfg["projectid"]
    param.owner = unit
    param.target = ability_target_unit
    param.move_type = Bomb.MOVE_LINE_TARGET
    param.distance = 600
    param.height = 200
    param.speed = 3000

    --基础变量
    local damage = self._hurtCalculate:calculate(self.hit_label(ability, cfg))
    param.hitCallback = function(projectile, hitTarget, isArray)
        --途径伤害
        unit:damage({ target = hitTarget, type = y3.const.DamageTypeMap['普通'], damage = damage, text_type = y3.Const
        .DamageTextType["physics"] })
    end
    local ball = Bomb.new(param)
end

--荆棘
function ActorSkillComponnet:_handle_skill5(ability, unit, ability_target_unit, cast, cfg)
    --运动变量
    local param = {}
    param.projectId = cfg["projectid"]
    param.owner = unit
    param.target = ability_target_unit
    param.move_type = Bomb.MOVE_LINE_TARGET
    param.distance = 600
    param.height = 200
    param.speed = 3000

    --基础变量
    local damage = self._hurtCalculate:calculate(self.hit_label(ability, cfg))
    param.hitCallback = function(projectile, hitTarget, isArray)
        --途径伤害
        unit:damage({ target = hitTarget, type = y3.const.DamageTypeMap['普通'], damage = damage, text_type = y3.Const
        .DamageTextType["physics"] })
    end
    local ball = Bomb.new(param)
end

-----------------------------------------------------------------------------------------------

return ActorSkillComponnet
