local GlobalConfigHelper  = include "gameplay.level.logic.helper.GlobalConfigHelper"
local ActorHurtComponent  = include "gameplay.scene.com.ActorHurtComponent"
local SurviveHelper       = include "gameplay.level.logic.helper.SurviveHelper"
local ActorBase           = include("gameplay.base.ActorBase")
local MonsterActor        = class("MonsterActor", ActorBase)
local ActorBuffComponent  = include "gameplay.scene.com.ActorBuffComponent"
local ActorSkillComponnet = include("gameplay.scene.com.ActorSkillComponent")

local mutiHps_2           = string.split(GlobalConfigHelper.get(15), "|")
local mutiAtks_2          = string.split(GlobalConfigHelper.get(16), "|")

local mutiHps_3           = string.split(GlobalConfigHelper.get(56), "|")
local mutiAtks_3          = string.split(GlobalConfigHelper.get(57), "|")

function MonsterActor:ctor(player_id, cfg, stageCfg, mutiHps, mutiAtks, challengeCfg, challengeCfg2, bossCfg)
    self._mutiHps = mutiHps
    self._mutiAtks = mutiAtks
    local unit = y3.PoolMgr:getMonsterUnitByKey(cfg.monster_template_id)
    self:_setUnit(unit)
    self:setIsMonster(true)
    self._cfg = cfg
    self:_clearTag()
    self._actorUnit:set_armor_type(self._cfg.armor_type)
    self._actorUnit:add_tag(y3.SurviveConst.STATE_ENEMY_TAG)
    self._buffCom = ActorBuffComponent.new(self)
    self._actorCom = ActorHurtComponent.new(self)
    local spawnEnemy = y3.gameApp:getLevel():getLogic("SurviveSpawnerEnemy")
    local stopCoin = spawnEnemy and spawnEnemy:getStopDropCoin() or false
    if challengeCfg then
        if stopCoin then
            self._actorUnit:kv_save("die_gold", 0)
            self._actorUnit:kv_save("die_black_diamond", 0.0)
        else
            self._actorUnit:kv_save("die_gold",
                math.floor(self._cfg.die_gold * challengeCfg.stage_challenge_monster_gold_multiplier))
            self._actorUnit:kv_save("die_black_diamond",
                self._cfg.die_black_diamond * challengeCfg.stage_challenge_monster_diamond_multiplier)
        end
    else
        if stopCoin then
            self._actorUnit:kv_save("die_gold", 0)
            self._actorUnit:kv_save("die_black_diamond", 0.0)
        else
            self._actorUnit:kv_save("die_gold", math.floor(self._cfg.die_gold))
            self._actorUnit:kv_save("die_black_diamond", self._cfg.die_black_diamond * 1.0)
        end
    end
    self._isDie = false
    self._actorUnit:kv_save("cfgId", self._cfg.id)
    self._actorUnit:kv_save("if_boss", self._cfg.if_boss == 1 and true or false)
    self:_initAttr(stageCfg, challengeCfg, challengeCfg2, bossCfg)
    self:_handleMonsterDie()
    self._timerAddAtk = y3.gameApp:addTimerLoop(1, handler(self, self._addAtkLogic))
    self._spawnTime = os.time()
    if self._cfg.monster_type == 3 then
        self._actorUnit:add_tag(y3.SurviveConst.STATE_TAG_FINAL_BOSS)
    end
end

function MonsterActor:setOwnPlayerId(playerId)
    local player = y3.player(playerId)
    self._actorUnit:kv_save("own_player_id", player)
end

function MonsterActor:dieDropItem(itemId, size)
    self._dieDropItem = itemId
    self._dieDropSize = size
end

function MonsterActor:_addAtkLogic()
    if y3.class.isValid(self._actorUnit) then
        local atk = self._actorUnit:get_attr(y3.const.UnitAttr['物理攻击'], "基础")
        local addRatio = self._actorUnit:get_attr("每秒攻击成长(%)") / 100
        atk = atk + math.floor(atk * addRatio)
        self._actorUnit:set_attr(y3.const.UnitAttr['物理攻击'], atk)
    else
        self:remove()
    end
