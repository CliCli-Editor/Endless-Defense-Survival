---@enum(key, partial) y3.Const.SceneUI
local SceneUI = {
    ["start_game"] = "5dccbd7e-65b0-47c2-a559-124587568ec5",
    ["tower_sum"] = "6ddd785e-04c3-47cc-86a7-d569f68b19d3",
    ["npc_title"] = "e83ad096-03d1-4c76-9fb4-fefef3a27003",
    ["tower_gain"] = "ed5c7f0e-0951-452a-88c6-3b7e4fc71dd1",
}

y3.util.tableMerge(y3.const.SceneUI or {}, SceneUI)
