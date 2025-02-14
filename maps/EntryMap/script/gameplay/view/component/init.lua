local component_init = {}

component_init.com_map = {}

component_init.com_list = {
    { uid = "9665ac8d-e59b-4fb4-9483-86227daa71f0", compClass = include("gameplay.view.component.ComponentTest") }
}

for i = 1, #component_init.com_list do
    local data = component_init.com_list[i]
    local component = data.compClass.new(y3.UIHelper.getUI(data.uid))
    component_init.com_map[data.uid] = component
end

return component_init
