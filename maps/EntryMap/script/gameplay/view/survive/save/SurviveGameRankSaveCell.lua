local StaticUIBase = include("gameplay.base.UIBase")
local SurviveGameRankSaveCell = class("SurviveGameRankSaveCell", StaticUIBase)

function SurviveGameRankSaveCell:ctor(parent)
    SurviveGameRankSaveCell.super.ctor(self, parent, y3.SurviveConst.PREFAB_MAP["main_rank"])

    self._rank_TEXT = self._ui:get_child("rank._rank_TEXT")
    self._player_plat_name_TEXT = self._ui:get_child("player_plat_name._player_plat_name_TEXT")
    self._rank_value_TEXT = self._ui:get_child("rank_value._rank_value_TEXT")
    self._add_info_TEXT = self._ui:get_child("add_info._add_info_TEXT")

    self._bg_top1 = self._ui:get_child("rank.bg_top")
    self._bg_top2 = self._ui:get_child("rank.bg_top_2")
    self._bg_top3 = self._ui:get_child("rank.bg_top_3")
end

function SurviveGameRankSaveCell:updateUI(slot, rank)
    local nickName = GameAPI.get_archive_rank_player_nickname(slot, rank)
    local rankValue = GameAPI.get_archive_rank_player_archive_value(slot, rank)
    local tag = GameAPI.get_archive_rank_player_tag(slot, rank)
    self._rank_TEXT:set_text(rank)
    self._player_plat_name_TEXT:set_text(nickName ~= "" and nickName or "查无此人")
    if slot == 11 then
        local stageid = math.floor(rankValue / 100000) + 1
        local time = 100000 - (rankValue % 100000)
        local stageCfg = include("gameplay.config.stage_config").get(stageid)
        if stageCfg and stageCfg.stage_type == 1 then
            self._rank_value_TEXT:set_text(stageCfg.stage_name)
            local min = math.floor(time / 60)
            local sec = time % 60
            self._add_info_TEXT:set_text(string.format("%dmin%ds", min, sec))
        else
            self._rank_value_TEXT:set_text("")
            self._add_info_TEXT:set_text("")
        end
    else
        self._rank_value_TEXT:set_text(rankValue)
        self._add_info_TEXT:set_text(tag)
    end
    self._bg_top1:set_visible(rank == 1)
    self._bg_top2:set_visible(rank == 2)
    self._bg_top3:set_visible(rank == 3)
end

return SurviveGameRankSaveCell