end

function MonsterActor:_attachEvent()
end

function MonsterActor:_clearTag()
    self._actorUnit:remove_tag("dying")
    self._actorUnit:remove_tag(y3.SurviveConst.STATE_TAG_FINAL_BOSS)
    self._actorUnit:remove_tag(y3.SurviveConst.STATE_ENEMY_TAG)
    self._actorUnit:set_armor_type(0)
end

function MonsterActor:addBuff(buffId)
    self._actorUnit:add_buff({ key = buffId, source = self._actorUnit, time = -1 })
end

function MonsterActor:_initAttr(stageCfg, challengeCfg, challengeCfg2, bossCfg)
    if stageCfg then
        local playerNum = y3.userData:getPlayerCount()
        local hp        = self._cfg.hp * stageCfg.hp_multiplier
        local atk       = self._cfg.patk * stageCfg.patk_multiplier
        if self._cfg.monster_type == 1 and stageCfg.event_type == 3 then
            hp = hp * tonumber(self._mutiHps[playerNum])
            atk = atk * tonumber(self._mutiAtks[playerNum])
        elseif (self._cfg.monster_type == 2 or self._cfg.monster_type == 3) and stageCfg.event_type == 3 then
            assert(mutiAtks_2)
            assert(mutiHps_2)
            hp = hp * tonumber(mutiHps_2[playerNum])
            atk = atk * tonumber(mutiAtks_2[playerNum])
        end
        self._actorUnit:set_attr(y3.const.UnitAttr['最大生命'], hp)
        self._actorUnit:set_attr(y3.const.UnitAttr['生命'], hp)
        self._actorUnit:set_attr(y3.const.UnitAttr['移动速度'], self._cfg.speed * stageCfg.move_multiplier)
        self._actorUnit:set_attr(y3.const.UnitAttr['物理攻击'], atk)
        self._actorUnit:set_attr(y3.const.UnitAttr['法术攻击'], atk)
        self._actorUnit:set_attr(y3.const.UnitAttr['生命恢复'], self._cfg.recycle_hp * stageCfg.hp_recycle_multiplier)
        self._actorUnit:set_attr(y3.const.UnitAttr['攻击间隔'], self._cfg.atk_interval)
        self._actorUnit:set_attr(y3.const.UnitAttr['攻击范围'], self._cfg.atk_range)
        self._actorUnit:set_attr(y3.const.UnitAttr['每秒攻击成长(%)'], self._cfg.atk_increase)
        self._actorUnit:set_attr(y3.const.UnitAttr['攻击速度'], self._cfg.atk_speed)
        self._actorUnit:set_attr(y3.const.UnitAttr['物理防御'], self._cfg.armor * stageCfg.armor_multiplier)
        self._actorUnit:set_attr(y3.const.UnitAttr['物理穿透'], self._cfg.ignore_armor * stageCfg.ignore_armor_multiplier)
        if stageCfg.stage_born_buffs ~= "" then
            local buffs = string.split(stageCfg.stage_born_buffs, "|")
            assert(buffs, "")
            for i = 1, #buffs do
                -- self._actorUnit:add_buff({ key = tonumber(buffs[i]), source = self._actorUnit, time = -1 })
                self:addBuff(tonumber(buffs[i]))
            end
        end
    elseif challengeCfg then
        local hp  = self._cfg.hp * challengeCfg.hp_multiplier
        local atk = self._cfg.patk * challengeCfg.patk_multiplier
        self._actorUnit:set_attr(y3.const.UnitAttr['最大生命'], hp)
        self._actorUnit:set_attr(y3.const.UnitAttr['生命'], hp)
        self._actorUnit:set_attr(y3.const.UnitAttr['移动速度'], self._cfg.speed * challengeCfg.move_multiplier)
        self._actorUnit:set_attr(y3.const.UnitAttr['物理攻击'], atk)
        self._actorUnit:set_attr(y3.const.UnitAttr['法术攻击'], atk)
        self._actorUnit:set_attr(y3.const.UnitAttr['生命恢复'], self._cfg.recycle_hp * challengeCfg.hp_recycle_multiplier)
        self._actorUnit:set_attr(y3.const.UnitAttr['攻击间隔'], self._cfg.atk_interval)
        self._actorUnit:set_attr(y3.const.UnitAttr['攻击范围'], self._cfg.atk_range)
        self._actorUnit:set_attr(y3.const.UnitAttr['每秒攻击成长(%)'], self._cfg.atk_increase)
        self._actorUnit:set_attr(y3.const.UnitAttr['攻击速度'], self._cfg.atk_speed)
        self._actorUnit:set_attr(y3.const.UnitAttr['物理防御'], self._cfg.armor * challengeCfg.armor_multiplier)
        self._actorUnit:set_attr(y3.const.UnitAttr['物理穿透'], self._cfg.ignore_armor * challengeCfg
            .ignore_armor_multiplier)
    elseif challengeCfg2 then
        local hp  = self._cfg.hp * challengeCfg2.hp_multiplier
        local atk = self._cfg.patk * challengeCfg2.patk_multiplier
        self._actorUnit:set_attr(y3.const.UnitAttr['最大生命'], hp)
        self._actorUnit:set_attr(y3.const.UnitAttr['生命'], hp)
        self._actorUnit:set_attr(y3.const.UnitAttr['移动速度'], self._cfg.speed * challengeCfg2.move_multiplier)
        self._actorUnit:set_attr(y3.const.UnitAttr['物理攻击'], atk)
        self._actorUnit:set_attr(y3.const.UnitAttr['法术攻击'], atk)
        self._actorUnit:set_attr(y3.const.UnitAttr['生命恢复'], self._cfg.recycle_hp * challengeCfg2.hp_recycle_multiplier)
        self._actorUnit:set_attr(y3.const.UnitAttr['攻击间隔'], self._cfg.atk_interval)
        self._actorUnit:set_attr(y3.const.UnitAttr['攻击范围'], self._cfg.atk_range)
        self._actorUnit:set_attr(y3.const.UnitAttr['每秒攻击成长(%)'], self._cfg.atk_increase)
        self._actorUnit:set_attr(y3.const.UnitAttr['攻击速度'], self._cfg.atk_speed)
        self._actorUnit:set_attr(y3.const.UnitAttr['物理防御'], self._cfg.armor * challengeCfg2.armor_multiplier)
        self._actorUnit:set_attr(y3.const.UnitAttr['物理穿透'], self._cfg.ignore_armor * challengeCfg2
            .ignore_armor_multiplier)
    elseif bossCfg then
        self._bossCfg = bossCfg
        local hp      = self._cfg.hp * bossCfg.hp_multiplier
        local atk     = self._cfg.patk * bossCfg.patk_multiplier
        assert(mutiHps_3)
        assert(mutiAtks_3)
        local playerNum = y3.userData:getPlayerCount()
        hp = hp * (tonumber(mutiHps_3[playerNum]) or 1)
        atk = atk * (tonumber(mutiAtks_3[playerNum]) or 1)
        self._actorUnit:set_attr(y3.const.UnitAttr['最大生命'], hp)
        self._actorUnit:set_attr(y3.const.UnitAttr['生命'], hp)
        self._actorUnit:set_attr(y3.const.UnitAttr['移动速度'], self._cfg.speed * bossCfg.move_multiplier)
        self._actorUnit:set_attr(y3.const.UnitAttr['物理攻击'], atk)
        self._actorUnit:set_attr(y3.const.UnitAttr['法术攻击'], atk)
        self._actorUnit:set_attr(y3.const.UnitAttr['生命恢复'], self._cfg.recycle_hp * bossCfg.hp_recycle_multiplier)
        self._actorUnit:set_attr(y3.const.UnitAttr['攻击间隔'], self._cfg.atk_interval)
        self._actorUnit:set_attr(y3.const.UnitAttr['攻击范围'], self._cfg.atk_range)
        self._actorUnit:set_attr(y3.const.UnitAttr['每秒攻击成长(%)'], self._cfg.atk_increase)
        self._actorUnit:set_attr(y3.const.UnitAttr['攻击速度'], self._cfg.atk_speed)
        self._actorUnit:set_attr(y3.const.UnitAttr['物理防御'], self._cfg.armor * bossCfg.armor_multiplier)
        self._actorUnit:set_attr(y3.const.UnitAttr['物理穿透'], self._cfg.ignore_armor * bossCfg.ignore_armor_multiplier)
    else
        self._actorUnit:set_attr(y3.const.UnitAttr['最大生命'], self._cfg.hp)
        self._actorUnit:set_attr(y3.const.UnitAttr['生命'], self._cfg.hp)
        self._actorUnit:set_attr(y3.const.UnitAttr['移动速度'], self._cfg.speed)
        self._actorUnit:set_attr(y3.const.UnitAttr['物理攻击'], self._cfg.patk)
        self._actorUnit:set_attr(y3.const.UnitAttr['法术攻击'], self._cfg.patk)
        self._actorUnit:set_attr(y3.const.UnitAttr['生命恢复'], self._cfg.recycle_hp)
        self._actorUnit:set_attr(y3.const.UnitAttr['攻击间隔'], self._cfg.atk_interval)
        self._actorUnit:set_attr(y3.const.UnitAttr['攻击范围'], self._cfg.atk_range)
        self._actorUnit:set_attr(y3.const.UnitAttr['每秒攻击成长(%)'], self._cfg.atk_increase)
        self._actorUnit:set_attr(y3.const.UnitAttr['攻击速度'], self._cfg.atk_speed)
        self._actorUnit:set_attr(y3.const.UnitAttr['物理防御'], self._cfg.armor)
        self._actorUnit:set_attr(y3.const.UnitAttr['物理穿透'], self._cfg.ignore_armor)
    end
    if self._cfg.magic_id ~= "" then
        local magic_ids = string.split(self._cfg.magic_id, "|")
        assert(magic_ids, "")
        for _, magic_id in ipairs(magic_ids) do
            local data = {}
            data.key = tonumber(magic_id)
            data.source = self._actorUnit
            data.time = -1
            self._actorUnit:add_buff(data)
        end
    end
