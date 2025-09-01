ModLuaFileAppend("data/scripts/lib/utilities.lua", "mods/D2DContentPack/files/scripts/utilities.lua")

ModLuaFileAppend("data/scripts/gun/gun_actions.lua", "mods/D2DContentPack/files/scripts/actions.lua")
ModLuaFileAppend("data/scripts/gun/gun_extra_modifiers.lua", "mods/D2DContentPack/files/scripts/gun_extra_modifiers.lua")
--ModLuaFileAppend("data/scripts/perks/perk_list.lua", "mods/D2DContentPack/files/scripts/perks.lua")
ModLuaFileAppend("data/scripts/status_effects/status_list.lua", "mods/D2DContentPack/files/scripts/status_effects/status_list.lua")
ModLuaFileAppend("data/scripts/item_spawnlists.lua", "mods/D2DContentPack/files/scripts/items.lua")
ModMaterialsFileAdd("mods/D2DContentPack/files/materials/materials.xml")

ModLuaFileAppend("data/scripts/gun/procedural/gun_procedural.lua", "mods/D2DContentPack/files/scripts/gun_procedural.lua")
ModLuaFileAppend("data/scripts/biome_scripts.lua", "mods/D2DContentPack/files/scripts/biome_scripts.lua")
ModLuaFileAppend("data/scripts/items/heart_fullhp_temple.lua", "mods/D2DContentPack/files/scripts/items/heart_fullhp_temple_custom.lua")
ModLuaFileAppend("data/scripts/items/orb_pickup.lua", "mods/D2DContentPack/files/scripts/items/orb_pickup_custom.lua")

function OnModPostInit()
    ModLuaFileAppend("data/scripts/perks/perk_list.lua", "mods/D2DContentPack/files/scripts/perks.lua")
end

function OnPlayerSpawned(player)
    local rnd = Random( 0, 100 )
    if ( rnd <= 5 ) then
        dofile_once( "data/scripts/perks/perk.lua" )
        local perk = perk_spawn( 800, -100, "D2D_TIME_TRIAL" )
    end
end



local translations = ModTextFileGetContent("data/translations/common.csv")
local new_translations = ModTextFileGetContent("mods/D2DContentPack/translations.csv")
translations = translations .. "\n" .. new_translations .. "\n"
translations = translations:gsub("\r", ""):gsub("\n\n+", "\n")
ModTextFileSetContent("data/translations/common.csv", translations)
