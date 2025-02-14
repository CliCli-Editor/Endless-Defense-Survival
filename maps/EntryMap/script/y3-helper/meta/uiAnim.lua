---@enum(key, partial) y3.Const.UIAnimKey
local UIAnimKey = {
    ["menu_maintitle_logo"] = "8ae1b12a-b88c-4f70-8254-647472580ffa",
    ["menu_maintitle_clicktostart"] = "a71b3ee8-4c0c-4e3c-be89-8a916adc240a",
    ["hud"] = "be4705b7-70d4-4dd9-8444-9b8686c7955b",
}

y3.util.tableMerge(y3.const.UIAnimKey or {}, UIAnimKey)
