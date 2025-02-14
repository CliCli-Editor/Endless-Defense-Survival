local GameUtils = {}

GameUtils.globalId = 1

function GameUtils.convertText(num)
    if num >= 10000 then
        return string.format("%.1f万", num / 10000)
    elseif num >= 100000000 then
        return string.format("%.1f亿", num / 100000000)
    else
        return string.format("%.1f", num)
    end
end

function GameUtils.convertText3(num)
    if num >= 1000 then
        return string.format("%.1fk", num / 10000)
    else
        return string.format("%d", math.floor(num))
    end
end

function GameUtils.isInteger(num)
    return num == math.floor(num)
end

function GameUtils.convertText2(num)
    if num >= 10000 then
        return string.format("%d万", num / 10000)
    elseif num >= 100000000 then
        return string.format("%d亿", num / 100000000)
    else
        return string.format("%d", num)
    end
end

function GameUtils.getUid()
    local retId = GameUtils.globalId
    GameUtils.globalId = GameUtils.globalId + 1
    return retId
end

function GameUtils.shuffleArray(array)
    for i = #array, 2, -1 do
        local j = math.floor(y3.math.random_float(1, i))
        array[i], array[j] = array[j], array[i]
    end
    return array
end

function GameUtils.random(min, max)
    return math.floor(y3.math.random_float(min, max))
end

function GameUtils.lerp(from, to, t)
    return from + (to - from) * t
end

function GameUtils.gotoWebUrl()
    GameAPI.visual_pyexec(
        "import MPlatform;MPlatform.GotoUrl('http://qm.qq.com/cgi-bin/qm/qr?_wv=1027&k=tLnoQwle9mjhpIBUWKimtyOBa-SV7WsB&authKey=N238nSda9hyQ%2BTl2AxpzfLO9XokLuKyyLmLBfISeibSEP37Vlx5T2QLV0YR5tvla&noverify=0&group_code=907832371')")
end

function GameUtils.uploadCheating(content)
    local url =
    "https://open.popo.netease.com/open-apis/robots/v1/hook/JSXCpiiQDaNDU3G6NU7FwQBg4S7KIJfz6DEOmYVUOJm6GLrPUFjC5v0XcvXYLEzFEvAE30Tmm1Dhw2B7CX4gLTKQYCM8yKPq"
    local options = {}
    options.post = true
    options.header = { ['Content-Type'] = 'application/json' }
    local body = string.format('{"message": "作弊信息：%s"}', content)
    y3.game:request_url(url, body, function(rvl)
        log.debug("返回内容：" .. tostring(rvl))
    end, options)
end

function GameUtils.get_server_time()
    local result = y3.game.get_current_server_time(8)
    result.timestamp = result.time_zone_stamp
    return result
end

function GameUtils.convertConfigTimestamp(configTimestamp)
    return configTimestamp + 8 * 3600
end

function GameUtils.getCurrentDate(timestamp)
    local date = os.date("!*t", timestamp)
    local year = date.year
    local month = date.month
    local day = date.day
    return year, month, day
end

function GameUtils.getCurrentDate2(timestamp)
    local date = os.date("!*t", timestamp)
    local year = date.year
    local month = date.month
    local day = date.day
    local hour = date.hour
    local minu = date.min
    local seco = date.sec
    return year, month, day, hour, minu, seco
end

function GameUtils.getCurrentDate2Str(timestamp)
    local date = os.date("!*t", timestamp)
    local year = date.year
    local month = date.month
    local day = date.day
    local hour = date.hour
    local minu = date.min
    local seco = date.sec
    return year .. "/" .. month .. "/" .. day .. " " .. hour .. ":" .. minu .. ":" .. seco
end

function GameUtils.getMidnightTimestamp(timestamp)
    local date = os.date("!*t", timestamp)
    date.hour = 0
    date.min = 0
    date.sec = 0
    return os.time(date)
end

