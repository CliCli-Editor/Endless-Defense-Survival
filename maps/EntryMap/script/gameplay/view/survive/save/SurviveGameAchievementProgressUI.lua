local StaticUIBase = include("gameplay.base.StaticUIBase")
local SurviveGameAchievementProgressUI = class("SurviveGameAchievementProgressUI", StaticUIBase)

local MAX_STAR = 4

local UNLOCK_FIRST_BOX_IMG = 134251740
local LOCK_FIRST_BOX_IMG = 134254714

function SurviveGameAchievementProgressUI:ctor()
    local ui = y3.UIHelper.getUI("90154d0e-28be-4b9e-9516-8f7eccca6a9a")
    SurviveGameAchievementProgressUI.super.ctor(self, ui)
    self._progress_BAR = y3.UIHelper.getUI("3375eb99-2f43-4252-bb5a-0acf54492995")
    self._progress_value_TEXT = y3.UIHelper.getUI("9e5289f4-a495-40e7-8710-a085fe51f67e")
    self._totalCountText = y3.UIHelper.getUI("9207df23-3445-4197-bc1c-485ea1631bdc")

    self._star4Text = y3.UIHelper.getUI("f8c4c50f-c031-4fee-84d0-ccbcd1a1a543")
    self._star3Text = y3.UIHelper.getUI("21cb1b59-df29-4ca9-b907-db2a6dbc1a75")
    self._star2Text = y3.UIHelper.getUI("385e8d4c-e9d4-4cdd-969c-02e846863dc0")
    self._star1Text = y3.UIHelper.getUI("f1e70bda-55db-4c60-b7a7-1a78b035b617")

    self._reward = y3.UIHelper.getUI("d55a609b-87e6-4c1b-8e33-3c840feb09fe")
    self._passText = y3.UIHelper.getUI("13fa505b-73c1-4108-87bb-06ad071b339a")
    self._rewardList = y3.UIHelper.getUI("3410255a-c3e0-45b4-9707-419c9c618625")
    self._fist_win_of_the_day = y3.UIHelper.getUI("3215fd41-a093-4446-aa9f-d8d8c0ebd69b")

    self._boxs = {}
    self._fist_win_of_the_day:add_local_event("鼠标-移入", function(local_player)
        if not self._firstCollects then
            return
        end
        local cfg = self._firstCollects[1]
        if cfg then
            y3.Sugar.tipRoot():showUniversalTip({ type = y3.SurviveConst.TIP_TYPE_ACHI_PASS, value = cfg.id })
        end
    end)
    self._fist_win_of_the_day:add_local_event("鼠标-移出", function(local_player)
        y3.Sugar.tipRoot():hideUniversalTip()
    end)
end

function SurviveGameAchievementProgressUI:updateUI(passCollects, firstCollects)
    local totalStar = #passCollects * MAX_STAR
    self._firstCollects = firstCollects
    local curStar = 0
    local achievemnt = y3.gameApp:getLevel():getLogic("SurviveGameAchievement")
    local STAR_MAP = {
        [1] = 0,
        [2] = 0,
        [3] = 0,
        [4] = 0,
    }
    for i, collect in ipairs(passCollects) do
        local starNum = achievemnt:getAchievementConditionValue(y3.gameApp:getMyPlayerId(), collect.id, 1)
        curStar = curStar + starNum
        if starNum > 0 then
            for j = 1, starNum do
                STAR_MAP[j] = STAR_MAP[j] + 1
            end
        end
    end
    self._totalCountText:set_text(curStar .. "/" .. totalStar)
    local pro = curStar / totalStar * 100
    self._progress_BAR:set_current_progress_bar_value(pro)
    self._progress_value_TEXT:set_text(string.format("%.2f", pro) .. "%")
    local cfg = firstCollects[2]
    local passAllCount = achievemnt:getAchievementConditionValue(y3.gameApp:getMyPlayerId(), cfg.id, 1)
    self._passText:set_text(GameAPI.get_text_config('#30000001#lua27') .. passAllCount)
    self:updateTodayBox()

    for i = 2, #self._firstCollects do
        local box = self._boxs[i]
        if not box then
            box = include("gameplay.view.survive.save.SurviveGameAchievementBox").new(self._rewardList)
            self._boxs[i] = box
        end
        box:updateUI(self._firstCollects[i])
    end
end

function SurviveGameAchievementProgressUI:updateTodayBox()
    local cfg = self._firstCollects[1]
    local reward_icon_IMG = self._fist_win_of_the_day:get_child("_reward_icon_IMG")
    local value_TEXT = self._fist_win_of_the_day:get_child("_value_TEXT")
    local unlock_TEXT = self._fist_win_of_the_day:get_child("unlock_TEXT")
    local achievemnt = y3.gameApp:getLevel():getLogic("SurviveGameAchievement")
    local isUnLock = achievemnt:achievementIsUnLock(y3.gameApp:getMyPlayerId(), cfg)
    local images = string.split(cfg.image, "|")
    assert(images, "")
    reward_icon_IMG:set_image(isUnLock and tonumber(images[2]) or tonumber(images[1]))
    unlock_TEXT:set_visible(isUnLock)
end

return SurviveGameAchievementProgressUI
