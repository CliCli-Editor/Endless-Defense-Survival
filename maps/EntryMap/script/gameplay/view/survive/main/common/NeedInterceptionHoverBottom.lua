local NeedInterceptionHoverBottom = class("NeedInterceptionHoverBottom")

local needlist = {
    "241a06d6-a0e9-4f5a-a120-14fbc229b94b",
    "5fa3b1ca-5492-45ec-9a31-79a0b05e7b0e",
    "ab2e4cf2-556f-4bcd-817e-1a917e7adf03",
    "ed74086f-f391-4e17-b27a-08d76f2299b9",
    "a3ad40d0-b5dd-421f-8a14-8ecfff742a67",
    "7b095060-dfdc-432a-a69a-441699b52980",
    "22125367-e5c8-4548-8e76-abb7a42f6a0c"
}

function NeedInterceptionHoverBottom:ctor()
    for i = 1, #needlist do
        local ui = y3.UIHelper.getUI(needlist[i])
        print(ui)
        ui:add_local_event('鼠标-移入', function(local_player)
        end)
        ui:add_local_event('鼠标-移出', function(local_player)
        end)
    end
end

return NeedInterceptionHoverBottom
