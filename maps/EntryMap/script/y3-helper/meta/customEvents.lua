---@class ECAHelper
---@field call fun(name: '波次刷怪')
---@field call fun(name: '结束集火', v1: Player)
---@field call fun(name: '刷怪特效', v1: table)
---@field call fun(name: '伤害事件（临时）', v1: Unit, v2: Unit, v3: integer, v4: any, v5: boolean, v6: number, v7: Ability)
---@field call fun(name: '刷新镜头', v1: Player)
---@field call fun(name: '设定可视范围', v1: Player, v2: Point)
---@field call fun(name: '击杀特效', v1: table)
---@field call fun(name: '游戏模式选择确认', v1: table)
---@field call fun(name: '设置成长允许', v1: table)

---@diagnostic disable-next-line: invisible
y3.eca.register_custom_event_impl('波次刷怪', function (_)
    y3.game.send_custom_event(1533721807, {

    })
end)

---@diagnostic disable-next-line: invisible
y3.eca.register_custom_event_impl('结束集火', function (_, v1)
    y3.game.send_custom_event(1696147982, {
        ['玩家'] = y3.py_converter.lua_to_py_by_lua_type('Player', v1)
    })
end)

---@diagnostic disable-next-line: invisible
y3.eca.register_custom_event_impl('刷怪特效', function (_, v1)
    y3.game.send_custom_event(2103968820, {
        ['table'] = v1
    })
end)

---@diagnostic disable-next-line: invisible
y3.eca.register_custom_event_impl('伤害事件（临时）', function (_, v1, v2, v3, v4, v5, v6, v7)
    y3.game.send_custom_event(1623822635, {
        ['伤害来源'] = y3.py_converter.lua_to_py_by_lua_type('Unit', v1),
        ['目标单位'] = y3.py_converter.lua_to_py_by_lua_type('Unit', v2),
        ['伤害类型'] = v3,
        ['攻击类型'] = y3.py_converter.lua_to_py_by_lua_type('any', v4),
        ['是否跳字'] = v5,
        ['伤害值'] = v6,
        ['所属技能'] = y3.py_converter.lua_to_py_by_lua_type('Ability', v7)
    })
end)

---@diagnostic disable-next-line: invisible
y3.eca.register_custom_event_impl('刷新镜头', function (_, v1)
    y3.game.send_custom_event(2089306232, {
        ['玩家'] = y3.py_converter.lua_to_py_by_lua_type('Player', v1)
    })
end)

---@diagnostic disable-next-line: invisible
y3.eca.register_custom_event_impl('设定可视范围', function (_, v1, v2)
    y3.game.send_custom_event(2088113838, {
        ['玩家'] = y3.py_converter.lua_to_py_by_lua_type('Player', v1),
        ['point'] = y3.py_converter.lua_to_py_by_lua_type('Point', v2)
    })
end)

---@diagnostic disable-next-line: invisible
y3.eca.register_custom_event_impl('击杀特效', function (_, v1)
    y3.game.send_custom_event(2107078305, {
        ['table'] = v1
    })
end)

---@diagnostic disable-next-line: invisible
y3.eca.register_custom_event_impl('游戏模式选择确认', function (_, v1)
    y3.game.send_custom_event(1048051359, {
        ['table'] = v1
    })
end)

---@diagnostic disable-next-line: invisible
y3.eca.register_custom_event_impl('设置成长允许', function (_, v1)
    y3.game.send_custom_event(1759341115, {
        ['table'] = v1
    })
end)