end

function MonsterActor:setAttrOrdealChangeCfg(cfg)
    local hp = self._actorUnit:get_attr(y3.const.UnitAttr['最大生命'], "基础")
    local atk = self._actorUnit:get_attr(y3.const.UnitAttr['物理攻击'], "基础")
    local speed = self._actorUnit:get_attr(y3.const.UnitAttr['移动速度'], "基础")
    local hp_recycle = self._actorUnit:get_attr(y3.const.UnitAttr['生命恢复'], "基础")
    local defense = self._actorUnit:get_attr(y3.const.UnitAttr['物理防御'], "基础")
    local chauntou = self._actorUnit:get_attr(y3.const.UnitAttr['物理穿透'], "基础")
    self._actorUnit:set_attr(y3.const.UnitAttr['最大生命'], hp * cfg.hp_multiplier)
    self._actorUnit:set_attr(y3.const.UnitAttr['生命'], hp * cfg.hp_multiplier)
    self._actorUnit:set_attr(y3.const.UnitAttr['物理攻击'], atk * cfg.patk_multiplier)
    self._actorUnit:set_attr(y3.const.UnitAttr['移动速度'], speed * cfg.move_multiplier)
    self._actorUnit:set_attr(y3.const.UnitAttr['生命恢复'], hp_recycle * cfg.hp_recycle_multiplier)
    self._actorUnit:set_attr(y3.const.UnitAttr['物理防御'], defense * cfg.armor_multiplier)
    self._actorUnit:set_attr(y3.const.UnitAttr['物理穿透'], chauntou * cfg.ignore_armor_multiplier)
