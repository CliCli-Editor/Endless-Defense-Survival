local LogicBase = include("gameplay.level.logic.LogicBase")
local SurviveGameCheckFuncOpen = class("SurviveGameCheckFuncOpen", LogicBase)

function SurviveGameCheckFuncOpen:ctor(level)
    SurviveGameCheckFuncOpen.super.ctor(self, level)
    self:_init()
    y3.gameApp:addTimerLoop(0.5, handler(self, self._onTimer))
end

function SurviveGameCheckFuncOpen:_init()
    local stage_funcation_unlock = include("gameplay.config.stage_funcation_unlock")
    local allInPlayers           = y3.userData:getAllInPlayers()
    self._funcOpenParam          = {}
    local len                    = stage_funcation_unlock.length()
    for _, playerData in ipairs(allInPlayers) do
        local param = {}
        local funcList = {}
        for i = 1, len do
            local cfg = stage_funcation_unlock.indexOf(i)
            local data = {}
            data.isOpen = false
            data.cfg = cfg
            table.insert(funcList, data)
        end
        param.funcList = funcList
        self._funcOpenParam[playerData:getId()] = param
    end
end

function SurviveGameCheckFuncOpen:_onTimer(delay)
    if not self._level:isGameStart() then
        return
    end
    local dt = delay:float()
    local allInPlayers = y3.userData:getAllInPlayers()
    for _, playerData in ipairs(allInPlayers) do
        local param = self._funcOpenParam[playerData:getId()]
        local funcList = param.funcList
        for _, data in ipairs(funcList) do
            local isOpen = data.isOpen
            if not isOpen then
                local cfg = data.cfg
                data.isOpen = y3.FuncCheck.checkFuncIsOpen(playerData:getId(), cfg.stage_funcation)
                if data.isOpen then
                    y3.Sugar.localNotice(playerData:getId(), cfg.stage_funcation_unlock_notice_id, {})
                    y3.gameApp:dispatchEvent(y3.EventConst.EVENT_FUNC_CHECK_UPDATE, playerData:getId(),
                    cfg.stage_funcation)
                end
            end
        end
        for i, data in ipairs(funcList) do
            local isOpen = data.isOpen
            if isOpen then
                table.remove(funcList, i)
            end
        end
    end
end

return SurviveGameCheckFuncOpen
