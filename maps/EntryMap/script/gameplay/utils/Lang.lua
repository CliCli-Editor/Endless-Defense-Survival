local Lang = {}
local LangTemplate = {}
LangTemplate["lang_qiuxian_des"] = "#d9d9d9[当前等级#20e60flevel#d9d9d9] \
每10秒获得#20e60f num #d9d9d9份求贤令 \
[下一等级#20e60flevel_next#d9d9d9] \
每10秒获得#20e60f num_next #d9d9d9份求贤令"
LangTemplate["lang_liangcao_des"] = "#d9d9d9[当前等级#20e60flevel#d9d9d9] \
拥有#20e60f num #d9d9d9粮草上限 \
[下一等级#20e60flevel_next#d9d9d9] \
拥有#20e60f num_next #d9d9d9粮草上限"
LangTemplate["lang_tiaozhanshibai"] = GameAPI.get_text_config('#1809989295#lua')
LangTemplate["lang_jueweitiaozhan_chenggong"] = GameAPI.get_text_config('#1919439813#lua')
LangTemplate["lang_wufatiaozhan_zhanxunbuzu"] = GameAPI.get_text_config('#2146479411#lua')
LangTemplate["lang_zhengzaitiaozhanzhong"] = GameAPI.get_text_config('#1486432435#lua')
LangTemplate["lang_max_juewei_wufatiaozhan"] = GameAPI.get_text_config('#76019178#lua')
LangTemplate["lang_wufatiaozhantishi"] = GameAPI.get_text_config('#-627252301#lua')
LangTemplate["lang_daojishi_txt"] = GameAPI.get_text_config('#537429267#lua')
LangTemplate["lang_guanzhirenshu_xianzhi"] = GameAPI.get_text_config('#-1835822957#lua')
LangTemplate["lang_wuketibadeguanzhi"] = GameAPI.get_text_config('#-247662427#lua')
LangTemplate["lang_sell_content_des"] = GameAPI.get_text_config('#1910560616#lua')
LangTemplate["lang_skill_type_desc"] = GameAPI.get_text_config('#15160731#lua')
LangTemplate["lang_skill_type_desc5"] = GameAPI.get_text_config('#1772894007#lua')
LangTemplate["sell_out_tip"] = GameAPI.get_text_config('#1835377998#lua')
LangTemplate["shuaxinheishi"] = GameAPI.get_text_config('#34301107#lua')
LangTemplate["wupinwenben"] = GameAPI.get_text_config('#-535761679#lua')
LangTemplate["jinnegwenben"] = GameAPI.get_text_config('#-304454385#lua')
LangTemplate["jinnegwenben1"] = GameAPI.get_text_config('#-659068328#lua')
LangTemplate["renwushibai"] = GameAPI.get_text_config('#1532784220#lua')
LangTemplate["jinbibuzu"] = GameAPI.get_text_config('#-1604967454#lua')

LangTemplate["treasure_level_max_tip"] = GameAPI.get_text_config('#-435886849#lua')
LangTemplate["treasure_lv_up_cost_tip"] = GameAPI.get_text_config('#-1288538949#lua')
LangTemplate["treasure_lv_up_success"] = GameAPI.get_text_config('#-784991155#lua')

LangTemplate["level_mode1"] = GameAPI.get_text_config('#-378228758#lua')
LangTemplate["level_mode2"] = GameAPI.get_text_config('#-685684920#lua')
LangTemplate["level_mode3"] = GameAPI.get_text_config('#-685684920#lua')

LangTemplate["level_start_title"] = GameAPI.get_text_config('#-335557470#lua')
LangTemplate["level_start_title_master"] = GameAPI.get_text_config('#1739798535#lua')
LangTemplate["lang_rank_detail_text"] = GameAPI.get_text_config('#1383735022#lua')
LangTemplate["lang_rank_detail_texttop"] = GameAPI.get_text_config('#-852622641#lua')

LangTemplate["lang_afk_reward_text"] = GameAPI.get_text_config('#-159387495#lua')
LangTemplate["lang_afk_info_desc"] = GameAPI.get_text_config('#1939754546#lua')
LangTemplate["lang_task_time_shengyu"] = GameAPI.get_text_config('#394851360#lua')
LangTemplate["lang_task_desc"] = GameAPI.get_text_config('#-464072148#lua')
LangTemplate["lang_task_time_shengyu_no"] = GameAPI.get_text_config('#1746438842#lua')
LangTemplate["lang_stage_speed_text"] = GameAPI.get_text_config('#-1211842826#lua')
LangTemplate["lang_survive_time_text"] = GameAPI.get_text_config('#1668692584#lua')
LangTemplate["lang_survive_highest_time_text"] = GameAPI.get_text_config('#-1380681797#lua')

function Lang.get(key, params)
    local text = LangTemplate[key]
    if text then
        if params and type(params) == "table" then
            for key, value in pairs(params) do
                text = string.gsub(text, key, value .. "", 1)
            end
        end
        return text
    end
    return key
end

function Lang.getLang(txt, params)
    local text = txt
    if text then
        if params and type(params) == "table" then
            for key, value in pairs(params) do
                text = string.gsub(text, "{" .. key .. "}", function()
                    value = string.gsub(value, "/%", "")
                    return value
                end) --value .. "")
            end
        end
        return text
    end
    return txt
end

return Lang