function GameUtils.getDifferenceDay(timestamp1, timestamp2)
    local zeroTime1 = GameUtils.getMidnightTimestamp(timestamp1)
    local zeroTime2 = GameUtils.getMidnightTimestamp(timestamp2)
    local diffTime = zeroTime2 - zeroTime1
    local diffDay = math.ceil(diffTime / 86400)
    return diffDay
end

function GameUtils.convertInteger(num)
    local floorNum = math.floor(num)
    local delta = num - floorNum
    if delta < 0.5 then
        return floorNum
    else
        return floorNum + 1
    end
end

function GameUtils.pow(k, n)
    return GlobalAPI.pow(k, n):float()
end

function GameUtils.easeInSine(x)
    return 1 - math.cos((x * math.pi) / 2);
end

function GameUtils.easeOutSine(x)
    return math.sin((x * math.pi) / 2);
end

function GameUtils.easeInOutSine(x)
    return -(math.cos(math.pi * x) - 1) / 2;
end

function GameUtils.easeInQuad(x)
    return x * x;
end

function GameUtils.easeOutQuad(x)
    return 1 - (1 - x) * (1 - x);
end

function GameUtils.easeInOutQuad(x)
    return x < 0.5 and (2 * x * x) or (1 - GameUtils.pow(-2 * x + 2, 2) / 2)
end

function GameUtils.easeInCubic(x)
    return x * x * x;
end

function GameUtils.easeOutCubic(x)
    return 1 - GameUtils.pow(1 - x, 3)
end

function GameUtils.easeInOutCubic(x)
    return x < 0.5 and (4 * x * x * x) or (1 - GameUtils.pow(-2 * x + 2, 3) / 2)
end

function GameUtils.easeInQuart(x)
    return x * x * x * x
end

function GameUtils.easeOutQuart(x)
    return 1 - GameUtils.pow(1 - x, 4)
end

function GameUtils.easeInOutQuart(x)
    return x < 0.5 and (8 * x * x * x * x) or (1 - GameUtils.pow(-2 * x + 2, 4) / 2)
end

function GameUtils.easeInQuint(x)
    return x * x * x * x * x;
end

function GameUtils.easeOutQuint(x)
    return 1 - GameUtils.pow(1 - x, 5)
end

function GameUtils.easeInOutQuint(x)
    return x < 0.5 and (16 * x * x * x * x * x) or (1 - GameUtils.pow(-2 * x + 2, 5) / 2)
end

function GameUtils.easeInExpo(x)
    return x == 0 and 0 or GameUtils.pow(2, 10 * x - 10)
end

function GameUtils.easeOutExpo(x)
    return x == 1 and 1 and 1 - GameUtils.pow(2, -10 * x)
end

function GameUtils.easeInOutExpo(x)
    return x == 0 and 0 or
        (x == 1 and 1 or (x < 0.5 and GameUtils.pow(2, 20 * x - 10) / 2 or (2 - GameUtils.pow(2, -20 * x + 10)) / 2))
end

function GameUtils.easeInCirc(x)
    return 1 - math.sqrt(1 - GameUtils.pow(x, 2))
end

function GameUtils.easeOutCirc(x)
    return math.sqrt(1 - GameUtils.pow(x - 1, 2))
end

function GameUtils.easeInOutCirc(x)
    return x < 0.5
        and (1 - math.sqrt(1 - GameUtils.pow(2 * x, 2))) / 2
        or (math.sqrt(1 - GameUtils.pow(-2 * x + 2, 2)) + 1) / 2
end

function GameUtils.easeInBack(x)
    local c1 = 1.70158;
    local c3 = c1 + 1;
    return c3 * x * x * x - c1 * x * x;
end

function GameUtils.easeOutBack(x)
    local c1 = 1.70158;
    local c3 = c1 + 1;
    return 1 + c3 * GameUtils.pow(x - 1, 3) + c1 * GameUtils.pow(x - 1, 2);
