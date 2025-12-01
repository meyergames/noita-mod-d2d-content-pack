ModLuaFileAppend("data/scripts/lib/utilities.lua", "mods/D2DContentPack/files/scripts/utilities.lua")

ModLuaFileAppend("data/scripts/gun/gun_actions.lua", "mods/D2DContentPack/files/scripts/actions.lua")
-- ModLuaFileAppend("data/scripts/gun/gun.lua", "mods/D2DContentPack/files/scripts/gun.lua")
ModLuaFileAppend("data/scripts/gun/gun_extra_modifiers.lua", "mods/D2DContentPack/files/scripts/gun_extra_modifiers.lua")
--ModLuaFileAppend("data/scripts/perks/perk_list.lua", "mods/D2DContentPack/files/scripts/perks.lua")
ModLuaFileAppend("data/scripts/status_effects/status_list.lua", "mods/D2DContentPack/files/scripts/status_effects/status_list.lua")
ModLuaFileAppend("data/scripts/item_spawnlists.lua", "mods/D2DContentPack/files/scripts/items.lua")
ModMaterialsFileAdd("mods/D2DContentPack/files/materials/materials.xml")

ModLuaFileAppend("data/scripts/gun/procedural/gun_procedural.lua", "mods/D2DContentPack/files/scripts/gun_procedural.lua")
ModLuaFileAppend("data/scripts/biome_scripts.lua", "mods/D2DContentPack/files/scripts/biome_scripts.lua")
ModLuaFileAppend("data/scripts/biomes/temple_altar.lua", "mods/D2DContentPack/files/scripts/biomes/temple_altar.lua")
ModLuaFileAppend("data/scripts/items/heart_fullhp_temple.lua", "mods/D2DContentPack/files/scripts/items/heart_fullhp_temple_custom.lua")
ModLuaFileAppend("data/scripts/items/orb_pickup.lua", "mods/D2DContentPack/files/scripts/items/orb_pickup_custom.lua")
ModLuaFileAppend("data/scripts/items/generate_shop_item.lua", "mods/D2DContentPack/files/scripts/items/generate_shop_item.lua")

if ModIsEnabled( "Apotheosis" ) then
    ModLuaFileAppend( "mods/Apotheosis/files/scripts/animals/cat_pet.lua", "mods/D2DContentPack/files/scripts/animals/cat_pet.lua" )
end

if ModIsEnabled("anvil_of_destiny") then
  ModLuaFileAppend("mods/anvil_of_destiny/files/scripts/modded_content.lua", "mods/D2DContentPack/files/scripts/aod/aod_modded_content_append.lua")
end

function OnModPostInit()
    ModLuaFileAppend("data/scripts/perks/perk_list.lua", "mods/D2DContentPack/files/scripts/perks.lua")
end

function OnPlayerSpawned(player)
    local config_spawn_time_trial_at_start = ModSettingGet("D2DContentPack.spawn_time_trial_at_start")
    if config_spawn_time_trial_at_start then
        local rnd = Random( 0, 100 )
        if ( rnd <= 5 ) then
            dofile_once( "data/scripts/perks/perk.lua" )
            local perk = perk_spawn( 800, -100, "D2D_TIME_TRIAL" )
        end
    end

    -- dofile_once( "mods/D2DContentPack/files/scripts/wand_utils.lua" )
    -- spawn_random_staff( 0, -100, 55 )
    -- spawn_random_staff( 20, -100, 75 )

    -- dofile_once( "data/scripts/perks/perk.lua" )
    -- spawn_random_perk( -20, -50 )
    -- spawn_perk( "D2D_BLESSINGS_AND_CURSE", 0, -50 )
    -- spawn_random_perk( 20, -50 )

    -- dofile_once( "data/scripts/lib/utilities.lua" )
    -- local px, py = EntityGetTransform( get_player() )
    -- CreateItemActionEntity( "D2D_BLINK", px, py )
end



local translations = ModTextFileGetContent("data/translations/common.csv")
local new_translations = ModTextFileGetContent("mods/D2DContentPack/translations.csv")
translations = translations .. "\n" .. new_translations .. "\n"
translations = translations:gsub("\r", ""):gsub("\n\n+", "\n")
ModTextFileSetContent("data/translations/common.csv", translations)
