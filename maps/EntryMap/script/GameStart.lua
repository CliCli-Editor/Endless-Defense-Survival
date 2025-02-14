if y3.gameApp then
    y3.gameApp:clear()
    y3.gameApp = nil
end
if y3.userData then
    y3.userData:clear()
    y3.userData = nil
end
include("gameplay.utils.init")
y3.player.with_local(function(local_player)
    y3.gameApp = include("gameplay.GameApp").new()
    y3.gameApp:setMyPlayerId(local_player:get_id())
    y3.userData = include("gameplay.data.UserData").new()
    y3.gameApp:run()
    local btnMenu = y3.UIHelper.getUI("e8c1e779-ac2f-4491-89e6-97ca38e559ed")
    btnMenu:set_button_enable(false)
end)
