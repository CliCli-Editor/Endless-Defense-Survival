local LuaCallEca = {}

function LuaCallEca.call(name, ...)
    local args = table.pack(...)
    xpcall(function()
            y3.eca.call(name, table.unpack(args))
        end,
        function(message)
            local traceback = debug.traceback()
            local errors = "\nERROR: " .. message .. "\n"
            errors = errors .. ">>>>>>>>>>>>>>>>>>>>>>>>>>>\n"
            errors = errors .. traceback .. "\n"
            errors = errors .. "<<<<<<<<<<<<<<<<<<<<<<<<<<<\n"
            consoleprint(errors)
        end)
end

return LuaCallEca
