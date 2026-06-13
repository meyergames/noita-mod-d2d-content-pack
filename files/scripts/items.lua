dofile_once("data/scripts/item_spawnlists.lua")

-- nabbed from Apoth + Nathan changes
---@param listname string
---@param weight integer
---@param entity string
---@param offset integer
local function register_item(listname, weight, entity, offset)
    local newmin = spawnlists[listname].rnd_max + 1
    local newmax = newmin + weight - 1
    spawnlists[listname].rnd_max = newmax
    local tbl = {
        value_min = newmin,
        value_max = newmax,
        offset_y = offset,
        load_entity = entity
    }
    table.insert(spawnlists[listname].spawns, tbl)
end

d2d_items = {
    {
        weight = 2,
        entity = "mods/D2DContentPack/files/entities/items/pickup/emergency_injection.xml",
        offset = -2,
    },
    {
        weight = 2,
        entity = "mods/D2DContentPack/files/entities/items/pickup/treasure_map/treasure_map_entity.xml",
        offset = -2,
    },
}

for i, v in ipairs( d2d_items ) do
    register_item( "potion_spawnlist", v.weight, v.entity, v.offset )
end


function HasSettingFlag(name)
    return ModSettingGet(name) or false
end

function AddSettingFlag(name)
    ModSettingSet(name, true)
end

function RemoveSettingFlag(name)
    ModSettingRemove(name)
end