end

function MonsterActor:replaceMonsterName(langStr)
    self._actorUnit:set_name(langStr)
    -- y3.Lang.getLang(langStr,{monster_name=self._cfg.monster_name,})
end

function MonsterActor:isDie()
    return self._isDie
end

function MonsterActor:IsPlayerKill()
    return self._isPlayerKill
end

function MonsterActor:setArchieveNpc(npc)
    self._archieveNpc = npc
end

function MonsterActor:_handleMonsterDie()
    self._dieTrigger = self._actorUnit:event('单位-死亡', function(trg, data)
        if self._archieveNpc then
            self._archieveNpc:remove_state(y3.const.UnitEnumState["隐藏"])
        end
        self._isDie = true
        local curTime = os.time()
        local source_unit = data.source_unit
        if source_unit then
            local owner = source_unit:get_owner_player()
            if owner then
                if self._dieDropItem then
                    SurviveHelper.dropItemInScene(owner:get_id(), self._dieDropItem, self._actorUnit:get_point())
                end
                local playerData = y3.userData:getPlayerData(owner:get_id())
                if playerData then
                    if self._cfg.monster_type == 3 then
                        local allPlayers = y3.userData:getAllInPlayers()
                        for _, playerDataEx in ipairs(allPlayers) do
                            playerDataEx:addKillNumId(self._cfg.id, 1)
                        end
                    else
                        playerData:addKillNumId(self._cfg.id, 1)
                    end
                    self._isPlayerKill = true
                    if self._cfg.monster_type == 3 then --最终boss
                        log.info("final boss die time:", curTime - self._spawnTime)
                        y3.Sugar.achievement():setKillFinalBossTime(playerData:getId(), curTime - self._spawnTime)
                    end
                    playerData:addKillNum(self._cfg.monster_type, 1)
                    y3.SignalMgr:dispatch(y3.SignalConst.SIGNAL_MONSTER_DIE, owner, self._cfg.id)
                end
            end
        end
        self:removeFromGroup()
        y3.gameApp:removeTimer(self._timerAddAtk)
        self:dropBossAward()
        self:dropTreasureReward()
        self:remove()
    end)