end

function GameUtils.easeInOutBack(x)
    local c1 = 1.70158;
    local c2 = c1 * 1.525;
    return x < 0.5
        and (GameUtils.pow(2 * x, 2) * ((c2 + 1) * 2 * x - c2)) / 2
        and (GameUtils.pow(2 * x - 2, 2) * ((c2 + 1) * (x * 2 - 2) + c2) + 2) / 2
end

function GameUtils.easeInElastic(x)
    local c4 = (2 * math.pi) / 3
    return x == 0 and 0 or (x == 1 and 1 or (-GameUtils.pow(2, 10 * x - 10) * math.sin((x * 10 - 10.75) * c4)))
end

function GameUtils.easeOutElastic(x)
    local c4 = (2 * math.pi) / 3;
    return x == 0 and 0 or (x == 1 and 1 or (GameUtils.pow(2, -10 * x) * math.sin((x * 10 - 0.75) * c4) + 1))
end

function GameUtils.easeInOutElastic(x)
    local c5 = (2 * math.pi) / 4.5;
    return x == 0 and 0 or
        (x == 1 and 1 or (x < 0.5 and -(GameUtils.pow(2, 20 * x - 10) * math.sin((20 * x - 11.125) * c5)) / 2 or ((GameUtils.pow(2, -20 * x + 10) * math.sin((20 * x - 11.125) * c5)) / 2 + 1)))
end

function GameUtils.easeOutBounce(x)
    local n1 = 7.5625;
    local d1 = 2.75;

    if (x < 1 / d1) then
        return n1 * x * x
    elseif (x < 2 / d1) then
        x = x - 1.5 / d1
        return (n1 * x * x + 0.75)
    elseif (x < 2.5 / d1) then
        x = x - 2.25 / d1
        return n1 * (x) * x + 0.9375
    else
        x = x - 2.625 / d1
        return n1 * (x) * x + 0.984375
    end
end

function GameUtils.easeInBounce(x)
    return 1 - GameUtils.easeOutBounce(1 - x);
end

function GameUtils.easeInOutBounce(x)
    return x < 0.5
        and (1 - GameUtils.easeOutBounce(1 - 2 * x)) / 2
        or (1 + GameUtils.easeOutBounce(2 * x - 1)) / 2
end

function GameUtils.retSame(x)
    return x
end

GameUtils.easeMap = {
    [0] = GameUtils.retSame,
    [1] = GameUtils.easeInSine,
    [2] = GameUtils.easeOutSine,
    [3] = GameUtils.easeInOutSine,
    [4] = GameUtils.easeInQuad,
    [5] = GameUtils.easeOutQuad,
    [6] = GameUtils.easeInOutQuad,
    [7] = GameUtils.easeInCubic,
    [8] = GameUtils.easeOutCubic,
    [9] = GameUtils.easeInOutCubic,
    [10] = GameUtils.easeInQuart,
    [11] = GameUtils.easeOutQuart,
    [12] = GameUtils.easeInOutQuart,
    [13] = GameUtils.easeInQuint,
    [14] = GameUtils.easeOutQuint,
    [15] = GameUtils.easeInOutQuint,
    [16] = GameUtils.easeInExpo,
    [17] = GameUtils.easeOutExpo,
    [18] = GameUtils.easeInOutExpo,
    [19] = GameUtils.easeInCirc,
    [20] = GameUtils.easeOutCirc,
    [21] = GameUtils.easeInOutCirc,
    [22] = GameUtils.easeInBack,
    [23] = GameUtils.easeOutBack,
    [24] = GameUtils.easeInOutBack,
    [25] = GameUtils.easeInElastic,
    [26] = GameUtils.easeOutElastic,
    [27] = GameUtils.easeInOutElastic,
    [28] = GameUtils.easeInBounce,
    [29] = GameUtils.easeOutBounce,
    [30] = GameUtils.easeInOutBounce
}

return GameUtils
