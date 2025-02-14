--[[

        itemtype_manage.lua
        exported by excel2lua.py
        from file:itemtype_manage.xlsx

        auto generate by tools, do not modify it!!!

--]]

local _data = {
  [1] = {id = 1,type_table = 'save_item',not_ = GameAPI.get_text_config('#-2046146373#lua'),},
  [2] = {id = 2,type_table = 'treasure',not_ = GameAPI.get_text_config('#-1195694970#lua'),},
  [3] = {id = 3,type_table = 'title',not_ = GameAPI.get_text_config('#1422298641#lua'),},
  [4] = {id = 4,type_table = 'stage_tower',not_ = GameAPI.get_text_config('#-974284267#lua'),},
  [5] = {id = 5,type_table = 'hero',not_ = GameAPI.get_text_config('#-1730022642#lua'),},
  [6] = {id = 6,type_table = 'attr_pack',not_ = GameAPI.get_text_config('#-134798616#lua'),},
  [7] = {id = 7,type_table = 'stage_tower_skin',not_ = GameAPI.get_text_config('#-167613859#lua'),},
}

local id_to_index={
   [1] = 1,
   [2] = 2,
   [3] = 3,
   [4] = 4,
   [5] = 5,
   [6] = 6,
   [7] = 7,
}

local itemtype_manage={}
itemtype_manage.__index=itemtype_manage 

function itemtype_manage.length() 
   return #_data 
end 

function itemtype_manage.indexOf(index) 
 index = tonumber(index) 
  
 local rawData = _data[index] 
 if not rawData then 
 return nil 
 end 
local ret = setmetatable({}, {__index = function(t, k) local value = rawData[k] 
 assert(value,"表中没有这个字段"..k) return rawData[k] end, __newindex = function(t, k, v)end }) 
 return ret 
end 

function itemtype_manage.get(id) 
   
    return itemtype_manage.indexOf(id_to_index[id])
end 

return itemtype_manage