end

function MonsterActor:dropTreasureReward()
    if self._cfg.treasure_reward_type > 0 then
        for pid = 1, 4 do
            local treasureDrop = y3.gameApp:getLevel():getLogic("SurviveGameTreasureDrop")
            treasureDrop:randomNum()
            if pid == y3.gameApp:getMyPlayerId() then
                treasureDrop:dropPureTreasureType(y3.gameApp:getMyPlayerId(), y3.userData:getCurStageId(),
                    self._cfg.treasure_reward_type)
            end
        end
    end
end

function MonsterActor:dropBossAward()
    if self._bossCfg then
        local allPlayers = y3.userData:getAllInPlayers()
        for _, playerData in ipairs(allPlayers) do
            local treasureDrop = y3.gameApp:getLevel():getLogic("SurviveGameTreasureDrop")
            treasureDrop:updateStagePass(playerData:getId(), y3.userData:getCurStageId(), true,
                tonumber(self._bossCfg.stage_archive_boss_type))
            if self._cfg then
                y3.Sugar.localNotice(playerData:getId(), 43, { boss_name = self._cfg.monster_name })
            end
        end
    end
end

function MonsterActor:init()
end

function MonsterActor:addToGroup(group)
    self._group = group
    table.insert(self._group, self)
end

function MonsterActor:getGroup()
    return self._group
end

function MonsterActor:removeFromGroup()
    if self._group then
        for i = 1, #self._group do
            if self._group[i] == self then
                table.remove(self._group, i)
                break
            end
        end
        self._group = nil
    end
end

function MonsterActor:cleanup()
    -- self._skillCom:clear()
    self._buffCom:clear()
    self._actorCom:clear()
    -- self._skillCom = nil
    self._buffCom = nil
    self._actorCom = nil
    y3.gameApp:removeTimer(self._timerAddAtk)
    -- y3.PoolMgr:recycleMonsterUnitByKey(self._actorUnit:get_key(), self._actorUnit)
    MonsterActor.super.cleanup(self)
end

function MonsterActor:remove()
    self._dieTrigger:remove()
    self:removeFromGroup()
    self:cleanup()
end

function MonsterActor:isAlive()
    return self._actorUnit:is_alive()
end

return MonsterActor
