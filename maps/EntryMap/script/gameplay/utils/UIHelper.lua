local UIHelper = {}

UIHelper.uiDetailMaps = {}

UIHelper.nameRecord = {}
--- 自动设置以_开头的ui控件到root中
--- @param root table
--- @param ui UI
--- @param isreserve boolean 是否保留以_开头的ui控件
function UIHelper.autoBindUI(root, ui, isreserve)
    if not isreserve then
        UIHelper.nameRecord = {}
        print("--------------------------------------------------------------")
    end
    local mainChilds = ui:get_childs()
    print("mainChilds count:", #mainChilds)
    for i = 1, #mainChilds do
        local childName = mainChilds[i]:get_name()
        print(childName)
        local index = string.find(childName, '_')
        if index and index == 1 then
            if not UIHelper.nameRecord[childName] then
                UIHelper.nameRecord[childName] = 1
            else
                UIHelper.nameRecord[childName] = UIHelper.nameRecord[childName] + 1
            end
            if root[childName] then
                childName = childName .. UIHelper.nameRecord[childName]
            end
            root[childName] = mainChilds[i]
            print('auto bind ui:', childName, mainChilds[i])
        end
        UIHelper.autoBindUI(root, mainChilds[i], true)
    end
end

---comment
---@param uid string
---@return UI
function UIHelper.getUI(uid)
    return y3.ui.get_by_handle(y3.player(y3.gameApp:getMyPlayerId()), uid)
end

---comment
---@param uid any
---@return UIPrefab
function UIHelper.getPrefabById(uid)
    return y3.ui_prefab.get_by_handle(y3.player(y3.gameApp:getMyPlayerId()), uid)
end

---comment
---@param uiname any
---@param parent_ui any
---@return UIPrefab
function UIHelper.getPrefabByName(uiname, parent_ui)
    return y3.ui_prefab.create(y3.player(y3.gameApp:getMyPlayerId()), uiname, parent_ui)
end

function UIHelper.limitTipOffset(playerId, ui)
    local screenWidth = y3.ui.get_screen_width()
    local screenHeight = y3.ui.get_screen_height()
    local playerData = y3.userData:getPlayerData(playerId)
    local player = playerData:getPlayer()
    local x, y = y3.game.world_pos_to_camera_pos(player:get_mouse_pos()) --y3.gameApp:getMouseScreenPos(playerData:getId())
    local mousePosEx = { x = x, y = y }
    local uiWidth = ui:get_width()
    local uiHeight = ui:get_height()
    local xOffset = 0
    if mousePosEx.x + uiWidth >= screenWidth - 30 then
        xOffset = -uiWidth + 10
    end
    local yOffset = 0
    if mousePosEx.y + uiHeight >= screenHeight - 60 then
        yOffset = -uiHeight + 10
    end
    return xOffset, yOffset
end

return UIHelper
