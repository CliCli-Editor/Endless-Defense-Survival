local ActorBase = include("gameplay.base.ActorBase")
local UnitConst = include("gameplay.const.UnitConst")
local TowerActor = class("TowerActor", ActorBase)

local MAX_LEVEL = 10

function TowerActor:ctor(player_id, cfg)
    self._cfg = cfg
    TowerActor.super.ctor(self, player_id, UnitConst.UNIT_TOWER_ID)
    self._actorUnit:set_attr(y3.const.UnitAttr['物理攻击'], 900)
    self._actorUnit:set_attr(y3.const.UnitAttr["攻击范围"], 1000)

    self._actorUnit:set_bar_cnt(9)
    self._actorUnit.towerCfg = cfg
    local curPos = self:getPosition()
    local dir = y3.point.create(curPos:get_x(), curPos:get_y() - 200, curPos:get_z())
    self._actorUnit:set_facing(curPos:get_angle_with(dir), 1 / 30)
    self._actorUnit:set_move_collision(y3.const.CollisionLayers['物件'], true)
    self._totalDamage = 0
    self._roundDamage = {}
    self._killNum = 0
    self._level = 1
    self:updateLevelStar()
    self:_recordDamage()
    self:_attackLogic()
end

function TowerActor:_recordDamage()
    self._actorUnit:event("单位-造成伤害后", function(trg, data)
        self._totalDamage = self._totalDamage + data.damage
        if not self._roundDamage[y3.userData:getCurRound()] then
            self._roundDamage[y3.userData:getCurRound()] = data.damage
        else
            self._roundDamage[y3.userData:getCurRound()] = self._roundDamage[y3.userData:getCurRound()] + data.damage
        end
        local tarUnit = data.target_unit
        if not tarUnit:is_alive() then
            self._killNum = self._killNum + 1
        end
    end)
end

function TowerActor:_attackLogic()
    local attackRange = self._actorUnit:get_attr(y3.const.UnitAttr['攻击范围'])
    self._attackShape = y3.shape.create_circular_shape(attackRange)
    self._attackSelecter = y3.selector.create()
    local normalAbility = self._actorUnit:get_abilities_by_type(y3.const.AbilityType.NORMAL)[1]
    local mainAbility = self._actorUnit:get_abilities_by_type(y3.const.AbilityType.COMMON)[1]
    self._timerId = y3.gameApp:addTimerLoop(0.2, function()
        -- print("攻击")
        self._attackSelecter:in_shape(self._actorUnit:get_point(), self._attackShape)
        local units = self._attackSelecter:get():pick()
        for i = 1, #units do
            local unit = units[i]
            if unit:is_alive() and self._actorUnit:is_enemy(unit) then
                -- print("攻击目标", unit:get_name())
                if mainAbility:get_cd() <= 0 then
                    self._actorUnit:cast(mainAbility, unit)
                elseif normalAbility:get_cd() <= 0 then
                    self._actorUnit:cast(normalAbility, unit)
                end
                -- self._actorUnit:attack_target(unit, attackRange)
            end
        end
    end)
end

function TowerActor:cleanup()
    y3.gameApp:removeTimer(self._timerId)
    TowerActor.super.cleanup(self)
end

function TowerActor:getTotalDamage()
    return self._totalDamage
end

function TowerActor:getRoundDamage(round)
    return self._roundDamage[round] or 0
end

function TowerActor:getTowerCfg()
    return self._cfg
end

function TowerActor:getTowerCfgId()
    return self._cfg.id
end

function TowerActor:levelup(upLv)
    local upLvs = upLv or 1
    local data = {}
    data.type = 102825
    data.target = self._actorUnit
    data.time = 1
    data.immediate = false
    y3.particle.create(data)
    local attack = self._actorUnit:get_attr(y3.const.UnitAttr['物理攻击'])
    self._actorUnit:set_attr(y3.const.UnitAttr['物理攻击'], attack + upLvs * 30)
    local level = self._level
    local upLevel = math.min(MAX_LEVEL, level + upLvs)
    self._level = upLevel
    self:updateLevelStar()
end

function TowerActor:updateLevelStar()
    if self._starUI then
        self._starUI:remove_scene_ui()
        self._starUI = nil
    end
    local pos = self._actorUnit:get_point()
    self._starUI = y3.scene_ui.create_scene_ui_at_point(string.format("%d", self:getLevel()), pos, 5000, 160)
    self._actorUnit:bindGC(self._starUI)
    -- self._starUI = y3.scene_ui.create_scene_ui_at_player_unit_socket(string.format("%d", self:getLevel()),
    --     self._actorUnit:get_owner(),
    --     self._actorUnit,
    --     "ui_hp")
    -- self._actorUnit:bindGC(self._starUI)
    -- local uuu = self._starUI:get_ui_comp_in_scene_ui(self._actorUnit:get_owner(), "")
end

function TowerActor:getLevel()
    return self._level
end

return TowerActor
