local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGameRankSaveUI = class("SurviveGameRankSaveUI", StaticUIBase)

local MAX_RANK = 50

function SurviveGameRankSaveUI:ctor(ui, slot)
    self._slot = slot
    SurviveGameRankSaveUI.super.ctor(self, ui)

    self._title = self._ui:get_child("title")
    self._mine = self._ui:get_child("mine")
    self._rankList = self._ui:get_child("rank_LIST")

    self._rankCards = {}

    self._mineRankDetail_Text = self._ui:get_child("mine.rank._rank_detail_TEXT")
    self._minePlayerName_Text = self._ui:get_child("mine.player_plat_name._player_plat_name_TEXT")
    self._mineRankValue_Text = self._ui:get_child("mine.rank_value._rank_value_TEXT")
    self._mineAddInfo_Text = self._ui:get_child("mine.add_info._add_info_TEXT")

    self:updateUI()
    self:updateMine()
end

function SurviveGameRankSaveUI:updateUI()
    for i = 1, MAX_RANK do
        local card = self._rankCards[i]
        if not card then
            card = include("gameplay.view.survive.save.SurviveGameRankSaveCell").new(self._rankList)
            self._rankCards[i] = card
        end
        print(self._slot)
        card:updateUI(self._slot, i)
    end
end

function SurviveGameRankSaveUI:updateMine()
    local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local player = playerData:getPlayer()
    local rank = player:get_rank_num(self._slot)
    print(rank)
    local rankValue1 = GameAPI.get_archive_rank_player_archive_value(self._slot, rank)
    if rank > 1 then
        if self._slot == 11 then
            self._mineRankDetail_Text:set_text(y3.Lang.get("lang_rank_detail_texttop", {
                rank = rank
            }))
        else
            local rankValue2 = GameAPI.get_archive_rank_player_archive_value(self._slot, rank - 1)
            self._mineRankDetail_Text:set_text(y3.Lang.get("lang_rank_detail_text", {
                rank = rank,
                score = rankValue2 -
                    rankValue1
            }))
        end


        if rank > 50 then
            self._mineRankDetail_Text:set_text(GameAPI.get_text_config('#-2057880043#lua'))
        end
    elseif rank == 1 then
        self._mineRankDetail_Text:set_text(y3.Lang.get("lang_rank_detail_texttop", {
            rank = rank
        }))
    else
        self._mineRankDetail_Text:set_text(GameAPI.get_text_config('#-2057880043#lua'))
    end
    local playerData = y3.userData:getPlayerData(y3.gameApp:getMyPlayerId())
    local myName = playerData:getPlayerName()
    self._minePlayerName_Text:set_text(myName)
    local tag = GameAPI.get_archive_rank_player_tag(self._slot, rank)
    if self._slot == 11 then
        local stageid = math.floor(rankValue1 / 100000) + 1
        local time = 100000 - (rankValue1 % 100000)
        local stageCfg = include("gameplay.config.stage_config").get(stageid)
        if stageCfg and stageCfg.stage_type == 1 then
            self._mineRankValue_Text:set_text(stageCfg.stage_name)
            local min = math.floor(time / 60)
            local sec = time % 60
            self._mineAddInfo_Text:set_text(string.format("%dmin%ds", min, sec))
        else
            self._mineRankValue_Text:set_text(rankValue1)
            self._mineAddInfo_Text:set_text(tag)
        end
    else
        local attrMap = y3.userDataHelper.getAllSaveAttr(y3.gameApp:getMyPlayerId())
        local attrPower = y3.userDataHelper.getAttrPower(attrMap)
        self._mineRankValue_Text:set_text(math.floor(attrPower))
    end
end

return SurviveGameRankSaveUI
