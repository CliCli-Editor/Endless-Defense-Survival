local SurviveGameUIMouseTip = class("SurviveGameUIMouseTip")

function SurviveGameUIMouseTip:ctor()
    self:_init()
end

function SurviveGameUIMouseTip:_init()
    local ui_mouse_action = include("gameplay.config.ui_mouse_action")
    local len = ui_mouse_action.length()
    for i = 1, len do
        local cfg = ui_mouse_action.indexOf(i)
        assert(cfg, "SurviveGameUIMouseTip")
        local ui = y3.UIHelper.getUI(cfg.element_id)
        if ui then
            ui:add_local_event('鼠标-移入', function(local_player)
                if cfg.element_action == 4 then
                    y3.gameApp:getLevel():getView("SurviveGameTip"):showUniversalTip({ title = "", desc = cfg.content })
                else
                    y3.gameApp:getLevel():getView("SurviveGameTip"):showInfoTip(cfg.element_action, cfg.id)
                end
            end)
            ui:add_local_event('鼠标-移出', function(local_player)
                if cfg.element_action == 4 then
                    y3.gameApp:getLevel():getView("SurviveGameTip"):hideUniversalTip()
                else
                    y3.gameApp:getLevel():getView("SurviveGameTip"):hideInfoTip(cfg.element_action, cfg.id)
                end
            end)
        end
    end
end

return SurviveGameUIMouseTip
