local SurviveGamePlayerAllayUI = class("SurviveGamePlayerAllayUI")

function SurviveGamePlayerAllayUI:ctor(root)
    self._root = root
    self._ui = y3.UIHelper.getUI("d6ce18a4-097b-4653-a008-4fa78a3319b1")
    self._player_allay_LIST = y3.UIHelper.getUI("81d04cca-97c6-4638-9622-a97d4135ff59")

    self._playerCards = {}
    self:updateUI()
end

function SurviveGamePlayerAllayUI:updateUI()
    local allInPlayer = y3.userData:getAllInPlayers()
    local cells = self._player_allay_LIST:get_childs()
    for i, cell in ipairs(cells) do
        local card = self._playerCards[i]
        if not card then
            card = include("gameplay.view.survive.main.SurviveGamePlayerAllyIcon").new(cell)
            self._playerCards[i] = card
        end
        if allInPlayer[i] then
            -- print("updateUI", i, allInPlayer[i]:getPlayer())
            card:updateUI(allInPlayer[i]:getPlayer(),allInPlayer[i]:getMainActor())
            card:setVisible(true)
        else
            card:setVisible(false)
        end
    end
end

return SurviveGamePlayerAllayUI
