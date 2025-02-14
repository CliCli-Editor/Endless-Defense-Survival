local UIBase                    = include("gameplay.base.UIBase")
local SurviveGameWeaponBookCard = class("SurviveGameWeaponBookCard", UIBase)

function SurviveGameWeaponBookCard:ctor(parent, root)
    self._root = root
    SurviveGameWeaponBookCard.super.ctor(self, parent, y3.SurviveConst.PREFAB_MAP["main_wiki_weapon"])
    self._icon_IMG = self._ui:get_child("avatar._icon_IMG")
    self._locked = self._ui:get_child("avatar.locked")
    self._sel = self._ui:get_child("sel")

    self._icon_IMG:add_local_event("左键-点击", function()
        if self._weaponId then
            if self._isUnlock then
                self._root:onSelectWeaponCard(self._weaponId)
            else
                local cfg = include("gameplay.config.stage_config").get(self._cfg.unlock_stage_level)
                if cfg then
                    y3.Sugar.localTips(y3.gameApp:getMyPlayerId(), GameAPI.get_text_config('#30000001#lua40') .. cfg.stage_name .. GameAPI.get_text_config('#30000001#lua23'))
                end
            end
        end
    end)
    self._icon_IMG:add_local_event("鼠标-移入", function()
        y3.Sugar.tipRoot():showSkillTip({ cfg = self._cfg })
    end)
    self._icon_IMG:add_local_event("鼠标-移出", function()
        y3.Sugar.tipRoot():hideSkillTip()
    end)
end

function SurviveGameWeaponBookCard:updateUI(weaponId)
    local cfg = include("gameplay.config.config_skillData").get(tostring(weaponId))
    if not cfg then
        return
    end
    local stagePass = y3.gameApp:getLevel():getLogic("SurviveGameStagePass")
    local maxPassStageId = stagePass:getMaxPassStageId(y3.gameApp:getMyPlayerId())
    self:updateSampleUI(weaponId, maxPassStageId)
end

function SurviveGameWeaponBookCard:updateSampleUI(weaponId, maxPassStageId)
    local cfg = include("gameplay.config.config_skillData").get(tostring(weaponId))
    if not cfg then
        return
    end
    self._cfg = cfg
    self._weaponId = weaponId
    self._icon_IMG:set_image(tonumber(cfg.icon))
    local isUnlock = maxPassStageId >= cfg.unlock_stage_level
    self._isUnlock = isUnlock
    self._locked:set_visible(not isUnlock)
    self._icon_IMG:set_visible(isUnlock)
end

function SurviveGameWeaponBookCard:updateSelect(seWeaponId)
    self._sel:set_visible(seWeaponId == self._weaponId)
end

return SurviveGameWeaponBookCard
